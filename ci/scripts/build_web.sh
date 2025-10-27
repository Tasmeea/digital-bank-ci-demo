#!/usr/bin/env bash
set -e
MODE="$1"          # debug|test|release|release-protected
ENV_NAME="$2"      # UAT|SIT|PROD

./ci/scripts/select_env.sh "$ENV_NAME"
pushd web >/dev/null
npm run "build:${MODE}"
popd >/dev/null
mkdir -p artifacts/web
cp -r web/dist/* artifacts/web/
echo "WEB artifact ready at artifacts/web/"
