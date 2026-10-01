#!/usr/bin/env bash
# Fast check of ONE file, no full lake build.
#   scripts/check.sh src/Toric/Defs.lean
#   scripts/check.sh examples/01Rewriting.lean
set -euo pipefail
cd "$(dirname "$0")/.."

if [ $# -eq 0 ]; then
  echo "usage: $0 <file.lean>" >&2
  exit 2
fi

f="$1"
if [ ! -f "$f" ]; then
  echo "no such file: $f" >&2
  exit 2
fi

# `lake env` only sets LEAN_PATH; it does not build anything.
exec lake env lean "$f"
