# Etapa de construcción
FROM node:18-alpine AS builder

# Configurar directorio de trabajo
WORKDIR /app

# Copiar archivos necesarios
COPY package.json yarn.lock ./

# Instalar Yarn globalmente e instalar dependencias
RUN npm install -g yarn && \
    yarn install --frozen-lockfile --production

# Copiar código fuente
COPY . .

# Argumento para el entorno
ARG REACT_APP_ENV=dev

# Establecer variables de entorno basadas en el argumento
ENV REACT_APP_ENV=${REACT_APP_ENV}

# Configurar URL de API según el entorno
RUN if [ "$REACT_APP_ENV" = "prod" ]; then \
      echo "REACT_APP_API_URL=https://api.calendar-prod.com " >> .env; \
    elif [ "$REACT_APP_ENV" = "qa" ]; then \
      echo "REACT_APP_API_URL=https://api.calendar-qa.com " >> .env; \
    else \
      echo "REACT_APP_API_URL=https://api.calendar-dev.com " >> .env; \
    fi

# Construir la aplicación
RUN yarn build

# Etapa de producción
FROM nginx:alpine

# Copiar configuración de nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Eliminar contenido por defecto y copiar los archivos construidos
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/build /usr/share/nginx/html

# Exponer puerto
EXPOSE 80

# Comando para iniciar nginx
CMD ["nginx", "-g", "daemon off;"]