# Pipeline de GitHub Actions

## Propósito

El workflow `.github/workflows/pipeline.yml` automatiza la validación del proyecto y controla su despliegue en Netlify. De esta manera, los cambios se comprueban antes de integrarse y una publicación solo puede comenzar después de que las pruebas y el build finalicen correctamente.

## Eventos de ejecución

El pipeline responde a dos eventos:

- **`pull_request`:** valida los cambios propuestos antes de fusionarlos. En este evento se ejecuta el job `test`, mientras que `deploy` aparece omitido.
- **`push` a `main`:** vuelve a validar la versión integrada y, si el despliegue está habilitado, permite ejecutar el job `deploy`.

Estos eventos mantienen el mismo control de calidad antes y después de integrar un pull request.

## Permisos y entorno

El workflow declara el permiso `contents: read`, suficiente para que GitHub Actions pueda obtener el contenido del repositorio sin conceder permisos de escritura. Cada job usa un runner independiente con `ubuntu-latest` y configura Node.js 22.

## Job de pruebas

El job `test` realiza los siguientes pasos:

1. Descarga el repositorio con `actions/checkout`.
2. Configura Node.js 22 y la caché de npm con `actions/setup-node`.
3. Ejecuta `bash scripts/setup.sh` para preparar el entorno.
4. Ejecuta `bash scripts/test.sh` para correr las pruebas y generar el build.

El script de pruebas ejecuta tanto `npm test` como `npm run build`. Por lo tanto, un error en las pruebas o en la construcción detiene el pipeline.

## Job de despliegue

El job `deploy` declara `needs: test`, por lo que solo puede comenzar si `test` termina correctamente. Debido a que cada job se ejecuta en un runner limpio, prepara su propio entorno mediante checkout, Node.js 22 y los scripts del proyecto antes de invocar `bash scripts/deploy.sh`.

Además, el job utiliza esta condición:

```yaml
if: github.event_name == 'push' && github.ref == 'refs/heads/main' && vars.DEPLOY_ENABLED == 'true'
```

La condición impide desplegar desde un pull request, desde otra rama o cuando el interruptor de despliegue no está habilitado.

## Variable y secretos

La configuración de GitHub Actions requiere:

- **Variable `DEPLOY_ENABLED`:** debe tener el valor `true` para permitir el despliegue desde `main`.
- **Secreto `NETLIFY_AUTH_TOKEN`:** credencial utilizada por Netlify CLI para autenticar el despliegue.
- **Secreto `NETLIFY_SITE_ID`:** identifica el sitio de Netlify que recibe la publicación.

Los dos secretos se exponen únicamente mediante `env` en el paso que ejecuta `scripts/deploy.sh`. No se incluyen sus valores en el workflow, en esta documentación ni en los registros del proyecto.

## Orden del flujo

```text
pull request → test → revisión y merge
push a main → test → condición de despliegue → deploy en Netlify
```

En un pull request, el resultado esperado es `test` exitoso y `deploy` omitido. Después del merge, una ejecución de `main` debe mostrar `test` y `deploy` exitosos siempre que `DEPLOY_ENABLED` esté habilitada y los secretos de Netlify estén configurados correctamente.

## Evidencia pendiente

La validación local comprueba los scripts de pruebas y build. La evidencia remota debe completarse en GitHub con un pull request validado y, junto con el líder, una ejecución de `main` que despliegue correctamente en Netlify. No es necesario provocar deliberadamente un fallo para demostrar el bloqueo del despliegue.
