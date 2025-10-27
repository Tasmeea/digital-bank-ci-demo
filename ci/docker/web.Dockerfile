# ---------- Build stage ----------
FROM node:20-alpine AS builder
WORKDIR /app

# Build arg lets Jenkins pick the build mode (debug/test/release/release-protected)
ARG MODE=release

# Cache deps
COPY web/package*.json ./web/
RUN cd web && (npm ci || npm i)

# Copy source and build
COPY web ./web
WORKDIR /app/web
# Each build script writes a minimal dist/index.html as in your repo template
RUN npm run build:${MODE}

# ---------- Runtime stage ----------
FROM nginx:alpine
# Optional: drop a simple health page
RUN echo "ok" > /usr/share/nginx/html/health
# Copy static build to Nginx html
COPY --from=builder /app/web/dist/ /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
