# 12 — Justificacion Tecnologica

La rubrica exige justificar las decisiones tecnicas. Aqui se sustenta cada eleccion, dentro de las **tecnologias permitidas** por el proyecto integrador.

## Resumen de decisiones

| Capa | Eleccion | Alternativas permitidas | Por que esta |
|------|----------|-------------------------|--------------|
| Frontend | HTML5 + CSS3 + **JS Vanilla (SPA)** | (obligatorio; sin frameworks) | Requisito del proyecto |
| Estilos | CSS3 + Custom Properties | Tailwind, Bootstrap, Sass/Less | Cero dependencias, control total, responsive nativo |
| Backend | **Python + FastAPI** | Flask, Express.js | Python alineado a la Ruta Basica + validacion y docs integradas |
| Base de datos | **MySQL** | PostgreSQL, MongoDB | Datos relacionales, integridad, consultas agregadas |
| Auth | **JWT** | sesiones server-side | Sin estado, encaja con SPA + API REST |
| IA (resumenes) | **Claude API** (`anthropic`) | otros LLM, sin IA | Calidad de redaccion de coaching + privacidad por diseno (solo agregados anonimos) |

## Backend: por que FastAPI?

- **Python** es uno de los lenguajes centrales de la Ruta Basica (ver objetivos del proyecto) -> el equipo lo domina y puede **sustentarlo**.
- **Validacion de datos con Pydantic** integrada: cumple directamente el requisito "validacion de datos" con schemas declarativos y errores `422` automaticos por campo.
- **Documentacion automatica** (Swagger en `/docs`, ReDoc en `/redoc`): acelera la integracion con el frontend y aporta evidencia para el pitch tecnico y las pruebas.
- **Inyeccion de dependencias** nativa: ideal para `get_db`, `get_current_user` y `require_role` (RBAC) de forma limpia.
- **Rendimiento** (ASGI/async) y tipado estatico -> codigo mas mantenible para un equipo de 5.
- **Manejo de errores** estructurado con `HTTPException` y handlers globales.

> *vs Flask:* FastAPI trae validacion, tipado y docs sin librerias extra. *vs Express:* mantiene el backend en Python, coherente con lo aprendido en la ruta.

## Base de datos: por que MySQL (relacional)?

- El dominio es **naturalmente relacional**: usuarios<->roles, plantillas<->preguntas, evaluaciones<->respuestas. Las **claves foraneas** garantizan integridad.
- Requerimos **restricciones** que una relacional aplica nativamente: unicidad de evaluacion por (evaluador, evaluado, periodo), rangos de puntaje, FKs.
- El **dashboard** vive de **consultas agregadas** (promedios por criterio, conteos, agrupacion por periodo): SQL las expresa de forma directa y eficiente.
- Modelo **normalizable a 3FN** sin friccion (ver [`07-base-de-datos.md`](./07-base-de-datos.md)).
- Ampliamente ensenada -> el equipo la sustenta con solvencia.

> *vs MongoDB:* el modelo documental no aporta ventajas aqui; introduciria duplicacion o referencias manuales para datos que son claramente tabulares y relacionados. *vs PostgreSQL:* equivalente y valida; se elige MySQL por familiaridad del equipo.

## Frontend: SPA en JavaScript Vanilla

- **Requisito** del proyecto (no se admiten frameworks de UI).
- Arquitectura **modular** propia (router + store + services) demuestra dominio de fundamentos JS, valorado en la evaluacion individual.
- **Vite** como dev server/bundler: mejora la DX (HMR, build optimizado) sin ser un framework de UI -> permitido.
- **CSS3 con Custom Properties** y enfoque **mobile-first**; Tailwind/Bootstrap quedan disponibles si el equipo prefiere acelerar el maquetado (ambos permitidos).

## Autenticacion: JWT

- Encaja con una arquitectura **SPA + API REST sin estado**: el token viaja en cada peticion.
- Permite **RBAC** simple (rol embebido/derivado del usuario) verificado en el backend.
- Contrasenas siempre **hasheadas** (passlib/bcrypt); el token se firma con `JWT_SECRET` desde `.env`.

## IA: por que Claude API?

- **Caso de uso:** resumir, en lenguaje natural para el **Admin (Jefe de TL/tutores)**, el feedback
  agregado por persona/periodo (fortalezas, riesgos, recomendacion de acompanamiento). Es
  generacion de texto, donde un LLM aporta valor real frente a una plantilla fija.
- **Modelo recomendado:** `claude-sonnet-4-6` por su balance calidad/costo para redaccion de
  coaching; alternativa economica para resumenes masivos: `claude-haiku-4-5-20251001`. Se accede
  via el SDK `anthropic` desde `services/ai_service.py`, con `ANTHROPIC_API_KEY` en `core/config.py`.
- **Privacidad por diseno (regla de negocio):** al modelo solo se envian **agregados anonimizados**
  (promedios, conteos, comentarios sin autor). **Nunca** `evaluator_id` ni datos que revelen
  identidad -> el anonimato se preserva aun usando un servicio externo.
- **Control de costo:** los resumenes se **cachean** en `ai_feedback_cache`
  (`UNIQUE(evaluatee_id, period_id)`) para no re-llamar al modelo.
- **Sustentacion:** es un diferenciador del producto sin romper las restricciones del proyecto
  (la IA complementa la **logica de negocio propia** —ICA— que es lo evaluado por la rubrica).

## Decisiones que evitan sobreingenieria

- Sin frameworks de frontend ni capa de estado externa (store propio minimo).
- ORM (SQLAlchemy) para claridad y seguridad ante SQL injection, pero esquema simple en 3FN.
- Migraciones opcionales: para el MVP basta `database/schema.sql` versionado (Alembic queda como mejora futura).
- Tests enfocados en la **logica de negocio** (no cobertura total): mayor valor con menos esfuerzo.

## Alineacion con la rubrica

| Requisito de la rubrica | Como se cumple |
|-------------------------|----------------|
| Integracion front + back + persistencia | SPA <-> FastAPI <-> MySQL |
| Validacion de datos | Pydantic (back) + validators (front) |
| Manejo de errores | HTTPException + handlers + toasts |
| Gestion de rutas | Routers FastAPI + router SPA |
| Modelo 3FN, relaciones, CRUD, consultas | Ver 07 + schema.sql |
| Logica de negocio (no solo CRUD) | Anonimato, no-duplicado por periodo, **ICA**, RBAC, resumen IA |
| Justificacion tecnologica | Este documento |
