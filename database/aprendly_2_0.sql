-- ===================================================================
-- APRENDLY | BASE DE DATOS UNIFICADA Y SEGURA PARA PRUEBAS LOCALES
-- Esquema + catálogo + 50 perfiles objetivo + sesiones + reseñas sintéticas
-- Compatible con MySQL 8 / MariaDB (XAMPP).
-- EJECUTAR SOLO EN UNA BASE LOCAL DE PRUEBAS TRAS EXPORTAR RESPALDO.
-- NO usa DROP TABLE y NO sobrescribe usuarios ni contraseñas existentes.
-- Si la base tiene 17 usuarios originales, agrega hasta llegar a 50.
-- Si ya tiene 50 usuarios y sesiones de ejemplo, NO duplica esos usuarios.
-- Las reseñas y asesorías sintéticas NO son testimonios reales.
-- Contraseña para nuevas cuentas @example.test: AprendlyDemo2026!
-- Contraseña de los 15 perfiles iniciales (si nacen aquí): Password123
-- ===================================================================


-- PARTE 1 / 2: TABLAS Y RELACIONES

-- ============================================================
-- Aprendly (SkillSync) — Esquema MySQL
-- ============================================================
-- Motor: InnoDB / Charset: utf8mb4
-- Entidades: universities, users, profiles, knowledge,
--            user_teach_knowledge, user_learn_knowledge,
--            matches, conversations, messages

CREATE DATABASE IF NOT EXISTS skillsync
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE skillsync;

-- Universidades (catálogo, dominio para orientación, NO limitante)
CREATE TABLE IF NOT EXISTS universities (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  domain VARCHAR(100) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Usuarios (auth + verificación institucional simulada)
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(80) NOT NULL,
  last_name VARCHAR(80) NOT NULL,
  institutional_email VARCHAR(160) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  university_id INT NULL,
  university_name VARCHAR(150) NOT NULL DEFAULT '',
  is_verified TINYINT(1) NOT NULL DEFAULT 0,
  verification_code VARCHAR(10) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_users_university FOREIGN KEY (university_id)
    REFERENCES universities(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- institutional_email UNIQUE ya crea un índice; evitamos duplicarlo.

-- Perfil académico (1:1 con users)
CREATE TABLE IF NOT EXISTS profiles (
  user_id INT PRIMARY KEY,
  career VARCHAR(120) NOT NULL DEFAULT '',
  semester VARCHAR(40) NOT NULL DEFAULT '',
  bio VARCHAR(500) NOT NULL DEFAULT '',
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT fk_profiles_user FOREIGN KEY (user_id)
    REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Catálogo de conocimientos
CREATE TABLE IF NOT EXISTS knowledge (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL UNIQUE,
  category VARCHAR(80) NOT NULL DEFAULT 'General'
) ENGINE=InnoDB;

-- Qué puede enseñar cada usuario
CREATE TABLE IF NOT EXISTS user_teach_knowledge (
  user_id INT NOT NULL,
  knowledge_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, knowledge_id),
  CONSTRAINT fk_teach_user FOREIGN KEY (user_id)
    REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_teach_know FOREIGN KEY (knowledge_id)
    REFERENCES knowledge(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Qué quiere aprender cada usuario
CREATE TABLE IF NOT EXISTS user_learn_knowledge (
  user_id INT NOT NULL,
  knowledge_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, knowledge_id),
  CONSTRAINT fk_learn_user FOREIGN KEY (user_id)
    REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_learn_know FOREIGN KEY (knowledge_id)
    REFERENCES knowledge(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Matches persistidos (par ordenado user_low < user_high para unicidad)
CREATE TABLE IF NOT EXISTS matches (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_a_id INT NOT NULL,
  user_b_id INT NOT NULL,
  compatibility DECIMAL(5,2) NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_match_pair (user_a_id, user_b_id),
  CONSTRAINT fk_match_a FOREIGN KEY (user_a_id)
    REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_match_b FOREIGN KEY (user_b_id)
    REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT chk_match_order CHECK (user_a_id < user_b_id),
  CONSTRAINT chk_match_distinct CHECK (user_a_id <> user_b_id)
) ENGINE=InnoDB;

-- Conversaciones 1:1 entre matches (par ordenado)
CREATE TABLE IF NOT EXISTS conversations (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_one_id INT NOT NULL,
  user_two_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_conv_pair (user_one_id, user_two_id),
  CONSTRAINT fk_conv_one FOREIGN KEY (user_one_id)
    REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_conv_two FOREIGN KEY (user_two_id)
    REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT chk_conv_order CHECK (user_one_id < user_two_id),
  CONSTRAINT chk_conv_distinct CHECK (user_one_id <> user_two_id)
) ENGINE=InnoDB;

-- Mensajes básicos
CREATE TABLE IF NOT EXISTS messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  conversation_id INT NOT NULL,
  sender_id INT NOT NULL,
  body TEXT NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_msg_conv FOREIGN KEY (conversation_id)
    REFERENCES conversations(id) ON DELETE CASCADE,
  CONSTRAINT fk_msg_sender FOREIGN KEY (sender_id)
    REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Índice adicional de mensajes opcional en migración posterior.


-- ============================================================
-- Aprendly 2.0 — ampliaciones para asesorías, reseñas y reconocimientos
-- Compatible con el backend original y XAMPP (MariaDB/MySQL).
-- Ejecutar en una BD de prueba. No elimina tablas existentes.
-- ============================================================

CREATE TABLE IF NOT EXISTS connection_requests (
  id INT AUTO_INCREMENT PRIMARY KEY,
  requester_id INT NOT NULL,
  recipient_id INT NOT NULL,
  status ENUM('pending','accepted','rejected','cancelled') NOT NULL DEFAULT 'pending',
  message VARCHAR(500) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  responded_at DATETIME NULL,
  FOREIGN KEY (requester_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (recipient_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY uq_connection_direction (requester_id,recipient_id),
  INDEX idx_requests_recipient (recipient_id,status)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS mentorship_sessions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  mentor_id INT NOT NULL,
  learner_id INT NOT NULL,
  knowledge_id INT NOT NULL,
  scheduled_start DATETIME NOT NULL,
  scheduled_end DATETIME NOT NULL,
  modality ENUM('online','presential') NOT NULL DEFAULT 'online',
  meeting_url VARCHAR(500) NULL,
  status ENUM('proposed','accepted','rejected','cancelled','completed','no_show') NOT NULL DEFAULT 'proposed',
  mentor_confirmed TINYINT(1) NOT NULL DEFAULT 0,
  learner_confirmed TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (mentor_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (learner_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (knowledge_id) REFERENCES knowledge(id),
  INDEX idx_sessions_mentor (mentor_id,status,scheduled_start),
  INDEX idx_sessions_learner (learner_id,status,scheduled_start)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS session_reviews (
  id INT AUTO_INCREMENT PRIMARY KEY,
  session_id INT NOT NULL,
  reviewer_id INT NOT NULL,
  reviewed_id INT NOT NULL,
  rating TINYINT UNSIGNED NOT NULL,
  comment VARCHAR(1000) NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_session_reviewer (session_id,reviewer_id),
  FOREIGN KEY (session_id) REFERENCES mentorship_sessions(id) ON DELETE CASCADE,
  FOREIGN KEY (reviewer_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (reviewed_id) REFERENCES users(id) ON DELETE CASCADE,
  CHECK (rating BETWEEN 1 AND 5)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS notifications (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  event_type VARCHAR(60) NOT NULL,
  title VARCHAR(160) NOT NULL,
  body VARCHAR(500) NULL,
  reference_type VARCHAR(50) NULL,
  reference_id INT NULL,
  is_read TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_notifications_user (user_id,is_read,created_at)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS recognitions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  period_year SMALLINT NOT NULL,
  period_month TINYINT NOT NULL,
  rank_position TINYINT NOT NULL,
  average_rating DECIMAL(3,2) NOT NULL,
  sessions_count INT NOT NULL,
  verification_code VARCHAR(64) NOT NULL UNIQUE,
  issued_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY uq_recognition_period_user (user_id,period_year,period_month),
  UNIQUE KEY uq_recognition_period_rank (period_year,period_month,rank_position),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  CHECK (rank_position BETWEEN 1 AND 5)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS user_availability (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  weekday TINYINT NOT NULL COMMENT '1=lunes,7=domingo',
  start_time TIME NOT NULL,
  end_time TIME NOT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  UNIQUE KEY uq_availability_slot (user_id,weekday,start_time),
  CHECK (weekday BETWEEN 1 AND 7)
) ENGINE=InnoDB;

-- ================================================================


-- Tablas marcadoras: permiten distinguir y limpiar datos ficticios.
CREATE TABLE IF NOT EXISTS aprendly_demo_seed_users (
  user_id INT PRIMARY KEY,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_demo_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB;
CREATE TABLE IF NOT EXISTS aprendly_demo_seed_sessions (
  session_id INT PRIMARY KEY,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_demo_session FOREIGN KEY (session_id) REFERENCES mentorship_sessions(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Recomendación: permitir que el TOP3 cambie sin chocar con índice por puesto.
SET @has_recognition_rank_index := (
  SELECT COUNT(*) FROM information_schema.statistics
  WHERE table_schema = DATABASE() AND table_name='recognitions'
    AND index_name='uq_recognition_period_rank'
);
SET @sql_recognition_rank := IF(@has_recognition_rank_index > 0,
  'ALTER TABLE recognitions DROP INDEX uq_recognition_period_rank',
  'SELECT ''El índice de puestos ya está ajustado'' AS aviso');
PREPARE apr_stmt FROM @sql_recognition_rank;
EXECUTE apr_stmt;
DEALLOCATE PREPARE apr_stmt;

-- Catálogo de universidades y 15 perfiles de ejemplo iniciales.
-- Nunca modificamos datos de una cuenta que ya existe.


-- PARTE 2 / 2: DATOS FICTICIOS DE PRUEBA
-- ================================================================

-- APR ENDLY 2.0 - Datos DEMO, NO usar con personas reales.
-- Importar DESPUÉS de aprendly_01_esquema.sql, mediante phpMyAdmin.
-- Cuentas ficticias preexistentes: Password123 SOLO si se crean nuevas. No se actualizan contraseñas.
-- Idempotente para usuarios/habilidades/relaciones. No crea sesiones inventadas.
-- SEGURIDAD: esta versión NO reemplaza contraseñas ni perfiles ya existentes.
USE skillsync;

INSERT INTO universities(name,domain) SELECT 'Universidad Tecnológica del Perú (UTP)','utp.edu.pe' WHERE NOT EXISTS (SELECT 1 FROM universities WHERE domain='utp.edu.pe');
INSERT INTO universities(name,domain) SELECT 'Universidad Nacional Mayor de San Marcos','unmsm.edu.pe' WHERE NOT EXISTS (SELECT 1 FROM universities WHERE domain='unmsm.edu.pe');
INSERT INTO universities(name,domain) SELECT 'Pontificia Universidad Católica del Perú','pucp.edu.pe' WHERE NOT EXISTS (SELECT 1 FROM universities WHERE domain='pucp.edu.pe');
INSERT INTO universities(name,domain) SELECT 'Universidad Peruana de Ciencias Aplicadas','upc.edu.pe' WHERE NOT EXISTS (SELECT 1 FROM universities WHERE domain='upc.edu.pe');
INSERT INTO universities(name,domain) SELECT 'Universidad Nacional de Ingeniería','uni.edu.pe' WHERE NOT EXISTS (SELECT 1 FROM universities WHERE domain='uni.edu.pe');
INSERT INTO knowledge(name,category) VALUES ('Java','Programación') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO knowledge(name,category) VALUES ('Git','Herramientas') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO knowledge(name,category) VALUES ('HTML','Programación Web') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO knowledge(name,category) VALUES ('CSS','Programación Web') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO knowledge(name,category) VALUES ('Programación Web','Programación Web') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO knowledge(name,category) VALUES ('Estadística','Matemáticas') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO knowledge(name,category) VALUES ('Excel','Ofimática') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO knowledge(name,category) VALUES ('Python','Programación') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO knowledge(name,category) VALUES ('Machine Learning','IA/Datos') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO knowledge(name,category) VALUES ('Redes','Infraestructura') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO knowledge(name,category) VALUES ('Packet Tracer','Infraestructura') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO knowledge(name,category) VALUES ('Diseño UX','Diseño') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO knowledge(name,category) VALUES ('Figma','Diseño') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO knowledge(name,category) VALUES ('SQL','Bases de Datos') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO knowledge(name,category) VALUES ('Bases de Datos','Bases de Datos') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO knowledge(name,category) VALUES ('Matemáticas','Matemáticas') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO knowledge(name,category) VALUES ('Inglés','Idiomas') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO knowledge(name,category) VALUES ('Marketing','Negocios') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO knowledge(name,category) VALUES ('Comunicación','Comunicación') ON DUPLICATE KEY UPDATE category=VALUES(category);
INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified,verification_code) VALUES ('Leonardo','Ramos','leonardo.ramos@utp.edu.pe','$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W',(SELECT id FROM universities WHERE domain='utp.edu.pe' LIMIT 1),'Universidad Tecnológica del Perú (UTP)',1,NULL) ON DUPLICATE KEY UPDATE id=id;
INSERT INTO profiles(user_id,career,semester,bio) SELECT id,'Ingeniería Informática','5to ciclo','Desarrollo web, Java y Git. Quiero mejorar mi Estadística.' FROM users WHERE institutional_email='leonardo.ramos@utp.edu.pe' ON DUPLICATE KEY UPDATE user_id=user_id;
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Java' WHERE u.institutional_email='leonardo.ramos@utp.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Git' WHERE u.institutional_email='leonardo.ramos@utp.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='HTML' WHERE u.institutional_email='leonardo.ramos@utp.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Estadística' WHERE u.institutional_email='leonardo.ramos@utp.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Excel' WHERE u.institutional_email='leonardo.ramos@utp.edu.pe';
INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified,verification_code) VALUES ('Carlos','Mendoza','carlos.mendoza@unmsm.edu.pe','$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W',(SELECT id FROM universities WHERE domain='unmsm.edu.pe' LIMIT 1),'Universidad Nacional Mayor de San Marcos',1,NULL) ON DUPLICATE KEY UPDATE id=id;
INSERT INTO profiles(user_id,career,semester,bio) SELECT id,'Ingeniería de Sistemas','4to ciclo','Me gustan las matemáticas y compartir técnicas de Excel.' FROM users WHERE institutional_email='carlos.mendoza@unmsm.edu.pe' ON DUPLICATE KEY UPDATE user_id=user_id;
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Estadística' WHERE u.institutional_email='carlos.mendoza@unmsm.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Excel' WHERE u.institutional_email='carlos.mendoza@unmsm.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Matemáticas' WHERE u.institutional_email='carlos.mendoza@unmsm.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Java' WHERE u.institutional_email='carlos.mendoza@unmsm.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Python' WHERE u.institutional_email='carlos.mendoza@unmsm.edu.pe';
INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified,verification_code) VALUES ('Andrea','Torres','andrea.torres@pucp.edu.pe','$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W',(SELECT id FROM universities WHERE domain='pucp.edu.pe' LIMIT 1),'Pontificia Universidad Católica del Perú',1,NULL) ON DUPLICATE KEY UPDATE id=id;
INSERT INTO profiles(user_id,career,semester,bio) SELECT id,'Ciencia de la Computación','6to ciclo','Trabajo con Python y Machine Learning; quiero dominar Git.' FROM users WHERE institutional_email='andrea.torres@pucp.edu.pe' ON DUPLICATE KEY UPDATE user_id=user_id;
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Python' WHERE u.institutional_email='andrea.torres@pucp.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Machine Learning' WHERE u.institutional_email='andrea.torres@pucp.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Estadística' WHERE u.institutional_email='andrea.torres@pucp.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Git' WHERE u.institutional_email='andrea.torres@pucp.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Diseño UX' WHERE u.institutional_email='andrea.torres@pucp.edu.pe';
INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified,verification_code) VALUES ('Miguel','Quispe','miguel.quispe@upc.edu.pe','$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W',(SELECT id FROM universities WHERE domain='upc.edu.pe' LIMIT 1),'Universidad Peruana de Ciencias Aplicadas',1,NULL) ON DUPLICATE KEY UPDATE id=id;
INSERT INTO profiles(user_id,career,semester,bio) SELECT id,'Ingeniería de Redes','3er ciclo','Me entusiasman las redes y las simulaciones de conectividad.' FROM users WHERE institutional_email='miguel.quispe@upc.edu.pe' ON DUPLICATE KEY UPDATE user_id=user_id;
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Redes' WHERE u.institutional_email='miguel.quispe@upc.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Packet Tracer' WHERE u.institutional_email='miguel.quispe@upc.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='HTML' WHERE u.institutional_email='miguel.quispe@upc.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='CSS' WHERE u.institutional_email='miguel.quispe@upc.edu.pe';
INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified,verification_code) VALUES ('Valeria','Castillo','valeria.castillo.demo@utp.edu.pe','$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W',(SELECT id FROM universities WHERE domain='utp.edu.pe' LIMIT 1),'Universidad Tecnológica del Perú (UTP)',1,NULL) ON DUPLICATE KEY UPDATE id=id;
INSERT INTO profiles(user_id,career,semester,bio) SELECT id,'Ingeniería de Software','7mo ciclo','Diseño experiencias digitales y aprendo programación.' FROM users WHERE institutional_email='valeria.castillo.demo@utp.edu.pe' ON DUPLICATE KEY UPDATE user_id=user_id;
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Diseño UX' WHERE u.institutional_email='valeria.castillo.demo@utp.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Figma' WHERE u.institutional_email='valeria.castillo.demo@utp.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='CSS' WHERE u.institutional_email='valeria.castillo.demo@utp.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Python' WHERE u.institutional_email='valeria.castillo.demo@utp.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='SQL' WHERE u.institutional_email='valeria.castillo.demo@utp.edu.pe';
INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified,verification_code) VALUES ('Diego','Rojas','diego.rojas.demo@uni.edu.pe','$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W',(SELECT id FROM universities WHERE domain='uni.edu.pe' LIMIT 1),'Universidad Nacional de Ingeniería',1,NULL) ON DUPLICATE KEY UPDATE id=id;
INSERT INTO profiles(user_id,career,semester,bio) SELECT id,'Ingeniería de Sistemas','8vo ciclo','Me gusta resolver problemas de bases de datos y backend.' FROM users WHERE institutional_email='diego.rojas.demo@uni.edu.pe' ON DUPLICATE KEY UPDATE user_id=user_id;
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='SQL' WHERE u.institutional_email='diego.rojas.demo@uni.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Java' WHERE u.institutional_email='diego.rojas.demo@uni.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Bases de Datos' WHERE u.institutional_email='diego.rojas.demo@uni.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Inglés' WHERE u.institutional_email='diego.rojas.demo@uni.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Machine Learning' WHERE u.institutional_email='diego.rojas.demo@uni.edu.pe';
INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified,verification_code) VALUES ('Sofía','Ramírez','sofia.ramirez.demo@pucp.edu.pe','$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W',(SELECT id FROM universities WHERE domain='pucp.edu.pe' LIMIT 1),'Pontificia Universidad Católica del Perú',1,NULL) ON DUPLICATE KEY UPDATE id=id;
INSERT INTO profiles(user_id,career,semester,bio) SELECT id,'Administración','5to ciclo','Intercambio conocimientos en comunicación y análisis.' FROM users WHERE institutional_email='sofia.ramirez.demo@pucp.edu.pe' ON DUPLICATE KEY UPDATE user_id=user_id;
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Excel' WHERE u.institutional_email='sofia.ramirez.demo@pucp.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Inglés' WHERE u.institutional_email='sofia.ramirez.demo@pucp.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Marketing' WHERE u.institutional_email='sofia.ramirez.demo@pucp.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Estadística' WHERE u.institutional_email='sofia.ramirez.demo@pucp.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Python' WHERE u.institutional_email='sofia.ramirez.demo@pucp.edu.pe';
INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified,verification_code) VALUES ('Luciana','Pérez','luciana.perez.demo@upc.edu.pe','$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W',(SELECT id FROM universities WHERE domain='upc.edu.pe' LIMIT 1),'Universidad Peruana de Ciencias Aplicadas',1,NULL) ON DUPLICATE KEY UPDATE id=id;
INSERT INTO profiles(user_id,career,semester,bio) SELECT id,'Comunicación','4to ciclo','Aprendo tecnología y comparto herramientas digitales.' FROM users WHERE institutional_email='luciana.perez.demo@upc.edu.pe' ON DUPLICATE KEY UPDATE user_id=user_id;
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Comunicación' WHERE u.institutional_email='luciana.perez.demo@upc.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Inglés' WHERE u.institutional_email='luciana.perez.demo@upc.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Diseño UX' WHERE u.institutional_email='luciana.perez.demo@upc.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='HTML' WHERE u.institutional_email='luciana.perez.demo@upc.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Marketing' WHERE u.institutional_email='luciana.perez.demo@upc.edu.pe';
INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified,verification_code) VALUES ('Daniel','Flores','daniel.flores.demo@unmsm.edu.pe','$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W',(SELECT id FROM universities WHERE domain='unmsm.edu.pe' LIMIT 1),'Universidad Nacional Mayor de San Marcos',1,NULL) ON DUPLICATE KEY UPDATE id=id;
INSERT INTO profiles(user_id,career,semester,bio) SELECT id,'Ingeniería Estadística','7mo ciclo','Analizo datos y ayudo con fundamentos estadísticos.' FROM users WHERE institutional_email='daniel.flores.demo@unmsm.edu.pe' ON DUPLICATE KEY UPDATE user_id=user_id;
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Estadística' WHERE u.institutional_email='daniel.flores.demo@unmsm.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Python' WHERE u.institutional_email='daniel.flores.demo@unmsm.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='SQL' WHERE u.institutional_email='daniel.flores.demo@unmsm.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Machine Learning' WHERE u.institutional_email='daniel.flores.demo@unmsm.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Git' WHERE u.institutional_email='daniel.flores.demo@unmsm.edu.pe';
INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified,verification_code) VALUES ('Camila','Vargas','camila.vargas.demo@utp.edu.pe','$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W',(SELECT id FROM universities WHERE domain='utp.edu.pe' LIMIT 1),'Universidad Tecnológica del Perú (UTP)',1,NULL) ON DUPLICATE KEY UPDATE id=id;
INSERT INTO profiles(user_id,career,semester,bio) SELECT id,'Ingeniería Informática','3er ciclo','Quiero aprender a crear aplicaciones web.' FROM users WHERE institutional_email='camila.vargas.demo@utp.edu.pe' ON DUPLICATE KEY UPDATE user_id=user_id;
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='HTML' WHERE u.institutional_email='camila.vargas.demo@utp.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='CSS' WHERE u.institutional_email='camila.vargas.demo@utp.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Java' WHERE u.institutional_email='camila.vargas.demo@utp.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='SQL' WHERE u.institutional_email='camila.vargas.demo@utp.edu.pe';
INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified,verification_code) VALUES ('José','Navarro','jose.navarro.demo@uni.edu.pe','$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W',(SELECT id FROM universities WHERE domain='uni.edu.pe' LIMIT 1),'Universidad Nacional de Ingeniería',1,NULL) ON DUPLICATE KEY UPDATE id=id;
INSERT INTO profiles(user_id,career,semester,bio) SELECT id,'Ingeniería Electrónica','6to ciclo','Comparto fundamentos matemáticos y redes.' FROM users WHERE institutional_email='jose.navarro.demo@uni.edu.pe' ON DUPLICATE KEY UPDATE user_id=user_id;
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Matemáticas' WHERE u.institutional_email='jose.navarro.demo@uni.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Redes' WHERE u.institutional_email='jose.navarro.demo@uni.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Packet Tracer' WHERE u.institutional_email='jose.navarro.demo@uni.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Python' WHERE u.institutional_email='jose.navarro.demo@uni.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Git' WHERE u.institutional_email='jose.navarro.demo@uni.edu.pe';
INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified,verification_code) VALUES ('Mariana','Salazar','mariana.salazar.demo@upc.edu.pe','$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W',(SELECT id FROM universities WHERE domain='upc.edu.pe' LIMIT 1),'Universidad Peruana de Ciencias Aplicadas',1,NULL) ON DUPLICATE KEY UPDATE id=id;
INSERT INTO profiles(user_id,career,semester,bio) SELECT id,'Ingeniería de Software','5to ciclo','Me interesa la experiencia de usuario y programación.' FROM users WHERE institutional_email='mariana.salazar.demo@upc.edu.pe' ON DUPLICATE KEY UPDATE user_id=user_id;
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Figma' WHERE u.institutional_email='mariana.salazar.demo@upc.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Diseño UX' WHERE u.institutional_email='mariana.salazar.demo@upc.edu.pe';
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='HTML' WHERE u.institutional_email='mariana.salazar.demo@upc.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Machine Learning' WHERE u.institutional_email='mariana.salazar.demo@upc.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Excel' WHERE u.institutional_email='mariana.salazar.demo@upc.edu.pe';
INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified,verification_code) VALUES ('Renato','García','renato.garcia.demo@unmsm.edu.pe','$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W',(SELECT id FROM universities WHERE domain='unmsm.edu.pe' LIMIT 1),'Universidad Nacional Mayor de San Marcos',1,NULL) ON DUPLICATE KEY UPDATE id=id;
INSERT INTO profiles(user_id,career,semester,bio) SELECT id,'Administración','2do ciclo','Nuevo en la comunidad; busco apoyo en herramientas digitales.' FROM users WHERE institutional_email='renato.garcia.demo@unmsm.edu.pe' ON DUPLICATE KEY UPDATE user_id=user_id;
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Comunicación' WHERE u.institutional_email='renato.garcia.demo@unmsm.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Excel' WHERE u.institutional_email='renato.garcia.demo@unmsm.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Estadística' WHERE u.institutional_email='renato.garcia.demo@unmsm.edu.pe';
INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified,verification_code) VALUES ('Paula','Medina','paula.medina.demo@pucp.edu.pe','$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W',(SELECT id FROM universities WHERE domain='pucp.edu.pe' LIMIT 1),'Pontificia Universidad Católica del Perú',1,NULL) ON DUPLICATE KEY UPDATE id=id;
INSERT INTO profiles(user_id,career,semester,bio) SELECT id,'Ciencia de Datos','3er ciclo','Exploro diferentes técnicas de análisis y programación.' FROM users WHERE institutional_email='paula.medina.demo@pucp.edu.pe' ON DUPLICATE KEY UPDATE user_id=user_id;
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Python' WHERE u.institutional_email='paula.medina.demo@pucp.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='SQL' WHERE u.institutional_email='paula.medina.demo@pucp.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Estadística' WHERE u.institutional_email='paula.medina.demo@pucp.edu.pe';
INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified,verification_code) VALUES ('Bruno','Herrera','bruno.herrera.demo@utp.edu.pe','$2a$10$DmvKpf/g.NAySDAzav.Lx.qi8qBBaBWAW.tdgiH4x1HAOFqXF0k7W',(SELECT id FROM universities WHERE domain='utp.edu.pe' LIMIT 1),'Universidad Tecnológica del Perú (UTP)',1,NULL) ON DUPLICATE KEY UPDATE id=id;
INSERT INTO profiles(user_id,career,semester,bio) SELECT id,'Ingeniería Informática','2do ciclo','Busco compañeros para reforzar mis cursos.' FROM users WHERE institutional_email='bruno.herrera.demo@utp.edu.pe' ON DUPLICATE KEY UPDATE user_id=user_id;
INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='HTML' WHERE u.institutional_email='bruno.herrera.demo@utp.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Java' WHERE u.institutional_email='bruno.herrera.demo@utp.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Git' WHERE u.institutional_email='bruno.herrera.demo@utp.edu.pe';
INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id) SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Redes' WHERE u.institutional_email='bruno.herrera.demo@utp.edu.pe';



-- ====================================================
-- Usuarios ficticios adicionales, SOLO los necesarios para 50
-- ====================================================


INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Ariana','Paredes','aprendly.demo01@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Peruana de Ciencias Aplicadas',1
FROM universities un WHERE un.domain='upc.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo01@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Administración','6to ciclo','Comparto Excel y también quiero aprender Inglés.'
FROM users u WHERE u.institutional_email='aprendly.demo01@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo01@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Excel' WHERE u.institutional_email='aprendly.demo01@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Marketing' WHERE u.institutional_email='aprendly.demo01@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Inglés' WHERE u.institutional_email='aprendly.demo01@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Estadística' WHERE u.institutional_email='aprendly.demo01@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Mateo','Cruz','aprendly.demo02@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Tecnológica del Perú (UTP)',1
FROM universities un WHERE un.domain='utp.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo02@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Ingeniería de Sistemas','4to ciclo','Comparto Git y también quiero aprender SQL.'
FROM users u WHERE u.institutional_email='aprendly.demo02@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo02@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Git' WHERE u.institutional_email='aprendly.demo02@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='SQL' WHERE u.institutional_email='aprendly.demo02@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Java' WHERE u.institutional_email='aprendly.demo02@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Fernanda','Ruiz','aprendly.demo03@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Pontificia Universidad Católica del Perú',1
FROM universities un WHERE un.domain='pucp.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo03@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Diseño Gráfico','5to ciclo','Comparto Figma y también quiero aprender HTML.'
FROM users u WHERE u.institutional_email='aprendly.demo03@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo03@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Figma' WHERE u.institutional_email='aprendly.demo03@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Diseño UX' WHERE u.institutional_email='aprendly.demo03@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='HTML' WHERE u.institutional_email='aprendly.demo03@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='CSS' WHERE u.institutional_email='aprendly.demo03@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Emilio','Vega','aprendly.demo04@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Nacional de Ingeniería',1
FROM universities un WHERE un.domain='uni.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo04@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Ingeniería Industrial','3to ciclo','Comparto Matemáticas y también quiero aprender Excel.'
FROM users u WHERE u.institutional_email='aprendly.demo04@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo04@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Matemáticas' WHERE u.institutional_email='aprendly.demo04@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Excel' WHERE u.institutional_email='aprendly.demo04@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Python' WHERE u.institutional_email='aprendly.demo04@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Alessia','Campos','aprendly.demo05@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Peruana de Ciencias Aplicadas',1
FROM universities un WHERE un.domain='upc.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo05@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Comunicación','4to ciclo','Comparto Comunicación y también quiero aprender Marketing.'
FROM users u WHERE u.institutional_email='aprendly.demo05@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo05@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Comunicación' WHERE u.institutional_email='aprendly.demo05@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Marketing' WHERE u.institutional_email='aprendly.demo05@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Inglés' WHERE u.institutional_email='aprendly.demo05@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Joaquín','Torres','aprendly.demo06@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Nacional Mayor de San Marcos',1
FROM universities un WHERE un.domain='unmsm.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo06@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Contabilidad','2to ciclo','Busco apoyo para aprender Excel.'
FROM users u WHERE u.institutional_email='aprendly.demo06@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo06@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Excel' WHERE u.institutional_email='aprendly.demo06@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Estadística' WHERE u.institutional_email='aprendly.demo06@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Karla','Reyes','aprendly.demo07@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Pontificia Universidad Católica del Perú',1
FROM universities un WHERE un.domain='pucp.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo07@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Psicología','5to ciclo','Busco apoyo para aprender Inglés.'
FROM users u WHERE u.institutional_email='aprendly.demo07@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo07@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Inglés' WHERE u.institutional_email='aprendly.demo07@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Comunicación' WHERE u.institutional_email='aprendly.demo07@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Sebastián','Flores','aprendly.demo08@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Tecnológica del Perú (UTP)',1
FROM universities un WHERE un.domain='utp.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo08@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Ingeniería de Software','6to ciclo','Comparto Java y también quiero aprender Machine Learning.'
FROM users u WHERE u.institutional_email='aprendly.demo08@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo08@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Java' WHERE u.institutional_email='aprendly.demo08@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Git' WHERE u.institutional_email='aprendly.demo08@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Machine Learning' WHERE u.institutional_email='aprendly.demo08@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Redes' WHERE u.institutional_email='aprendly.demo08@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Rocío','Guzmán','aprendly.demo09@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Peruana de Ciencias Aplicadas',1
FROM universities un WHERE un.domain='upc.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo09@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Marketing','4to ciclo','Comparto Marketing y también quiero aprender Figma.'
FROM users u WHERE u.institutional_email='aprendly.demo09@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo09@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Marketing' WHERE u.institutional_email='aprendly.demo09@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Figma' WHERE u.institutional_email='aprendly.demo09@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Excel' WHERE u.institutional_email='aprendly.demo09@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Alonso','Pinto','aprendly.demo10@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Nacional de Ingeniería',1
FROM universities un WHERE un.domain='uni.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo10@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Arquitectura','3to ciclo','Busco apoyo para aprender Figma.'
FROM users u WHERE u.institutional_email='aprendly.demo10@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo10@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Figma' WHERE u.institutional_email='aprendly.demo10@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Matemáticas' WHERE u.institutional_email='aprendly.demo10@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'María','Chávez','aprendly.demo11@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Nacional Mayor de San Marcos',1
FROM universities un WHERE un.domain='unmsm.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo11@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Economía','6to ciclo','Comparto Estadística y también quiero aprender Python.'
FROM users u WHERE u.institutional_email='aprendly.demo11@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo11@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Estadística' WHERE u.institutional_email='aprendly.demo11@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Python' WHERE u.institutional_email='aprendly.demo11@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='SQL' WHERE u.institutional_email='aprendly.demo11@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Esteban','Cárdenas','aprendly.demo12@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Nacional de Ingeniería',1
FROM universities un WHERE un.domain='uni.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo12@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Ingeniería Civil','4to ciclo','Busco apoyo para aprender Matemáticas.'
FROM users u WHERE u.institutional_email='aprendly.demo12@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo12@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Matemáticas' WHERE u.institutional_email='aprendly.demo12@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Excel' WHERE u.institutional_email='aprendly.demo12@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Daniela','Soto','aprendly.demo13@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Pontificia Universidad Católica del Perú',1
FROM universities un WHERE un.domain='pucp.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo13@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Ciencia de Datos','7to ciclo','Comparto SQL y también quiero aprender Redes.'
FROM users u WHERE u.institutional_email='aprendly.demo13@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo13@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='SQL' WHERE u.institutional_email='aprendly.demo13@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Python' WHERE u.institutional_email='aprendly.demo13@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Redes' WHERE u.institutional_email='aprendly.demo13@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Inglés' WHERE u.institutional_email='aprendly.demo13@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Nicolás','Herrera','aprendly.demo14@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Peruana de Ciencias Aplicadas',1
FROM universities un WHERE un.domain='upc.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo14@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Derecho','3to ciclo','Busco apoyo para aprender Comunicación.'
FROM users u WHERE u.institutional_email='aprendly.demo14@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo14@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Comunicación' WHERE u.institutional_email='aprendly.demo14@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Inglés' WHERE u.institutional_email='aprendly.demo14@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Jimena','Cabrera','aprendly.demo15@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Tecnológica del Perú (UTP)',1
FROM universities un WHERE un.domain='utp.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo15@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Ingeniería Informática','2to ciclo','Busco apoyo para aprender Java.'
FROM users u WHERE u.institutional_email='aprendly.demo15@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo15@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Java' WHERE u.institutional_email='aprendly.demo15@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='HTML' WHERE u.institutional_email='aprendly.demo15@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Rodrigo','Molina','aprendly.demo16@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Nacional Mayor de San Marcos',1
FROM universities un WHERE un.domain='unmsm.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo16@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Administración','5to ciclo','Comparto Excel y también quiero aprender Inglés.'
FROM users u WHERE u.institutional_email='aprendly.demo16@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo16@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Excel' WHERE u.institutional_email='aprendly.demo16@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Inglés' WHERE u.institutional_email='aprendly.demo16@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Marketing' WHERE u.institutional_email='aprendly.demo16@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Camila','Aguilar','aprendly.demo17@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Peruana de Ciencias Aplicadas',1
FROM universities un WHERE un.domain='upc.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo17@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Publicidad','4to ciclo','Busco apoyo para aprender Diseño UX.'
FROM users u WHERE u.institutional_email='aprendly.demo17@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo17@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Diseño UX' WHERE u.institutional_email='aprendly.demo17@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Marketing' WHERE u.institutional_email='aprendly.demo17@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Santiago','Paz','aprendly.demo18@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Nacional de Ingeniería',1
FROM universities un WHERE un.domain='uni.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo18@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Ingeniería de Sistemas','5to ciclo','Comparto SQL y también quiero aprender Machine Learning.'
FROM users u WHERE u.institutional_email='aprendly.demo18@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo18@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='SQL' WHERE u.institutional_email='aprendly.demo18@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Machine Learning' WHERE u.institutional_email='aprendly.demo18@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Git' WHERE u.institutional_email='aprendly.demo18@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Renata','Bautista','aprendly.demo19@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Pontificia Universidad Católica del Perú',1
FROM universities un WHERE un.domain='pucp.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo19@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Psicología','2to ciclo','Busco apoyo para aprender Estadística.'
FROM users u WHERE u.institutional_email='aprendly.demo19@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo19@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Estadística' WHERE u.institutional_email='aprendly.demo19@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Comunicación' WHERE u.institutional_email='aprendly.demo19@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Hugo','Navarro','aprendly.demo20@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Tecnológica del Perú (UTP)',1
FROM universities un WHERE un.domain='utp.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo20@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Ingeniería de Redes','4to ciclo','Comparto Packet Tracer y también quiero aprender Python.'
FROM users u WHERE u.institutional_email='aprendly.demo20@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo20@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Packet Tracer' WHERE u.institutional_email='aprendly.demo20@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Python' WHERE u.institutional_email='aprendly.demo20@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Redes' WHERE u.institutional_email='aprendly.demo20@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Nicole','Luna','aprendly.demo21@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Nacional Mayor de San Marcos',1
FROM universities un WHERE un.domain='unmsm.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo21@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Contabilidad','3to ciclo','Busco apoyo para aprender Excel.'
FROM users u WHERE u.institutional_email='aprendly.demo21@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo21@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Excel' WHERE u.institutional_email='aprendly.demo21@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Estadística' WHERE u.institutional_email='aprendly.demo21@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Álvaro','Silva','aprendly.demo22@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Pontificia Universidad Católica del Perú',1
FROM universities un WHERE un.domain='pucp.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo22@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Ciencia de la Computación','6to ciclo','Comparto HTML y también quiero aprender SQL.'
FROM users u WHERE u.institutional_email='aprendly.demo22@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo22@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='HTML' WHERE u.institutional_email='aprendly.demo22@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='CSS' WHERE u.institutional_email='aprendly.demo22@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='SQL' WHERE u.institutional_email='aprendly.demo22@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Java' WHERE u.institutional_email='aprendly.demo22@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Fiorella','Castro','aprendly.demo23@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Peruana de Ciencias Aplicadas',1
FROM universities un WHERE un.domain='upc.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo23@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Negocios Internacionales','5to ciclo','Busco apoyo para aprender Inglés.'
FROM users u WHERE u.institutional_email='aprendly.demo23@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo23@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Inglés' WHERE u.institutional_email='aprendly.demo23@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Marketing' WHERE u.institutional_email='aprendly.demo23@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Kevin','López','aprendly.demo24@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Nacional de Ingeniería',1
FROM universities un WHERE un.domain='uni.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo24@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Ingeniería Electrónica','4to ciclo','Comparto Matemáticas y también quiero aprender Redes.'
FROM users u WHERE u.institutional_email='aprendly.demo24@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo24@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Matemáticas' WHERE u.institutional_email='aprendly.demo24@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Redes' WHERE u.institutional_email='aprendly.demo24@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Python' WHERE u.institutional_email='aprendly.demo24@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Lucero','Romero','aprendly.demo25@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Tecnológica del Perú (UTP)',1
FROM universities un WHERE un.domain='utp.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo25@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Diseño UX','3to ciclo','Comparto Figma y también quiero aprender HTML.'
FROM users u WHERE u.institutional_email='aprendly.demo25@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo25@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Figma' WHERE u.institutional_email='aprendly.demo25@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='HTML' WHERE u.institutional_email='aprendly.demo25@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Marketing' WHERE u.institutional_email='aprendly.demo25@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Adrián','Peña','aprendly.demo26@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Nacional Mayor de San Marcos',1
FROM universities un WHERE un.domain='unmsm.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo26@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Administración','2to ciclo','Busco apoyo para aprender Excel.'
FROM users u WHERE u.institutional_email='aprendly.demo26@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo26@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Excel' WHERE u.institutional_email='aprendly.demo26@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Comunicación' WHERE u.institutional_email='aprendly.demo26@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Claudia','Morales','aprendly.demo27@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Pontificia Universidad Católica del Perú',1
FROM universities un WHERE un.domain='pucp.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo27@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Comunicación Audiovisual','6to ciclo','Comparto Comunicación y también quiero aprender Diseño UX.'
FROM users u WHERE u.institutional_email='aprendly.demo27@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo27@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Comunicación' WHERE u.institutional_email='aprendly.demo27@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Diseño UX' WHERE u.institutional_email='aprendly.demo27@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Inglés' WHERE u.institutional_email='aprendly.demo27@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Gonzalo','Medina','aprendly.demo28@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Peruana de Ciencias Aplicadas',1
FROM universities un WHERE un.domain='upc.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo28@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Ingeniería de Sistemas','3to ciclo','Busco apoyo para aprender Java.'
FROM users u WHERE u.institutional_email='aprendly.demo28@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo28@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Java' WHERE u.institutional_email='aprendly.demo28@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='SQL' WHERE u.institutional_email='aprendly.demo28@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Brenda','Palacios','aprendly.demo29@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Nacional Mayor de San Marcos',1
FROM universities un WHERE un.domain='unmsm.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo29@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Economía','4to ciclo','Busco apoyo para aprender Estadística.'
FROM users u WHERE u.institutional_email='aprendly.demo29@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo29@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Estadística' WHERE u.institutional_email='aprendly.demo29@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Excel' WHERE u.institutional_email='aprendly.demo29@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Thiago','Mendoza','aprendly.demo30@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Tecnológica del Perú (UTP)',1
FROM universities un WHERE un.domain='utp.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo30@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Ingeniería de Software','2to ciclo','Busco apoyo para aprender Git.'
FROM users u WHERE u.institutional_email='aprendly.demo30@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo30@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Git' WHERE u.institutional_email='aprendly.demo30@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='HTML' WHERE u.institutional_email='aprendly.demo30@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Isabel','Fuentes','aprendly.demo31@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Pontificia Universidad Católica del Perú',1
FROM universities un WHERE un.domain='pucp.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo31@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Psicología','4to ciclo','Busco apoyo para aprender Inglés.'
FROM users u WHERE u.institutional_email='aprendly.demo31@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo31@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Inglés' WHERE u.institutional_email='aprendly.demo31@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Comunicación' WHERE u.institutional_email='aprendly.demo31@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Óscar','Ríos','aprendly.demo32@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Nacional de Ingeniería',1
FROM universities un WHERE un.domain='uni.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo32@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Ingeniería Industrial','5to ciclo','Comparto Excel y también quiero aprender Python.'
FROM users u WHERE u.institutional_email='aprendly.demo32@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo32@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Excel' WHERE u.institutional_email='aprendly.demo32@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Python' WHERE u.institutional_email='aprendly.demo32@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Matemáticas' WHERE u.institutional_email='aprendly.demo32@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Valentina','Acuña','aprendly.demo33@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Peruana de Ciencias Aplicadas',1
FROM universities un WHERE un.domain='upc.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo33@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Administración','3to ciclo','Busco apoyo para aprender Marketing.'
FROM users u WHERE u.institutional_email='aprendly.demo33@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo33@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Marketing' WHERE u.institutional_email='aprendly.demo33@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Estadística' WHERE u.institutional_email='aprendly.demo33@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Fabricio','Salinas','aprendly.demo34@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Tecnológica del Perú (UTP)',1
FROM universities un WHERE un.domain='utp.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo34@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Informática','6to ciclo','Comparto Git y también quiero aprender Redes.'
FROM users u WHERE u.institutional_email='aprendly.demo34@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo34@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Git' WHERE u.institutional_email='aprendly.demo34@example.test';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='HTML' WHERE u.institutional_email='aprendly.demo34@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Redes' WHERE u.institutional_email='aprendly.demo34@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Java' WHERE u.institutional_email='aprendly.demo34@example.test';

INSERT INTO users(first_name,last_name,institutional_email,password_hash,university_id,university_name,is_verified)
SELECT 'Diana','Vergara','aprendly.demo35@example.test','$2a$10$zMrdhfR/B2lO7lo3fR2GhuLcQKp9hKbQ18WTwbBbA7lszKoMekiai',un.id,'Universidad Nacional Mayor de San Marcos',1
FROM universities un WHERE un.domain='unmsm.edu.pe'
  AND NOT EXISTS (SELECT 1 FROM users WHERE institutional_email='aprendly.demo35@example.test')
  AND (SELECT COUNT(*) FROM users) < 50 LIMIT 1;

INSERT IGNORE INTO profiles(user_id,career,semester,bio)
SELECT u.id,'Comunicación','4to ciclo','Busco apoyo para aprender Inglés.'
FROM users u WHERE u.institutional_email='aprendly.demo35@example.test';

INSERT IGNORE INTO aprendly_demo_seed_users(user_id)
SELECT u.id FROM users u WHERE u.institutional_email='aprendly.demo35@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Inglés' WHERE u.institutional_email='aprendly.demo35@example.test';

INSERT IGNORE INTO user_learn_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Marketing' WHERE u.institutional_email='aprendly.demo35@example.test';


-- Habilidades variadas de mentores destacados (sin eliminar habilidades previas).


INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Python' WHERE u.institutional_email='andrea.torres@pucp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Machine Learning' WHERE u.institutional_email='andrea.torres@pucp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Estadística' WHERE u.institutional_email='andrea.torres@pucp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Git' WHERE u.institutional_email='andrea.torres@pucp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='SQL' WHERE u.institutional_email='andrea.torres@pucp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Excel' WHERE u.institutional_email='sofia.ramirez.demo@pucp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Marketing' WHERE u.institutional_email='sofia.ramirez.demo@pucp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Comunicación' WHERE u.institutional_email='sofia.ramirez.demo@pucp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Inglés' WHERE u.institutional_email='sofia.ramirez.demo@pucp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Estadística' WHERE u.institutional_email='sofia.ramirez.demo@pucp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Java' WHERE u.institutional_email='leonardo.ramos@utp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Git' WHERE u.institutional_email='leonardo.ramos@utp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='HTML' WHERE u.institutional_email='leonardo.ramos@utp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='CSS' WHERE u.institutional_email='leonardo.ramos@utp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Programación Web' WHERE u.institutional_email='leonardo.ramos@utp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Estadística' WHERE u.institutional_email='carlos.mendoza@unmsm.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Excel' WHERE u.institutional_email='carlos.mendoza@unmsm.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Matemáticas' WHERE u.institutional_email='carlos.mendoza@unmsm.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='SQL' WHERE u.institutional_email='carlos.mendoza@unmsm.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Redes' WHERE u.institutional_email='miguel.quispe@upc.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Packet Tracer' WHERE u.institutional_email='miguel.quispe@upc.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Python' WHERE u.institutional_email='miguel.quispe@upc.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Git' WHERE u.institutional_email='miguel.quispe@upc.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='SQL' WHERE u.institutional_email='diego.rojas.demo@uni.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Bases de Datos' WHERE u.institutional_email='diego.rojas.demo@uni.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Java' WHERE u.institutional_email='diego.rojas.demo@uni.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Git' WHERE u.institutional_email='diego.rojas.demo@uni.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Diseño UX' WHERE u.institutional_email='valeria.castillo.demo@utp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Figma' WHERE u.institutional_email='valeria.castillo.demo@utp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='HTML' WHERE u.institutional_email='valeria.castillo.demo@utp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='CSS' WHERE u.institutional_email='valeria.castillo.demo@utp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Comunicación' WHERE u.institutional_email='luciana.perez.demo@upc.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Marketing' WHERE u.institutional_email='luciana.perez.demo@upc.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='SQL' WHERE u.institutional_email='daniel.flores.demo@unmsm.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Excel' WHERE u.institutional_email='daniel.flores.demo@unmsm.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Diseño UX' WHERE u.institutional_email='camila.vargas.demo@utp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Figma' WHERE u.institutional_email='camila.vargas.demo@utp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Matemáticas' WHERE u.institutional_email='jose.navarro.demo@uni.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Redes' WHERE u.institutional_email='jose.navarro.demo@uni.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Marketing' WHERE u.institutional_email='mariana.salazar.demo@upc.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Inglés' WHERE u.institutional_email='mariana.salazar.demo@upc.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Inglés' WHERE u.institutional_email='renato.garcia.demo@unmsm.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Estadística' WHERE u.institutional_email='paula.medina.demo@pucp.edu.pe';

INSERT IGNORE INTO user_teach_knowledge(user_id,knowledge_id)
SELECT u.id,k.id FROM users u JOIN knowledge k ON k.name='Java' WHERE u.institutional_email='bruno.herrera.demo@utp.edu.pe';


-- Guarda si la carga anterior ya generó sesiones, para evitar duplicados.
SET @aprendly_habia_sesiones_demo := (SELECT COUNT(*) FROM aprendly_demo_seed_sessions);
-- ================================================================
-- Asesorías de prueba distribuidas en fechas y temas diversos.
-- Solo se usan cuentas del catálogo ficticio, nunca cuentas personales.
-- Se generan una sola vez por combinación mentor/alumno/tema/fecha.
-- ================================================================
CREATE TEMPORARY TABLE tmp_aprendly_seed_plan (
  mentor_email VARCHAR(160) NOT NULL,
  learner_email VARCHAR(160) NOT NULL,
  topic VARCHAR(80) NOT NULL,
  scheduled_start DATETIME NOT NULL,
  scheduled_end DATETIME NOT NULL,
  rating TINYINT NOT NULL,
  comment VARCHAR(1000) NULL,
  PRIMARY KEY(mentor_email,learner_email,scheduled_start)
) ENGINE=MEMORY;


INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('paula.medina.demo@pucp.edu.pe','leonardo.ramos@utp.edu.pe','Estadística','2026-06-17 09:00:00','2026-06-17 10:00:00',4,'Explicación clara y ejemplos útiles.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo05@example.test','aprendly.demo03@example.test','Comunicación','2026-06-18 16:30:00','2026-06-18 17:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo09@example.test','aprendly.demo21@example.test','Marketing','2026-06-19 14:00:00','2026-06-19 15:00:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('jose.navarro.demo@uni.edu.pe','bruno.herrera.demo@utp.edu.pe','Matemáticas','2026-06-20 12:30:00','2026-06-20 13:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('leonardo.ramos@utp.edu.pe','aprendly.demo17@example.test','CSS','2026-06-21 10:00:00','2026-06-21 11:00:00',5,'Aprendí a aplicar el tema.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo03@example.test','daniel.flores.demo@unmsm.edu.pe','Figma','2026-06-22 17:30:00','2026-06-22 18:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('andrea.torres@pucp.edu.pe','aprendly.demo13@example.test','Git','2026-06-23 15:00:00','2026-06-23 16:00:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('luciana.perez.demo@upc.edu.pe','valeria.castillo.demo@utp.edu.pe','Marketing','2026-06-25 13:30:00','2026-06-25 14:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('luciana.perez.demo@upc.edu.pe','aprendly.demo08@example.test','Comunicación','2026-06-26 11:00:00','2026-06-26 12:00:00',5,'Tuvo paciencia para explicar.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('daniel.flores.demo@unmsm.edu.pe','leonardo.ramos@utp.edu.pe','SQL','2026-06-27 09:30:00','2026-06-27 10:30:00',3,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('daniel.flores.demo@unmsm.edu.pe','aprendly.demo04@example.test','Excel','2026-06-28 16:00:00','2026-06-28 17:00:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('miguel.quispe@upc.edu.pe','aprendly.demo21@example.test','Packet Tracer','2026-06-29 14:30:00','2026-06-29 15:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('andrea.torres@pucp.edu.pe','bruno.herrera.demo@utp.edu.pe','Machine Learning','2026-06-30 12:00:00','2026-06-30 13:00:00',5,'Explicación clara y ejemplos útiles.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('mariana.salazar.demo@upc.edu.pe','aprendly.demo17@example.test','Marketing','2026-07-02 10:30:00','2026-07-02 11:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo16@example.test','daniel.flores.demo@unmsm.edu.pe','Excel','2026-07-03 17:00:00','2026-07-03 18:00:00',3,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('diego.rojas.demo@uni.edu.pe','aprendly.demo13@example.test','Git','2026-07-04 15:30:00','2026-07-04 16:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('miguel.quispe@upc.edu.pe','diego.rojas.demo@uni.edu.pe','Git','2026-07-05 13:00:00','2026-07-05 14:00:00',5,'Aprendí a aplicar el tema.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo13@example.test','aprendly.demo07@example.test','SQL','2026-07-06 11:30:00','2026-07-06 12:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('daniel.flores.demo@unmsm.edu.pe','leonardo.ramos@utp.edu.pe','SQL','2026-07-07 09:00:00','2026-07-07 10:00:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo02@example.test','aprendly.demo04@example.test','Git','2026-07-09 16:30:00','2026-07-09 17:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('sofia.ramirez.demo@pucp.edu.pe','aprendly.demo21@example.test','Excel','2026-07-10 14:00:00','2026-07-10 15:00:00',5,'Tuvo paciencia para explicar.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo09@example.test','paula.medina.demo@pucp.edu.pe','Marketing','2026-07-11 12:30:00','2026-07-11 13:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo08@example.test','aprendly.demo17@example.test','Java','2026-07-12 10:00:00','2026-07-12 11:00:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('leonardo.ramos@utp.edu.pe','camila.vargas.demo@utp.edu.pe','CSS','2026-07-13 17:30:00','2026-07-13 18:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('sofia.ramirez.demo@pucp.edu.pe','aprendly.demo13@example.test','Inglés','2026-07-14 15:00:00','2026-07-14 16:00:00',5,'Explicación clara y ejemplos útiles.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo22@example.test','valeria.castillo.demo@utp.edu.pe','CSS','2026-07-16 13:30:00','2026-07-16 14:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('renato.garcia.demo@unmsm.edu.pe','aprendly.demo08@example.test','Inglés','2026-07-17 11:00:00','2026-07-17 12:00:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo03@example.test','leonardo.ramos@utp.edu.pe','Diseño UX','2026-07-18 09:30:00','2026-07-18 10:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo13@example.test','aprendly.demo03@example.test','Python','2026-07-19 16:00:00','2026-07-19 17:00:00',4,'Aprendí a aplicar el tema.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('diego.rojas.demo@uni.edu.pe','aprendly.demo21@example.test','Java','2026-07-20 14:30:00','2026-07-20 15:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('andrea.torres@pucp.edu.pe','bruno.herrera.demo@utp.edu.pe','Estadística','2026-07-21 12:00:00','2026-07-21 13:00:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo11@example.test','aprendly.demo17@example.test','Estadística','2026-07-23 10:30:00','2026-07-23 11:30:00',3,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo22@example.test','daniel.flores.demo@unmsm.edu.pe','HTML','2026-07-24 17:00:00','2026-07-24 18:00:00',5,'Tuvo paciencia para explicar.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('carlos.mendoza@unmsm.edu.pe','aprendly.demo13@example.test','Estadística','2026-07-25 15:30:00','2026-07-25 16:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('carlos.mendoza@unmsm.edu.pe','diego.rojas.demo@uni.edu.pe','Excel','2026-07-26 13:00:00','2026-07-26 14:00:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('sofia.ramirez.demo@pucp.edu.pe','aprendly.demo08@example.test','Comunicación','2026-07-27 11:30:00','2026-07-27 12:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('miguel.quispe@upc.edu.pe','leonardo.ramos@utp.edu.pe','Packet Tracer','2026-07-28 09:00:00','2026-07-28 10:00:00',4,'Explicación clara y ejemplos útiles.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('leonardo.ramos@utp.edu.pe','aprendly.demo04@example.test','Git','2026-07-30 16:30:00','2026-07-30 17:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('diego.rojas.demo@uni.edu.pe','aprendly.demo21@example.test','Bases de Datos','2026-07-31 14:00:00','2026-07-31 15:00:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('valeria.castillo.demo@utp.edu.pe','bruno.herrera.demo@utp.edu.pe','Diseño UX','2026-08-01 12:30:00','2026-08-01 13:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('carlos.mendoza@unmsm.edu.pe','aprendly.demo17@example.test','Estadística','2026-08-02 10:00:00','2026-08-02 11:00:00',5,'Aprendí a aplicar el tema.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('valeria.castillo.demo@utp.edu.pe','camila.vargas.demo@utp.edu.pe','Figma','2026-08-03 17:30:00','2026-08-03 18:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('andrea.torres@pucp.edu.pe','aprendly.demo13@example.test','Git','2026-08-04 15:00:00','2026-08-04 16:00:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('andrea.torres@pucp.edu.pe','diego.rojas.demo@uni.edu.pe','SQL','2026-08-06 13:30:00','2026-08-06 14:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('sofia.ramirez.demo@pucp.edu.pe','aprendly.demo08@example.test','Marketing','2026-08-07 11:00:00','2026-08-07 12:00:00',5,'Tuvo paciencia para explicar.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('valeria.castillo.demo@utp.edu.pe','leonardo.ramos@utp.edu.pe','CSS','2026-08-08 09:30:00','2026-08-08 10:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('camila.vargas.demo@utp.edu.pe','aprendly.demo04@example.test','Diseño UX','2026-08-09 16:00:00','2026-08-09 17:00:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('sofia.ramirez.demo@pucp.edu.pe','aprendly.demo21@example.test','Excel','2026-08-10 14:30:00','2026-08-10 15:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo18@example.test','paula.medina.demo@pucp.edu.pe','SQL','2026-08-11 12:00:00','2026-08-11 13:00:00',4,'Explicación clara y ejemplos útiles.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('andrea.torres@pucp.edu.pe','aprendly.demo17@example.test','Python','2026-08-13 10:30:00','2026-08-13 11:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('sofia.ramirez.demo@pucp.edu.pe','camila.vargas.demo@utp.edu.pe','Excel','2026-08-14 17:00:00','2026-08-14 18:00:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('andrea.torres@pucp.edu.pe','aprendly.demo13@example.test','Python','2026-08-15 15:30:00','2026-08-15 16:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('camila.vargas.demo@utp.edu.pe','valeria.castillo.demo@utp.edu.pe','Figma','2026-08-16 13:00:00','2026-08-16 14:00:00',4,'Aprendí a aplicar el tema.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('diego.rojas.demo@uni.edu.pe','aprendly.demo08@example.test','SQL','2026-08-17 11:30:00','2026-08-17 12:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('carlos.mendoza@unmsm.edu.pe','leonardo.ramos@utp.edu.pe','SQL','2026-08-18 09:00:00','2026-08-18 10:00:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('leonardo.ramos@utp.edu.pe','aprendly.demo04@example.test','Java','2026-08-20 16:30:00','2026-08-20 17:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('valeria.castillo.demo@utp.edu.pe','aprendly.demo21@example.test','Diseño UX','2026-08-21 14:00:00','2026-08-21 15:00:00',5,'Tuvo paciencia para explicar.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo24@example.test','paula.medina.demo@pucp.edu.pe','Matemáticas','2026-08-22 12:30:00','2026-08-22 13:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo13@example.test','aprendly.demo17@example.test','SQL','2026-08-23 10:00:00','2026-08-23 11:00:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo11@example.test','daniel.flores.demo@unmsm.edu.pe','Estadística','2026-08-24 17:30:00','2026-08-24 18:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo08@example.test','aprendly.demo13@example.test','Java','2026-08-25 15:00:00','2026-08-25 16:00:00',4,'Explicación clara y ejemplos útiles.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('leonardo.ramos@utp.edu.pe','diego.rojas.demo@uni.edu.pe','Java','2026-08-27 13:30:00','2026-08-27 14:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('sofia.ramirez.demo@pucp.edu.pe','aprendly.demo08@example.test','Comunicación','2026-08-28 11:00:00','2026-08-28 12:00:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('mariana.salazar.demo@upc.edu.pe','leonardo.ramos@utp.edu.pe','Inglés','2026-08-29 09:30:00','2026-08-29 10:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('sofia.ramirez.demo@pucp.edu.pe','aprendly.demo04@example.test','Inglés','2026-08-30 16:00:00','2026-08-30 17:00:00',4,'Aprendí a aplicar el tema.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('leonardo.ramos@utp.edu.pe','aprendly.demo21@example.test','Programación Web','2026-08-31 14:30:00','2026-08-31 15:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('miguel.quispe@upc.edu.pe','bruno.herrera.demo@utp.edu.pe','Python','2026-09-01 12:00:00','2026-09-01 13:00:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('carlos.mendoza@unmsm.edu.pe','aprendly.demo17@example.test','SQL','2026-09-03 10:30:00','2026-09-03 11:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('bruno.herrera.demo@utp.edu.pe','daniel.flores.demo@unmsm.edu.pe','Java','2026-09-04 17:00:00','2026-09-04 18:00:00',4,'Tuvo paciencia para explicar.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('sofia.ramirez.demo@pucp.edu.pe','aprendly.demo13@example.test','Estadística','2026-09-05 15:30:00','2026-09-05 16:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('andrea.torres@pucp.edu.pe','diego.rojas.demo@uni.edu.pe','SQL','2026-09-06 13:00:00','2026-09-06 14:00:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('luciana.perez.demo@upc.edu.pe','aprendly.demo08@example.test','Comunicación','2026-09-07 11:30:00','2026-09-07 12:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('jose.navarro.demo@uni.edu.pe','leonardo.ramos@utp.edu.pe','Redes','2026-09-08 09:00:00','2026-09-08 10:00:00',4,'Explicación clara y ejemplos útiles.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('leonardo.ramos@utp.edu.pe','aprendly.demo04@example.test','HTML','2026-09-10 16:30:00','2026-09-10 17:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('sofia.ramirez.demo@pucp.edu.pe','aprendly.demo21@example.test','Marketing','2026-09-11 14:00:00','2026-09-11 15:00:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('luciana.perez.demo@upc.edu.pe','bruno.herrera.demo@utp.edu.pe','Marketing','2026-09-12 12:30:00','2026-09-12 13:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo02@example.test','aprendly.demo17@example.test','Git','2026-09-13 10:00:00','2026-09-13 11:00:00',4,'Aprendí a aplicar el tema.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo18@example.test','daniel.flores.demo@unmsm.edu.pe','SQL','2026-09-14 17:30:00','2026-09-14 18:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('camila.vargas.demo@utp.edu.pe','aprendly.demo13@example.test','Diseño UX','2026-09-15 15:00:00','2026-09-15 16:00:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo04@example.test','valeria.castillo.demo@utp.edu.pe','Matemáticas','2026-09-17 13:30:00','2026-09-17 14:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('andrea.torres@pucp.edu.pe','aprendly.demo08@example.test','Machine Learning','2026-09-18 11:00:00','2026-09-18 12:00:00',5,'Tuvo paciencia para explicar.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('valeria.castillo.demo@utp.edu.pe','leonardo.ramos@utp.edu.pe','HTML','2026-09-19 09:30:00','2026-09-19 10:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo32@example.test','aprendly.demo07@example.test','Excel','2026-09-20 16:00:00','2026-09-20 17:00:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('miguel.quispe@upc.edu.pe','aprendly.demo21@example.test','Python','2026-09-21 14:30:00','2026-09-21 15:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('leonardo.ramos@utp.edu.pe','bruno.herrera.demo@utp.edu.pe','HTML','2026-09-22 12:00:00','2026-09-22 13:00:00',4,'Explicación clara y ejemplos útiles.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('carlos.mendoza@unmsm.edu.pe','aprendly.demo17@example.test','Matemáticas','2026-09-24 10:30:00','2026-09-24 11:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('andrea.torres@pucp.edu.pe','camila.vargas.demo@utp.edu.pe','Estadística','2026-09-25 17:00:00','2026-09-25 18:00:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('sofia.ramirez.demo@pucp.edu.pe','aprendly.demo13@example.test','Estadística','2026-09-26 15:30:00','2026-09-26 16:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('miguel.quispe@upc.edu.pe','diego.rojas.demo@uni.edu.pe','Git','2026-09-27 13:00:00','2026-09-27 14:00:00',4,'Aprendí a aplicar el tema.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('miguel.quispe@upc.edu.pe','aprendly.demo08@example.test','Redes','2026-09-28 11:30:00','2026-09-28 12:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('leonardo.ramos@utp.edu.pe','carlos.mendoza@unmsm.edu.pe','Git','2026-09-29 09:00:00','2026-09-29 10:00:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('carlos.mendoza@unmsm.edu.pe','aprendly.demo04@example.test','Excel','2026-10-01 16:30:00','2026-10-01 17:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('carlos.mendoza@unmsm.edu.pe','aprendly.demo21@example.test','Estadística','2026-10-02 14:00:00','2026-10-02 15:00:00',5,'Tuvo paciencia para explicar.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('diego.rojas.demo@uni.edu.pe','bruno.herrera.demo@utp.edu.pe','SQL','2026-10-03 12:30:00','2026-10-03 13:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo20@example.test','aprendly.demo16@example.test','Packet Tracer','2026-10-04 10:00:00','2026-10-04 11:00:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo08@example.test','daniel.flores.demo@unmsm.edu.pe','Git','2026-10-05 17:30:00','2026-10-05 18:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('andrea.torres@pucp.edu.pe','aprendly.demo13@example.test','Machine Learning','2026-10-06 15:00:00','2026-10-06 16:00:00',5,'Explicación clara y ejemplos útiles.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('miguel.quispe@upc.edu.pe','diego.rojas.demo@uni.edu.pe','Redes','2026-10-08 13:30:00','2026-10-08 14:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('andrea.torres@pucp.edu.pe','aprendly.demo08@example.test','Python','2026-10-09 11:00:00','2026-10-09 12:00:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('aprendly.demo27@example.test','aprendly.demo22@example.test','Comunicación','2026-10-10 09:30:00','2026-10-10 10:30:00',5,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('leonardo.ramos@utp.edu.pe','aprendly.demo04@example.test','Programación Web','2026-10-11 16:00:00','2026-10-11 17:00:00',5,'Aprendí a aplicar el tema.');

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('carlos.mendoza@unmsm.edu.pe','aprendly.demo21@example.test','Matemáticas','2026-10-12 14:30:00','2026-10-12 15:30:00',4,NULL);

INSERT IGNORE INTO tmp_aprendly_seed_plan VALUES ('diego.rojas.demo@uni.edu.pe','bruno.herrera.demo@utp.edu.pe','Bases de Datos','2026-10-13 12:00:00','2026-10-13 13:00:00',4,NULL);


-- Sesiones. WHERE NOT EXISTS garantiza que reimportar no duplique fechas previas.
INSERT INTO mentorship_sessions (
  mentor_id,learner_id,knowledge_id,scheduled_start,scheduled_end,
  modality,status,mentor_confirmed,learner_confirmed,created_at)
SELECT m.id,l.id,k.id,t.scheduled_start,t.scheduled_end,
  'online','completed',1,1,DATE_SUB(t.scheduled_start, INTERVAL 2 DAY)
FROM tmp_aprendly_seed_plan t
JOIN users m ON m.institutional_email=t.mentor_email
JOIN users l ON l.institutional_email=t.learner_email
JOIN knowledge k ON k.name=t.topic
WHERE @aprendly_habia_sesiones_demo = 0 AND m.id<>l.id AND NOT EXISTS (
  SELECT 1 FROM mentorship_sessions existing
  WHERE existing.mentor_id=m.id AND existing.learner_id=l.id
    AND existing.knowledge_id=k.id AND existing.scheduled_start=t.scheduled_start
);
-- Marcamos sesiones ficticias para distinguirlas de las creadas por usuarios.
INSERT IGNORE INTO aprendly_demo_seed_sessions(session_id)
SELECT s.id FROM mentorship_sessions s
JOIN tmp_aprendly_seed_plan t ON t.scheduled_start=s.scheduled_start
JOIN users m ON m.id=s.mentor_id AND m.institutional_email=t.mentor_email
JOIN users l ON l.id=s.learner_id AND l.institutional_email=t.learner_email
JOIN knowledge k ON k.id=s.knowledge_id AND k.name=t.topic
WHERE @aprendly_habia_sesiones_demo = 0;

-- Reseñas del alumno al mentor. Solo una por participante y asesoría.
INSERT IGNORE INTO session_reviews (session_id,reviewer_id,reviewed_id,rating,comment,created_at)
SELECT s.id, l.id,m.id,t.rating,t.comment,DATE_ADD(s.scheduled_end, INTERVAL 3 HOUR)
FROM tmp_aprendly_seed_plan t
JOIN users m ON m.institutional_email=t.mentor_email
JOIN users l ON l.institutional_email=t.learner_email
JOIN mentorship_sessions s ON s.mentor_id=m.id AND s.learner_id=l.id
  AND s.scheduled_start=t.scheduled_start
JOIN aprendly_demo_seed_sessions marker ON marker.session_id=s.id
WHERE @aprendly_habia_sesiones_demo = 0;
DROP TEMPORARY TABLE IF EXISTS tmp_aprendly_seed_plan;

-- Resultados y comprobación.
SELECT COUNT(*) AS usuarios_totales FROM users;
SELECT COUNT(*) AS usuarios_ficticios_nuevos FROM aprendly_demo_seed_users;
SELECT COUNT(*) AS asesorias_ficticias FROM aprendly_demo_seed_sessions;
SELECT COUNT(*) AS resenas_totales FROM session_reviews;

