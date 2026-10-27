import { Router, Response } from 'express';
import type { RowDataPacket, ResultSetHeader } from 'mysql2';
import { randomBytes } from 'crypto';
import { pool, useMySQL } from '../config/db';
import { AuthRequest, requireAuth } from '../middleware/auth';

const router = Router();
router.use(requireAuth);
const STABILITY = 10;

export type Rank = {
  id: number;
  name: string;
  university: string;
  career: string;
  given: number;
  reviews: number;
  rating: number | null; // promedio aritmético, solo para cálculos internos
  score: number | null;  // puntuación bayesiana pública (valor SIN redondear)
  position: number;
};

// Ranking HISTÓRICO: todos los usuarios tienen posición, incluidos quienes aún
// no han impartido asesorías. Un usuario sin reseñas siempre va al final y
// NO recibe una puntuación inventada.
async function rankings(): Promise<Rank[]> {
  const [rows] = await pool!.query<RowDataPacket[]>(`
    SELECT u.id, CONCAT(u.first_name, ' ', u.last_name) AS name,
           u.university_name AS university, p.career,
           u.created_at, COALESCE(x.given, 0) AS given,
           COALESCE(x.reviews, 0) AS reviews,
           COALESCE(x.rating_sum, 0) AS rating_sum
    FROM users u
    LEFT JOIN profiles p ON p.user_id = u.id
    LEFT JOIN (
      SELECT s.mentor_id,
             COUNT(DISTINCT s.id) AS given,
             COUNT(r.id) AS reviews,
             COALESCE(SUM(r.rating), 0) AS rating_sum
      FROM mentorship_sessions s
      LEFT JOIN session_reviews r ON r.session_id = s.id
        AND r.reviewer_id = s.learner_id
        AND r.reviewed_id = s.mentor_id
      WHERE s.status = 'completed'
        AND s.mentor_confirmed = 1
        AND s.learner_confirmed = 1
      GROUP BY s.mentor_id
    ) x ON x.mentor_id = u.id
    ORDER BY u.id ASC`);

  // C = media de todas las evaluaciones REALES recibidas como mentor.
  // Ponderamos por número de reseñas; no por número de usuarios.
  const totalReviews = rows.reduce((sum, r) => sum + Number(r.reviews), 0);
  const sumRatings = rows.reduce((sum, r) => sum + Number(r.rating_sum), 0);
  const C = totalReviews ? sumRatings / totalReviews : null;

  const result: Rank[] = rows.map(r => {
    const reviews = Number(r.reviews);
    const ratingSum = Number(r.rating_sum);
    return {
      id: Number(r.id), name: String(r.name),
      university: String(r.university ?? ''), career: String(r.career ?? ''),
      given: Number(r.given), reviews,
      rating: reviews ? ratingSum / reviews : null,
      score: reviews && C !== null
        ? (ratingSum + STABILITY * C) / (reviews + STABILITY)
        : null,
      position: 0
    };
  });

  // Desempate: puntaje COMPLETO > reseñas > asesorías > fecha de registro > id.
  // El id de usuario estabiliza empates absolutos sin inventar méritos.
  const joinedAt = new Map(rows.map(r => [Number(r.id), String(r.created_at)]));
  result.sort((a, b) => {
    if (a.score === null && b.score !== null) return 1;
    if (b.score === null && a.score !== null) return -1;
    if (a.score !== null && b.score !== null && a.score !== b.score) return b.score - a.score;
    return b.reviews - a.reviews || b.given - a.given ||
      String(joinedAt.get(a.id)).localeCompare(String(joinedAt.get(b.id))) || a.id - b.id;
  });
  return result.map((rank, i) => ({ ...rank, position: i + 1 }));
}

const dbRequired = (res: Response) => {
  if (useMySQL && pool) return true;
  res.status(503).json({ error: 'El ranking necesita MySQL conectado.' });
  return false;
};

router.get('/', async (req: AuthRequest, res: Response) => {
  try {
    if (!dbRequired(res)) return;
    const all = await rankings();
    res.json({ top: all.slice(0, 5), me: all.find(r => r.id === req.userId) ?? null,
      total: all.length, type: 'historical' });
  } catch (e) { console.error(e); res.status(500).json({ error: 'No se pudo cargar el ranking.' }); }
});

router.get('/user/:id', async (req: AuthRequest, res: Response) => {
  try {
    if (!dbRequired(res)) return;
    const id = Number(req.params.id);
    if (!Number.isInteger(id) || id <= 0) {
      res.status(400).json({ error: 'Usuario inválido.' }); return;
    }
    const all = await rankings();
    const stats = all.find(r => r.id === id);
    if (!stats) { res.status(404).json({ error: 'Usuario no encontrado.' }); return; }
    res.json({ stats });
  } catch (e) { console.error(e); res.status(500).json({ error: 'No se pudo cargar el perfil.' }); }
});

// Reconocimiento disponible ÚNICAMENTE a quienes ocupan actualmente TOP 1-3.
// Se evalúa nuevamente al solicitar el PDF: nunca confiar en el botón frontend.
async function recognitionStatus(userId: number) {
  const all = await rankings();
  const me = all.find(r => r.id === userId) ?? null;
  const eligible = Boolean(me && me.position <= 3 && me.reviews > 0);
  const now = new Date(Date.now() - 5 * 60 * 60 * 1000);
  const period = { year: now.getUTCFullYear(), month: now.getUTCMonth() + 1 };
  const [rows] = await pool!.query<RowDataPacket[]>(
    'SELECT verification_code FROM recognitions WHERE user_id = ? AND period_year = ? AND period_month = ? LIMIT 1',
    [userId, period.year, period.month]);
  return { period, me, eligible, issued: rows.length > 0 };
}

router.get('/recognition', async (req: AuthRequest, res: Response) => {
  try {
    if (!dbRequired(res)) return;
    res.json(await recognitionStatus(req.userId!));
  } catch (e) { console.error(e); res.status(500).json({ error: 'No se pudo consultar el reconocimiento.' }); }
});

// PDF autónomo A4. No es una certificación oficial; representa participación.
function buildPDF(name: string, position: number, count: number, score: number, code: string): Buffer {
  const safe = (s: string) => s.normalize('NFC').replace(/[\r\n\t]/g, ' ')
    .replace(/[\u2010-\u2015]/g, '-').replace(/[\u2018\u2019]/g, "'")
    .replace(/[^\u0020-\u007e\u00a1-\u00ff]/g, '?')
    .replace(/\\/g, '\\\\').replace(/\(/g, '\\(').replace(/\)/g, '\\)');
  const write = (x: number, y: number, value: string, size: number, font = 'F1', rgb = '0.19 0.14 0.22') =>
    `BT /${font} ${size} Tf ${rgb} rg 1 0 0 1 ${x} ${y} Tm (${safe(value)}) Tj ET\n`;
  const content = [
    '0.97 0.93 0.94 rg 0 0 595 842 re f\n',
    '1 1 1 rg 30 35 535 772 re f\n',
    '0.91 0.43 0.47 rg 30 750 535 57 re f\n',
    write(54, 770, 'APRENDLY', 22, 'F2', '1 1 1'),
    write(54, 690, 'RECONOCIMIENTO DE PARTICIPACION', 20, 'F2'),
    write(54, 657, 'Aprendizaje colaborativo entre estudiantes', 12),
    write(54, 596, 'Aprendly reconoce a:', 12),
    write(54, 554, name.slice(0, 46), 24, 'F2'),
    '0.91 0.43 0.47 rg 54 531 470 2 re f\n',
    write(54, 493, `Posicion en ranking historico: TOP ${position}`, 15, 'F2'),
    write(54, 457, `Asesorias impartidas y completadas: ${count}`, 13),
    write(54, 423, `Puntuacion bayesiana: ${score.toFixed(1)} de 5`, 13),
    write(54, 372, 'Reconocimiento de participacion dentro de Aprendly.', 11),
    write(54, 347, 'No equivale a grado, titulo o certificacion oficial.', 11),
    write(54, 230, `Codigo de registro: ${code}`, 10),
    write(54, 210, `Emision: ${new Date().toISOString().slice(0, 10)}`, 10),
  ].join('');
  const commands = Buffer.from(content, 'latin1');
  const objects = [
    '<< /Type /Catalog /Pages 2 0 R >>',
    '<< /Type /Pages /Kids [3 0 R] /Count 1 >>',
    '<< /Type /Page /Parent 2 0 R /MediaBox [0 0 595 842] /Resources << /Font << /F1 4 0 R /F2 5 0 R >> >> /Contents 6 0 R >>',
    '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica /Encoding /WinAnsiEncoding >>',
    '<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica-Bold /Encoding /WinAnsiEncoding >>',
    `<< /Length ${commands.length} >>\nstream\n${content}endstream`,
  ];
  const chunks: Buffer[] = [Buffer.from('%PDF-1.4\n', 'latin1')];
  const offsets: number[] = [0];
  for (let i = 0; i < objects.length; i++) {
    offsets.push(chunks.reduce((n, b) => n + b.length, 0));
    chunks.push(Buffer.from(`${i + 1} 0 obj\n${objects[i]}\nendobj\n`, 'latin1'));
  }
  const startXref = chunks.reduce((n, b) => n + b.length, 0);
  chunks.push(Buffer.from(`xref\n0 ${objects.length + 1}\n0000000000 65535 f \n` +
    offsets.slice(1).map(n => `${String(n).padStart(10, '0')} 00000 n \n`).join('') +
    `trailer\n<< /Size ${objects.length + 1} /Root 1 0 R >>\nstartxref\n${startXref}\n%%EOF`, 'latin1'));
  return Buffer.concat(chunks);
}

router.get('/recognition/pdf', async (req: AuthRequest, res: Response) => {
  try {
    if (!dbRequired(res)) return;
    const status = await recognitionStatus(req.userId!);
    if (!status.eligible || !status.me || status.me.score === null) {
      res.status(403).json({ error: 'Solo los tres primeros puestos con reseñas pueden descargar el reconocimiento.' });
      return;
    }
    const { period, me } = status;
    const code = randomBytes(16).toString('hex');
    // Permite conservar documentos históricos si cambian las posiciones.
    // La migración elimina la restricción de rango único del mes.
    await pool!.execute<ResultSetHeader>(`
      INSERT INTO recognitions
        (user_id, period_year, period_month, rank_position,
         average_rating, sessions_count, verification_code)
      VALUES (?, ?, ?, ?, ?, ?, ?)
      ON DUPLICATE KEY UPDATE
        rank_position = VALUES(rank_position),
        average_rating = VALUES(average_rating),
        sessions_count = VALUES(sessions_count)`, [
      req.userId!, period.year, period.month, me.position,
      me.score, me.given, code
    ]);
    const [rows] = await pool!.query<RowDataPacket[]>(
      'SELECT verification_code FROM recognitions WHERE user_id = ? AND period_year = ? AND period_month = ? LIMIT 1',
      [req.userId, period.year, period.month]);
    if (!rows.length) throw new Error('Reconocimiento no registrado');
    const bytes = buildPDF(me.name, me.position, me.given, me.score!, String(rows[0].verification_code));
    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', 'attachment; filename="reconocimiento-aprendly.pdf"');
    res.setHeader('Content-Length', bytes.length);
    res.send(bytes);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'No se pudo generar el reconocimiento.' });
  }
});

export default router;