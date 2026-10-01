#!/usr/bin/env bash
# One-time (and re-runnable) environment setup.
#
# Everything large lives on /mnt/extra/lean, version-keyed:
#   ~/.elan/toolchains -> /mnt/extra/lean/toolchains
#   .lake/packages      -> /mnt/extra/lean/packages/<project>-<version>
#   .lake/build         -> /mnt/extra/lean/packages/<project>-<version>/build
# See /mnt/extra/lean/README.md.
#
# Safe to re-run: elan and lake both skip work that is already done.
set -euo pipefail
cd "$(dirname "$0")/.."

mkdir -p logs
bash scripts/link_extra.sh

LOG="logs/setup-$(date +%Y%m%d-%H%M%S).log"
exec > >(tee -a "$LOG") 2>&1

echo "=== setup start $(date -Is) ==="
echo "toolchain file: $(cat lean-toolchain)"
echo "log: $LOG"

echo "--- 1/4 toolchain (parallel download, see scripts/install_toolchain.sh)"
bash scripts/install_toolchain.sh

echo "--- 2/4 lake update (fetch sources) ---"
lake update

echo "--- 3/4 mathlib cache (this is the big one, ~440MB) ---"
lake exe cache get

echo "--- 4/4 lake build ---"
lake build

echo "=== setup done $(date -Is) ==="
echo "next: scripts/smoke.sh"
