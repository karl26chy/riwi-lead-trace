# 07 — Diseño de Base de Datos

Aunque el MVP es una SPA frontend, se diseña la base de datos relacional para el **backend que consumirá la API REST**. Modelo normalizado y simple (sin sobreingeniería).

## Entidades

| Entidad | Descripción |
|---------|-------------|
| `roles` | Catálogo de roles del sistema (coder, team_leader, tutor, coordinador) |
| `users` | Usuarios de la plataforma; cada uno tiene un rol |
| `periods` | Periodos/ciclos de evaluación (p.ej. trimestre, cohorte) |
| `form_templates` | Plantilla de formulario según el rol evaluado (TL / Tutor) |
| `questions` | Preguntas/criterios que componen una plantilla |
| `evaluations` | Una evaluación de un evaluador hacia un evaluado en un periodo |
| `evaluation_answers` | Respuestas (puntaje + comentario) por pregunta de una evaluación |

## Atributos principales

### `roles`
| Atributo | Tipo | Notas |
|----------|------|-------|
| id | INT PK | |
| name | VARCHAR(30) | único: coder, team_leader, tutor, coordinador |

### `users`
| Atributo | Tipo | Notas |
|----------|------|-------|
| id | INT PK | |
| full_name | VARCHAR(120) | |
| email | VARCHAR(150) | único |
| password_hash | VARCHAR(255) | nunca texto plano |
| role_id | INT FK → roles.id | |
| is_active | BOOLEAN | default true |
| created_at | TIMESTAMP | |

### `periods`
| Atributo | Tipo | Notas |
|----------|------|-------|
| id | INT PK | |
| name | VARCHAR(60) | p.ej. "2026-T1" |
| starts_at | DATE | |
| ends_at | DATE | |
| is_active | BOOLEAN | |

### `form_templates`
| Atributo | Tipo | Notas |
|----------|------|-------|
| id | INT PK | |
| title | VARCHAR(120) | |
| target_role_id | INT FK → roles.id | rol que se evalúa (team_leader/tutor) |
| is_active | BOOLEAN | |

### `questions`
| Atributo | Tipo | Notas |
|----------|------|-------|
| id | INT PK | |
| template_id | INT FK → form_templates.id | |
| text | VARCHAR(255) | |
| category | VARCHAR(60) | agrupa criterios (comunicación, técnica...) |
| input_type | VARCHAR(20) | 'scale' \| 'text' |
| sort_order | INT | orden de despliegue |

### `evaluations`
| Atributo | Tipo | Notas |
|----------|------|-------|
| id | INT PK | |
| evaluator_id | INT FK → users.id (NULLABLE) | **NULL si es anónima** |
| evaluatee_id | INT FK → users.id | persona evaluada |
| template_id | INT FK → form_templates.id | |
| period_id | INT FK → periods.id | |
| is_anonymous | BOOLEAN | default false |
| status | VARCHAR(20) | 'draft' \| 'submitted' |
| submitted_at | TIMESTAMP NULL | |
| created_at | TIMESTAMP | |

### `evaluation_answers`
| Atributo | Tipo | Notas |
|----------|------|-------|
| id | INT PK | |
| evaluation_id | INT FK → evaluations.id | |
| question_id | INT FK → questions.id | |
| score | SMALLINT NULL | 1–5 si input_type='scale' |
| comment | TEXT NULL | si input_type='text' |

## Relaciones

- `roles` 1—N `users`
- `roles` 1—N `form_templates` (rol evaluado)
- `form_templates` 1—N `questions`
- `users` (evaluador) 1—N `evaluations` *(opcional: NULL en anónimas)*
- `users` (evaluado) 1—N `evaluations`
- `periods` 1—N `evaluations`
- `evaluations` 1—N `evaluation_answers`
- `questions` 1—N `evaluation_answers`

## Modelo Entidad-Relación (texto)

```
roles (id PK, name)
   │1
   ├──< users (id PK, full_name, email, password_hash, role_id FK, is_active, created_at)
   │1                         │1 (evaluatee)        │0..1 (evaluator, NULL si anónima)
   │                          │                     │
   └──< form_templates (id PK, title, target_role_id FK, is_active)
            │1
            └──< questions (id PK, template_id FK, text, category, input_type, sort_order)
                      │1
                      └──< evaluation_answers (id PK, evaluation_id FK, question_id FK, score, comment)
                                   │N
                                   └──> evaluations (id PK, evaluator_id FK?, evaluatee_id FK,
                                                     template_id FK, period_id FK, is_anonymous,
                                                     status, submitted_at, created_at)
                                                          │N
periods (id PK, name, starts_at, ends_at, is_active) ─────┘
```

Cardinalidades clave:
- **users ──< evaluations (evaluatee):** un usuario puede ser evaluado muchas veces.
- **users ──< evaluations (evaluator):** un usuario puede evaluar muchas veces; FK *nullable* para anonimato.
- **evaluations ──< evaluation_answers:** una evaluación tiene muchas respuestas.

## Modelo relacional (resumen)

```
roles(id, name)
users(id, full_name, email, password_hash, role_id→roles, is_active, created_at)
periods(id, name, starts_at, ends_at, is_active)
form_templates(id, title, target_role_id→roles, is_active)
questions(id, template_id→form_templates, text, category, input_type, sort_order)
evaluations(id, evaluator_id→users?, evaluatee_id→users, template_id→form_templates,
            period_id→periods, is_anonymous, status, submitted_at, created_at)
evaluation_answers(id, evaluation_id→evaluations, question_id→questions, score, comment)
```

## Decisiones de diseño

- **Anonimato:** se modela con `is_anonymous` + `evaluator_id` NULLABLE. Si la evaluación es anónima, no se persiste el evaluador → anonimato real a nivel de datos.
- **Plantillas dinámicas:** `form_templates` + `questions` permiten cambiar criterios sin tocar código (preparado para futuro CRUD de formularios, fuera del MVP).
- **Una respuesta por pregunta** vía `evaluation_answers` (normalizado), facilitando métricas por criterio/categoría.
- **Integridad de unicidad** (recomendada en backend): un evaluador no debería evaluar dos veces al mismo evaluado en el mismo periodo → índice único parcial sobre `(evaluator_id, evaluatee_id, period_id)` cuando no es anónima.

El script ejecutable está en [`/database/schema.sql`](../database/schema.sql).
