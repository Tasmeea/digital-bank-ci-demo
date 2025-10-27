FROM node:20-alpine AS builder
WORKDIR /app

ARG MODE=release

# cache deps if lockfile exists
COPY web/package*.json ./web/
RUN sh -c 'cd web && if [ -f package-lock.json ]; then npm ci; else npm i; fi'

COPY web ./web
WORKDIR /app/web
RUN npm run build:${MODE}

FROM nginx:alpine
RUN echo "ok" > /usr/share/nginx/html/health
COPY --from=builder /app/web/dist/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
