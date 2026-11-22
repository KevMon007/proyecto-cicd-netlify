# Integrante 5 — despliegue en Netlify

Lee primero `00_GUIA_GENERAL.md`.

## Tu objetivo

Vincular el pipeline con Netlify. Tus archivos son `netlify.toml`, `scripts/deploy.sh`, `netlify/functions/health.js` y `docs/08-despliegue.md`. Rama: `feature/netlify`.

## Trabajo independiente

1. Crea un sitio vacío en Netlify sin activar otro autodeploy que compita con GitHub Actions.
2. Configura en GitHub los secretos `NETLIFY_SITE_ID` y `NETLIFY_AUTH_TOKEN`. Nunca compartas ni documentes sus valores.
3. Revisa `netlify.toml`: build `npm run build`, publicación `dist`, funciones `netlify/functions`, Node 22 y redirect `/api/health`.
4. Revisa que el handler responda HTTP 200, JSON y `content-type`.
5. Revisa que `scripts/deploy.sh` valide los secretos y ejecute Netlify CLI 23 en producción.
6. Documenta configuración y solución de errores comunes. Abre PR.

El líder habilita `DEPLOY_ENABLED`; no publiques manualmente para sustituir el pipeline. Después de integrar, comprueba el deploy, registra URL y SHA y prueba la página y `/api/health`.

## Terminado cuando

- [ ] Sitio y secretos están configurados.
- [ ] El deploy automático de `main` está verde.
- [ ] URL, SHA y endpoint están documentados.
