#!/usr/bin/env bash
set -e
HOOK="$1"
if [ "$HOOK" = "true" ]; then
  echo "[HOOK] Running custom hook..."
  # simulate any domain hook here
  # e.g., lint, schema check, security scan...
  sleep 1
  echo "[HOOK] Done."
else
  echo "[HOOK] Skipped."
fi
