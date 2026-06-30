# 09 — Alcance del MVP

Filosofia: **startup validando una idea**. El MVP debe ser lo minimo para comprobar que el feedback ascendente estructurado (con ICA e IA) aporta valor. Todo lo que no sirva a esa validacion se pospone.

## Dentro del MVP (obligatorio)

| Funcionalidad | Por que es obligatoria |
|---------------|------------------------|
| **Backend FastAPI + MySQL** funcional | Requisito de la rubrica: integracion front + back + persistencia |
| **Logica de negocio** (anonimato, no-duplicado, **ICA**, RBAC) | Requisito: no limitarse a CRUD basico |
| Inicio de sesion (con JWT) | Sin identidad no hay feedback atribuible ni roles |
| Gestion de roles (Coder, Tutor, TL, Admin) | Define que ve y hace cada usuario |
| Listar Team Leaders y Tutores evaluables | Punto de entrada de la accion principal |
| Evaluar Team Leader (formulario estructurado) | Nucleo de la hipotesis del producto |
| Evaluar Tutor (formulario estructurado) | Completa el alcance del feedback ascendente |
| Feedback anonimo opcional | Clave para obtener feedback honesto (confianza) |
| Registro/persistencia de evaluaciones (API) | Sin datos no hay validacion ni metricas |
| Historial de evaluaciones (Coder) | Trazabilidad minima para el evaluador |
| Dashboard de resultados (Admin) | Convierte datos en decision; razon de negocio |
| **ICA** e indicadores | Mide calidad del acompanamiento con un indice accionable |
| **Resumen de feedback con IA** (Claude) para el Admin | Diferenciador; sintesis accionable y anonimizada |
| SPA responsive y navegable | Restriccion tecnica + usabilidad basica |
| Despliegue accesible (front + back) | Requisito: app funcional disponible para la sustentacion |

**Seguimiento historico (admin)** se incluye como `Should`: aporta a la validacion pero puede recortarse si la capacidad aprieta.

## Fuera del MVP (versiones futuras)

| Funcionalidad | Cuando / por que se pospone |
|---------------|------------------------------|
| Areas / segmentacion multi-area | Simplifica el MVP; la segmentacion se agrega post-validacion |
| Bitacora TL->Tutor (evaluacion descendente) | Excede el feedback ascendente; se agrega como v2 |
| Analitica de talento (ranking de futuros TL) | Requiere volumen de datos y bitacora; post-validacion |
| Pesos del ICA configurables por Admin | Los defaults son suficientes para el piloto |
| Mejoras por IA para el evaluado (TL/Tutor) | El MVP entrega IA solo al Admin; el evaluado ve resultados sin IA |
| Visualizacion de tendencias (graficos temporales) | CSV/tabla basica como `Could`; graficos avanzados son futuro |
| Reportes avanzados / exportacion PDF estilizada | CSV/impresion basica como `Could`; lo demas es futuro |
| CRUD de formularios y criterios desde la UI | Las plantillas se siembran en BD; editor visual es v2 |
| Notificaciones (email/in-app) y recordatorios | No esencial para validar la hipotesis |
| Gestion de usuarios/altas desde la UI (admin) | Se cargan via seed/BD en el MVP |
| Comparativas avanzadas, benchmarking entre cohortes | Requiere volumen de datos; post-validacion |
| Despliegue en contenedores (Docker) y multi-sede | Se aborda en un plan/iteracion aparte |
| Internacionalizacion (i18n) | El piloto es en espanol |
| Auditoria detallada / logs de actividad | Mas alla de la trazabilidad basica de evaluaciones |
| Roles y permisos granulares (mas alla de los 4) | Los 4 roles cubren el piloto |
| App movil nativa / PWA offline | La SPA responsive es suficiente para validar |

## Criterio de exito del MVP

El MVP se considera validado si, durante el piloto, se alcanzan las **metricas de exito** definidas en [`01-vision-y-producto.md`](./01-vision-y-producto.md) (adopcion >=60%, completitud >=80%, y al menos un admin usando el dashboard semanalmente), confirmando que el feedback ascendente genera informacion accionable.
