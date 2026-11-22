# Caso de estudio: CI/CD en Netlify

## 1. Justificación del pipeline
GitHub Actions automatiza la instalación, pruebas y build en cada pull request y push a main. Solo después de aprobar la etapa de pruebas se ejecuta el despliegue a producción. Esto reduce errores manuales y mejora la trazabilidad.

## 2. Entorno requerido
GitHub, GitHub Actions (ubuntu-latest), Node.js 22, Netlify, Netlify CLI, sitio estático HTML y función serverless de Node.js. Archivos: `netlify.toml`, `scripts/setup.sh`, `scripts/test.sh`, `scripts/deploy.sh`.

## 3. Niveles de servicio acordados (objetivos académicos)
Disponibilidad mensual objetivo: 99%; latencia p95 del endpoint de salud: menos de 2 segundos; tasa de respuestas HTTP 5xx: menos del 1%; tiempo objetivo de recuperación: 30 minutos. Son objetivos propuestos, no garantías de Netlify ni métricas verificadas.

## 4. Métricas de monitoreo
Disponibilidad del endpoint `/api/health`, latencia p95, porcentaje de errores 5xx, duración y éxito del pipeline, frecuencia de despliegues. Capturar evidencia de comprobaciones HTTP y de ejecuciones en GitHub Actions/Netlify.

## 5. Parámetros de configuración
`node-version: 22`; triggers: `pull_request` y `push` a `main`; build: `npm run build`; publicación: `dist`; functions: `netlify/functions`; variables secretas: `NETLIFY_AUTH_TOKEN`, `NETLIFY_SITE_ID`; endpoint: `/api/health`.

## 6. Evidencias pendientes
Agregar capturas de un PR con pruebas aprobadas, push a main, despliegue en Netlify y respuesta HTTP 200 del endpoint.
