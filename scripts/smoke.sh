#!/usr/bin/env bash
# Environment smoke test. Run this after scripts/setup_env.sh, and any time
# you suspect the toolchain / mathlib cache is broken.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "toolchain: $(lean --version)"
echo "lean path: $(lake env printenv LEAN_PATH | tr ':' '\n' | wc -l) entries"
lake env lean test/Smoke.lean
echo "SMOKE OK"
