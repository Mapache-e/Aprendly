import { Router, Response } from 'express';
import type { RowDataPacket, ResultSetHeader } from 'mysql2';
import { pool, useMySQL, listCandidates, listKnowledge } from '../config/db';
import { AuthRequest, requireAuth } from '../middleware/auth';

const router = Router();
router.use(requireAuth);

const isId = (value: unknown) => Number.isInteger(Number(value)) && Number(value) > 0;
const fail = (res: Response, status: number, error: string) => res.status(status).json({ error });
const timeRe = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$/;
// Las fechas DATETIME del sistema representan hora local de Perú (UTC-05).
const limaTime = (value: string) => new Date(`${value.replace(' ', 'T')}-05:00`).getTime();
const checkDb = (res: Response): boolean => {
  if (useMySQL && pool) return true;
  fail(res, 503, 'Activa MySQL en XAMPP para utilizar asesorías.');
  return false;
};

// Mentor elegible: debe haber declarado la materia que desea enseñar.
router.get('/mentors', async (req: AuthRequest, res: Response) => {
  try {
    if (!checkDb(res)) return;
    const people = await listCandidates(req.userId!);
    const catalog = await listKnowledge();
    res.json(people.filter(p => p.teach.length > 0).map(p => ({
      id: p.user.id,
      name: `${p.user.first_name} ${p.user.last_name}`,
      university: p.user.university_name,
      skills: p.teach.map(name => catalog.find(k => k.name.toLowerCase() === name.toLowerCase()))
        .filter((item): item is (typeof catalog)[number] => item !== undefined)
    })));
  } catch (e) {
    console.error(e);
    fail(res, 500, 'No se pudieron cargar los mentores.');
  }
});

// Lista de sesiones del usuario autenticado, con estado de reseña.
router.get('/', async (req: AuthRequest, res: Response) => {
  try {
    if (!checkDb(res)) return;
    const [rows] = await pool!.query<RowDataPacket[]>(`
      SELECT s.id, s.mentor_id, s.learner_id, s.knowledge_id, k.name AS topic,
        DATE_FORMAT(s.scheduled_start,'%Y-%m-%dT%H:%i') AS scheduled_start,
        DATE_FORMAT(s.scheduled_end,'%Y-%m-%dT%H:%i') AS scheduled_end,
        s.modality, s.meeting_url, s.status,
        s.mentor_confirmed, s.learner_confirmed,
        CONCAT(mentor.first_name,' ',mentor.last_name) AS mentor_name,
        CONCAT(learner.first_name,' ',learner.last_name) AS learner_name,
        EXISTS (SELECT 1 FROM session_reviews r
          WHERE r.session_id = s.id AND r.reviewer_id = ?) AS has_reviewed
      FROM mentorship_sessions s
      JOIN users mentor ON mentor.id = s.mentor_id
      JOIN users learner ON learner.id = s.learner_id
      JOIN knowledge k ON k.id = s.knowledge_id
      WHERE s.mentor_id = ? OR s.learner_id = ?
      ORDER BY s.scheduled_start DESC, s.id DESC`,
      [req.userId, req.userId, req.userId]
    );
    res.json(rows.map(row => ({ ...row,
      role: Number(row.mentor_id) === req.userId ? 'mentor' : 'learner',
      has_reviewed: Boolean(row.has_reviewed),
      mentor_confirmed: Boolean(row.mentor_confirmed),
      learner_confirmed: Boolean(row.learner_confirmed)
    })));
  } catch (e) {
    console.error(e);
    fail(res, 500, 'No se pudieron cargar las asesorías.');
  }
});

// El estudiante solicita una asesoría a una persona que ENSEÑA el tema.
router.post('/', async (req: AuthRequest, res: Response) => {
  try {
    if (!checkDb(res)) return;
    const mentor = Number(req.body?.mentor_id);
    const topic = Number(req.body?.knowledge_id);
    const start = String(req.body?.scheduled_start || '');
    const duration = Number(req.body?.duration_minutes);
    const modality = req.body?.modality;
    const url = typeof req.body?.meeting_url === 'string' ? req.body.meeting_url.trim() : '';

    if (!isId(mentor) || mentor === req.userId || !isId(topic)) {
      fail(res, 400, 'Selecciona un mentor y una materia válida.'); return;
    }
    if (!timeRe.test(start) || !Number.isInteger(duration) || duration < 30 || duration > 180) {
      fail(res, 400, 'Selecciona fecha, hora y duración entre 30 y 180 minutos.'); return;
    }
    if (modality !== 'online' && modality !== 'presential') {
      fail(res, 400, 'Modalidad inválida.'); return;
    }
    if (url.length > 500 || (url && (!/^https:\/\//i.test(url) || (()=>{try {return new URL(url).hostname.length===0;} catch{return true;}})()))) {
      fail(res, 400, 'El enlace debe ser una URL HTTPS válida.'); return;
    }
    const at = limaTime(start);
    if (!Number.isFinite(at) || at < Date.now() + 10 * 60000 || at > Date.now() + 90 * 86400000) {
      fail(res, 400, 'La asesoría debe programarse entre 10 minutos y 90 días desde ahora.'); return;
    }
    const end = new Date(at + duration * 60000);
    // Convertir la hora absoluta de regreso a la zona fija de Lima.
    const finish = new Date(end.getTime() - 5 * 3600000).toISOString().slice(0, 19).replace('T', ' ');
    const begin = `${start.replace('T', ' ')}:00`;
    const [known] = await pool!.query<RowDataPacket[]>(`
      SELECT 1 FROM user_teach_knowledge
      WHERE user_id = ? AND knowledge_id = ? LIMIT 1`, [mentor, topic]);
    if (!known.length) {
      fail(res, 400, 'Ese mentor no ofrece la materia seleccionada.'); return;
    }
    // No crear solicitudes solapadas para los mismos participantes.
    const [overlap] = await pool!.query<RowDataPacket[]>(`
      SELECT id FROM mentorship_sessions
      WHERE status IN ('proposed','accepted')
        AND (mentor_id IN (?, ?) OR learner_id IN (?, ?))
        AND scheduled_start < ? AND scheduled_end > ? LIMIT 1`,
      [mentor, req.userId, mentor, req.userId, finish, begin]);
    if (overlap.length) {
      fail(res, 409, 'Uno de los participantes ya tiene una asesoría en ese horario.'); return;
    }
    const [result] = await pool!.execute<ResultSetHeader>(`
      INSERT INTO mentorship_sessions
        (mentor_id, learner_id, knowledge_id, scheduled_start, scheduled_end,
         modality, meeting_url, status)
      VALUES (?, ?, ?, ?, ?, ?, ?, 'proposed')`,
      [mentor, req.userId, topic, begin, finish, modality, url || null]);
    res.status(201).json({ id: result.insertId, message: 'Solicitud enviada al mentor.' });
  } catch (e) {
    console.error(e);
    fail(res, 500, 'No se pudo programar la asesoría.');
  }
});

// Mentor acepta/rechaza. Ambos pueden cancelar una solicitud vigente.
router.post('/:id/decision', async (req: AuthRequest, res: Response) => {
  const id = Number(req.params.id);
  const action = req.body?.action;
  if (!isId(id) || !['accept', 'reject', 'cancel'].includes(action)) {
    fail(res, 400, 'Solicitud o acción inválida.'); return;
  }
  try {
    if (!checkDb(res)) return;
    const [rows] = await pool!.query<RowDataPacket[]>(
      "SELECT *, DATE_FORMAT(scheduled_start,'%Y-%m-%dT%H:%i') AS start_at FROM mentorship_sessions WHERE id = ? LIMIT 1", [id]);
    const s = rows[0];
    if (!s || (s.mentor_id !== req.userId && s.learner_id !== req.userId)) {
      fail(res, 404, 'Asesoría no encontrada.'); return;
    }
    if (action === 'accept' || action === 'reject') {
      if (s.mentor_id !== req.userId || s.status !== 'proposed') {
        fail(res, 409, 'Solo el mentor puede responder solicitudes pendientes.'); return;
      }
    } else if (!['proposed', 'accepted'].includes(s.status)) {
      fail(res, 409, 'Esta asesoría no se puede cancelar.'); return;
    }
    if ((action === 'accept' || action === 'cancel') && limaTime(String(s.start_at)) <= Date.now()) {
      fail(res, 409, 'El horario de la asesoría ya comenzó.'); return;
    }
    const status = action === 'accept' ? 'accepted' : action === 'reject' ? 'rejected' : 'cancelled';
    const [updated] = await pool!.execute<ResultSetHeader>(
      'UPDATE mentorship_sessions SET status = ? WHERE id = ? AND status = ?',
      [status, id, s.status]);
    if (!updated.affectedRows) {
      fail(res, 409, 'La asesoría cambió de estado. Actualiza el calendario.'); return;
    }
    res.json({ message: 'Estado actualizado.', status });
  } catch (e) {
    console.error(e);
    fail(res, 500, 'No se pudo actualizar la asesoría.');
  }
});

// Cada participante confirma que la sesión ocurrió. Se completa al confirmar ambos.
router.post('/:id/confirm', async (req: AuthRequest, res: Response) => {
  const id = Number(req.params.id);
  if (!isId(id)) { fail(res, 400, 'ID inválido.'); return; }
  if (!checkDb(res)) return;
  const connection = await pool!.getConnection();
  try {
    await connection.beginTransaction();
    const [rows] = await connection.query<RowDataPacket[]>(`
      SELECT id, mentor_id, learner_id, status, mentor_confirmed, learner_confirmed,
        DATE_FORMAT(scheduled_end,'%Y-%m-%dT%H:%i') AS end_at
      FROM mentorship_sessions WHERE id = ? FOR UPDATE`, [id]);
    const s = rows[0];
    if (!s || (s.mentor_id !== req.userId && s.learner_id !== req.userId)) {
      await connection.rollback(); fail(res, 404, 'Asesoría no encontrada.'); return;
    }
    if (s.status !== 'accepted' || limaTime(s.end_at) > Date.now()) {
      await connection.rollback(); fail(res, 409, 'Primero debe terminar una asesoría aceptada.'); return;
    }
    const mentorConfirmed = Boolean(s.mentor_confirmed) || s.mentor_id === req.userId;
    const learnerConfirmed = Boolean(s.learner_confirmed) || s.learner_id === req.userId;
    const nextStatus = mentorConfirmed && learnerConfirmed ? 'completed' : 'accepted';
    await connection.execute(
      `UPDATE mentorship_sessions
       SET mentor_confirmed = ?, learner_confirmed = ?, status = ? WHERE id = ?`,
      [mentorConfirmed ? 1 : 0, learnerConfirmed ? 1 : 0, nextStatus, id]);
    await connection.commit();
    res.json({ status: nextStatus, message: nextStatus === 'completed'
      ? 'Asesoría completada. Ya pueden dejar sus reseñas.'
      : 'Confirmación registrada. Falta la otra persona.' });
  } catch (e) {
    await connection.rollback(); console.error(e);
    fail(res, 500, 'No se pudo confirmar la asesoría.');
  } finally {
    connection.release();
  }
});

// Reseña recíproca, exactamente una por participante y sesión completada.
router.post('/:id/review', async (req: AuthRequest, res: Response) => {
  const id = Number(req.params.id);
  const rating = Number(req.body?.rating);
  const comment = typeof req.body?.comment === 'string' ? req.body.comment.trim() : '';
  if (!isId(id) || !Number.isInteger(rating) || rating < 1 || rating > 5 || comment.length > 1000) {
    fail(res, 400, 'Calificación de 1 a 5; comentario de máximo 1000 caracteres.'); return;
  }
  try {
    if (!checkDb(res)) return;
    const [rows] = await pool!.query<RowDataPacket[]>(
      'SELECT mentor_id, learner_id, status FROM mentorship_sessions WHERE id = ?', [id]);
    const s = rows[0];
    if (!s || (s.mentor_id !== req.userId && s.learner_id !== req.userId)) {
      fail(res, 404, 'Asesoría no encontrada.'); return;
    }
    if (s.status !== 'completed') {
      fail(res, 409, 'Solo se pueden valorar asesorías completadas por ambos.'); return;
    }
    const reviewed = s.mentor_id === req.userId ? s.learner_id : s.mentor_id;
    await pool!.execute(
      `INSERT INTO session_reviews (session_id, reviewer_id, reviewed_id, rating, comment)
       VALUES (?, ?, ?, ?, ?)`,
      [id, req.userId, reviewed, rating, comment || null]);
    res.status(201).json({ message: 'Gracias por tu reseña.' });
  } catch (e) {
    if ((e as { code?: string }).code === 'ER_DUP_ENTRY') {
      fail(res, 409, 'Ya calificaste esta asesoría.'); return;
    }
    console.error(e); fail(res, 500, 'No se pudo guardar la reseña.');
  }
});

export default router;