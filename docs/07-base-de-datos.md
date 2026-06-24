# 07 — Diseño de Base de Datos

Base de datos **relacional MySQL** consumida por el backend FastAPI. Modelo **normalizado hasta la Tercera Forma Normal (3FN)**, con integridad referencial y operaciones CRUD completas (requisitos de la rúbrica).

## ¿Por qué MySQL (relacional)?

- Los datos son **altamente estructurados y relacionados** (usuarios, roles, plantillas, preguntas, evaluaciones, respuestas) → encajan naturalmente en un modelo relacional con FKs.
- Necesitamos **integridad referencial** (una respuesta siempre pertenece a una evaluación y a una pregunta) y **restricciones de unicidad** (no-duplicado por periodo).
- El dashboard requiere **consultas agregadas** (promedios, conteos, agrupaciones) que SQL resuelve de forma natural.
- Es ampliamente enseñada en la Ruta Básica → el equipo puede sustentarla con solvencia.

Justificación ampliada en [`12-justificacion-tecnologica.md`](./12-justificacion-tecnologica.md).

## Entidades

| Entidad | Descripción |
|---------|-------------|
| `roles` | Catálogo de roles del sistema (coder, team_leader, tutor, coordinador) |
| `cohortes` | Cohortes de Riwi (p.ej. cohorte 5); agrupan clanes |
| `clanes` | Clanes dentro de una cohorte; a ellos pertenecen los Coders |
| `users` | Usuarios de la plataforma; cada uno tiene un rol y (si es Coder) un clan |
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

### `cohortes`
| Atributo | Tipo | Notas |
|----------|------|-------|
| id | INT PK | |
| numero | INT | número de la cohorte (p.ej. 5); único |
| nombre | VARCHAR(80) | nombre descriptivo |
| ciudad | VARCHAR(80) NULL | ciudad/sede (opcional) |

### `clanes`
| Atributo | Tipo | Notas |
|----------|------|-------|
| id | INT PK | |
| cohorte_id | INT FK → cohortes.id | cohorte a la que pertenece el clan |
| numero | INT | número del clan (p.ej. 10) |
| nombre | VARCHAR(80) | nombre del clan |
| | | **UNIQUE(cohorte_id, numero)**: el nº es único *dentro* de la cohorte (puede repetirse en otra) |

### `users`
| Atributo | Tipo | Notas |
|----------|------|-------|
| id | INT PK | |
| full_name | VARCHAR(120) | |
| email | VARCHAR(150) | único |
| password_hash | VARCHAR(255) | nunca texto plano |
| role_id | INT FK → roles.id | |
| clan_id | INT FK → clanes.id (NULLABLE) | clan del Coder (un tutor sigue siendo coder → conserva su clan); NULL para team_leader/coordinador |
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
- `cohortes` 1—N `clanes`
- `clanes` 1—N `users` *(un Coder/Tutor pertenece a un clan; FK nullable para team_leader/coordinador)*
- `roles` 1—N `form_templates` (rol evaluado)
- `form_templates` 1—N `questions`
- `users` (evaluador) 1—N `evaluations` *(opcional: NULL en anónimas)*
- `users` (evaluado) 1—N `evaluations`
- `periods` 1—N `evaluations`
- `evaluations` 1—N `evaluation_answers`
- `questions` 1—N `evaluation_answers`

## Modelo Entidad-Relación (texto)

```
cohortes (id PK, numero, nombre, ciudad)
   │1
   └──< clanes (id PK, cohorte_id FK, numero, nombre)   UNIQUE(cohorte_id, numero)
            │1
            └──< (clan_id, NULL en no-coders)
                   │
roles (id PK, name)
   │1
   ├──< users (id PK, full_name, email, password_hash, role_id FK, clan_id FK?, is_active, created_at)
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
cohortes(id, numero, nombre, ciudad)
clanes(id, cohorte_id→cohortes, numero, nombre)   -- UNIQUE(cohorte_id, numero)
users(id, full_name, email, password_hash, role_id→roles, clan_id→clanes?, is_active, created_at)
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
- **Cohortes y clanes:** un Coder pertenece a **un** clan (`users.clan_id`, relación 1—N), y cada clan vive dentro de **una** cohorte (`clanes.cohorte_id`). El número de clan es único **dentro** de su cohorte → `UNIQUE(cohorte_id, numero)`: el "clan 10" puede existir en la cohorte 5 y también en otra cohorte/ciudad como filas distintas, pero no dos veces en la misma cohorte.
- **No guardamos `cohorte_id` en `users`:** la cohorte de un Coder se obtiene siguiendo `users.clan_id → clanes.cohorte_id` (un JOIN). Duplicar la cohorte en `users` sería una **dependencia transitiva** (rompe 3FN) y permitiría inconsistencias (un user con clan de la cohorte 5 pero `cohorte_id` = 3).
- **`clan_id` es NULLABLE:** lo usan Coders (y Tutores, que siguen siendo Coders); queda NULL para team_leaders y coordinador.

## Cumplimiento de la Tercera Forma Normal (3FN)

- **1FN:** todos los atributos son atómicos; no hay grupos repetidos (las respuestas se modelan en su propia tabla `evaluation_answers`, no como columnas múltiples).
- **2FN:** sin dependencias parciales; cada tabla tiene PK simple (`id`) y los atributos dependen de ella por completo.
- **3FN:** sin dependencias transitivas; p.ej. el nombre del rol vive en `roles` (no se repite en `users`), y los criterios viven en `questions` (no se duplican en cada respuesta). Igualmente, la **cohorte de un Coder no se almacena en `users`**: depende del clan (`clan_id → clanes.cohorte_id`), así que guardarla sería transitiva; se deriva por JOIN.

## Operaciones CRUD (cobertura MVP)

| Entidad | Create | Read | Update | Delete |
|---------|:------:|:----:|:------:|:------:|
| users | seed/admin | login, listar evaluables | perfil (futuro) | baja lógica (`is_active`) |
| evaluations | Coder (POST) | historial, dashboard | borrador→enviada | borrador descartable |
| evaluation_answers | con la evaluación | en detalle/métricas | en borrador | cascada con evaluación |
| form_templates / questions | seed | render de formularios | (admin, futuro) | (admin, futuro) |
| periods | seed/admin | filtros | activar/cerrar | — |

> La lógica de negocio (anonimato, no-duplicado, agregaciones) se implementa en la capa `services` del backend sobre estas operaciones; **no es CRUD plano**.

## Ampliación futura (fuera del MVP)

El modelo actual asume que un Coder pertenece a **una** cohorte (vía su clan). Si en el
futuro se necesita que un mismo Coder esté en **varias** cohortes a la vez (p.ej. alguien
que cursa dos rutas en paralelo), se migraría a una relación **N—N**:

- Quitar `users.clan_id`.
- Crear una tabla intermedia `coder_clanes(user_id → users, clan_id → clanes)` con
  `PRIMARY KEY(user_id, clan_id)`, de modo que un usuario pueda enlazarse a varios clanes
  (cada uno de su cohorte).

Mientras eso no sea un requisito, el MVP usa la relación 1—N (`users.clan_id`) por simplicidad.

El script ejecutable está en [`/database/schema.sql`](../database/schema.sql).
