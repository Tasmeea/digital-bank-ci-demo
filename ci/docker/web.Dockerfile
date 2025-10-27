FROM node:20-alpine
WORKDIR /app
COPY web/package.json web/package-lock.json* ./web/
RUN cd web && npm ci || npm i
COPY web ./web
WORKDIR /app/web
CMD ["npm","run","build:release"]
