#!/bin/bash
# Post-install patch for opencode-restart: remove --ctty from setsid invocation
# This fixes "setsid: failed to set the controlling terminal: Operation not permitted"
# in environments without CAP_SYS_ADMIN (containers, restricted shells).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGETS=(
  "$SCRIPT_DIR/node_modules/opencode-restart/dist/index.js"
  "$HOME/.cache/opencode/packages/opencode-restart@latest/node_modules/opencode-restart/dist/index.js"
)

patched=0
for f in "${TARGETS[@]}"; do
  if [ -f "$f" ]; then
    if grep -q 'setsid --ctty --wait' "$f" 2>/dev/null; then
      sed -i 's/setsid --ctty --wait/setsid --wait/g' "$f"
      echo "  patched: $f"
      patched=$((patched + 1))
    else
      echo "  already clean: $f"
    fi
  fi
done

if [ "$patched" -gt 0 ]; then
  echo "Patched $patched file(s) — --ctty removed from setsid call."
else
  echo "Nothing to patch."
fi
