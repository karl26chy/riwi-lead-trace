# 08 — Diseño Técnico

## Convenciones de nombres

### Archivos y carpetas
- Carpetas y archivos en **kebab-case**: `evaluation-form.view.js`, `auth.service.js`.
- Sufijos por tipo: `*.view.js` (vistas), `*.service.js` (servicios), `*.store.js` (stores).
- Componentes reutilizables sin sufijo en `components/`: `navbar.js`, `rating-input.js`.

### Código JavaScript
- **Variables y funciones:** `camelCase` (`getEvaluables`, `currentUser`).
- **Constantes globales:** `UPPER_SNAKE_CASE` (`API_BASE_URL`).
- **Clases/constructores:** `PascalCase` (raro en este MVP; preferir funciones).
- **Privado por convención:** prefijo `_` (`_render`).
- **Booleanos:** prefijo `is/has/can` (`isAnonymous`, `hasSession`).
- Módulos ES (`import`/`export`); evitar variables globales.

### CSS
- Metodología **BEM**: `.card`, `.card__title`, `.card--highlight`.
- Variables de diseño en `:root` (`--color-primary`, `--space-md`).
- **Mobile-first**: estilos base para móvil, `@media (min-width: ...)` para ampliar.

### Base de datos / API
- Tablas y columnas en **snake_case** (`form_templates`, `created_at`).
- Endpoints REST en **kebab/plural** (`/evaluations`, `/form-templates`).

## Estrategia de ramas Git (GitFlow simplificado)

Dado que desarrolla **una sola persona**, se usa un GitFlow reducido a 3 tipos de rama:

```
main        ← código estable / entregable (releases del MVP)
 └─ develop ← integración continua del trabajo del sprint
     └─ feature/<id>-<slug>   ← una rama por historia
```

- `main`: siempre desplegable. Solo recibe merges desde `develop` al cerrar un sprint/release.
- `develop`: rama de integración; refleja el estado actual del MVP.
- `feature/*`: una por historia del backlog, nombrada con el ID:
  - `feature/CORE-01-setup-spa`
  - `feature/AUTH-02-sesion-rutas-protegidas`
  - `feature/EVAL-05-registrar-evaluacion`
- Correcciones urgentes sobre `main`: `hotfix/<slug>`.

### Flujo de trabajo
1. `git checkout develop && git pull`
2. `git checkout -b feature/EVAL-02-evaluar-team-leader`
3. Commits pequeños y frecuentes durante la historia.
4. Pull Request `feature/* → develop` (auto-revisión; checklist de DoD).
5. Merge a `develop` al cumplir la Definition of Done.
6. Al cerrar el sprint: PR `develop → main` + tag de versión (`v0.1.0`, `v0.2.0`, ...).

> En este repositorio, el trabajo asistido se realiza en la rama indicada por la tarea
> (`claude/claude-md-docs-8814n5`); al integrarse seguirá el flujo anterior hacia `develop`.

### Convención de commits (Conventional Commits)

```
<tipo>(<alcance>): <descripción breve en imperativo>
```

Tipos: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`.

Ejemplos:
```
feat(eval): agregar formulario de evaluación de Team Leader
fix(auth): redirigir a login cuando el token expira
docs(backlog): actualizar story points del sprint 3
```

Referenciar el ID de la historia cuando aplique: `feat(eval): EVAL-02 formulario Team Leader`.

## Estructura del repositorio GitHub

```
riwi-lead-trace/
├── README.md                 # overview + cómo correr
├── CLAUDE.md                 # guía para asistentes de IA
├── .gitignore
├── package.json
├── vite.config.js
├── index.html
├── src/                      # código de la SPA (ver 06-arquitectura)
├── public/
├── database/
│   └── schema.sql
└── docs/                     # documentación Scrum + técnica (01..10)
```

### Configuración recomendada del repo
- **Branch protection** en `main` y `develop` (no push directo; PR requerido).
- **PR template** con checklist de Definition of Done.
- **Issues** vinculados a las historias del backlog (un issue por ID).
- **Milestones** = Sprints (Sprint 1, 2, 3).
- **Labels:** por épica (`core`, `auth`, `eval`, `hist`, `dash`) y prioridad (`must`, `should`, `could`).

## Calidad y herramientas (livianas, sin sobreingeniería)
- **Formato:** Prettier con configuración por defecto.
- **Linting:** ESLint base (`eslint:recommended`) para JS Vanilla/ESM.
- **Sin framework de tests** en el MVP: validación manual contra criterios de aceptación. (Tests unitarios de `utils/` quedan como mejora futura.)
- **Editor:** `.editorconfig` para consistencia de indentación (2 espacios).
