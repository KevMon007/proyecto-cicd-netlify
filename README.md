# Proyecto CI/CD con GitHub Actions y Netlify

Caso de estudio académico de liberación y despliegue continuos para un sitio HTML estático y una función serverless de salud.

## Alcance

El proyecto demuestra el flujo completo sin incorporar frameworks, base de datos ni autenticación:

```text
pull request → instalación → pruebas → build → merge a main → pruebas → despliegue
```

- GitHub almacena el código y los pull requests.
- GitHub Actions valida los cambios y controla la liberación.
- Netlify publica el sitio y la función serverless.
- `/api/health` debe responder HTTP 200 con `{"status":"ok"}`.

## Requisitos

- Git y Bash.
- Node.js 22 y npm.
- Repositorio de GitHub con Actions habilitado.
- Sitio de Netlify, únicamente para el despliegue remoto.

## Ejecución local

Desde la raíz del proyecto:

```bash
bash scripts/setup.sh
bash scripts/test.sh
```

También pueden ejecutarse los comandos npm por separado:

```bash
npm test
npm run build
```

El build genera `dist/index.html`. La carpeta `dist/` es un artefacto local y no se versiona.

## Comportamiento del pipeline

- En cada pull request, el job `test` instala, prueba y construye el proyecto.
- En cada push a `main`, el job `test` se ejecuta nuevamente.
- El job `deploy` depende de `test` y solo se ejecuta en `main` cuando `DEPLOY_ENABLED` es `true`.
- Los secretos de Netlify se entregan únicamente al paso de despliegue.

## Configuración de GitHub y Netlify

1. Crea un sitio vacío en Netlify sin habilitar otro autodespliegue del mismo repositorio.
2. Obtén el Site ID y genera un personal access token de Netlify.
3. En GitHub, abre **Settings → Secrets and variables → Actions**.
4. Crea los secretos `NETLIFY_SITE_ID` y `NETLIFY_AUTH_TOKEN`.
5. Cuando scripts, pruebas y workflow estén integrados, crea la variable `DEPLOY_ENABLED` con valor `true`.
6. Fusiona un pull request real en `main` y comprueba los jobs `test` y `deploy`.
7. Abre la URL pública y verifica `/api/health`.

Nunca escribas tokens, IDs reales ni otros datos de acceso en archivos, capturas o comentarios.

## Organización del equipo

| Integrante | Responsabilidad |
|---|---|
| 1 | Liderazgo, justificación, README y reporte final |
| 2 | Entorno de liberación |
| 3 | Pipeline de GitHub Actions |
| 4 | Pruebas automatizadas |
| 5 | Configuración y despliegue en Netlify |
| 6 | Niveles de servicio |
| 7 | Métricas y parámetros de configuración |

Las instrucciones y ramas asignadas se encuentran en [`guias-equipo/00_GUIA_GENERAL.md`](guias-equipo/00_GUIA_GENERAL.md).

## Documentación

- Justificación: [`docs/01-justificacion.md`](docs/01-justificacion.md).
- Reporte consolidado: [`docs/reporte.md`](docs/reporte.md).
- URL pública: pendiente de la configuración final de Netlify.

El reporte final reunirá los documentos del equipo y las evidencias reales de GitHub Actions y Netlify. Los resultados pendientes se indicarán como tales; no se inventarán mediciones.
