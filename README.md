# Proyecto de Desarrollo de Datos (Nivel 0 - Dockerizado)

Este repositorio contiene la estructura básica para comenzar a trabajar en el diplomado, utilizando **Docker** para garantizar que su entorno de desarrollo sea **reproducible** y funcione exactamente igual en cualquier máquina (Windows, Mac, Linux).

## Introducción: El Problema de la Reproducibilidad

En el mundo de la ciencia de datos, a menudo un proyecto funciona "en mi máquina, pero no en la tuya" debido a conflictos de versiones de Python o librerías.

**Docker resuelve esto:**
1.  Crea una máquina virtual liviana (Contenedor) que incluye solo lo esencial (Python, JupyterLab, Pandas).
2.  Empaqueta esa "máquina" con el código y la configuración necesaria.
3.  Usted ejecuta el paquete, y la aplicación (JupyterLab) siempre tendrá el mismo sistema operativo base, las mismas librerías y las mismas versiones.

## Estructura del Repositorio

| Archivo/Carpeta | Propósito | Explicación para Principiantes |
| :--- | :--- | :--- |
| `Datos/` | **Datasets de Entrada** | Carpeta donde se guardan los archivos de datos crudos (ej: `.csv`, `.json`). El código en Jupyter los lee desde aquí. |
| `Cuadernos/` | **Código de Desarrollo** | Contiene todos los archivos de desarrollo (`.ipynb` de JupyterLab). Es el lugar donde usted escribe y ejecuta su código Python. |
| `Dockerfile` | **La Receta de la Imagen** | Archivo de texto con las instrucciones exactas que Docker debe seguir para crear el entorno. Es como la lista de ingredientes y pasos de un pastel. |
| `setup_docker_jupyter.sh` | **El Automatizador** | Script de un solo comando para construir la imagen, crear el Contenedor y dejar JupyterLab corriendo. |

---

## Guía de Docker: Las 5 Fases del Entorno

### Fase 1: La Imagen (La Receta)

La **Imagen** es un paquete estático e inmutable que contiene todo el sistema operativo, las librerías (`pandas`, `numpy`) y las aplicaciones (`JupyterLab`).

El archivo `Dockerfile` es la receta para construirla. Analicemos sus pasos clave:

| Instrucción | Explicación |
| :--- | :--- |
| `FROM python:3.11-slim` | **La Base.** Indica que el sistema comienza con una versión limpia y ligera de Python 3.11. |
| `WORKDIR /app` | **El Directorio de Trabajo.** Establece `/app` como la carpeta principal del proyecto dentro del contenedor. Todo nuestro código se ejecutará desde aquí. |
| `RUN pip install ...` | **Las Librerías.** Instala todas las dependencias de Python necesarias (`jupyterlab`, `pandas`, `numpy`) en la Imagen. |
| `EXPOSE 8888` | **El Puerto Interno.** Informa a Docker que el servicio JupyterLab está disponible internamente en el puerto 8888 del contenedor. |
| `CMD ["jupyter-lab", ...]` | **El Encendido.** Es el comando que Docker ejecuta automáticamente cuando se inicia el Contenedor. |

### Fase 2: Construyendo la Imagen

Este paso compila la receta y crea la imagen binaria que usaremos.

```bash
docker build -t jupyter-test-env .
````

### Fase 3: El Contenedor (La Instancia en Ejecución)

El **Contenedor** es la instancia de la Imagen que está ejecutándose en tiempo real. Es el equivalente a "encender" la máquina virtual.

El comando `docker run` inicia esta instancia y utiliza argumentos cruciales para la conexión con su máquina local:

| Argumento | Explicación | Función Clave |
| :--- | :--- | :--- |
| `-d` | **Detach.** Corre el contenedor en segundo plano, liberando su terminal. | Pone el servicio en marcha sin bloquear la terminal. |
| `-p 8888:8888` | **Mapeo de Puertos.** Conecta el puerto 8888 de su máquina (izquierda) al puerto 8888 del contenedor (derecha). | Permite acceder al servicio web (JupyterLab) desde su navegador. |
| `-v "$(pwd)":/app` | **Volumen (Sincronización).** Sincroniza su carpeta local completa con la carpeta `/app` dentro del Contenedor. | Permite editar archivos localmente (en VS Code) y que el código de Jupyter los vea al instante. |
| `--name ...` | **Nombre.** Asigna un nombre fácil de recordar al contenedor. | Permite detenerlo o reiniciarlo fácilmente. |

### Fase 4: Accediendo a JupyterLab

Una vez que el Contenedor está corriendo, debe obtener un token de seguridad que JupyterLab genera automáticamente.

1.  **Ejecute el script de inicio** (`./setup_docker_jupyter.sh`) si no lo ha hecho.

2.  **Obtenga la URL de acceso:** Use este comando para ver el log de arranque del Contenedor, que contiene la dirección completa.

    ```bash
    docker logs jupyter-test-env-container
    ```

    *Busque una línea que comience con `http://127.0.0.1:8888/lab?token=...`*

3.  **Acceda:** Copie y pegue esa URL en su navegador. Ahora puede abrir el archivo `Cuadernos/Exploracion.ipynb` y ejecutar el código de Python.

-----

### Detener y Limpiar el Entorno

Para liberar el puerto 8888 y apagar el entorno de forma segura, use el siguiente comando:

```bash
docker stop jupyter-test-env-container
```