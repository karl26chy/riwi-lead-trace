# 10 — Requisitos No Funcionales (RNF)

Definidos con criterio MVP: suficientes para un piloto confiable, sin sobreingeniería.

## 🔒 Seguridad
- Autenticación con **JWT**; contraseñas siempre como **hash** (bcrypt/argon2) en backend, nunca en texto plano.
- Token en `localStorage` enviado vía header `Authorization: Bearer`; **expiración** del token y cierre de sesión automático ante `401`.
- **Autorización por rol** en cliente (guards) y, obligatoriamente, **validada también en el backend** (el control en cliente es solo UX).
- **Anonimato real:** cuando una evaluación es anónima, no se persiste `evaluator_id`. La UI nunca debe permitir reconstruir la identidad.
- Comunicación sobre **HTTPS** en producción.
- Validación y saneamiento de entradas en cliente y servidor (evitar XSS al renderizar texto del usuario → escapar/usar `textContent`).

## 📈 Escalabilidad
- **Frontend desacoplado** del backend vía contrato REST → se puede escalar/servir como estáticos en CDN.
- **Arquitectura modular**: nuevas vistas/servicios se agregan sin tocar el núcleo.
- **Plantillas de formulario en BD** → crecer en criterios/roles sin redeploy de frontend.
- Modelo de datos normalizado preparado para mayor volumen de evaluaciones.

## ⚡ Rendimiento
- Carga inicial ligera (sin frameworks pesados); bundle minimizado por Vite.
- Objetivo: **First Contentful Paint < 2 s** en conexión 3G/4G típica.
- Renderizado bajo demanda (la vista se monta solo cuando su ruta se activa).
- Llamadas a API mínimas y con estados de carga; evitar peticiones redundantes (cachear catálogos como roles/plantillas en `store`).

## 🧑‍💻 Usabilidad
- **Responsive** (mobile-first) desde 320px hasta escritorio.
- Feedback inmediato: estados de carga, vacío, error y éxito (toasts).
- Formularios con validación clara por campo y prevención de envíos incompletos.
- Navegación coherente y mínima fricción para completar una evaluación (acción principal en ≤3 clics).

## 🧰 Mantenibilidad
- Código modular con responsabilidades separadas (router/store/services/views/components).
- **Convenciones** unificadas (ver [`08-diseno-tecnico.md`](./08-diseno-tecnico.md)).
- Toda la data pasa por `services` → un único punto para cambiar de mock a API real.
- Documentación viva en `/docs`; commits con Conventional Commits.
- Dependencias mínimas → menor superficie de mantenimiento para un equipo de una persona.

## ♿ Accesibilidad
- HTML **semántico** (`<nav>`, `<main>`, `<button>`, `<label>` asociados a inputs).
- **Navegación por teclado** completa y foco visible.
- Contraste de color conforme a **WCAG AA**.
- Atributos `aria-*` donde el semántico no baste (toasts, estados de carga).
- Gráficos de tendencias con **alternativa textual/tabla** de datos.
- Textos de error asociados a sus campos (`aria-describedby`).

## Resumen de objetivos medibles

| RNF | Objetivo verificable |
|-----|----------------------|
| Seguridad | 0 contraseñas en texto plano; anónimas sin `evaluator_id` |
| Rendimiento | FCP < 2 s; bundle inicial liviano |
| Usabilidad | Completar evaluación en ≤3 clics desde el listado |
| Accesibilidad | Navegable 100% por teclado; contraste AA |
| Responsive | Funcional y legible desde 320px |
| Mantenibilidad | Cambio mock→API real solo en capa `services` |
