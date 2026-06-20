# Riwi LeadTrace

> MVP de **feedback ascendente**: una SPA que permite a los Coders evaluar a Team Leaders y Tutores mediante formularios estructurados, generando trazabilidad sobre la calidad del acompañamiento académico en Riwi.

## 📌 ¿Qué es?

Hoy los Team Leaders evalúan a los Coders, pero **no existe un mecanismo formal para que los Coders evalúen a sus líderes y tutores**. Riwi LeadTrace cierra ese ciclo: habilita feedback bidireccional, identifica fortalezas y debilidades del acompañamiento, y entrega métricas para la toma de decisiones de los responsables académicos.

## 🧱 Stack técnico

| Capa | Tecnología | Justificación |
|------|------------|---------------|
| Estructura | HTML5 semántico | Restricción del proyecto + accesibilidad |
| Estilos | CSS3 (Custom Properties, mobile-first) | Sin dependencias, responsive nativo |
| Lógica | JavaScript Vanilla (ES Modules) | Restricción explícita: sin React/Angular/Vue |
| Arquitectura | SPA modular con router propio | Navegación sin recarga, alcance MVP |
| Tooling (dev) | Vite | Solo dev server + bundler; no es un framework |
| API mock (dev) | json-server | Permite desarrollar el frontend antes del backend real |
| Persistencia | API REST (preparada) + `localStorage` para sesión | Desacople frontend/backend |

> ⚠️ Vite y json-server son **herramientas de desarrollo**, no frameworks de UI. La aplicación que se entrega es HTML5 + CSS3 + JS Vanilla.

## 📚 Documentación

Toda la planeación Scrum y el diseño técnico viven en [`/docs`](./docs):

| Documento | Contenido |
|-----------|-----------|
| [01 — Visión y Producto](./docs/01-vision-y-producto.md) | Product Vision, Goal, objetivos de negocio, métricas de éxito |
| [02 — Product Backlog](./docs/02-product-backlog.md) | Backlog completo priorizado con SP y dependencias |
| [03 — Historias de Usuario](./docs/03-historias-de-usuario.md) | Historias con criterios de aceptación |
| [04 — Épicas](./docs/04-epicas.md) | Agrupación de historias en épicas |
| [05 — Sprint Planning](./docs/05-sprint-planning.md) | Sprints 1, 2 y 3 con goal, capacidad y backlog |
| [06 — Arquitectura](./docs/06-arquitectura.md) | Arquitectura general, rutas, estado, API, errores |
| [07 — Base de Datos](./docs/07-base-de-datos.md) | MER, modelo relacional y script SQL |
| [08 — Diseño Técnico](./docs/08-diseno-tecnico.md) | Convenciones, Git flow, estructura del repo |
| [09 — Alcance MVP](./docs/09-mvp-alcance.md) | Dentro/fuera del MVP |
| [10 — Requisitos No Funcionales](./docs/10-requisitos-no-funcionales.md) | Seguridad, rendimiento, accesibilidad, etc. |

El script SQL inicial está en [`/database/schema.sql`](./database/schema.sql).

## 🚀 Puesta en marcha (cuando exista el código)

```bash
npm install            # instala dependencias de desarrollo
npm run dev            # levanta Vite en http://localhost:5173
npm run mock:api       # levanta json-server en http://localhost:3000
npm run build          # genera el bundle de producción en /dist
npm run preview        # sirve el build de producción localmente
```

## 👤 Equipo

Simulación Scrum de **1 Scrum Master (que desarrolla) + 4 Developers**, optimizada para que **una sola persona** implemente el MVP. Ver [05 — Sprint Planning](./docs/05-sprint-planning.md).

## 👥 Roles del sistema

`Coder` · `Team Leader` · `Tutor` · `Coordinador / Responsable Académico`
