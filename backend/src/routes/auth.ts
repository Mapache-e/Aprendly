
import { Router, Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import type { ResultSetHeader } from 'mysql2';

import {
  createUser,
  findUserByEmail,
  findUserById,
  isValidInstitutionalEmail,
  isEduLike,
  markVerified,
  pool,
  publicUser,
  updateProfile,
  useMySQL
} from '../config/db';

import { signToken } from '../middleware/auth';

const router = Router();

// ==========================================
// FUNCIONES AUXILIARES
// ==========================================

function clean(value: unknown): string {
  return typeof value === 'string' ? value.trim() : '';
}

const validSemesters = new Set([
  '1.er ciclo',
  '2.º ciclo',
  '3.er ciclo',
  '4.º ciclo',
  '5.º ciclo',
  '6.º ciclo',
  '7.º ciclo',
  '8.º ciclo',
  '9.º ciclo',
  '10.º ciclo'
]);

// ==========================================
// REGISTRAR USUARIO
// POST /api/auth/register
// ==========================================

router.post('/register', async (req: Request, res: Response) => {
  try {
    const first_name = clean(req.body?.first_name);
    const last_name = clean(req.body?.last_name);

    const institutional_email = clean(
      req.body?.institutional_email
    ).toLowerCase();

    const university_name = clean(req.body?.university_name);
    const career = clean(req.body?.career);
    const semester = clean(req.body?.semester);

    const password =
      typeof req.body?.password === 'string'
        ? req.body.password
        : '';

    const confirm_password =
      typeof req.body?.confirm_password === 'string'
        ? req.body.confirm_password
        : '';

    // ======================================
    // VALIDACIONES PERSONALES
    // ======================================

    if (
      !first_name ||
      !last_name ||
      first_name.length > 80 ||
      last_name.length > 80
    ) {
      res.status(400).json({
        error: 'Ingresa un nombre y apellido válidos.'
      });
      return;
    }

    // ======================================
    // VALIDACIÓN DEL CORREO
    // ======================================

    if (
      institutional_email.length > 160 ||
      !isValidInstitutionalEmail(institutional_email) ||
      !isEduLike(institutional_email)
    ) {
      res.status(400).json({
        error: 'Utiliza un correo institucional o académico válido.'
      });
      return;
    }

    // ======================================
    // UNIVERSIDAD Y CARRERA
    // ======================================

    if (!university_name || university_name.length > 150) {
      res.status(400).json({
        error: 'Indica una universidad válida.'
      });
      return;
    }

    if (!career || career.length > 120) {
      res.status(400).json({
        error: 'Indica una carrera universitaria válida.'
      });
      return;
    }

    if (!validSemesters.has(semester)) {
      res.status(400).json({
        error: 'Selecciona un ciclo académico válido.'
      });
      return;
    }

    // ======================================
    // CONTRASEÑA
    // ======================================

    if (
      password.length < 8 ||
      Buffer.byteLength(password, 'utf8') > 72
    ) {
      res.status(400).json({
        error:
          'La contraseña debe tener al menos 8 caracteres y no superar 72 bytes.'
      });
      return;
    }

    if (password !== confirm_password) {
      res.status(400).json({
        error: 'Las contraseñas no coinciden.'
      });
      return;
    }

    // ======================================
    // CORREO EXISTENTE
    // ======================================

    const existing = await findUserByEmail(institutional_email);

    if (existing) {
      res.status(409).json({
        error: 'Este correo ya está registrado.'
      });
      return;
    }

    // ======================================
    // GENERAR HASH BCRYPT
    // ======================================

    const password_hash = await bcrypt.hash(password, 10);

    let userId: number;

    // ======================================
    // CREAR CUENTA EN MYSQL
    // ======================================

    if (useMySQL && pool) {
      const connection = await pool.getConnection();

      try {
        await connection.beginTransaction();

        const [result] =
          await connection.execute<ResultSetHeader>(
            `INSERT INTO users (
              first_name,
              last_name,
              institutional_email,
              password_hash,
              university_name,
              is_verified,
              verification_code
            ) VALUES (?, ?, ?, ?, ?, 1, NULL)`,
            [
              first_name,
              last_name,
              institutional_email,
              password_hash,
              university_name
            ]
          );

        userId = result.insertId;

        // Guardar la carrera y el ciclo desde el registro.
        await connection.execute(
          `INSERT INTO profiles (
            user_id,
            career,
            semester,
            bio
          ) VALUES (?, ?, ?, '')`,
          [
            userId,
            career,
            semester
          ]
        );

        await connection.commit();
      } catch (error) {
        await connection.rollback();
        throw error;
      } finally {
        connection.release();
      }
    } else {
      // Compatibilidad con el modo memoria original.
      const created = await createUser({
        first_name,
        last_name,
        institutional_email,
        password_hash,
        university_name,
        verification_code: ''
      });

      userId = created.id;

      await updateProfile(userId, {
        career,
        semester,
        bio: ''
      });

      await markVerified(userId);
    }

    // ======================================
    // RESPUESTA
    // ======================================

    const createdUser = await findUserById(userId);

    if (!createdUser) {
      throw new Error('No fue posible recuperar la cuenta.');
    }

    res.status(201).json({
      user: publicUser(createdUser),
      message: 'Tu cuenta fue creada. Ya puedes iniciar sesión.'
    });

  } catch (error: unknown) {
    const dbError = error as { code?: string };

    if (dbError.code === 'ER_DUP_ENTRY') {
      res.status(409).json({
        error: 'Este correo ya está registrado.'
      });
      return;
    }

    console.error('Error de registro:', error);

    res.status(500).json({
      error: 'No se pudo completar el registro.'
    });
  }
});

// ==========================================
// INICIAR SESIÓN
// POST /api/auth/login
// ==========================================

router.post('/login', async (req: Request, res: Response) => {
  try {
    const email = clean(req.body?.email).toLowerCase();

    const password =
      typeof req.body?.password === 'string'
        ? req.body.password
        : '';

    if (!email || !password) {
      res.status(400).json({
        error: 'Ingresa tu correo y contraseña.'
      });
      return;
    }

    const user = await findUserByEmail(email);

    if (
      !user ||
      !(await bcrypt.compare(password, user.password_hash))
    ) {
      res.status(401).json({
        error: 'Correo o contraseña incorrectos.'
      });
      return;
    }

    // Compatibilidad con cuentas antiguas.
    // is_verified se conserva como indicador interno
    // para las consultas heredadas, no como prueba
    // de propiedad del correo.
    if (user.is_verified !== 1) {
      await markVerified(user.id);
    }

    const activeUser = await findUserById(user.id);

    if (!activeUser) {
      throw new Error('Cuenta no encontrada.');
    }

    res.json({
      user: publicUser(activeUser),
      token: signToken(activeUser.id)
    });

  } catch (error) {
    console.error('Error de inicio de sesión:', error);

    res.status(500).json({
      error: 'No se pudo iniciar sesión.'
    });
  }
});

export default router;
