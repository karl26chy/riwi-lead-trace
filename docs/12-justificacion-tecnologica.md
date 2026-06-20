# 12 — Justificación Tecnológica

La rúbrica exige justificar las decisiones técnicas. Aquí se sustenta cada elección, dentro de las **tecnologías permitidas** por el proyecto integrador.

## Resumen de decisiones

| Capa | Elección | Alternativas permitidas | Por qué esta |
|------|----------|-------------------------|--------------|
| Frontend | HTML5 + CSS3 + **JS Vanilla (SPA)** | (obligatorio; sin frameworks) | Requisito del proyecto |
| Estilos | CSS3 + Custom Properties | Tailwind, Bootstrap, Sass/Less | Cero dependencias, control total, responsive nativo |
| Backend | **Python + FastAPI** | Flask, Express.js | Python alineado a la Ruta Básica + validación y docs integradas |
| Base de datos | **MySQL** | PostgreSQL, MongoDB | Datos relacionales, integridad, consultas agregadas |
| Auth | **JWT** | sesiones server-side | Sin estado, encaja con SPA + API REST |

## Backend: ¿por qué FastAPI?

- **Python** es uno de los lenguajes centrales de la Ruta Básica (ver objetivos del proyecto) → el equipo lo domina y puede **sustentarlo**.
- **Validación de datos con Pydantic** integrada: cumple directamente el requisito "validación de datos" con schemas declarativos y errores `422` automáticos por campo.
- **Documentación automática** (Swagger en `/docs`, ReDoc en `/redoc`): acelera la integración con el frontend y aporta evidencia para el pitch técnico y las pruebas.
- **Inyección de dependencias** nativa: ideal para `get_db`, `get_current_user` y `require_role` (RBAC) de forma limpia.
- **Rendimiento** (ASGI/async) y tipado estático → código más mantenible para un equipo de 5.
- **Manejo de errores** estructurado con `HTTPException` y handlers globales.

> *vs Flask:* FastAPI trae validación, tipado y docs sin librerías extra. *vs Express:* mantiene el backend en Python, coherente con lo aprendido en la ruta.

## Base de datos: ¿por qué MySQL (relacional)?

- El dominio es **naturalmente relacional**: usuarios↔roles, plantillas↔preguntas, evaluaciones↔respuestas. Las **claves foráneas** garantizan integridad.
- Requerimos **restricciones** que una relacional aplica nativamente: unicidad de evaluación por (evaluador, evaluado, periodo), rangos de puntaje, FKs.
- El **dashboard** vive de **consultas agregadas** (promedios por criterio, conteos, agrupación por periodo): SQL las expresa de forma directa y eficiente.
- Modelo **normalizable a 3FN** sin fricción (ver [`07-base-de-datos.md`](./07-base-de-datos.md)).
- Ampliamente enseñada → el equipo la sustenta con solvencia.

> *vs MongoDB:* el modelo documental no aporta ventajas aquí; introduciría duplicación o referencias manuales para datos que son claramente tabulares y relacionados. *vs PostgreSQL:* equivalente y válida; se elige MySQL por familiaridad del equipo (PostgreSQL sería preferible si se necesitara analítica avanzada como CTEs/ventanas).

## Frontend: SPA en JavaScript Vanilla

- **Requisito** del proyecto (no se admiten frameworks de UI).
- Arquitectura **modular** propia (router + store + services) demuestra dominio de fundamentos JS, valorado en la evaluación individual.
- **Vite** como dev server/bundler: mejora la DX (HMR, build optimizado) sin ser un framework de UI → permitido.
- **CSS3 con Custom Properties** y enfoque **mobile-first**; Tailwind/Bootstrap quedan disponibles si el equipo prefiere acelerar el maquetado (ambos permitidos).

## Autenticación: JWT

- Encaja con una arquitectura **SPA + API REST sin estado**: el token viaja en cada petición.
- Permite **RBAC** simple (rol embebido/derivado del usuario) verificado en el backend.
- Contraseñas siempre **hasheadas** (passlib/bcrypt); el token se firma con `JWT_SECRET` desde `.env`.

## Decisiones que evitan sobreingeniería

- Sin frameworks de frontend ni capa de estado externa (store propio mínimo).
- ORM (SQLAlchemy) para claridad y seguridad ante SQL injection, pero esquema simple en 3FN.
- Migraciones opcionales: para el MVP basta `database/schema.sql` versionado (Alembic queda como mejora futura).
- Tests enfocados en la **lógica de negocio** (no cobertura total): mayor valor con menos esfuerzo.

## Alineación con la rúbrica

| Requisito de la rúbrica | Cómo se cumple |
|-------------------------|----------------|
| Integración front + back + persistencia | SPA ↔ FastAPI ↔ MySQL |
| Validación de datos | Pydantic (back) + validators (front) |
| Manejo de errores | HTTPException + handlers + toasts |
| Gestión de rutas | Routers FastAPI + router SPA |
| Modelo 3FN, relaciones, CRUD, consultas | Ver 07 + schema.sql |
| Lógica de negocio (no solo CRUD) | Anonimato, no-duplicado, métricas, RBAC |
| Justificación tecnológica | Este documento |
