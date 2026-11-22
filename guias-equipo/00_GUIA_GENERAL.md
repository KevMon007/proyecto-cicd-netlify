# Guía general — proyecto CI/CD sencillo con Netlify

## 1. Propósito

Entregar en dos días un caso de estudio pequeño que demuestre liberación y despliegue continuos. El producto es una página HTML estática y una función serverless de salud. No se desarrollarán más pantallas, base de datos, autenticación ni API adicional.

La entrega debe incluir:

- un documento final en `docs/reporte.md` con justificación del pipeline, entorno, niveles de servicio, métricas, parámetros y vinculación GitHub Actions–Netlify;
- el workflow en `.github/workflows/pipeline.yml`;
- el script de entorno `scripts/setup.sh`;
- las pruebas y su ejecutor en `tests/` y `scripts/test.sh`;
- el build y despliegue en `scripts/build.js`, `scripts/deploy.sh` y `netlify.toml`;
- un repositorio de GitHub con al menos un PR validado por Actions y un despliegue de `main` en Netlify.

## 2. Caso de estudio

Una organización necesita publicar una página informativa y comprobar que el servicio está disponible mediante `/api/health`. Cada pull request debe ejecutar instalación, pruebas y build. Al integrar en `main`, el mismo control debe ejecutarse antes de publicar en Netlify. GitHub Actions es la herramienta de liberación continua y Netlify es el entorno de despliegue.

## 3. Diseño mínimo congelado

Estos contratos no se cambian durante el trabajo salvo que el líder autorice una corrección:

| Elemento | Contrato |
|---|---|
| Runtime | Node.js 22 |
| Instalación | `bash scripts/setup.sh` |
| Pruebas y build | `bash scripts/test.sh` |
| Build directo | `npm run build` |
| Salida | `dist/` |
| Función | `netlify/functions/health.js` |
| Endpoint público | `/api/health` |
| Respuesta esperada | HTTP 200 y `{"status":"ok"}` |
| Despliegue | `bash scripts/deploy.sh` |
| Secretos | `NETLIFY_AUTH_TOKEN`, `NETLIFY_SITE_ID` |
| Interruptor de despliegue | variable `DEPLOY_ENABLED` |

El proyecto no necesita paquetes de aplicación. Se usa Node.js nativo; Netlify CLI se ejecuta únicamente durante el despliegue.

## 4. Trabajo paralelo de siete integrantes

Después de que el líder publique el repositorio base, todos pueden empezar sin esperar el trabajo de otra persona.

| Persona | Rama | Entregable independiente |
|---|---|---|
| 1. Líder | `docs/lider-inicial` | Repositorio, `README.md`, `docs/01-justificacion.md` y reporte final |
| 2. Entorno | `feature/entorno` | `scripts/setup.sh`, archivos npm y `docs/02-entorno.md` |
| 3. Pipeline | `feature/pipeline` | Workflow y `docs/06-pipeline.md` |
| 4. Pruebas | `feature/pruebas` | Prueba, script y `docs/07-pruebas.md` |
| 5. Netlify | `feature/netlify` | Configuración, función, despliegue y `docs/08-despliegue.md` |
| 6. SLA | `docs/sla` | `docs/03-niveles-servicio.md` |
| 7. Métricas | `docs/metricas` | `docs/04-metricas.md` y `docs/05-configuracion.md` |

Cada persona edita solamente sus archivos. Las mediciones reales, URL y enlaces a ejecuciones pueden añadirse al final; no impiden redactar el contenido inicial.

## 5. Plan de dos días

### Día 1 — construir en paralelo

1. El líder crea el repositorio privado, protege el despliegue con `vars.DEPLOY_ENABLED == 'true'`, sube la base e invita al equipo.
2. Cada integrante crea su rama, revisa su archivo base, realiza su tarea y abre un PR.
3. Cada PR indica: archivos modificados, prueba realizada y pendiente remoto, si existe.
4. El líder revisa que nadie haya cambiado archivos ajenos y fusiona únicamente PR con CI verde.

No es necesario desplegar para terminar el trabajo del día 1. Tampoco se requiere crear deliberadamente un PR roto.

### Día 2 — integrar, desplegar y documentar

1. Integrar los PR pendientes. Los documentos pueden fusionarse en cualquier orden.
2. Confirmar en GitHub los secretos de Netlify y establecer `DEPLOY_ENABLED=true`.
3. Hacer un cambio real mediante PR y fusionarlo a `main`; comprobar que los jobs `test` y `deploy` terminan correctamente.
4. Verificar la página y `/api/health`; registrar URL, fecha, SHA y resultado.
5. El líder reúne los documentos `01` a `08` en `docs/reporte.md`, actualiza el README y verifica la entrega.

La única dependencia final es natural: para comprobar el despliegue deben estar integrados el workflow, los scripts y los secretos. Esa dependencia no bloquea el trabajo inicial de nadie.

## 6. Procedimiento Git común

```bash
git switch main
git pull origin main
git switch -c RAMA_ASIGNADA
# Edita solo tus archivos.
git status
git diff
git add RUTAS_ASIGNADAS
git commit -m "tipo: descripción breve"
git push -u origin RAMA_ASIGNADA
```

Abrir un PR hacia `main`. No hacer push directo a `main`, no usar `git add .` en una rama de trabajo y no subir `dist/`, `node_modules/`, `.env` ni credenciales.

## 7. Contenido del documento final

`docs/reporte.md` debe tener estas secciones:

1. Portada y descripción del caso.
2. Justificación del flujo PR → pruebas → merge → pruebas → build → deploy.
3. Entorno requerido: Git, GitHub, Actions, Ubuntu, Bash, Node 22, npm y Netlify.
4. Niveles de servicio acordados, claramente identificados como objetivos académicos.
5. Métricas: estado del endpoint, disponibilidad de la muestra, latencia y resultado/duración del pipeline.
6. Parámetros de configuración de GitHub Actions y Netlify, sin valores secretos.
7. Implementación de scripts y vinculación GitHub Actions–Netlify.
8. Evidencias: PR verde, ejecución de `main`, deploy y respuesta de `/api/health`.
9. Resultados, limitaciones y conclusión.

No afirmar disponibilidad mensual a partir de pocas solicitudes ni inventar resultados. Si algo no pudo comprobarse, se marca como pendiente o no evaluado.

## 8. Lista de entrega

- [ ] Los siete aportes están integrados en `main`.
- [ ] `npm test` y `npm run build` funcionan con Node 22.
- [ ] Un PR ejecutó CI correctamente.
- [ ] Un push a `main` ejecutó pruebas antes del deploy.
- [ ] GitHub Actions está vinculado con Netlify mediante secretos.
- [ ] La URL raíz y `/api/health` funcionan.
- [ ] El reporte cubre los seis puntos solicitados y referencia los scripts entregados.
- [ ] No hay tokens, `.env`, `node_modules/` ni `dist/` versionados.

## 9. Comunicación breve

Usar este formato:

```text
Persona | rama/PR | resultado | evidencia o prueba | bloqueo
```

Si falla CI, revisar el primer paso rojo y reproducirlo localmente. Si falla el deploy, revisar nombres de secretos, permisos, `dist/`, ruta de funciones y configuración de Netlify. Comunicar el error sin inventar una validación.
