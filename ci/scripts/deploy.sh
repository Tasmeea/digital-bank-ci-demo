#!/usr/bin/env bash
set -e
TARGET="$1"       # web|android|ios
ENV_NAME="$2"
MW_USER="$3"
MW_PASS="$4"

./ci/scripts/select_env.sh "$ENV_NAME"
echo "Deploying $TARGET to $ENV_NAME ..."
# simulate a middleware call with credentials
curl -u "${MW_USER}:${MW_PASS}" -X POST "https://middleware.${ENV_NAME}.digitalbank.example/deploy" \
  -d "service=${TARGET}&env=${ENV_NAME}" || true
echo "Deployed (simulated)."
