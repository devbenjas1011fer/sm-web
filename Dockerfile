# Imagen base
FROM debian:stable-slim AS build-env

# Instalar dependencias necesarias
RUN apt-get update && \
    apt-get install -y bash curl file git unzip xz-utils zip libglu1-mesa && \
    rm -rf /var/lib/apt/lists/*
RUN apt-get clean

# Crear usuario para Flutter
RUN groupadd -r -g 1441 flutter && useradd --no-log-init -r -u 1441 -g flutter -m flutter

# Cambiar al usuario
USER flutter:flutter

# Establecer directorio de trabajo
WORKDIR /home/flutter

# Descargar y extraer Flutter desde la fuente oficial
RUN curl -LO https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.47.5-stable.tar.xz && \
    tar xf flutter_linux_3.47.5-stable.tar.xz && \
    rm flutter_linux_3.47.5-stable.tar.xz

# Agregar Flutter al PATH
ENV PATH="/home/flutter/flutter/bin:$PATH"

# Verificar instalación
RUN flutter doctor -v
RUN flutter pub cache clean

# Configurar la aplicación
WORKDIR /app
COPY --chown=flutter:flutter . .
RUN chown -R flutter:flutter /app

# Recibir variables de entorno desde Coolify (build-time)
ARG API_URL
ARG AUTH_URL

# Compilar Flutter para Web, inyectando las variables (único build)
RUN flutter build web --release \
    --dart-define=API_URL=$API_URL \
    --dart-define=AUTH_URL=$AUTH_URL

EXPOSE 8081

# Imagen final con Nginx
FROM nginxinc/nginx-unprivileged:stable-alpine
COPY --from=build-env /app/build/web /usr/share/nginx/html