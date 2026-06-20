# 03 — Historias de Usuario

Formato: **Como** [rol] / **Quiero** [funcionalidad] / **Para** [beneficio].
Cada historia incluye criterios de aceptación (CA), prioridad y Story Points.

---

## ÉPICA CORE

### CORE-01 — Setup repo + scaffold SPA · `Must` · `5 SP`
**Como** developer **quiero** una base de proyecto SPA modular con router, store y cliente HTTP **para** construir las funcionalidades de forma ordenada y rápida.

**Criterios de aceptación**
- [ ] Monorepo con `frontend/` y `backend/` según [`06-arquitectura.md`](./06-arquitectura.md).
- [ ] El frontend arranca con `npm run dev` y muestra una vista inicial.
- [ ] Existe un router cliente que cambia de vista sin recargar la página.
- [ ] Hay un módulo `store` (estado) y un módulo `http` (fetch) reutilizables.

### CORE-02 — Scaffold backend (FastAPI) + BD · `Must` · `5 SP`
**Como** developer **quiero** un backend FastAPI por capas conectado a MySQL **para** exponer la API REST que consumirá la SPA.

**Criterios de aceptación**
- [ ] `uvicorn app.main:app --reload` levanta la API y expone `/docs` (Swagger).
- [ ] Estructura por capas: `routers/`, `services/`, `repositories/`, `models/`, `schemas/`, `deps.py`.
- [ ] Conexión a MySQL configurable por `.env`; la BD se crea con `database/schema.sql` (seed incluido).
- [ ] Endpoint de salud (`GET /health`) responde `200`.
- [ ] CORS habilitado para el origen del frontend.

### CORE-03 — Layout y navegación responsive · `Must` · `5 SP`
**Como** usuario **quiero** una interfaz con navegación clara y adaptable **para** usar la plataforma cómodamente desde móvil o escritorio.

**Criterios de aceptación**
- [ ] Header con navegación que cambia según el rol autenticado.
- [ ] Layout mobile-first; se adapta a ≥320px, tablet y escritorio.
- [ ] La vista activa se resalta en la navegación.
- [ ] Estados de carga y vacío con un componente común.

---

## ÉPICA AUTH

### AUTH-01 — Inicio de sesión · `Must` · `3 SP`
**Como** usuario registrado **quiero** iniciar sesión con mis credenciales **para** acceder a la plataforma de forma segura.

**Criterios de aceptación**
- [ ] Formulario con email y contraseña validados en cliente.
- [ ] `POST /auth/login` verifica la contraseña con **hash** (passlib/bcrypt) y emite un **JWT**.
- [ ] Mensaje de error claro ante credenciales inválidas (`401`).
- [ ] Al autenticar, se redirige a la vista inicial según el rol.
- [ ] Botón deshabilitado y feedback de carga durante la petición.

### AUTH-02 — Sesión y rutas protegidas · `Must` · `5 SP`
**Como** usuario autenticado **quiero** mantener mi sesión y que las rutas privadas estén protegidas **para** no tener que reingresar y proteger mi información.

**Criterios de aceptación**
- [ ] El token (JWT) se persiste en `localStorage` y se envía en cada petición.
- [ ] El backend valida el token (`get_current_user`) y rechaza peticiones sin token o expirado (`401`).
- [ ] Acceder a una ruta privada sin sesión redirige a login.
- [ ] Existe acción de logout que limpia la sesión.
- [ ] Si el token expira (401), se cierra sesión y se redirige a login.

### AUTH-03 — Gestión de roles / autorización · `Must` · `3 SP`
**Como** sistema **quiero** mostrar funcionalidades según el rol **para** que cada usuario vea solo lo que le corresponde.

**Criterios de aceptación**
- [ ] El Coder ve evaluaciones e historial propio; no ve el dashboard de coordinación.
- [ ] El Coordinador ve dashboard, métricas e histórico.
- [ ] Las rutas no autorizadas redirigen o muestran "no autorizado" (front).
- [ ] El backend aplica `require_role` y responde `403` ante accesos no autorizados (autoridad real).
- [ ] La navegación se construye dinámicamente según los permisos del rol.

---

## ÉPICA EVAL

### EVAL-01 — Listar evaluables · `Must` · `3 SP`
**Como** Coder **quiero** ver la lista de Team Leaders y Tutores que puedo evaluar **para** elegir a quién dar feedback.

**Criterios de aceptación**
- [ ] Lista obtenida desde la API, separada/filtrable por tipo (Team Leader / Tutor).
- [ ] Indica si ya evalué a esa persona en el periodo actual.
- [ ] Estado vacío si no hay evaluables asignados.

### EVAL-02 — Evaluar Team Leader · `Must` · `5 SP`
**Como** Coder **quiero** completar un formulario estructurado para evaluar a un Team Leader **para** retroalimentar su acompañamiento.

**Criterios de aceptación**
- [ ] Formulario con criterios por categoría y escala (p.ej. 1–5) + comentario opcional.
- [ ] Validación: no se envía incompleto; muestra errores por campo.
- [ ] Se puede guardar como borrador y retomar.
- [ ] Confirmación visual al enviar.

### EVAL-03 — Evaluar Tutor · `Must` · `3 SP`
**Como** Coder **quiero** evaluar a un Tutor con un formulario estructurado **para** retroalimentar su apoyo técnico.

**Criterios de aceptación**
- [ ] Reutiliza el motor de formularios de EVAL-02 con la plantilla de Tutor.
- [ ] Criterios propios del rol Tutor cargados desde la API.
- [ ] Mismas reglas de validación y confirmación.

### EVAL-04 — Feedback anónimo opcional · `Should` · `2 SP`
**Como** Coder **quiero** poder enviar mi evaluación de forma anónima **para** dar feedback honesto sin temor.

**Criterios de aceptación**
- [ ] Toggle "Enviar de forma anónima" visible antes de enviar.
- [ ] Si está activo, la evaluación se registra sin asociar la identidad del evaluador.
- [ ] El sistema informa que el anonimato es irreversible una vez enviado.

### EVAL-05 — Registrar evaluación (API) · `Must` · `5 SP`
**Como** Coder **quiero** que mi evaluación se guarde de forma confiable **para** que cuente en las métricas.

**Criterios de aceptación**
- [ ] La evaluación se persiste vía `POST /evaluations` con validación Pydantic en servidor.
- [ ] Maneja estados: borrador y enviada.
- [ ] **Regla de negocio:** rechaza (`409`) una segunda evaluación del mismo evaluado en el mismo periodo.
- [ ] Manejo de errores de red con reintento y mensaje claro.
- [ ] Tras enviar, la persona evaluada aparece como "ya evaluada".

---

## ÉPICA HIST

### HIST-01 — Historial del Coder · `Should` · `3 SP`
**Como** Coder **quiero** consultar las evaluaciones que he enviado **para** llevar registro de mi participación.

**Criterios de aceptación**
- [ ] Lista de evaluaciones propias con fecha, evaluado y estado.
- [ ] Detalle de cada evaluación enviada (no editable).
- [ ] Las anónimas se muestran al propio autor pero marcadas como anónimas.

### HIST-02 — Seguimiento histórico · `Should` · `3 SP`
**Como** Coordinador **quiero** consultar el histórico de evaluaciones por líder/tutor y periodo **para** dar seguimiento a su evolución.

**Criterios de aceptación**
- [ ] Filtros por persona evaluada, rol y periodo.
- [ ] Vista agregada que respeta el anonimato (sin exponer evaluadores anónimos).
- [ ] Estado vacío y de carga.

---

## ÉPICA DASH

### DASH-01 — Dashboard de resultados · `Must` · `5 SP`
**Como** Coordinador **quiero** un panel con resultados agregados **para** entender rápidamente la calidad del acompañamiento.

**Criterios de aceptación**
- [ ] Tarjetas resumen: nº de evaluaciones, promedio general, participación.
- [ ] Ranking/listado de líderes y tutores con su promedio.
- [ ] Filtro por periodo.

### DASH-02 — Métricas e indicadores · `Should` · `5 SP`
**Como** Coordinador **quiero** ver indicadores por criterio **para** identificar fortalezas y debilidades.

**Criterios de aceptación**
- [ ] Promedio por categoría/criterio para una persona seleccionada.
- [ ] Indicador de participación (% de Coders que evaluaron).
- [ ] Distinción clara entre datos suficientes e insuficientes (n bajo).

### DASH-03 — Visualización de tendencias · `Should` · `3 SP`
**Como** Coordinador **quiero** ver la evolución temporal de las calificaciones **para** detectar mejoras o deterioros.

**Criterios de aceptación**
- [ ] Gráfico de tendencia por persona y/o criterio a lo largo de periodos.
- [ ] Renderizado accesible (con tabla alternativa de datos).

### DASH-04 — Reportes básicos (export) · `Could` · `3 SP`
**Como** Coordinador **quiero** exportar los resultados **para** compartirlos fuera de la plataforma.

**Criterios de aceptación**
- [ ] Exportar a CSV los resultados agregados visibles.
- [ ] Vista imprimible del dashboard.
