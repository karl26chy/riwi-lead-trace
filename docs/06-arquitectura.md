# 06 — Arquitectura del Software

## Principios

- **Simplicidad sobre todo:** sin frameworks; solo lo necesario para un MVP mantenible por una persona.
- **Modularidad:** cada responsabilidad en su módulo (router, store, servicios, vistas, componentes).
- **Separación de capas:** UI (vistas/componentes) ↔ estado (store) ↔ datos (servicios/API).
- **Preparada para API REST:** toda la data pasa por la capa de `services`; cambiar de mock a backend real es transparente.

## Arquitectura general

SPA cliente con arquitectura modular en capas:

```
┌──────────────────────────────────────────────────────────┐
│                        Navegador                          │
│                                                            │
│   ┌──────────┐   ┌──────────────┐   ┌──────────────────┐  │
│   │  Router   │──▶│    Vistas     │◀─▶│   Componentes    │  │
│   │ (cliente) │   │  (páginas)    │   │  (reutilizables) │  │
│   └────┬──────┘   └──────┬────────┘   └──────────────────┘ │
│        │                 │                                  │
│        ▼                 ▼                                  │
│   ┌──────────────────────────────┐                         │
│   │           Store               │  estado global (pub/sub)│
│   │  (auth, ui, evaluaciones...)  │                         │
│   └──────────────┬───────────────┘                         │
│                  │                                          │
│                  ▼                                          │
│   ┌──────────────────────────────┐                         │
│   │          Services             │  lógica de datos        │
│   │  authService, evalService...  │                         │
│   └──────────────┬───────────────┘                         │
│                  │                                          │
│                  ▼                                          │
│   ┌──────────────────────────────┐                         │
│   │       http (fetch wrapper)    │  baseURL, JWT, errores  │
│   └──────────────┬───────────────┘                         │
└──────────────────┼─────────────────────────────────────────┘
                   │ HTTPS / REST
                   ▼
        ┌────────────────────────┐
        │   API REST (backend)   │  json-server en dev
        │  + Base de datos        │  (ver 07-base-de-datos)
        └────────────────────────┘
```

## Estructura de carpetas

```
riwi-lead-trace/
├── index.html                # punto de entrada SPA (un solo HTML)
├── package.json
├── vite.config.js
├── db.json                   # datos mock (json-server, ignorado por git)
├── public/                   # assets estáticos
│   └── assets/
├── src/
│   ├── main.js               # bootstrap: monta router + store inicial
│   ├── config/
│   │   └── env.js            # baseURL de API, constantes globales
│   ├── router/
│   │   ├── router.js         # motor de rutas (History API) + guards
│   │   └── routes.js         # tabla de rutas → vistas + roles permitidos
│   ├── store/
│   │   ├── store.js          # store pub/sub genérico
│   │   ├── auth.store.js     # estado de sesión y usuario
│   │   └── ui.store.js       # estado de UI (loading, toasts)
│   ├── services/
│   │   ├── http.js           # wrapper de fetch (baseURL, JWT, errores)
│   │   ├── auth.service.js
│   │   ├── evaluation.service.js
│   │   ├── user.service.js
│   │   └── metrics.service.js
│   ├── views/                # una vista por ruta
│   │   ├── login.view.js
│   │   ├── home.view.js
│   │   ├── evaluables.view.js
│   │   ├── evaluation-form.view.js
│   │   ├── history.view.js
│   │   ├── dashboard.view.js
│   │   └── not-found.view.js
│   ├── components/           # piezas reutilizables de UI
│   │   ├── navbar.js
│   │   ├── form-field.js
│   │   ├── rating-input.js
│   │   ├── card.js
│   │   ├── toast.js
│   │   └── loader.js
│   ├── utils/
│   │   ├── dom.js            # helpers de creación/render DOM
│   │   ├── validators.js
│   │   └── format.js         # fechas, números
│   └── styles/
│       ├── main.css          # importa el resto
│       ├── variables.css     # custom properties (colores, spacing)
│       ├── base.css          # reset + tipografía
│       ├── layout.css
│       └── components.css
├── docs/                     # documentación Scrum + técnica
└── database/
    └── schema.sql            # script SQL inicial (backend real)
```

## Sistema de rutas SPA

- Router propio basado en **History API** (`pushState` + evento `popstate`); fallback opcional a hash.
- `routes.js` declara cada ruta con su vista y los roles autorizados:

```js
// src/router/routes.js (ilustrativo)
export const routes = [
  { path: '/login',        view: 'login',          public: true },
  { path: '/',             view: 'home',           roles: ['coder','team_leader','tutor','coordinador'] },
  { path: '/evaluables',   view: 'evaluables',     roles: ['coder'] },
  { path: '/evaluar/:id',  view: 'evaluation-form',roles: ['coder'] },
  { path: '/historial',    view: 'history',        roles: ['coder','coordinador'] },
  { path: '/dashboard',    view: 'dashboard',      roles: ['coordinador'] },
  { path: '*',             view: 'not-found',      public: true },
];
```

- **Guards:** antes de renderizar, el router verifica sesión (`auth.store`) y rol. Sin sesión → `/login`; rol no autorizado → `not-found`/"no autorizado".

## Gestión de estado

- Store **pub/sub** minimalista (sin librerías). `store.getState()`, `store.setState(patch)`, `store.subscribe(fn)`.
- Stores por dominio: `auth.store` (usuario, token, rol), `ui.store` (loading, toasts).
- Las vistas se suscriben a los slices que necesitan y se re-renderizan ante cambios.
- El estado de sesión se **hidrata** desde `localStorage` al arrancar (`main.js`).

## Comunicación con la API

- Toda llamada pasa por `services/http.js`:
  - Prefija `baseURL` (de `config/env.js`).
  - Inyecta `Authorization: Bearer <token>` si hay sesión.
  - Serializa/parsea JSON.
  - Normaliza errores a una forma común `{ status, message }`.
- Cada `*.service.js` expone funciones de dominio (`evaluationService.submit(payload)`), nunca llama a `fetch` directo.
- **Contrato REST del MVP:**

| Método | Endpoint | Descripción |
|--------|----------|-------------|
| POST | `/auth/login` | Autenticación; devuelve `{ token, user }` |
| GET | `/users?role=team_leader` | Evaluables por rol |
| GET | `/forms?targetRole=team_leader` | Plantilla de formulario por rol |
| POST | `/evaluations` | Registrar evaluación |
| GET | `/evaluations?evaluatorId=:id` | Historial del Coder |
| GET | `/evaluations?evaluateeId=:id` | Histórico por evaluado |
| GET | `/metrics/summary?period=:p` | KPIs agregados del dashboard |

> En desarrollo, json-server sirve estos recursos desde `db.json` (los endpoints `/auth` y `/metrics` se simulan con rutas custom o middleware).

## Manejo de autenticación

- Login → `POST /auth/login` → se guardan `token` y `user` en `localStorage` y en `auth.store`.
- El token (JWT) viaja en cada petición vía `http.js`.
- `401` global → limpiar sesión y redirigir a `/login`.
- Logout → limpiar `localStorage` + `auth.store` + redirigir.
- Autorización por rol resuelta en los guards del router y en el render condicional de la UI.

## Manejo de errores

- **Capa HTTP:** errores de red y códigos no-2xx se normalizan y propagan.
- **Capa UI:** las vistas capturan errores y muestran un `toast` (`ui.store`) o un estado de error en la propia vista; nunca dejan la app en blanco.
- **Validación de formularios:** en cliente con `utils/validators.js`; errores por campo antes de enviar.
- **Estados de carga/vacío:** componentes `loader` y estado vacío estandarizados para cada vista que consume datos.
- **Errores no controlados:** `window.onerror` / `unhandledrejection` registran y muestran un toast genérico.
