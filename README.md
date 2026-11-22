# Proyecto CI/CD — Netlify
Caso de estudio: sitio estático y función serverless de salud, desplegados con GitHub Actions.

## Ejecutar localmente
Requiere Node.js 22. Ejecuta `bash scripts/setup.sh` y `bash scripts/test.sh`.

## Configuración de Netlify y GitHub
1. Crea un repositorio en GitHub y sube este proyecto a `main`.
2. Crea un sitio en Netlify (puede ser un sitio de despliegue manual). Obtén el **Site ID** en la configuración del sitio y genera un **personal access token** en Netlify.
3. En GitHub, abre **Settings > Secrets and variables > Actions** y añade `NETLIFY_SITE_ID` y `NETLIFY_AUTH_TOKEN`. No escribas sus valores en archivos.
4. Haz un push a `main`: GitHub Actions ejecuta pruebas y build, luego publica con Netlify CLI si todo pasa. Los pull requests solo ejecutan pruebas.
5. Abre `https://TU-SITIO.netlify.app/api/health` y comprueba `{ "status": "ok" }`.
6. Evita conectar otro autodespliegue del mismo repositorio en Netlify: aquí el despliegue lo controla GitHub Actions.

## Responsables
1: líder/documento; 2: entorno; 3: pipeline; 4: pruebas; 5: despliegue; 6: SLA; 7: métricas.

**Nota:** Este repositorio no crea automáticamente el sitio ni los secretos en cuentas externas.
