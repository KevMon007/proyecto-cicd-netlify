# 07 — Pruebas automatizadas

Responsable: Integrante 4 · Rama: `feature/pruebas-automatizadas-tona`

## 1. Alcance

Las pruebas validan el contrato mínimo del servicio definido en la guía general: la función `netlify/functions/health.js`, expuesta públicamente como `/api/health`, debe responder HTTP 200 con el cuerpo `{"status":"ok"}`. No se prueba la página HTML ni se agregan dependencias: se usan únicamente `node:test` y `node:assert/strict`, incluidos en Node.js 22.

| Archivo | Función |
|---|---|
| `tests/health.test.js` | Tres pruebas sobre el handler de la función de salud |
| `scripts/test.sh` | Ejecuta pruebas y luego el build; se detiene ante cualquier error |

## 2. Casos de prueba

Las pruebas invocan directamente `handler()` sin red ni servidor, por lo que no requieren entrada de usuario.

| # | Caso | Entrada | Resultado esperado | Aserción |
|---|---|---|---|---|
| 1 | Código HTTP | `handler()` | `statusCode` igual a `200` | `assert.equal` |
| 2 | Cuerpo de la respuesta | `handler()` | `body` interpretado como JSON igual a `{ status: 'ok' }` | `assert.deepEqual` |
| 3 | Tipo de contenido | `handler()` | Encabezado `content-type` contiene `application/json` | `assert.match` |

## 3. Ejecutor `scripts/test.sh`

```bash
#!/usr/bin/env bash
set -euo pipefail
npm test
npm run build
```

- `set -e`: el script termina en cuanto un comando devuelve un código distinto de cero.
- `set -u`: una variable no definida es un error.
- `set -o pipefail`: un fallo dentro de una tubería no queda oculto.
- `npm test` ejecuta `node --test`. Si falla, `npm run build` no se ejecuta.
- `npm run build` ejecuta `node scripts/build.js`, que copia `public/` a `dist/`.

Se ejecuta desde la raíz del proyecto con `bash scripts/test.sh`. Es el mismo comando que usa el job `test` de GitHub Actions.

## 4. Resultado de la comprobación local

Fecha: 2026-11-22 · Entorno: Node.js v22.23.5, npm 10.9.9 · Comando: `bash scripts/test.sh` (con `dist/` eliminado previamente).

| Verificación | Resultado |
|---|---|
| Prueba 1: HTTP 200 | `ok` |
| Prueba 2: cuerpo `{"status":"ok"}` | `ok` |
| Prueba 3: `content-type` JSON | `ok` |
| Resumen del ejecutor | `tests 3 · pass 3 · fail 0` |
| Build | `Sitio estático preparado en dist/` |
| Código de salida de `test.sh` | `0` |
| Existe `dist/index.html` | Sí (522 bytes) |
| `dist/index.html` idéntico a `public/index.html` | Sí (`cmp` sin diferencias) |

### Comprobación de que el script se detiene ante errores

Se realizó sobre una copia temporal del proyecto, sin modificar el repositorio ni crear una rama o PR con fallos.

| Escenario provocado | Comportamiento observado | Salida |
|---|---|---|
| El handler devuelve `statusCode: 500` | Falla la prueba 1; el build **no** se ejecuta y `dist/` no se crea | `1` |
| Pruebas correctas, pero falta la carpeta `public/` | `3 pass`; el build falla con `ENOENT` | `1` |
| El handler devuelve `content-type: text/plain` | Falla la prueba 3 (`pass 2 · fail 1`) | `1` |

Con esto se confirma que una prueba fallida detiene el flujo antes del build y que un build fallido también termina con error, que es lo que necesita el pipeline para bloquear el despliegue.

## 5. Validación pública posterior al despliegue

**Estado: pendiente.** Se completará cuando el workflow, los scripts y los secretos estén integrados en `main` y exista la URL pública de Netlify.

Comando (una sola validación):

```bash
curl -i https://URL_DEL_SITIO/api/health
```

Resultado esperado: línea de estado `HTTP/2 200`, encabezado `content-type: application/json` y cuerpo `{"status":"ok"}`.

| Dato | Valor |
|---|---|
| URL | _pendiente_ |
| Fecha y hora | _pendiente_ |
| SHA desplegado | _pendiente_ |
| Código HTTP obtenido | _pendiente_ |
| Cuerpo obtenido | _pendiente_ |
| `content-type` obtenido | _pendiente_ |
| Resultado | _pendiente_ |

## 6. Limitaciones

- Las pruebas verifican el handler como función de Node.js. No prueban la redirección `/api/health` de `netlify.toml` ni el comportamiento de Netlify; eso se cubre con la validación pública de la sección 5.
- No se mide disponibilidad ni latencia en esta etapa; esas métricas corresponden al documento de métricas.
