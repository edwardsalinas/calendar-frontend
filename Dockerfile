# Etapa de construcción
FROM node:18-alpine AS builder

WORKDIR /app

COPY package.json yarn.lock ./

# ✅ Ya no instalamos Yarn, lo usamos directamente
RUN yarn install --frozen-lockfile --production

COPY . .

ARG REACT_APP_ENV=dev
ENV REACT_APP_ENV=${REACT_APP_ENV}

# Configurar URL de API según el entorno
RUN if [ "$REACT_APP_ENV" = "prod" ]; then \
      echo "REACT_APP_API_URL=https://api.calendar-prod.com " >> .env; \
    elif [ "$REACT_APP_ENV" = "qa" ]; then \
      echo "REACT_APP_API_URL=https://api.calendar-qa.com " >> .env; \
    else \
      echo "REACT_APP_API_URL=https://api.calendar-dev.com " >> .env; \
    fi

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