FROM openjdk:21-jdk-slim
WORKDIR /srv/android
# In real life, you’d install Android SDK/NDK; we’ll run the stub gradlew
COPY android ./android
WORKDIR /srv/android/android
RUN chmod +x ./gradlew
CMD ["./gradlew","release"]
