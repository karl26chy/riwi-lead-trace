# 02 — Product Backlog

Backlog **full-stack** del MVP (frontend SPA + backend FastAPI + MySQL). Estimación en **Story Points (SP)**, escala Fibonacci (1, 2, 3, 5, 8). Prioridad **MoSCoW** (Must / Should / Could). Cada SP refleja el esfuerzo completo (UI + endpoint + datos), salvo las historias de andamiaje.

| ID | Nombre | Descripción | Épica | Prioridad | SP | Dependencias |
|----|--------|-------------|-------|-----------|:--:|--------------|
| CORE-01 | Setup repo + scaffold SPA | Monorepo, estructura `frontend/`, router, store y `http.js` | CORE | Must | 5 | — |
| CORE-02 | Scaffold backend + BD | FastAPI, capas (routers/services/repos/models), conexión MySQL, seed | CORE | Must | 5 | — |
| CORE-03 | Layout y navegación responsive | Shell SPA, nav por rol, estilos base mobile-first | CORE | Must | 5 | CORE-01 |
| AUTH-01 | Inicio de sesión | UI login + `POST /auth/login` con hash + emisión de JWT | AUTH | Must | 5 | CORE-02, CORE-03 |
| AUTH-02 | Sesión y rutas protegidas | JWT en `localStorage`, guards SPA, `get_current_user`, expiración/logout | AUTH | Must | 5 | AUTH-01 |
| AUTH-03 | Roles / autorización (RBAC) | Navegación/acciones por rol (front) + `require_role` (back) | AUTH | Must | 3 | AUTH-02 |
| EVAL-01 | Listar evaluables | UI + `GET /users?role=` de Team Leaders/Tutores a evaluar | EVAL | Must | 3 | AUTH-03 |
| EVAL-02 | Evaluar Team Leader | Formulario estructurado + `GET /forms?target_role=` plantilla | EVAL | Must | 5 | EVAL-01 |
| EVAL-03 | Evaluar Tutor | Reutiliza motor de formularios con plantilla de Tutor | EVAL | Must | 3 | EVAL-02 |
| EVAL-04 | Feedback anónimo opcional | Toggle + regla backend: no persistir `evaluator_id` | EVAL | Should | 3 | EVAL-02 |
| EVAL-05 | Registrar evaluación (API) | `POST /evaluations`: validación Pydantic, estados, **no-duplicado por periodo** | EVAL | Must | 5 | EVAL-02 |
| HIST-01 | Historial del Coder | UI + `GET /evaluations?evaluator_id=` de evaluaciones propias | HIST | Should | 3 | EVAL-05 |
| HIST-02 | Seguimiento histórico | Coordinador: histórico por evaluado/periodo, respeta anonimato | HIST | Should | 5 | EVAL-05 |
| DASH-01 | Dashboard de resultados | Panel coordinador + `GET /metrics/summary` (agregados) | DASH | Must | 5 | EVAL-05 |
| DASH-02 | Métricas e indicadores | **Lógica de negocio:** promedio por criterio, % participación | DASH | Should | 5 | DASH-01 |
| DASH-03 | Visualización de tendencias | Evolución temporal por criterio/persona | DASH | Should | 3 | DASH-02 |
| DASH-04 | Reportes básicos (export) | Exportar a CSV / vista imprimible | DASH | Could | 3 | DASH-01 |

**Total backlog MVP:** 71 SP.

## Lógica de negocio (no es solo CRUD)

La rúbrica exige lógica de negocio identificable más allá del CRUD. En este backlog reside en:
- **EVAL-05:** prevención de evaluación duplicada por (evaluador, evaluado, periodo) + manejo de estados borrador/enviada.
- **EVAL-04:** anonimato real (no se persiste el evaluador).
- **AUTH-03:** control de acceso basado en roles (RBAC) en servidor.
- **DASH-02 / DASH-03:** cálculos agregados (promedios por criterio, participación, tendencias temporales).

## Orden de refinamiento

1. **CORE** (andamiaje front + back + BD).
2. **AUTH** (identidad y rol; todo depende de ello).
3. **EVAL** (núcleo de valor; valida la hipótesis).
4. **HIST + DASH** (convierten datos en información accionable).

## Definition of Ready (DoR)
- Tiene descripción, criterios de aceptación y SP.
- Dependencias resueltas o planificadas en el mismo sprint.
- Contrato de API definido en [`06-arquitectura.md`](./06-arquitectura.md).

## Definition of Done (DoD)
- Cumple **todos** sus criterios de aceptación.
- **Backend:** validación con Pydantic, manejo de errores y códigos HTTP correctos; integrado con MySQL.
- **Frontend:** responsive (móvil + escritorio) y accesible (teclado, labels); sin errores en consola.
- Si aplica, incluye la **lógica de negocio** asociada (no degradada a CRUD).
- Sigue las convenciones de [`08-diseno-tecnico.md`](./08-diseno-tecnico.md).
- Probada manualmente (y con casos de prueba donde aplique); mergeada a `develop` vía Pull Request.
