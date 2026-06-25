# Riwi LeadTrace

> MVP de **evaluación 360° multi-área** para el **Proyecto Integrador — CodeUp Riwi: Beyond Limits (Ruta Básica)**. Aplicación web full-stack: los Coders evalúan a Team Leaders y Tutores (con opción anónima) y los TL llevan una bitácora continua de sus Tutores, todo por **área** (Desarrollo, Inglés, HSE, BLS). Calcula un **Índice de Calidad de Acompañamiento (ICA)**, una **analítica de talento** y **resúmenes con IA (Claude)** para el Admin (Jefe de TL/tutores).

## 📌 ¿Qué es?

Hoy los Team Leaders evalúan a los Coders, pero **no existe un mecanismo formal para que los Coders evalúen a sus líderes y tutores**. Riwi LeadTrace cierra ese ciclo: habilita feedback bidireccional (con opción anónima), identifica fortalezas y debilidades del acompañamiento, y entrega métricas accionables a los responsables académicos.

No es un CRUD básico: incorpora **lógica de negocio** real (reglas de anonimato, prevención de evaluaciones duplicadas por periodo/área, **ICA** —índice ponderado por criterio con confianza, tendencia y estado—, **analítica de talento**, resúmenes con IA anonimizados y control de acceso por rol).

## 👥 Equipo (5 integrantes)

Proyecto desarrollado por un equipo Scrum de **5 Coders** de la misma jornada. Roles (de referencia; todos desarrollan y comprenden la solución completa):

| Integrante | Rol Scrum | Foco técnico |
|-----------|-----------|--------------|
| 1 | Scrum Master / Líder | Coordinación + Fullstack |
| 2 | Product Owner | Backlog + Frontend |
| 3 | Backend Developer | FastAPI + MySQL |
| 4 | Backend Developer | FastAPI + lógica de negocio |
| 5 | Frontend Developer | SPA Vanilla JS |

> Cada integrante debe evidenciar commits propios, ramas y Pull Requests bajo **GitFlow** (ver [`docs/08-diseno-tecnico.md`](./docs/08-diseno-tecnico.md)).

## 🧱 Stack técnico

| Capa | Tecnología | Justificación (resumen) |
|------|------------|--------------------------|
| Frontend | HTML5 + CSS3 + **JavaScript Vanilla** (SPA) | Requisito del proyecto; sin frameworks |
| Estilos | CSS3 + Custom Properties (Tailwind/Bootstrap permitidos) | Responsive mobile-first |
| Backend | **Python + FastAPI** | Python alineado a la Ruta Básica; validación con Pydantic, docs OpenAPI automáticas, dependencias para auth/RBAC |
| ORM/DB driver | SQLAlchemy + PyMySQL | Acceso a datos limpio y mantenible |
| Base de datos | **MySQL** (relacional, **3FN**) | Integridad referencial; consultas agregadas para el dashboard |
| Auth | JWT (JSON Web Tokens) | Sesión sin estado; RBAC por rol |
| Tooling front (dev) | Vite | Dev server / bundler (no es framework de UI) |

Justificación tecnológica completa: [`docs/12-justificacion-tecnologica.md`](./docs/12-justificacion-tecnologica.md).

## 📚 Documentación

Planeación Scrum y diseño técnico en [`/docs`](./docs):

| Documento | Contenido |
|-----------|-----------|
| [01 — Visión y Producto](./docs/01-vision-y-producto.md) | Vision, Goal, objetivos, métricas |
| [02 — Product Backlog](./docs/02-product-backlog.md) | Backlog full-stack priorizado con SP |
| [03 — Historias de Usuario](./docs/03-historias-de-usuario.md) | Historias + criterios de aceptación |
| [04 — Épicas](./docs/04-epicas.md) | Épicas y mapa a sprints |
| [05 — Sprint Planning](./docs/05-sprint-planning.md) | Sprints 0–2 sobre cronograma de 5 semanas |
| [06 — Arquitectura](./docs/06-arquitectura.md) | Arquitectura full-stack (SPA + FastAPI + MySQL) |
| [07 — Base de Datos](./docs/07-base-de-datos.md) | MER, 3FN, modelo relacional y CRUD |
| [08 — Diseño Técnico](./docs/08-diseno-tecnico.md) | Convenciones, GitFlow de equipo, repo |
| [09 — Alcance MVP](./docs/09-mvp-alcance.md) | Dentro/fuera del MVP |
| [10 — Requisitos No Funcionales](./docs/10-requisitos-no-funcionales.md) | Seguridad, rendimiento, accesibilidad |
| [11 — Entregables y Evaluación](./docs/11-entregables-y-evaluacion.md) | Entregables del proyecto integrador |
| [12 — Justificación Tecnológica](./docs/12-justificacion-tecnologica.md) | Por qué FastAPI + MySQL + SPA Vanilla |

Script SQL inicial: [`/database/schema.sql`](./database/schema.sql).

## 🗂️ Estructura del repositorio (monorepo)

```
riwi-lead-trace/
├── frontend/      # SPA: HTML5 + CSS3 + JS Vanilla (Vite dev server)
├── backend/       # API REST: Python + FastAPI + SQLAlchemy
├── database/      # schema.sql + seed (MySQL, 3FN)
├── docs/          # documentación Scrum + técnica (01..12)
├── mockups/       # enlaces/exports de Figma (o ./docs)
└── README.md
```

## 🚀 Puesta en marcha

### 1) Base de datos (MySQL)
```bash
mysql -u root -p < database/schema.sql
```

### 2) Backend (FastAPI)
```bash
cd backend
python -m venv venv && source venv/bin/activate   # Windows: venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env                                # configurar DB_URL y JWT_SECRET
uvicorn app.main:app --reload                       # http://localhost:8000  (docs: /docs)
```

### 3) Frontend (SPA)
```bash
cd frontend
npm install
npm run dev                                         # http://localhost:5173
```

> Los comandos asumen la estructura objetivo descrita en [`docs/06-arquitectura.md`](./docs/06-arquitectura.md). El código aún no está implementado: el repo está en fase de planeación.

## 🌐 Despliegue previsto

- **Frontend:** GitHub Pages o Vercel.
- **Backend + DB:** plataforma en la nube (Render/Railway) o ejecución local documentada.

Ver [`docs/11-entregables-y-evaluacion.md`](./docs/11-entregables-y-evaluacion.md).

## 👤 Roles del sistema (usuarios)

`Coder` · `Tutor` · `Team Leader` · `Admin (Jefe de TL / tutores)`

Dimensión transversal de **área**: Desarrollo · Inglés · HSE · BLS.
