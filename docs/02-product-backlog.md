# 02 — Product Backlog

Backlog priorizado del MVP. Estimación en **Story Points (SP)** con escala Fibonacci (1, 2, 3, 5, 8). Prioridad **MoSCoW** (Must / Should / Could) ordenada por valor y dependencia.

| ID | Nombre | Descripción | Épica | Prioridad | SP | Dependencias |
|----|--------|-------------|-------|-----------|:--:|--------------|
| CORE-01 | Setup SPA modular | Inicializar proyecto, router cliente, estructura de carpetas, store y servicio HTTP base | CORE | Must | 5 | — |
| CORE-02 | Layout y navegación responsive | Shell de la app: header/nav por rol, contenedor de vistas, estilos base mobile-first | CORE | Must | 5 | CORE-01 |
| AUTH-01 | Inicio de sesión | Formulario de login con validación y feedback de error | AUTH | Must | 3 | CORE-02 |
| AUTH-02 | Sesión y rutas protegidas | Persistir token (JWT) en `localStorage`, guard de rutas, logout, expiración | AUTH | Must | 5 | AUTH-01 |
| AUTH-03 | Gestión de roles / autorización | Mostrar u ocultar vistas y acciones según rol del usuario | AUTH | Must | 3 | AUTH-02 |
| EVAL-01 | Listar evaluables | Coder ve la lista de Team Leaders y Tutores que puede evaluar | EVAL | Must | 3 | AUTH-03 |
| EVAL-02 | Evaluar Team Leader | Formulario estructurado (criterios + escala + comentarios) para Team Leader | EVAL | Must | 5 | EVAL-01 |
| EVAL-03 | Evaluar Tutor | Formulario estructurado para Tutor (reutiliza el motor de formularios) | EVAL | Must | 3 | EVAL-02 |
| EVAL-04 | Feedback anónimo opcional | Toggle que envía la evaluación sin asociar la identidad del evaluador | EVAL | Should | 2 | EVAL-02 |
| EVAL-05 | Registrar evaluación (API) | Validar y persistir la evaluación contra la API REST; estado borrador/enviada | EVAL | Must | 5 | EVAL-02 |
| HIST-01 | Historial del Coder | El Coder consulta las evaluaciones que ha enviado | HIST | Should | 3 | EVAL-05 |
| HIST-02 | Seguimiento histórico | El Coordinador consulta el histórico de evaluaciones por líder/tutor y periodo | HIST | Should | 3 | EVAL-05 |
| DASH-01 | Dashboard de resultados | Panel del Coordinador con resultados agregados por líder/tutor | DASH | Must | 5 | EVAL-05 |
| DASH-02 | Métricas e indicadores | KPIs: promedio por criterio, nº de evaluaciones, % participación | DASH | Should | 5 | DASH-01 |
| DASH-03 | Visualización de tendencias | Evolución temporal de calificaciones (gráfico de líneas/barras) | DASH | Should | 3 | DASH-02 |
| DASH-04 | Reportes básicos (export) | Exportar resultados a CSV/impresión | DASH | Could | 3 | DASH-01 |

**Total backlog MVP:** 61 SP.

## Orden de refinamiento

1. **Habilitadores (CORE):** sin la SPA base no se construye nada.
2. **AUTH:** todo el producto depende de identidad y rol.
3. **EVAL:** núcleo de valor; es lo que valida la hipótesis del producto.
4. **HIST + DASH:** convierten los datos en información accionable.

## Definition of Ready (DoR)

Una historia entra a un sprint cuando:
- Tiene descripción, criterios de aceptación y SP.
- Sus dependencias están resueltas o planificadas en el mismo sprint.
- Su contrato de API (si aplica) está definido en [`06-arquitectura.md`](./06-arquitectura.md).

## Definition of Done (DoD)

Una historia está terminada cuando:
- Cumple **todos** sus criterios de aceptación.
- Es responsive (móvil + escritorio) y accesible (navegación por teclado, labels).
- El código sigue las convenciones de [`08-diseno-tecnico.md`](./08-diseno-tecnico.md).
- Se probó manualmente contra la API mock; sin errores en consola.
- Está mergeada a `develop` vía Pull Request.
