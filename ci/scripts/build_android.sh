#!/usr/bin/env bash
set -e
MODE="$1"          # debug|test|release|release-protected
ENV_NAME="$2"
VERSION_NAME="$3"
VERSION_CODE="$4"

./ci/scripts/select_env.sh "$ENV_NAME"
pushd android >/dev/null
./gradlew "$MODE"
popd >/dev/null
mkdir -p artifacts/android
cp android/build/outputs/apk/app-"$MODE".apk "artifacts/android/dbank-${VERSION_NAME}-${VERSION_CODE}-${MODE}.apk"
echo "ANDROID artifact: artifacts/android/dbank-${VERSION_NAME}-${VERSION_CODE}-${MODE}.apk"
