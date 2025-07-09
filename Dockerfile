# Dockerfile
# Etapa de construcción
FROM node:18-alpine AS builder

# Configurar directorio de trabajo
WORKDIR /app

# Copiar archivos de dependencias
COPY package*.json ./

# Instalar dependencias
RUN npm ci --only=production

# Copiar código fuente
COPY . .

# Argument para el entorno
ARG REACT_APP_ENV=dev

# Variables de entorno específicas por ambiente
ENV REACT_APP_ENV=$REACT_APP_ENV

# Configurar variables de entorno según el ambiente
RUN if [ "$REACT_APP_ENV" = "prod" ]; then \
      export REACT_APP_API_URL=https://api.calendar-prod.com; \
    elif [ "$REACT_APP_ENV" = "qa" ]; then \
      export REACT_APP_API_URL=https://api.calendar-qa.com; \
    else \
      export REACT_APP_API_URL=https://api.calendar-dev.com; \
    fi

# Construir la aplicación
RUN npm run build

# Etapa de producción
FROM nginx:alpine

# Copiar configuración de nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar archivos construidos
COPY --from=builder /app/dist /usr/share/nginx/html

# Exponer puerto
EXPOSE 80

# Comando para iniciar nginx
CMD ["nginx", "-g", "daemon off;"]