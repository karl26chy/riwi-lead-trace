-- =====================================================================
-- Riwi LeadTrace — Script SQL inicial (MVP)
-- Motor: MySQL 8
-- Modelo relacional normalizado hasta 3FN (ver docs/07-base-de-datos.md)
-- Uso: mysql -u root -p < database/schema.sql
-- =====================================================================

CREATE DATABASE IF NOT EXISTS riwi_lead_trace
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE riwi_lead_trace;

-- Idempotencia para entorno de desarrollo
DROP TABLE IF EXISTS evaluation_answers;
DROP TABLE IF EXISTS evaluations;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS form_templates;
DROP TABLE IF EXISTS periods;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS roles;

-- ---------------------------------------------------------------------
-- Catálogo de roles
-- ---------------------------------------------------------------------
CREATE TABLE roles (
    id   INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL UNIQUE
);

-- ---------------------------------------------------------------------
-- Usuarios
-- ---------------------------------------------------------------------
CREATE TABLE users (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(120) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role_id       INT NOT NULL,
    is_active     BOOLEAN NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id)
);

-- ---------------------------------------------------------------------
-- Periodos de evaluación
-- ---------------------------------------------------------------------
CREATE TABLE periods (
    id        INT AUTO_INCREMENT PRIMARY KEY,
    name      VARCHAR(60) NOT NULL,
    starts_at DATE NOT NULL,
    ends_at   DATE NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT FALSE
);

-- ---------------------------------------------------------------------
-- Plantillas de formulario (por rol evaluado)
-- ---------------------------------------------------------------------
CREATE TABLE form_templates (
    id             INT AUTO_INCREMENT PRIMARY KEY,
    title          VARCHAR(120) NOT NULL,
    target_role_id INT NOT NULL,
    is_active      BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT fk_template_role FOREIGN KEY (target_role_id) REFERENCES roles(id)
);

-- ---------------------------------------------------------------------
-- Preguntas / criterios de una plantilla
-- ---------------------------------------------------------------------
CREATE TABLE questions (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    template_id INT NOT NULL,
    text        VARCHAR(255) NOT NULL,
    category    VARCHAR(60) NOT NULL,
    input_type  VARCHAR(20) NOT NULL DEFAULT 'scale', -- 'scale' | 'text'
    sort_order  INT NOT NULL DEFAULT 0,
    CONSTRAINT fk_question_template FOREIGN KEY (template_id) REFERENCES form_templates(id),
    CONSTRAINT chk_input_type CHECK (input_type IN ('scale','text'))
);

-- ---------------------------------------------------------------------
-- Evaluaciones
--   evaluator_id es NULL cuando la evaluación es anónima (anonimato real)
-- ---------------------------------------------------------------------
CREATE TABLE evaluations (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    evaluator_id INT NULL,
    evaluatee_id INT NOT NULL,
    template_id  INT NOT NULL,
    period_id    INT NOT NULL,
    is_anonymous BOOLEAN NOT NULL DEFAULT FALSE,
    status       VARCHAR(20) NOT NULL DEFAULT 'draft', -- 'draft' | 'submitted'
    submitted_at TIMESTAMP NULL,
    created_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_eval_evaluator FOREIGN KEY (evaluator_id) REFERENCES users(id),
    CONSTRAINT fk_eval_evaluatee FOREIGN KEY (evaluatee_id) REFERENCES users(id),
    CONSTRAINT fk_eval_template  FOREIGN KEY (template_id)  REFERENCES form_templates(id),
    CONSTRAINT fk_eval_period    FOREIGN KEY (period_id)    REFERENCES periods(id),
    CONSTRAINT chk_status CHECK (status IN ('draft','submitted'))
);

-- Evita doble evaluación del mismo evaluado en el mismo periodo (solo no anónimas)
CREATE UNIQUE INDEX uq_eval_once
    ON evaluations (evaluator_id, evaluatee_id, period_id);

-- ---------------------------------------------------------------------
-- Respuestas por pregunta
-- ---------------------------------------------------------------------
CREATE TABLE evaluation_answers (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    evaluation_id INT NOT NULL,
    question_id   INT NOT NULL,
    score         SMALLINT NULL, -- 1..5 cuando la pregunta es de escala
    comment       TEXT NULL,
    CONSTRAINT fk_answer_eval     FOREIGN KEY (evaluation_id) REFERENCES evaluations(id) ON DELETE CASCADE,
    CONSTRAINT fk_answer_question FOREIGN KEY (question_id)   REFERENCES questions(id),
    CONSTRAINT chk_score_range CHECK (score IS NULL OR (score BETWEEN 1 AND 5))
);

-- =====================================================================
-- Datos semilla (seed) — mínimos para desarrollo
-- =====================================================================
INSERT INTO roles (name) VALUES
    ('coder'), ('team_leader'), ('tutor'), ('coordinador');

INSERT INTO periods (name, starts_at, ends_at, is_active) VALUES
    ('2026-T1', '2026-01-15', '2026-04-15', TRUE);

-- Usuarios de ejemplo (password_hash es un placeholder; usar hash real en backend)
INSERT INTO users (full_name, email, password_hash, role_id) VALUES
    ('Coder Demo',       'coder@riwi.edu',       '$2y$placeholder', 1),
    ('Team Leader Demo', 'teamleader@riwi.edu',  '$2y$placeholder', 2),
    ('Tutor Demo',       'tutor@riwi.edu',       '$2y$placeholder', 3),
    ('Coordinador Demo', 'coordinador@riwi.edu', '$2y$placeholder', 4);

-- Plantillas: una para Team Leader, una para Tutor
INSERT INTO form_templates (title, target_role_id) VALUES
    ('Evaluación de Team Leader', 2),
    ('Evaluación de Tutor', 3);

-- Preguntas de ejemplo para la plantilla de Team Leader (id=1)
INSERT INTO questions (template_id, text, category, input_type, sort_order) VALUES
    (1, '¿Qué tan clara fue la comunicación del Team Leader?', 'Comunicación', 'scale', 1),
    (1, '¿El Team Leader brindó acompañamiento oportuno?',     'Acompañamiento', 'scale', 2),
    (1, '¿Promovió un ambiente de aprendizaje seguro?',        'Liderazgo', 'scale', 3),
    (1, 'Comentarios adicionales',                              'General', 'text', 4);

-- Preguntas de ejemplo para la plantilla de Tutor (id=2)
INSERT INTO questions (template_id, text, category, input_type, sort_order) VALUES
    (2, '¿El Tutor resolvió tus dudas técnicas con claridad?', 'Técnica', 'scale', 1),
    (2, '¿Estuvo disponible cuando lo necesitaste?',           'Disponibilidad', 'scale', 2),
    (2, 'Comentarios adicionales',                              'General', 'text', 3);
