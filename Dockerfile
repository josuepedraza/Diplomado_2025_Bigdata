# Usar una imagen base de Python ligera
FROM python:3.11-slim

# Establecer el directorio de trabajo
WORKDIR /app

# Instalar dependencias clave
RUN pip install jupyterlab pandas numpy

# Exponer el puerto de JupyterLab
EXPOSE 8888

# Comando para iniciar JupyterLab
# El --allow-root es necesario para algunas configuraciones de Docker
CMD ["jupyter-lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]
