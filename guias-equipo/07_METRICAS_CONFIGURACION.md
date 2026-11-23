# 07. Métricas y Configuración

**Responsable:** Mane  
**Archivo:** `07_METRICAS_CONFIGURACION.md`  
**Propósito:** Definir los indicadores clave de rendimiento (KPIs/DORA), las herramientas de monitoreo y la gestión de variables de entorno para garantizar la estabilidad y observabilidad del sistema en producción.

---

## 1. Métricas Clave de Entrega y Rendimiento (DORA Metrics)

Para medir la eficiencia del pipeline de CI/CD en GitHub Actions y la estabilidad del despliegue en Netlify, se establecen las siguientes métricas:

| Métrica | Definición | Objetivo (Meta) | Fuente de Medición |
| :--- | :--- | :--- | :--- |
| **Frecuencia de Despliegue** *(Deployment Frequency)* | Frecuencia con la que se liberan cambios a producción (`main`). | Al menos 1 despliegue por sprint / bajo demanda tras PR aprobado. | Historial de *Deploys* en Netlify y *Workflows* en GitHub Actions. |
| **Tiempo de Entrega** *(Lead Time for Changes)* | Tiempo transcurrido desde que se realiza un `commit` hasta que llega a producción. | Menor a 15 minutos. | GitHub Actions (duración del pipeline) + Netlify Build time. |
| **Tasa de Fallos en Cambios** *(Change Failure Rate)* | Porcentaje de despliegues que provocan un fallo en producción o requieren *rollback*. | Menor al 5%. | Registro de *Deploys* fallidos o revertidos en Netlify. |
| **Tiempo Medio de Recuperación** *(MTTR)* | Tiempo necesario para restaurar el servicio tras una caída o fallo crítico. | Menor a 10 minutos (mediante *Rollback* instantáneo en Netlify). | Logs de incidentes y tiempos de restauración en Netlify. |

---

## 2. Métricas de Calidad y Experiencia de Usuario (Web & CI)

Además del flujo de entrega, se monitorean los siguientes indicadores técnicos:

* **Cobertura de Pruebas (*Test Coverage*):** Porcentaje de código cubierto por las pruebas automatizadas ejecutadas en el paso `04_PRUEBAS_AUTOMATIZADAS.md`.
  * *Umbral mínimo aceptado:* **80%** en lógica crítica.
* **Rendimiento Web (Core Web Vitals):**
  * **LCP (Largest Contentful Paint):** Menor a `2.5 s` (velocidad de carga percibida).
  * **INP (Interaction to Next Paint):** Menor a `200 ms` (capacidad de respuesta).
  * **CLS (Cumulative Layout Shift):** Menor a `0.1` (estabilidad visual).
* **Tasa de Éxito del Pipeline:** Porcentaje de ejecuciones de GitHub Actions completadas sin errores de *linting*, *build* o *testing* (Meta: **> 95%**).

---

## 3. Gestión de Configuración y Variables de Entorno

Para evitar exponer credenciales en el repositorio y separar correctamente los entornos (`Desarrollo`, `Staging/Preview` y `Producción`), la configuración se divide en dos niveles:

### A. Secretos en GitHub Actions (`Settings > Secrets and variables > Actions`)
Utilizados exclusivamente durante la ejecución del pipeline de integración continua y despliegue:

* `NETLIFY_AUTH_TOKEN`: Token personal de acceso para autenticar la CLI de Netlify desde GitHub.
* `NETLIFY_SITE_ID`: Identificador único del proyecto alojado en Netlify.
* `SONAR_TOKEN` *(opcional)*: Token para análisis estático de código y reporte de cobertura.

### B. Variables de Entorno en Netlify (`Site configuration > Environment variables`)
Inyectadas durante el proceso de compilación (*build*) y ejecución de la aplicación web:

| Variable | Entorno(s) | Descripción | Ejemplo / Formato |
| :--- | :--- | :--- | :--- |
| `NODE_VERSION` | Todos | Versión fija de Node.js para garantizar consistencia entre local y nube. | `20.x` |
| `VITE_API_URL` / `REACT_APP_API_URL` | Producción / Preview | URL base del backend o servicios externos según la rama desplegada. | `https://api.dominio.com` |
| `APP_ENV` | Todos | Identificador del entorno activo. | `production` / `preview` |

> **Regla de Seguridad:** Ningún archivo `.env` con valores reales debe subirse al repositorio. Únicamente se versionará un archivo `.env.example` con las llaves vacías como referencia para el equipo.

---

## 4. Configuración de Archivos Base del Repositorio

Para asegurar que el entorno de liberación funcione de manera predecible, se mantienen los siguientes archivos de configuración en la raíz del proyecto:

* **`.env.example`**: Plantilla documentada de las variables requeridas para levantar el proyecto localmente.
* **`netlify.toml`**: Archivo de configuración como código (*Configuration as Code*) que define:
  * Comando de construcción (`npm run build`).
  * Directorio de publicación (`dist/` o `build/`).
  * Reglas de redirección para Single Page Applications (`/* -> /index.html` con estado `200`).
  * Cabeceras de seguridad HTTP (`X-Frame-Options`, `X-Content-Type-Options`).

---

## 5. Monitoreo y Alertas

* **Notificaciones de Build:** GitHub Actions y Netlify están configurados para alertar automáticamente ante cualquier fallo en la compilación o en las pruebas automatizadas antes de publicar cambios.
* **Logs en Tiempo Real:** Revisión periódica de los *Deploy Logs* y *Function Logs* directamente desde el panel de control de Netlify para detectar cuellos de botella o errores en tiempo de ejecución.
