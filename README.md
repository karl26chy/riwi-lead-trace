# Riwi LeadTrace

> Proyecto Integrador de Riwi. Los Coders evaluan a sus Team Leaders y Tutores (pueden marcarlo como anonimo) y el Admin ve los resultados por periodo, con un resumen generado por IA.

![Python](https://img.shields.io/badge/Python-3.12-3776AB?logo=python&logoColor=fff)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?logo=fastapi&logoColor=fff)
![MySQL](https://img.shields.io/badge/MySQL-3FN-4479A1?logo=mysql&logoColor=fff)
![Vanilla JS](https://img.shields.io/badge/Vanilla_JS-ES6+-f7df1e?logo=javascript&logoColor=000)
![Vite](https://img.shields.io/badge/Vite-646CFF?logo=vite&logoColor=fff)
![pytest](https://img.shields.io/badge/Tested_with-pytest-0A9EDC?logo=pytest&logoColor=fff)

---

## Notas tecnicas

Si una evaluacion es anonima, el `evaluator_id` no se guarda en la base de datos. No hay forma de recuperar despues quien la hizo.

El backend revisa el `evaluator_id` antes de insertar, para que un Coder no evalue dos veces a la misma persona en el mismo periodo. Ese id llega en el body de la peticion, no de un token.

El ICP (Indice de Calidad Percibida) se calcula al consultar, no se guarda en tablas. Con menos del minimo de evaluaciones no se publica puntaje. El estado (Solido, Estable, En riesgo) sale de comparar contra dos umbrales fijos en el codigo.

El login valida la contrasena con bcrypt en el servidor. No usamos JWT: el front recibe el usuario ya validado y decide que mostrar segun el rol que le llega.

Los resumenes con IA (API de Claude) reciben solo promedios y conteos, nunca los comentarios ni quien los escribio. Se cachean por persona y periodo.

Las queries son SQL directo con `text()` de SQLAlchemy, sin ORM declarativo.

## Estructura

```text
riwi-lead-trace/
├── frontend/      # SPA Vanilla JS (ES Modules) + Vite
├── backend/       # API REST: FastAPI + SQLAlchemy (SQL plano) + MySQL
├── database/      # schema.sql (3FN) + datos semilla
├── docs/          # documentacion Scrum y tecnica
└── mockups/       # prototipos de las pantallas del MVP
```

Detalle del backend en [`backend/README.md`](./backend/README.md).

## Local

```bash
# Base de datos
mysql -u root -p < database/schema.sql

# Backend
cd backend
python -m venv venv && source venv/bin/activate   # Windows: venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env
uvicorn app.main:app --reload                      # http://localhost:8000/docs

# Frontend
cd frontend
npm install
npm run dev                                         # http://localhost:5173
```

## Stack

| Capa | Tecnologia |
|---|---|
| Frontend | HTML5 + CSS3 + JavaScript Vanilla (SPA, sin frameworks) + Vite |
| Backend | Python + FastAPI, SQLAlchemy (`text()`), Pydantic |
| Base de datos | MySQL, normalizada a 3FN |
| Auth | bcrypt en el login + sesion en `localStorage` |
| IA | Claude API (`anthropic`), con cache de resumenes |

## Tests

```bash
cd backend && pytest      # login, permisos, evaluaciones y metricas
cd frontend && npm test   # validadores y utilidades del front
```

## Documentacion

Punto de partida: [`docs/00-documento-tecnico.md`](./docs/00-documento-tecnico.md). El resto de `/docs` desglosa vision, backlog, arquitectura, base de datos y convenciones del equipo.

## Equipo

| Integrante | Rol | Foco |
|---|---|---|
| Manuel Vasquez ([@manulzweb](https://github.com/manulzweb)) | Scrum Master / Lider | Coordinacion + backend (FastAPI + MySQL) |
| Carlos Charris ([@karl26chy](https://github.com/karl26chy)) | Product Owner | Backlog + frontend |
| Yamit Garcia ([@YamitGC](https://github.com/YamitGC)) | Backend Developer | Auth, sesiones y permisos |
| Sebastian Mendoza ([@smendozab097](https://github.com/smendozab097)) | Frontend Developer | SPA en Vanilla JS |
| Saeb Garcia ([@SaebGC](https://github.com/SaebGC)) | Frontend Developer | SPA en Vanilla JS |

GitFlow + Conventional Commits. Cada historia en su rama `feature/<ID>-<slug>` desde `develop`.

---

Usamos IA como apoyo para parte del codigo y de esta documentacion. Todo paso por revision del equipo antes de integrarse.
