## Historia / Tarea

<!-- ID de la historia (ej. EVAL-02) y enlace al issue si existe -->
Closes #

## Que cambia este PR?

<!-- Describe brevemente que hace este PR y por que -->

## Tipo de cambio

- [ ] feat: nueva funcionalidad
- [ ] fix: correccion de bug
- [ ] docs: documentacion
- [ ] refactor: refactorizacion (sin cambio funcional)
- [ ] style: estilos / formato
- [ ] test: pruebas
- [ ] chore: mantenimiento / configuracion

## Checklist (Definition of Done)

### General
- [ ] Cumple **todos** los criterios de aceptacion de la historia
- [ ] No degrada logica de negocio a CRUD plano
- [ ] Sigue convenciones de [`docs/08-diseno-tecnico.md`](./docs/08-diseno-tecnico.md)
- [ ] Commits con Conventional Commits (`feat(eval): ...`)

### Backend (si aplica)
- [ ] Validacion con Pydantic en servidor
- [ ] Manejo de errores con codigos HTTP correctos (`400/401/403/404/409/422`)
- [ ] Logica de negocio en `services/` (no en routers)
- [ ] RBAC con `require_role` donde corresponda
- [ ] Integrado con MySQL

### Frontend (si aplica)
- [ ] Responsive (movil + escritorio, >= 320px)
- [ ] Accesible (labels, teclado)
- [ ] Sin errores en consola
- [ ] Validacion de formularios en cliente
- [ ] Usa `services/` para llamadas a la API (no `fetch` directo)

### Pruebas
- [ ] Probado manualmente (camino feliz + casos de error)
- [ ] No rompe funcionalidad existente

## Capturas / Evidencia

<!-- Screenshots, GIFs o logs relevantes -->

## Notas para el reviewer

<!-- Algo que el reviewer deba saber: decisiones, tradeoffs, areas de riesgo -->
