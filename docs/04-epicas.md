# 04 — Épicas

Las historias se organizan en 5 épicas. `CORE` es transversal (habilitadora); las demás representan valor de negocio. Todas son **full-stack** (frontend SPA + backend FastAPI + MySQL).

---

## ÉPICA CORE — Plataforma full-stack base
**Objetivo:** disponer del andamiaje del monorepo: SPA modular navegable + API FastAPI conectada a MySQL.
**Valor:** habilitador técnico; sin esto no hay producto.
**Historias:** CORE-01, CORE-02, CORE-03
**Done:** la SPA arranca y navega sin recargar; el backend responde y consulta MySQL con datos seed; UI responsive.

---

## ÉPICA AUTH — Autenticación y gestión de roles
**Objetivo:** login con JWT y autorización por rol en cliente y servidor.
**Valor:** seguridad y segmentación de la experiencia.
**Historias:** AUTH-01, AUTH-02, AUTH-03
**Done:** un usuario se autentica, su sesión persiste, y rutas/acciones se restringen por rol (RBAC verificado en backend).

---

## ÉPICA EVAL — Evaluaciones
**Objetivo:** que los Coders evalúen Team Leaders y Tutores (con opción anónima) y se persista con sus reglas de negocio.
**Valor:** **núcleo del producto** — la hipótesis del MVP.
**Historias:** EVAL-01, EVAL-02, EVAL-03, EVAL-04, EVAL-05
**Done:** un Coder selecciona a quién evaluar, completa el formulario (anónimo o no) y la evaluación queda registrada vía API con validación, anonimato real y no-duplicado por periodo.

---

## ÉPICA HIST — Historial y trazabilidad
**Objetivo:** consultar evaluaciones pasadas y su evolución.
**Valor:** trazabilidad y seguimiento histórico.
**Historias:** HIST-01, HIST-02
**Done:** Coders ven su historial; coordinadores consultan el histórico por líder/tutor y periodo, respetando el anonimato.

---

## ÉPICA DASH — Dashboard, métricas y reportes
**Objetivo:** transformar las evaluaciones en información accionable mediante **agregaciones** (lógica de negocio).
**Valor:** soporte a la toma de decisiones académicas.
**Historias:** DASH-01, DASH-02, DASH-03, DASH-04
**Done:** el coordinador visualiza resultados agregados, indicadores, tendencias y puede exportar un reporte básico.

---

## Mapa épica → sprint (cronograma de 5 semanas)

| Épica | Sprint 0 (Sem. 1) | Sprint 1 (Sem. 2–3) | Sprint 2 (Sem. 4–5) |
|-------|:-----------------:|:-------------------:|:-------------------:|
| CORE  | ✅ (CORE-01/02) | ✅ (CORE-03) | |
| AUTH  | | ✅ | |
| EVAL  | | ✅ | |
| HIST  | | | ✅ |
| DASH  | | | ✅ |
