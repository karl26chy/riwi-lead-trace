# 05 — Sprint Planning

## Marco de trabajo

- **Equipo simulado:** 1 Scrum Master (que también desarrolla) + 4 Developers.
- **Realidad operativa:** **una sola persona** implementa todo. La planeación está optimizada para esa realidad: alcance ajustado, dependencias serializadas y foco en una épica por sprint.
- **Duración del sprint:** 2 semanas.
- **Velocidad estimada (solo dev):** ~20 SP por sprint (capacidad realista de una persona considerando que el "Scrum Master" también desarrolla).
- **Total del MVP:** 61 SP → 3 sprints.

> **Nota sobre la simulación de 5 personas:** los eventos Scrum (planning, daily, review, retro) se mantienen como práctica, pero las ceremonias se comprimen (daily = nota personal de avance/bloqueos). La asignación "por developer" se documenta para fines didácticos; en la práctica el flujo es secuencial para evitar dependencias bloqueantes en un equipo de uno.

---

## 🟦 Sprint 1 — Fundaciones + Autenticación

**Sprint Goal:** disponer de una SPA navegable y responsive donde los usuarios inician sesión y acceden según su rol.

**Capacidad estimada:** 21 SP

| ID | Historia | SP | "Dev" sugerido |
|----|----------|:--:|----------------|
| CORE-01 | Setup SPA modular | 5 | Dev A |
| CORE-02 | Layout y navegación responsive | 5 | Dev B |
| AUTH-01 | Inicio de sesión | 3 | Dev C |
| AUTH-02 | Sesión y rutas protegidas | 5 | Dev D |
| AUTH-03 | Gestión de roles / autorización | 3 | SM/Dev |

**Sprint Backlog (tareas clave):** inicializar Vite + estructura; router cliente; store y cliente HTTP; shell responsive; vista login; manejo de JWT en `localStorage`; guards de ruta; navegación por rol; configurar json-server con usuarios mock.

**Justificación:** sin la SPA base (CORE) y la identidad/rol (AUTH) no puede construirse ninguna funcionalidad de valor. Se agrupan porque toda evaluación, historial y dashboard dependen de saber **quién** es el usuario y **qué** puede hacer. Es el sprint habilitador.

---

## 🟩 Sprint 2 — Núcleo de Evaluaciones

**Sprint Goal:** un Coder puede evaluar a Team Leaders y Tutores (incluyendo modo anónimo) y la evaluación queda registrada en la API.

**Capacidad estimada:** 18 SP

| ID | Historia | SP | "Dev" sugerido |
|----|----------|:--:|----------------|
| EVAL-01 | Listar evaluables | 3 | Dev A |
| EVAL-02 | Evaluar Team Leader | 5 | Dev B |
| EVAL-03 | Evaluar Tutor | 3 | Dev C |
| EVAL-04 | Feedback anónimo opcional | 2 | Dev D |
| EVAL-05 | Registrar evaluación (API) | 5 | SM/Dev |

**Sprint Backlog (tareas clave):** servicio de evaluables; motor de formularios reutilizable (criterios + escala + comentarios); plantillas TL y Tutor; validación de formulario; toggle anónimo; persistencia `POST` con estados borrador/enviada; manejo de errores y reintento.

**Justificación:** es el **corazón del MVP** y la hipótesis a validar (feedback ascendente estructurado). Se concentra en un solo sprint para entregar valor end-to-end. EVAL-03 reutiliza el motor de EVAL-02, por eso su costo es menor. EVAL-04/05 dependen del formulario, de ahí el orden.

---

## 🟨 Sprint 3 — Trazabilidad, Métricas y Reportes

**Sprint Goal:** los Coders consultan su historial y los Coordinadores visualizan resultados, métricas, tendencias y exportan reportes.

**Capacidad estimada:** 19 SP comprometidos + 3 SP stretch

| ID | Historia | SP | "Dev" sugerido |
|----|----------|:--:|----------------|
| HIST-01 | Historial del Coder | 3 | Dev A |
| HIST-02 | Seguimiento histórico | 3 | Dev B |
| DASH-01 | Dashboard de resultados | 5 | Dev C |
| DASH-02 | Métricas e indicadores | 5 | Dev D |
| DASH-03 | Visualización de tendencias | 3 | SM/Dev |
| DASH-04 | Reportes básicos (export) | 3 | Stretch |

**Sprint Backlog (tareas clave):** historial propio y detalle; histórico filtrable con anonimato preservado; dashboard agregado; KPIs por criterio y participación; gráfico de tendencias con tabla alternativa accesible; exportación CSV / vista imprimible (stretch).

**Justificación:** una vez existen datos (Sprint 2), este sprint los convierte en información accionable, cerrando el ciclo de valor del producto. DASH-04 se marca como *stretch* porque es `Could` (MoSCoW) y no es crítico para validar la hipótesis; si la capacidad se reduce, es lo primero en salir.

---

## Resumen

| Sprint | Goal | SP | Épicas |
|--------|------|:--:|--------|
| 1 | SPA base + login + roles | 21 | CORE, AUTH |
| 2 | Evaluaciones end-to-end | 18 | EVAL |
| 3 | Historial + dashboard + reportes | 19 (+3) | HIST, DASH |

## Gestión de riesgos del plan

| Riesgo | Mitigación |
|--------|------------|
| Desarrollador único → cuello de botella | Alcance MVP estricto; `Could` como stretch sacrificable |
| API real no disponible | Desarrollo contra json-server con contrato REST estable |
| Sobreingeniería | Sin frameworks; módulos simples; reutilizar motor de formularios |
| Subestimación de SP | Buffer en Sprint 3 y backlog ordenado por prioridad MoSCoW |
