# Justificación del flujo de liberación y despliegue continuo

## Caso de estudio

El proyecto representa a un equipo que necesita publicar una página informativa sencilla y comprobar que el servicio continúa disponible mediante el endpoint `/api/health`. Aunque la aplicación es pequeña, una publicación manual puede introducir archivos incompletos, omitir pruebas o dificultar la identificación de la versión desplegada.

Para resolverlo se utiliza GitHub como repositorio, GitHub Actions como herramienta de liberación continua y Netlify como entorno de despliegue. El alcance se limita a una página HTML y una función serverless de Node.js; no se requieren base de datos, autenticación ni frameworks adicionales.

## Flujo de trabajo

El pipeline sigue esta secuencia:

```text
rama de trabajo
      ↓
pull request
      ↓
instalación → pruebas → build
      ↓
revisión y merge a main
      ↓
instalación → pruebas → build
      ↓
despliegue en Netlify
```

En cada pull request, GitHub Actions prepara un entorno limpio con Node.js 22, instala el proyecto, ejecuta las pruebas y genera el contenido estático en `dist/`. Esta validación permite detectar errores antes de integrar cambios.

Cuando un pull request aprobado se fusiona en `main`, el pipeline repite las validaciones. El job de despliegue depende del éxito del job de pruebas, por lo que una validación fallida impide publicar. Además, el despliegue requiere que la variable `DEPLOY_ENABLED` tenga el valor `true`; así puede mantenerse activo el CI mientras Netlify y sus secretos todavía no están configurados.

## Razones para automatizar

- **Consistencia:** los mismos comandos se utilizan localmente y en GitHub Actions.
- **Prevención de errores:** la publicación solo se intenta después de completar pruebas y build.
- **Reproducibilidad:** cada ejecución usa un runner limpio con una versión definida de Node.js.
- **Rapidez:** el equipo recibe un resultado automático en cada pull request.
- **Seguridad:** los valores de acceso a Netlify se almacenan como secretos de GitHub y no en el repositorio.
- **Trabajo paralelo:** cada integrante desarrolla en una rama y modifica archivos previamente asignados.

## Trazabilidad

GitHub relaciona cada cambio con una rama, commit y pull request. GitHub Actions conserva el resultado y duración de las ejecuciones, mientras que Netlify registra la publicación realizada. El script de despliegue incluye el SHA de GitHub en el mensaje, lo que permite asociar una versión publicada con el commit que la generó.

Las evidencias finales deben identificar como mínimo el pull request validado, el SHA integrado en `main`, la ejecución exitosa del pipeline, la URL publicada y la respuesta HTTP de `/api/health`. No deben incluir tokens ni valores secretos.

## Adecuación al proyecto

El flujo elegido demuestra liberación y despliegue continuos sin aumentar innecesariamente el tamaño de la aplicación. Node.js proporciona el ejecutor de pruebas y el script de build; GitHub Actions coordina la validación; y Netlify aloja tanto el sitio estático como la función serverless. Esta combinación permite cumplir el caso de estudio con herramientas accesibles y una configuración que puede comprenderse, ejecutarse y documentarse en dos días.

Los niveles de servicio definidos en el reporte son objetivos académicos. Las comprobaciones realizadas durante la práctica son evidencia puntual y no constituyen una garantía de disponibilidad mensual.
