#!/usr/bin/env bash
set -euo pipefail

TARGET="$1"       # web|android|ios
ENV_NAME="$2"     # UAT|SIT|PROD
MW_USER="$3"
MW_PASS="$4"

# Call select_env via bash so it doesn't need +x permission
bash ci/scripts/select_env.sh "${ENV_NAME}"

echo "Deploying ${TARGET} to ${ENV_NAME} ..."
# Simulated middleware deploy call (safe if endpoint isn't live)
curl -sS -u "${MW_USER}:${MW_PASS}" -X POST \
  "https://middleware.${ENV_NAME}.digitalbank.example/deploy" \
  -d "service=${TARGET}&env=${ENV_NAME}" || true

echo "Deployed (simulated)."
