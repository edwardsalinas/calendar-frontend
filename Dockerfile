# Etapa de construcción
FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json yarn.lock ./

# ✅ Instalamos todas dependencias (incluyendo devDependencies)
RUN yarn install --frozen-lockfile

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

# Ahora debería funcionar correctamente
RUN yarn build