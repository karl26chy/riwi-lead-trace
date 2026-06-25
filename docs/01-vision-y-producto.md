# 01 — Visión y Producto

## Product Vision

> **Para** el ecosistema Riwi **que** no cuenta con un canal formal y multidimensional para evaluar la calidad del acompañamiento, **Riwi LeadTrace es** una plataforma web de **evaluación 360° multi-área** (Desarrollo, Inglés, HSE, BLS) **que** permite a los Coders evaluar —de forma estructurada y opcionalmente anónima— a Team Leaders y Tutores, y a los Team Leaders llevar una **bitácora continua** de sus Tutores, **a diferencia de** los procesos informales o unidireccionales actuales, **nuestro producto** calcula un **Índice de Calidad de Acompañamiento (ICA)** por área, una **analítica de talento** (quién está listo para ser TL) y **resúmenes con IA** que impulsan decisiones del Admin (Jefe de TL/tutores).

## Product Goal

Validar, mediante un MVP funcional, que un proceso de **feedback bidireccional estructurado** mejora la visibilidad sobre la calidad del acompañamiento de Team Leaders y Tutores, entregando a los responsables académicos información accionable para la toma de decisiones.

## Objetivos de negocio

1. **Generar feedback 360°** formal: Coders → TL/Tutores, y TL → Tutores (bitácora continua).
2. **Mejorar la calidad del acompañamiento** por **área** (Desarrollo/Inglés/HSE/BLS), con el **ICA**.
3. **Crear trazabilidad y métricas** de seguimiento histórico por líder, tutor, área y periodo.
4. **Habilitar decisiones basadas en datos** para el Admin (Jefe de TL/tutores), apoyadas en **IA**.
5. **Detectar talento**: identificar tutores/coders con alta probabilidad de ser contratados como TL.
6. **Fomentar la mejora continua** dentro del ecosistema de aprendizaje de Riwi.

## Métricas de éxito del MVP

| Métrica | Indicador | Meta MVP |
|--------|-----------|----------|
| Adopción | % de Coders que completan al menos una evaluación | ≥ 60 % |
| Cobertura | % de Team Leaders/Tutores con al menos 3 evaluaciones | ≥ 70 % |
| Completitud | % de evaluaciones iniciadas que se envían | ≥ 80 % |
| Calidad del dato | % de evaluaciones con comentario cualitativo | ≥ 40 % |
| Calidad accionable | % de TL/Tutores con **ICA** calculado (datos suficientes) por área | ≥ 70 % |
| Uso analítico | Nº de admins (Jefe de TL) que consultan el dashboard semanalmente | ≥ 1 por programa |
| Confianza | % de evaluaciones enviadas usando la opción anónima (señal de seguridad percibida) | medición base |
| Satisfacción | NPS interno del proceso de feedback | establecer línea base |

> Las métricas se miden sobre los datos registrados por la propia plataforma (dashboard) más una encuesta breve post-MVP.

## Propuesta de valor

- **Para el Coder:** voz formal y segura sobre su experiencia de acompañamiento.
- **Para el Team Leader:** feedback concreto para crecer + herramienta para acompañar a sus Tutores.
- **Para el Tutor:** feedback para mejorar y un camino visible hacia ser TL (analítica de talento).
- **Para el Admin (Jefe de TL/tutores):** panel con **ICA** por área, tendencias, **resúmenes IA** y ranking de talento para decidir.
- **Para Riwi:** mejora medible y continua de la calidad académica y mejor pipeline de talento.

## Supuestos y restricciones

- Lo desarrolla un **equipo de 5 Coders** bajo Scrum (Proyecto Integrador, Ruta Básica) → priorizar simplicidad, paralelización y evidencia de contribución individual.
- Aplicación **full-stack**: SPA en **HTML5 + CSS3 + JS Vanilla** + backend **FastAPI** + **MySQL** (3FN).
- Debe incluir **lógica de negocio** identificable (no limitarse a CRUD básico).
- Alcance **MVP**: validar la idea con una solución funcional, estable y con valor para el usuario.
- Cronograma de **5 semanas** con metodología Scrum y **GitFlow** obligatorios.
