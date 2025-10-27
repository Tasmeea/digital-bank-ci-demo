FROM alpine:3.20
ARG MODE=debug
ARG APP_VERSION=0.0.0
ARG VERSION_CODE=1

# Simulate an APK build output for training.
# In a real setup you’d use an Android SDK image and run ./gradlew assemble<Variant>.
RUN mkdir -p /out && \
    echo "DBANK Android APK
Mode=${MODE}
AppVersion=${APP_VERSION}
VersionCode=${VERSION_CODE}
Built=$(date -u +%FT%TZ)
" > /out/app-${MODE}.apk

# (Optional) second variant to show multiple outputs; comment if not needed
RUN echo "Signed placeholder for ${MODE}" > /out/app-${MODE}-signed.apk
