# 04 — Épicas

Las historias se organizan en 5 épicas. `CORE` es transversal (habilitadora); las demás representan valor de negocio.

---

## ÉPICA CORE — Plataforma SPA base
**Objetivo:** disponer de una SPA modular, navegable y responsive sobre la cual construir el resto.
**Valor:** habilitador técnico; sin esto no hay producto.
**Historias:** CORE-01, CORE-02
**Criterio de done de la épica:** la app arranca, navega entre vistas sin recargar y se ve correctamente en móvil y escritorio.

---

## ÉPICA AUTH — Autenticación y gestión de roles
**Objetivo:** que cada usuario inicie sesión y acceda solo a lo que su rol permite.
**Valor:** seguridad y segmentación de la experiencia por rol.
**Historias:** AUTH-01, AUTH-02, AUTH-03
**Criterio de done:** un usuario se autentica, su sesión persiste y las rutas/acciones se restringen según rol.

---

## ÉPICA EVAL — Evaluaciones
**Objetivo:** permitir a los Coders evaluar Team Leaders y Tutores, con opción anónima, y persistir el resultado.
**Valor:** **núcleo del producto** — es la razón de ser del MVP.
**Historias:** EVAL-01, EVAL-02, EVAL-03, EVAL-04, EVAL-05
**Criterio de done:** un Coder selecciona a quién evaluar, completa el formulario (anónimo o no) y la evaluación queda registrada vía API.

---

## ÉPICA HIST — Historial y trazabilidad
**Objetivo:** consultar evaluaciones pasadas y su evolución.
**Valor:** trazabilidad y seguimiento histórico.
**Historias:** HIST-01, HIST-02
**Criterio de done:** Coders ven su historial; coordinadores consultan el histórico por líder/tutor.

---

## ÉPICA DASH — Dashboard, métricas y reportes
**Objetivo:** transformar las evaluaciones en información accionable.
**Valor:** soporte a la toma de decisiones académicas.
**Historias:** DASH-01, DASH-02, DASH-03, DASH-04
**Criterio de done:** el coordinador visualiza resultados agregados, indicadores, tendencias y puede exportar un reporte básico.

---

## Mapa épica → sprint

| Épica | Sprint 1 | Sprint 2 | Sprint 3 |
|-------|:--------:|:--------:|:--------:|
| CORE  | ✅ | | |
| AUTH  | ✅ | | |
| EVAL  | | ✅ | |
| HIST  | | | ✅ |
| DASH  | | | ✅ |
