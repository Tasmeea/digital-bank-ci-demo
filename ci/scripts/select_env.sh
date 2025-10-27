#!/usr/bin/env bash
set -e
ENV_NAME="$1"
FILE="env-config/${ENV_NAME}.env"
if [ ! -f "$FILE" ]; then
  echo "Env file not found: $FILE"; exit 1
fi
echo "Using env: $FILE"
export $(grep -v '^#' "$FILE" | xargs -0 -I{} echo {} | tr '\n' ' ')
