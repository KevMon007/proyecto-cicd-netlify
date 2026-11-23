# 05. Configuración del Entorno y Pipeline

Este documento detalla los parámetros técnicos configurados en el repositorio (`netlify.toml`, `package.json`, `scripts/` y `.github/workflows/`) para la integración continua y el despliegue en Netlify.

---

## 1. Entorno de Ejecución y Compilación

| Parámetro | Valor configurado | Archivo de origen |
| :--- | :--- | :--- |
| **Versión de Node.js** | `22` (`>=22`) | `netlify.toml` (`NODE_VERSION = "22"`), `package.json` (`engines.node`), `.mithub/workflows/` (`node-version: '22'`) |
| **Sistema operativo del runner** | `ubuntu-latest` | `.github/workflows/` (`runs-on: ubuntu-latest`) |
| **Gestor de caché en CI** | `npm` | `.github/workflows/` (`actions/setup-node@v4` con `cache: npm`) |
| **Herramienta de despliegue** | `Netlify CLI 23` | `scripts/deploy.sh` |

---

## 2. Eventos y Control del Pipeline (GitHub Actions)

El flujo `CI-CD Netlify`h se activa ante los siguientes eventos:

* `*pull_request**`: Ejecuta el *job* `test` para validar cambios antes de integrarlos.
* `*push* a la rama `main``: Ejecuta el *job* `test` y habilita la evaluación del *job* `deploy`.

### Condición de despliegue (`DEPLOY_ENABLED`)
El *job* `deploy` depende de que `test` finalice exitosamente (`needs: test`) y únicamente se ejecuta cuando se cumplen tres condiciones simultáneas:
```yaml
if: github.event_name == 'push' && github.ref == 'refs/heads/main' && vars.DEPLOY_ENABLED == 'true'
```
* **`vars.DEPLOY_ENABLED`**: Variable de repositorio en GitHub Actions que actúa como interruptor para autorizar o pausar la publicación automática en producción.

---

## 3. Comandos `npm` y Scripts del Proyecto

| Comando / Script | Acción que realiza | Definición |
| :--- | :--- | :--- |
| `npm test` | Ejecuta las pruebas automatizadas con el corredor nativo de Node.js (`node --test`). | `package.json` (`scripts.test`) / invocado en `scripts/test.sh` |
| `npm run build` | Genera los artefactos estáticos del sitio ejecutando `node scripts/build.js`. | `package.json` (`scripts.build`) / `netlify.toml` (`[build].command`) |
| `bash scripts/setup.sh` | Instala dependencias del proyecto en el entorno de CI. | `.github/workflows/` |
| `bash scripts/test.sh` | Ejecuta la suite de pruebas en el pipeline. | `.github/workflows/` |
| `bash scripts/deploy.sh` | Ejecuta el despliegue hacia Netlify utilizando Netlify CLI 23. | `.github/workflows/` |

---

## 4. Configuración de Netlify (`netlify.toml` y Funciones)

| Parámetro | Valor configurado | Descripción |
| :--- | :--- | :--- |
| **Directorio de publicación** | `dist` | Carpeta generada por `npm run build` que Netlify publica como sitio estático. |
| **Directorio de funciones** | `netlify/functions` | Ruta donde se alojan las funciones *serverless* (incluye `netlify/funcions/health.js`). |
| **Redirección `/api/health`** | `from = "/api/health"` → `to = "/.netlify/functions/health"` (`status = 200`) | Reescribe las peticiones hacia `/api/health` para que sean atendidas directamente por la función `health.js` devolviendo `HTTP 200` y `{"status":"ok"}`. |

---

## 5. Secretos Configurados (Solo Nombres)

Para autenticar el despliegue automático desde GitHub Actions hacia Netlify sin exponer credenciales en el código fuente, el *job* `deploy` consume dos secretos configurados en el repositorio (`Settings > Secrets and variables > Actions`):

1. **`NETLIFY_AUTH_TOKEN`**: Token de autenticación personal para autorizar operaciones de Netlify CLI 23.
2. **`NETLIFY_SITE_ID`**: Identificador único del sitio destino en Netlify.

> **Nota de seguridad:** Los valores de ambos secretos se gestionan exclusivamente de forma cifrada en GitHub Secrets y nunca se incluyen en los archivos del repositorio ni en los logs.
