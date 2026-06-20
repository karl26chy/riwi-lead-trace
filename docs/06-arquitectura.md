# 06 — Arquitectura del Software

## Principios

- **Simplicidad y claridad:** lo necesario para un MVP full-stack mantenible por un equipo de 5.
- **Separación de capas** en frontend y backend; responsabilidades únicas por módulo.
- **Lógica de negocio explícita** (no solo CRUD): vive en la capa `services` del backend.
- **Contrato REST estable** entre SPA y API → frontend y backend evolucionan en paralelo.

## Arquitectura general (full-stack)

```
┌───────────────────────── Navegador ─────────────────────────┐
│  SPA (frontend/)                                              │
│  Router ─▶ Vistas ◀─▶ Componentes                            │
│             │                                                 │
│             ▼                                                 │
│          Store (pub/sub: auth, ui)                           │
│             │                                                 │
│             ▼                                                 │
│          Services ─▶ http.js (fetch: baseURL, JWT, errores) │
└───────────────────────────┬─────────────────────────────────┘
                            │ HTTPS · REST (JSON) · JWT
                            ▼
┌──────────────────── Backend (backend/ · FastAPI) ───────────┐
│  Routers (endpoints, validación I/O con Pydantic)            │
│     │                                                        │
│     ▼                                                        │
│  Services  ◀── LÓGICA DE NEGOCIO (anonimato, no-duplicado,  │
│     │           métricas agregadas, RBAC, estados)          │
│     ▼                                                        │
│  Repositories (consultas / acceso a datos)                  │
│     │                                                        │
│     ▼                                                        │
│  Models (SQLAlchemy ORM)                                     │
└───────────────────────────┬─────────────────────────────────┘
                            │ SQLAlchemy + PyMySQL
                            ▼
                   ┌──────────────────┐
                   │   MySQL (3FN)    │  (ver 07-base-de-datos)
                   └──────────────────┘
```

## Estructura de carpetas (monorepo)

```
riwi-lead-trace/
├── frontend/
│   ├── index.html              # punto de entrada SPA (un solo HTML)
│   ├── package.json
│   ├── vite.config.js
│   ├── public/
│   └── src/
│       ├── main.js             # bootstrap: router + hidratar sesión
│       ├── config/env.js       # API_BASE_URL, constantes
│       ├── router/
│       │   ├── router.js       # motor de rutas (History API) + guards
│       │   └── routes.js       # rutas → vistas + roles permitidos
│       ├── store/
│       │   ├── store.js        # store pub/sub genérico
│       │   ├── auth.store.js
│       │   └── ui.store.js
│       ├── services/
│       │   ├── http.js         # wrapper fetch (baseURL, JWT, errores)
│       │   ├── auth.service.js
│       │   ├── evaluation.service.js
│       │   ├── user.service.js
│       │   └── metrics.service.js
│       ├── views/              # login, home, evaluables, evaluation-form,
│       │                       # history, dashboard, not-found (*.view.js)
│       ├── components/         # navbar, form-field, rating-input, card,
│       │                       # toast, loader
│       ├── utils/              # dom.js, validators.js, format.js
│       └── styles/             # variables, base, layout, components (.css)
│
├── backend/
│   ├── app/
│   │   ├── main.py             # crea FastAPI, CORS, incluye routers
│   │   ├── core/
│   │   │   ├── config.py       # settings (DB_URL, JWT_SECRET) desde .env
│   │   │   ├── database.py     # engine + SessionLocal + Base
│   │   │   └── security.py     # hash de contraseñas + crear/verificar JWT
│   │   ├── models/             # SQLAlchemy: user, role, period,
│   │   │                       # form_template, question, evaluation, answer
│   │   ├── schemas/            # Pydantic: request/response por dominio
│   │   ├── repositories/       # acceso a datos (queries reutilizables)
│   │   ├── services/           # LÓGICA DE NEGOCIO por dominio
│   │   ├── routers/            # auth, users, forms, evaluations, metrics
│   │   └── deps.py             # get_db, get_current_user, require_role
│   ├── tests/                  # pytest
│   ├── requirements.txt
│   └── .env.example
│
├── database/
│   └── schema.sql              # DDL + seed (MySQL, 3FN)
├── docs/                       # documentación Scrum + técnica (01..12)
└── mockups/                    # exports/enlaces Figma
```

## Sistema de rutas SPA (frontend)

- Router propio sobre **History API** (`pushState` + `popstate`).
- `routes.js` declara ruta → vista → roles autorizados:

```js
export const routes = [
  { path: '/login',        view: 'login',           public: true },
  { path: '/',             view: 'home',            roles: ['coder','team_leader','tutor','coordinador'] },
  { path: '/evaluables',   view: 'evaluables',      roles: ['coder'] },
  { path: '/evaluar/:id',  view: 'evaluation-form', roles: ['coder'] },
  { path: '/historial',    view: 'history',         roles: ['coder','coordinador'] },
  { path: '/dashboard',    view: 'dashboard',       roles: ['coordinador'] },
  { path: '*',             view: 'not-found',       public: true },
];
```

- **Guards:** antes de renderizar se valida sesión (`auth.store`) y rol. Sin sesión → `/login`; rol no autorizado → "no autorizado".

## Gestión de estado (frontend)

- Store **pub/sub** sin librerías: `getState()`, `setState(patch)`, `subscribe(fn)`.
- Slices por dominio: `auth.store` (usuario, token, rol), `ui.store` (loading, toasts).
- La sesión se **hidrata** desde `localStorage` al arrancar (`main.js`).

## Backend — arquitectura por capas (FastAPI)

| Capa | Responsabilidad | Regla |
|------|-----------------|-------|
| `routers/` | Definir endpoints, validar I/O con Pydantic, códigos HTTP | No contiene lógica de negocio |
| `services/` | **Lógica de negocio** (reglas, cálculos, orquestación) | No conoce detalles HTTP |
| `repositories/` | Consultas y acceso a datos vía ORM | Único lugar con queries |
| `models/` | Entidades SQLAlchemy mapeadas a MySQL | Definen el esquema |
| `schemas/` | Contratos Pydantic (validación/serialización) | Frontera de datos |
| `deps.py` | Dependencias: `get_db`, `get_current_user`, `require_role` | Inyección/seguridad |

Ejemplo de RBAC con dependencias (ilustrativo):

```python
# app/deps.py
def require_role(*roles):
    def checker(user = Depends(get_current_user)):
        if user.role not in roles:
            raise HTTPException(status_code=403, detail="No autorizado")
        return user
    return checker

# app/routers/metrics.py
@router.get("/metrics/summary")
def summary(period_id: int, user = Depends(require_role("coordinador")),
            db = Depends(get_db)):
    return metrics_service.build_summary(db, period_id)
```

## Comunicación con la API

- En frontend, **toda** llamada pasa por `services/http.js`: prefija `API_BASE_URL`, inyecta `Authorization: Bearer <token>`, serializa/parsea JSON y **normaliza errores** a `{ status, message }`.
- Cada `*.service.js` expone funciones de dominio; nunca `fetch` directo en vistas.
- **Contrato REST del MVP:**

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/auth/login` | Autenticación → `{ token, user }` |
| GET | `/users?role=team_leader` | Evaluables por rol |
| GET | `/forms?target_role=team_leader` | Plantilla de formulario por rol |
| POST | `/evaluations` | Registrar evaluación (con reglas de negocio) |
| GET | `/evaluations?evaluator_id=:id` | Historial del Coder |
| GET | `/evaluations?evaluatee_id=:id` | Histórico por evaluado (respeta anonimato) |
| GET | `/metrics/summary?period_id=:p` | KPIs agregados del dashboard |

> FastAPI expone documentación interactiva automática en `/docs` (Swagger) y `/redoc`, útil para pruebas y sustentación.

## Manejo de autenticación

- Login → `POST /auth/login`: backend verifica hash, emite **JWT** firmado. Frontend guarda `token` y `user` en `localStorage` + `auth.store`.
- El token viaja en cada petición (`http.js`); el backend lo valida en `get_current_user`.
- `401` global en frontend → limpiar sesión + redirigir a `/login`. Logout → limpiar storage + store.
- **Autorización por rol** en backend (`require_role`) — autoridad real — y en frontend (guards) — solo UX.

## Manejo de errores

**Backend**
- Validación de entrada con Pydantic → `422` automático con detalle por campo.
- Errores de negocio → `HTTPException` con código correcto (`400/403/404/409`).
- Manejadores globales para excepciones no controladas → `500` con cuerpo JSON consistente; logging.

**Frontend**
- `http.js` normaliza errores de red y códigos no-2xx.
- Las vistas muestran `toast` (`ui.store`) o estado de error; nunca dejan la pantalla en blanco.
- Validación de formularios en cliente (`utils/validators.js`) antes de enviar.
- Estados de **carga** y **vacío** estandarizados (`loader`, estado vacío).
- `window.onerror` / `unhandledrejection` → toast genérico + log.
