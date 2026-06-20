# 09 — Alcance del MVP

Filosofía: **startup validando una idea**. El MVP debe ser lo mínimo para comprobar que el feedback ascendente estructurado aporta valor. Todo lo que no sirva a esa validación se pospone.

## ✅ Dentro del MVP (obligatorio)

| Funcionalidad | Por qué es obligatoria |
|---------------|------------------------|
| Inicio de sesión | Sin identidad no hay feedback atribuible ni roles |
| Gestión de roles (Coder, TL, Tutor, Coordinador) | Define qué ve y hace cada usuario |
| Listar Team Leaders y Tutores evaluables | Punto de entrada de la acción principal |
| Evaluar Team Leader (formulario estructurado) | Núcleo de la hipótesis del producto |
| Evaluar Tutor (formulario estructurado) | Completa el alcance del feedback ascendente |
| Feedback anónimo opcional | Clave para obtener feedback honesto (confianza) |
| Registro/persistencia de evaluaciones (API) | Sin datos no hay validación ni métricas |
| Historial de evaluaciones (Coder) | Trazabilidad mínima para el evaluador |
| Dashboard de resultados (Coordinador) | Convierte datos en decisión; razón de negocio |
| Métricas e indicadores básicos | Mide calidad del acompañamiento |
| SPA responsive y navegable | Restricción técnica + usabilidad básica |

**Visualización de tendencias** y **seguimiento histórico (coordinador)** se incluyen como `Should`: aportan a la validación pero pueden recortarse si la capacidad aprieta.

## 🚫 Fuera del MVP (versiones futuras)

| Funcionalidad | Cuándo / por qué se pospone |
|---------------|------------------------------|
| Backend/API propios en producción | El MVP valida la UX/proceso; en dev se usa API mock |
| CRUD de formularios y criterios desde la UI | Las plantillas se siembran en BD; editor visual es v2 |
| Reportes avanzados / exportación PDF estilizada | CSV/impresión básica como `Could`; lo demás es futuro |
| Notificaciones (email/in-app) y recordatorios | No esencial para validar la hipótesis |
| Gestión de usuarios/altas desde la UI (admin) | Se cargan vía seed/BD en el MVP |
| Comparativas avanzadas, benchmarking, IA/insights | Requiere volumen de datos; post-validación |
| Internacionalización (i18n) | El piloto es en español |
| Auditoría detallada / logs de actividad | Más allá de la trazabilidad básica de evaluaciones |
| Roles y permisos granulares (más allá de los 4) | Los 4 roles cubren el piloto |
| App móvil nativa / PWA offline | La SPA responsive es suficiente para validar |

## Criterio de éxito del MVP

El MVP se considera validado si, durante el piloto, se alcanzan las **métricas de éxito** definidas en [`01-vision-y-producto.md`](./01-vision-y-producto.md) (adopción ≥60%, completitud ≥80%, y al menos un coordinador usando el dashboard semanalmente), confirmando que el feedback ascendente estructurado genera información accionable.
