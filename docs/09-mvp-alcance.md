# 09 — Alcance del MVP

Filosofía: **startup validando una idea**. El MVP debe ser lo mínimo para comprobar que la evaluación 360° multi-área (con ICA, IA y talento) aporta valor. Todo lo que no sirva a esa validación se pospone.

## ✅ Dentro del MVP (obligatorio)

| Funcionalidad | Por qué es obligatoria |
|---------------|------------------------|
| **Backend FastAPI + MySQL** funcional | Requisito de la rúbrica: integración front + back + persistencia |
| **Lógica de negocio** (anonimato, no-duplicado, **ICA**, **talento**, RBAC) | Requisito: no limitarse a CRUD básico |
| Inicio de sesión (con JWT) | Sin identidad no hay feedback atribuible ni roles |
| Gestión de roles (Coder, Tutor, TL, Admin) | Define qué ve y hace cada usuario |
| **Áreas** (Desarrollo, Inglés, HSE, BLS) | Dimensión transversal: todo se mide por área |
| Listar Team Leaders y Tutores evaluables (por área) | Punto de entrada de la acción principal |
| Evaluar Team Leader (formulario estructurado) | Núcleo de la hipótesis del producto |
| Evaluar Tutor (formulario estructurado) | Completa el alcance del feedback de los Coders |
| **Bitácora continua TL → Tutor** (visible solo al TL) | Historial de desempeño del tutor por tutoría |
| Feedback anónimo opcional | Clave para obtener feedback honesto (confianza) |
| Registro/persistencia de evaluaciones (API) | Sin datos no hay validación ni métricas |
| Historial de evaluaciones (Coder) | Trazabilidad mínima para el evaluador |
| Dashboard de resultados (Admin) | Convierte datos en decisión; razón de negocio |
| **ICA** e indicadores por área | Mide calidad del acompañamiento con un índice accionable |
| **Resumen de feedback con IA** (Claude) para el Admin | Diferenciador; síntesis accionable y anonimizada |
| **Analítica de talento** (ranking de futuros TL) | Detecta a quién contratar/promover |
| SPA responsive y navegable | Restricción técnica + usabilidad básica |
| Despliegue accesible (front + back) | Requisito: app funcional disponible para la sustentación |

**Visualización de tendencias** y **seguimiento histórico (admin)** se incluyen como `Should`: aportan a la validación pero pueden recortarse si la capacidad aprieta.

## 🚫 Fuera del MVP (versiones futuras)

| Funcionalidad | Cuándo / por qué se pospone |
|---------------|------------------------------|
| CRUD de formularios y criterios desde la UI | Las plantillas se siembran en BD; editor visual es v2 |
| Reportes avanzados / exportación PDF estilizada | CSV/impresión básica como `Could`; lo demás es futuro |
| Notificaciones (email/in-app) y recordatorios | No esencial para validar la hipótesis |
| Gestión de usuarios/altas desde la UI (admin) | Se cargan vía seed/BD en el MVP |
| Comparativas avanzadas, benchmarking entre cohortes | Requiere volumen de datos; post-validación |
| Despliegue en contenedores (Docker) y **multi-sede** | Se aborda en un plan/iteración aparte |
| Internacionalización (i18n) | El piloto es en español |
| Auditoría detallada / logs de actividad | Más allá de la trazabilidad básica de evaluaciones |
| Roles y permisos granulares (más allá de los 4) | Los 4 roles cubren el piloto |
| App móvil nativa / PWA offline | La SPA responsive es suficiente para validar |

## Criterio de éxito del MVP

El MVP se considera validado si, durante el piloto, se alcanzan las **métricas de éxito** definidas en [`01-vision-y-producto.md`](./01-vision-y-producto.md) (adopción ≥60%, completitud ≥80%, y al menos un admin usando el dashboard semanalmente), confirmando que la evaluación 360° multi-área genera información accionable.
