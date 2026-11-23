# Entorno de liberación

## Objetivo
Hacer reproducible el entorno local y el de GitHub Actions para instalar, probar y construir el proyecto.

## Requisitos
| Herramienta | Versión | Para qué sirve |
|---|---|---|
| Git | 2.52.0 (local) | Control de versiones y ramas |
| GitHub | n/a | Repositorio y pull requests |
| GitHub Actions | n/a | Ejecuta el pipeline de CI/CD |
| Ubuntu | runner ubuntu-latest | Sistema donde corre Actions |
| Bash | 5.2.37 (local) | Ejecuta los scripts del proyecto |
| Node.js | 22 (local v22.22.0) | Runtime de pruebas y build |
| npm | 10.9.4 (local) | Instalación reproducible con `npm ci` |
| Netlify | n/a | Destino de despliegue; la CLI se usa solo en `scripts/deploy.sh` |

## Comandos
- Instalar: `bash scripts/setup.sh`
- Pruebas: `npm test` (usa `node --test`)
- Build: `npm run build` (genera `dist/`, que no se versiona)
- Pruebas y build juntos: `bash scripts/test.sh`

## Reproducibilidad
`scripts/setup.sh` usa `set -euo pipefail` y `npm ci --no-audit --no-fund`. `npm ci` instala exactamente lo que dicta `package-lock.json`, por lo que cada instalación es idéntica. El script también verifica que la versión mayor de Node sea 22 y se detiene si no lo es. El proyecto no tiene dependencias de aplicación; solo se conservan los scripts npm `test` y `build`.

## Local, GitHub Actions y Netlify
- Local: cualquier equipo con Git, Bash y Node 22.
- GitHub Actions: usa Ubuntu y Node 22; ejecuta instalación, pruebas y build en cada pull request y en `main`.
- Netlify: es el destino de despliegue; recibe `dist/` y la función `health` solo cuando se despliega desde `main`.

## Evidencia de verificación local
Fecha de la prueba: 22 de noviembre de 2026.

- Versiones: git 2.52.0.windows.1, Bash 5.2.37(1), Node v22.22.0, npm 10.9.4.
- `bash scripts/setup.sh`: correcto; `npm ci` terminó con "up to date" y el script imprimió "Entorno listo".
- `npm test`: correcto; 3 pruebas, 3 aprobadas, 0 fallidas.
- `npm run build`: correcto; imprimió "Sitio estático preparado en dist/".
- `dist/index.html`: existe. `dist/` no se versiona (está en `.gitignore`).

## Pendiente remoto
La ejecución en GitHub Actions (Ubuntu con Node 22) queda pendiente hasta que el PR sea validado por el workflow.
