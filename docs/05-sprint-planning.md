# 05 — Sprint Planning

## Marco de trabajo

- **Equipo:** 5 Coders de la misma jornada (Scrum obligatorio).
- **Roles Scrum** (de referencia; todos desarrollan y comprenden la solución):

| # | Integrante | Rol Scrum | Foco |
|---|-----------|-----------|------|
| 1 | — | Scrum Master / Líder | Coordinación + Fullstack |
| 2 | — | Product Owner | Backlog + Frontend |
| 3 | — | Backend Developer | FastAPI + MySQL |
| 4 | — | Backend Developer | FastAPI + lógica de negocio |
| 5 | — | Frontend Developer | SPA Vanilla JS |

- **Cronograma del proyecto integrador: 5 semanas**
  - **Semana 1 — Planeación y Diseño** → *Sprint 0*
  - **Semanas 2–3 — Desarrollo** → *Sprint 1*
  - **Semanas 4–5 — Integración y Sustentación** → *Sprint 2*
- **Velocidad estimada del equipo:** ~30–37 SP por sprint de 2 semanas (5 personas).
- **Total backlog MVP:** 71 SP (full-stack). Ver [`02-product-backlog.md`](./02-product-backlog.md).

### Eventos Scrum
- **Daily** (15 min): qué hice / qué haré / impedimentos.
- **Sprint Planning** al inicio de cada sprint; **Review** y **Retrospective** al cierre.
- **Tablero** (Trello / GitHub Projects) con columnas To Do · In Progress · Review · Done.
- Registro de reuniones y seguimiento de avances (requisito de evaluación).

---

## 🟦 Sprint 0 — Planeación y Diseño (Semana 1)

**Sprint Goal:** dejar el proyecto listo para construir: problema definido, backlog, mockups, arquitectura, BD y andamiaje técnico funcionando.

**Capacidad:** 10 SP (más trabajo de planeación/diseño no estimado en SP)

| ID | Historia | SP | Responsable principal |
|----|----------|:--:|-----------------------|
| CORE-01 | Setup repo monorepo + scaffold SPA | 5 | Frontend Dev |
| CORE-02 | Scaffold backend (FastAPI) + conexión MySQL + seed | 5 | Backend Dev |

**Trabajo de planeación (no SP):** definición del problema y alcance, historias de usuario, MVP, **mockups (Figma)**, modelo de datos (3FN), arquitectura, configuración de tablero Scrum y GitFlow, plantilla de PR.

**Justificación:** la rúbrica dedica la Semana 1 a planeación y diseño. Se aprovecha para dejar el andamiaje full-stack listo (repo, SPA vacía navegable, API arrancando contra MySQL con seed) de modo que la Semana 2 empiece a producir valor de inmediato.

---

## 🟩 Sprint 1 — Núcleo: Autenticación + Evaluaciones (Semanas 2–3)

**Sprint Goal:** un usuario inicia sesión según su rol y un Coder puede evaluar (incl. anónimo) a Team Leaders y Tutores, persistiendo en la API con sus reglas de negocio.

**Capacidad:** 37 SP

| ID | Historia | SP | Responsable sugerido |
|----|----------|:--:|----------------------|
| CORE-03 | Layout y navegación responsive | 5 | Frontend Dev |
| AUTH-01 | Inicio de sesión (UI + API + JWT) | 5 | SM/Fullstack |
| AUTH-02 | Sesión y rutas protegidas (front + back) | 5 | Backend Dev |
| AUTH-03 | Roles / autorización (RBAC front + back) | 3 | Backend Dev |
| EVAL-01 | Listar evaluables | 3 | PO/Frontend |
| EVAL-02 | Evaluar Team Leader | 5 | Frontend Dev |
| EVAL-03 | Evaluar Tutor | 3 | PO/Frontend |
| EVAL-04 | Feedback anónimo opcional | 3 | Backend Dev |
| EVAL-05 | Registrar evaluación (API + reglas de negocio) | 5 | Backend Dev |

**Sprint Backlog (clave):** shell responsive y navegación por rol; login con hash + JWT; guards de ruta y `require_role`; motor de formularios reutilizable (criterios + escala + comentarios); plantillas TL/Tutor desde API; toggle anónimo; persistencia con validación Pydantic, **no-duplicado por periodo** y **anonimato real**.

**Justificación:** concentra el **corazón del producto** (la hipótesis a validar: feedback ascendente estructurado) en el periodo de desarrollo. Con 5 personas el trabajo se paraleliza: backend (AUTH/EVAL-05/04) y frontend (CORE-03/EVAL-01/02/03) avanzan en simultáneo contra el contrato REST.

---

## 🟨 Sprint 2 — Trazabilidad, Métricas, Integración y Entrega (Semanas 4–5)

**Sprint Goal:** Coordinadores visualizan resultados, métricas y tendencias; Coders consultan su historial; el producto queda integrado, probado, desplegado y con la documentación y pitches listos.

**Capacidad:** 24 SP + integración/estabilización/entrega

| ID | Historia | SP | Responsable sugerido |
|----|----------|:--:|----------------------|
| HIST-01 | Historial del Coder | 3 | Frontend Dev |
| HIST-02 | Seguimiento histórico (coordinador) | 5 | Backend Dev |
| DASH-01 | Dashboard de resultados | 5 | SM/Fullstack |
| DASH-02 | Métricas e indicadores (lógica agregada) | 5 | Backend Dev |
| DASH-03 | Visualización de tendencias | 3 | Frontend Dev |
| DASH-04 | Reportes básicos (export CSV) | 3 | PO/Frontend |

**Trabajo de integración/entrega (no SP):** corrección de errores, **casos de prueba y evidencias**, documento técnico final, **mockups finales**, despliegue (GitHub Pages/Vercel + backend en la nube), **pitch comercial (inglés)** y **pitch técnico (español)**.

**Justificación:** las Semanas 4–5 son de integración y sustentación. Por eso el compromiso de SP es menor (24) que en el Sprint 1: deja margen para estabilizar, probar, documentar y preparar las presentaciones. DASH-04 es `Could` (MoSCoW) → primer candidato a recortar si la capacidad aprieta.

---

## Resumen

| Sprint | Semanas | Goal | SP | Épicas |
|--------|---------|------|:--:|--------|
| 0 | 1 | Planeación + andamiaje | 10 | CORE |
| 1 | 2–3 | Login + roles + evaluaciones | 37 | CORE, AUTH, EVAL |
| 2 | 4–5 | Historial + dashboard + entrega | 24 | HIST, DASH |

## Gestión de riesgos del plan

| Riesgo | Mitigación |
|--------|------------|
| Integración front/back tardía | Contrato REST acordado en Sprint 0; `/docs` de FastAPI desde el inicio |
| Reparto desigual de contribución | Asignación por historia + evidencia GitFlow por integrante |
| Sprint 1 cargado (37 SP) | Paralelizar backend/frontend; `Should` recortables |
| Sobreingeniería | Sin frameworks de UI; capas simples; reutilizar motor de formularios |
| Quedar en "solo CRUD" | Priorizar lógica de negocio (métricas, anonimato, no-duplicado) como criterios de DoD |
