FROM alpine:3.20

# Build-time parameters (come from --build-arg in Jenkins)
ARG MODE=debug
ARG APP_VERSION=0.0.0
ARG VERSION_CODE=1

# Produce a placeholder "APK" file (a text artifact) for training
# Use printf to avoid Docker parser surprises
RUN mkdir -p /out && \
    printf "DBANK Android APK\nMode=%s\nAppVersion=%s\nVersionCode=%s\nBuilt=%s\n" \
        "$MODE" "$APP_VERSION" "$VERSION_CODE" "$(date -u +%FT%TZ)" \
        > /out/app-${MODE}.apk \
    && printf "Signed placeholder for %s\n" "$MODE" > /out/app-${MODE}-signed.apk
