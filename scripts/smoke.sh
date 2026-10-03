#!/usr/bin/env bash
# Environment smoke test. Run after scripts/setup_env.sh, and any time you
# suspect the toolchain or the mathlib cache is broken.
#
# Touches one thing from each corner of mathlib so a broken toolchain or a
# missing cache entry fails loudly instead of silently.
set -euo pipefail
cd "$(dirname "$0")/.."

echo "toolchain: $(lean --version)"
echo "lean path: $(lake env printenv LEAN_PATH | tr ':' '\n' | wc -l) entries"
lake env lean scripts/tests/Smoke.lean
echo "SMOKE OK"