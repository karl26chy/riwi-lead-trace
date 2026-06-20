# CLAUDE.md

Guía para asistentes de IA (Claude Code y similares) que trabajen en **Riwi LeadTrace**. Léela antes de generar o modificar código.

## Qué es este proyecto

MVP de **feedback ascendente**: una **SPA** que permite a los **Coders** evaluar a **Team Leaders** y **Tutores** con formularios estructurados (con opción anónima), generando trazabilidad, métricas y tendencias para los **Coordinadores / responsables académicos** de Riwi.

> **Estado actual del repositorio:** fase de **planeación**. El repo contiene la documentación Scrum y de diseño técnico (`/docs`), el script SQL (`/database`) y esta guía. **Todavía no hay código de la SPA.** Al implementar, sigue la arquitectura ya definida en `/docs` — no la reinventes.

## Restricciones técnicas (NO negociables)

- **SPA** (Single Page Application).
- **HTML5 + CSS3 + JavaScript Vanilla (ES Modules)**.
- **Prohibido** usar React, Angular, Vue u otro framework de UI.
- Vite (dev server/bundler) y json-server (API mock) **sí** están permitidos: son herramientas de desarrollo, no frameworks de UI.
- Arquitectura **modular**, **responsive** (mobile-first) y preparada para **APIs REST**.
- Alcance **MVP**, desarrollado por **una sola persona** → prioriza simplicidad, velocidad y mantenibilidad. **No sobreingenierizar.**

## Documentación fuente de verdad

Antes de decidir algo de producto o arquitectura, consulta `/docs`:

| Tema | Archivo |
|------|---------|
| Visión, objetivos, métricas | `docs/01-vision-y-producto.md` |
| Product Backlog (IDs, SP, prioridad) | `docs/02-product-backlog.md` |
| Historias de usuario + criterios de aceptación | `docs/03-historias-de-usuario.md` |
| Épicas | `docs/04-epicas.md` |
| Sprints 1–3 | `docs/05-sprint-planning.md` |
| **Arquitectura, rutas, estado, API, errores** | `docs/06-arquitectura.md` |
| **Base de datos (MER, relacional, SQL)** | `docs/07-base-de-datos.md` |
| **Convenciones, Git flow, estructura repo** | `docs/08-diseno-tecnico.md` |
| Alcance MVP (dentro/fuera) | `docs/09-mvp-alcance.md` |
| Requisitos no funcionales | `docs/10-requisitos-no-funcionales.md` |
| Script SQL ejecutable | `database/schema.sql` |

## Arquitectura en una pantalla

Capas: **Vistas/Componentes** → **Store (pub/sub)** → **Services** → **http (fetch)** → **API REST**.

Estructura objetivo de `src/` (detalle completo en `docs/06-arquitectura.md`):

```
src/
├── main.js            # bootstrap (monta router, hidrata sesión)
├── config/            # env, constantes (API_BASE_URL)
├── router/            # router (History API) + tabla de rutas con roles
├── store/             # store pub/sub + slices (auth, ui)
├── services/          # http.js + *.service.js (única capa que llama a la API)
├── views/             # una vista por ruta (*.view.js)
├── components/        # UI reutilizable (navbar, rating-input, toast...)
├── utils/             # dom, validators, format
└── styles/            # CSS (variables, base, layout, components)
```

Reglas de arquitectura:
- Las **vistas no llaman a `fetch` directamente** → usan `services/*`.
- Los **services no tocan el DOM** → devuelven datos.
- El **estado compartido vive en el store**, no en variables globales sueltas.
- Cambiar de API mock a backend real debe afectar **solo** a `services/` y `config/`.

## Roles del sistema

`coder` · `team_leader` · `tutor` · `coordinador`. La navegación y las rutas se restringen por rol (ver guards en `docs/06-arquitectura.md`). Recuerda: el control de rol en cliente es **UX**; la seguridad real es responsabilidad del backend.

## Convenciones de código

- Archivos/carpetas: **kebab-case** con sufijos `*.view.js`, `*.service.js`, `*.store.js`.
- JS: `camelCase` (vars/funcs), `UPPER_SNAKE_CASE` (constantes), booleanos con `is/has/can`.
- CSS: **BEM** + custom properties en `:root`, **mobile-first**.
- BD/API: `snake_case` en columnas; endpoints REST en plural (`/evaluations`).
- Detalle completo: `docs/08-diseno-tecnico.md`.

## Git y entrega

- **Branch flow** (GitFlow simplificado): `main` ← `develop` ← `feature/<ID>-<slug>` (ej. `feature/EVAL-02-evaluar-team-leader`).
- **Conventional Commits**: `feat(eval): ...`, `fix(auth): ...`, `docs(...): ...`. Referencia el ID de la historia.
- Una historia se cierra cuando cumple su **Definition of Done** (ver `docs/02-product-backlog.md`).
- **No abrir Pull Requests salvo que el usuario lo pida explícitamente.**
- En sesiones asistidas, trabaja en la rama indicada por la tarea; integra hacia `develop` siguiendo el flujo.

## Comandos previstos (cuando exista `package.json`)

```bash
npm install        # dependencias de desarrollo
npm run dev        # Vite dev server (http://localhost:5173)
npm run mock:api   # json-server (http://localhost:3000)
npm run build      # bundle de producción en /dist
npm run preview    # sirve el build localmente
npm run lint       # ESLint
npm run format     # Prettier
```

> Estos scripts aún no existen; defínelos en `package.json` al inicializar el proyecto (historia CORE-01) respetando estos nombres.

## Contrato REST del MVP (resumen)

| Método | Endpoint | Uso |
|--------|----------|-----|
| POST | `/auth/login` | login → `{ token, user }` |
| GET | `/users?role=team_leader` | evaluables por rol |
| GET | `/forms?targetRole=team_leader` | plantilla de formulario |
| POST | `/evaluations` | registrar evaluación |
| GET | `/evaluations?evaluatorId=:id` | historial del Coder |
| GET | `/evaluations?evaluateeId=:id` | histórico por evaluado |
| GET | `/metrics/summary?period=:p` | KPIs del dashboard |

Detalle y modelo de datos: `docs/06-arquitectura.md` y `docs/07-base-de-datos.md`.

## Reglas de negocio que NO debes romper

1. **Anonimato real:** si `is_anonymous` es true, **no** persistas ni expongas el `evaluator_id`. Nunca permitas reconstruir la identidad del evaluador anónimo.
2. **Un Coder no evalúa dos veces** al mismo evaluado en el mismo periodo (índice único en BD).
3. **Validación de formularios** antes de enviar; nada de evaluaciones incompletas.
4. **Seguridad mínima:** contraseñas siempre hasheadas (backend); manejo de `401` cierra sesión.
5. **Respeta el alcance MVP** (`docs/09-mvp-alcance.md`): no implementes funcionalidades marcadas como "fuera del MVP" sin que el usuario lo pida.

## Cómo trabajar en este repo (para el asistente)

1. **Lee la historia** correspondiente en `docs/03-historias-de-usuario.md` y sus criterios de aceptación.
2. **Respeta la arquitectura** de `docs/06-arquitectura.md` (capas y ubicación de archivos).
3. Implementa lo mínimo para cumplir los criterios; **sin sobreingeniería**.
4. Asegura **responsive** y **accesibilidad** básica (ver `docs/10-requisitos-no-funcionales.md`).
5. Verifica manualmente contra la API mock; sin errores en consola.
6. Commits pequeños con Conventional Commits; cumple la Definition of Done.
7. Si actualizas decisiones de arquitectura/producto, **actualiza también `/docs` y este `CLAUDE.md`** para mantenerlos como fuente de verdad.
