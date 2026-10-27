import { Router, Response } from 'express';
import bcrypt from 'bcryptjs';
import type { RowDataPacket, ResultSetHeader } from 'mysql2';
import { findUserById, getProfileFull, pool, updateProfile, useMySQL } from '../config/db';
import { AuthRequest, requireAuth } from '../middleware/auth';

const router = Router();
router.use(requireAuth);

const validSemesters = new Set([
  '1.er ciclo', '2.º ciclo', '3.er ciclo', '4.º ciclo', '5.º ciclo',
  '6.º ciclo', '7.º ciclo', '8.º ciclo', '9.º ciclo', '10.º ciclo',
  // Para compatibilidad con los perfiles existentes:
  '1er ciclo','2do ciclo','3er ciclo','4to ciclo','5to ciclo',
  '6to ciclo','7mo ciclo','8vo ciclo','9no ciclo','10mo ciclo'
]);

router.get('/', async (req: AuthRequest, res: Response) => {
  try {
    const profile = await getProfileFull(req.userId!);
    if (!profile) { res.status(404).json({ error: 'Perfil no encontrado.' }); return; }
    res.json(profile);
  } catch {
    res.status(500).json({ error: 'No se pudo consultar el perfil.' });
  }
});

// Edición simple: ciclo y biografía. Universidad/carrera tienen endpoint protegido.
router.put('/', async (req: AuthRequest, res: Response) => {
  try {
    const profile = await getProfileFull(req.userId!);
    if (!profile) { res.status(404).json({ error: 'Perfil no encontrado.' }); return; }
    const semester = req.body?.semester;
    const bio = req.body?.bio;
    if (typeof semester !== 'string' || !validSemesters.has(semester)) {
      res.status(400).json({ error: 'Ciclo académico inválido.' }); return;
    }
    if (typeof bio !== 'string' || bio.length > 500) {
      res.status(400).json({ error: 'La biografía debe tener máximo 500 caracteres.' }); return;
    }
    await updateProfile(req.userId!, {
      career: profile.career,
      semester,
      bio: bio.trim()
    });
    res.json(await getProfileFull(req.userId!));
  } catch (err) {
    console.error('Error al actualizar el perfil:', err);
    res.status(500).json({ error: 'No se pudo actualizar tu perfil.' });
  }
});

// POST /api/profile/password (requiere MySQL activo)
router.post('/password', async (req: AuthRequest, res: Response) => {
  try {
    const current = req.body?.current_password;
    const next = req.body?.new_password;
    if (typeof current !== 'string' || typeof next !== 'string') {
      res.status(400).json({ error: 'Completa ambas contraseñas.' }); return;
    }
    if (next.length < 8 || Buffer.byteLength(next, 'utf8') > 72) {
      res.status(400).json({ error: 'La nueva contraseña debe tener al menos 8 caracteres y máximo 72 bytes.' }); return;
    }
    if (!useMySQL || !pool) {
      res.status(503).json({ error: 'Esta función requiere que MySQL esté conectado.' }); return;
    }
    const user = await findUserById(req.userId!);
    if (!user) { res.status(404).json({ error: 'Cuenta no encontrada.' }); return; }
    const valid = await bcrypt.compare(current, user.password_hash);
    if (!valid) { res.status(400).json({ error: 'La contraseña actual es incorrecta.' }); return; }
    if (await bcrypt.compare(next, user.password_hash)) {
      res.status(400).json({ error: 'La contraseña nueva debe ser diferente a la actual.' }); return;
    }
    const hash = await bcrypt.hash(next, 12);
    // Evita sobrescribir una contraseña modificada en otra sesión durante esta solicitud.
    const [result] = await pool.execute<import('mysql2').ResultSetHeader>(
      'UPDATE users SET password_hash = ? WHERE id = ? AND password_hash = ?',
      [hash, req.userId!, user.password_hash]
    );
    if (result.affectedRows !== 1) {
      res.status(409).json({ error: 'La contraseña cambió durante la operación. Intenta nuevamente.' }); return;
    }
    res.json({ message: 'Contraseña actualizada correctamente.' });
  } catch (err) {
    console.error('Error al cambiar contraseña:', err);
    res.status(500).json({ error: 'No se pudo cambiar la contraseña.' });
  }
});

// Lista de universidades para el selector editable del perfil.
router.get('/universities', async (_req: AuthRequest, res: Response) => {
  try {
    if (!useMySQL || !pool) {
      res.status(503).json({ error: 'MySQL no está disponible.' }); return;
    }
    const [rows] = await pool.query<RowDataPacket[]>(
      'SELECT id, name FROM universities ORDER BY name ASC');
    res.json(rows);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: 'No se pudieron cargar las universidades.' });
  }
});

// Universidad y carrera editables, con confirmación de la contraseña actual.
// Email y nombre se mantienen sin cambios; no implica verificar identidad institucional.
router.put('/academic', async (req: AuthRequest, res: Response) => {
  try {
    if (!useMySQL || !pool) {
      res.status(503).json({ error: 'MySQL no está disponible.' }); return;
    }
    const university = typeof req.body?.university_name === 'string'
      ? req.body.university_name.trim() : '';
    const career = typeof req.body?.career === 'string'
      ? req.body.career.trim() : '';
    const currentPassword = req.body?.current_password;
    if (university.length < 3 || university.length > 150 ||
        career.length < 3 || career.length > 120 ||
        typeof currentPassword !== 'string' || !currentPassword) {
      res.status(400).json({ error: 'Completa universidad, carrera y contraseña actual.' }); return;
    }
    const user = await findUserById(req.userId!);
    if (!user) { res.status(404).json({ error: 'Usuario no encontrado.' }); return; }
    if (!await bcrypt.compare(currentPassword, user.password_hash)) {
      res.status(403).json({ error: 'La contraseña actual es incorrecta.' }); return;
    }
    const [list] = await pool.query<RowDataPacket[]>(
      'SELECT id, name FROM universities WHERE LOWER(name) = LOWER(?) LIMIT 1', [university]);
    const universityId = list.length ? Number(list[0].id) : null;
    const officialName = list.length ? String(list[0].name) : university;
    const connection = await pool.getConnection();
    try {
      await connection.beginTransaction();
      // Optimista: si otra solicitud cambió la contraseña, no persistir datos.
      const [changed] = await connection.execute<ResultSetHeader>(
        'UPDATE users SET university_id = ?, university_name = ? WHERE id = ? AND password_hash = ?',
        [universityId, officialName, req.userId!, user.password_hash]);
      if (changed.affectedRows !== 1) {
        await connection.rollback();
        res.status(409).json({ error: 'Actualiza tu sesión e inténtalo de nuevo.' }); return;
      }
      await connection.execute(
        'INSERT INTO profiles (user_id, career) VALUES (?, ?) ON DUPLICATE KEY UPDATE career = VALUES(career)',
        [req.userId!, career]);
      await connection.commit();
    } catch (err) { await connection.rollback(); throw err; }
    finally { connection.release(); }
    res.json(await getProfileFull(req.userId!));
  } catch (err) {
    console.error('No se pudieron actualizar datos académicos:', err);
    res.status(500).json({ error: 'No se pudo actualizar universidad o carrera.' });
  }
});

router.get('/:id', async (req: AuthRequest, res: Response) => {
  try {
    const id = Number(req.params.id);
    if (!Number.isInteger(id) || id <= 0) { res.status(400).json({ error: 'ID inválido.' }); return; }
    const profile = await getProfileFull(id);
    if (!profile) { res.status(404).json({ error: 'Estudiante no encontrado.' }); return; }
    res.json(profile);
  } catch {
    res.status(500).json({ error: 'No se pudo consultar el perfil.' });
  }
});

export default router;