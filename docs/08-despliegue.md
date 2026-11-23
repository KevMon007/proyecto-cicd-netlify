# 08. Despliegue Continuo en Netlify

## 1. Estrategia de Despliegue (Sin Colisiones)
El sitio en Netlify se creó como sitio vacío (sin vinculación directa a Git) para desactivar el *autodeploy* nativo de Netlify y evitar duplicidad con **GitHub Actions**. GitHub Actions ejecuta las pruebas, compila `dist/` y despliega únicamente desde `main` cuando `DEPLOY_ENABLED` está activo.

## 2. Configuración (`netlify.toml`)
- **Comando de build:** `npm run build`
- **Directorio de publicación:** `dist`
- **Funciones serverless:** `netlify/functions`
- **Versión de Node:** `22`
- **Redirect:** `/api/health` -> `/.netlify/functions/health` (HTTP `200`)

## 3. Secretos en GitHub Actions
Configurados en `Settings > Secrets and variables > Actions` (nunca expuestos en código):
- `NETLIFY_SITE_ID`
- `NETLIFY_AUTH_TOKEN`

## 4. Solución de Errores Comunes
- **Secretos faltantes:** `scripts/deploy.sh` valida ambas variables al inicio y detiene el proceso con código de salida `1` si alguna está vacía.
- **401 Unauthorized:** Token expirado o inválido; regenerar *Personal Access Token* en Netlify y actualizar `NETLIFY_AUTH_TOKEN`.
- **Carpeta `dist/` inexistente:** Asegurar que `npm run build` o la descarga de artefactos ocurra antes de ejecutar `scripts/deploy.sh`.
- **404 en `/api/health`:** Verificar que `[[redirects]]` esté declarado en `netlify.toml` y que se pase `--functions=netlify/functions` en el CLI.

## 5. Evidencia de Producción (Completar tras el merge a `main`)
- **URL de producción:** `Pendiente de activación DEPLOY_ENABLED`
- **Endpoint health:** `https://<sitio>.netlify.app/api/health` (HTTP 200, `application/json`)
- **Commit SHA:** `Pendiente de merge`