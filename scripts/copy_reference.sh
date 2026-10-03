#!/usr/bin/env bash
# Copy a reference Lean repository into examples/ without the junk.
#
#   scripts/copy_reference.sh ~/Public/lean-toric
#   scripts/copy_reference.sh ~/Public/lean-GlimpseOfLean     # refresh existing
#
# Takes .lean / .md / .tex / .pdf / lakefile.toml / lean-toolchain / LICENSE
# and the top-level *.py scripts. Skips .lake, .git, *.olean, build output --
# those are gigabytes and mean nothing as a reference.
#
# Never overwrite: refuses if the destination directory already exists,
# unless you pass -f.
set -euo pipefail
cd "$(dirname "$0")/.."

FORCE=0
case "${1:-}" in
  -f|--force) FORCE=1; shift ;;
  -h|--help) sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'; exit 2 ;;
esac

SRC="${1:-}"
[ -n "$SRC" ] || { echo "usage: $0 [-f] <path-to-reference-repo>" >&2; exit 2; }
[ -d "$SRC" ] || { echo "not a directory: $SRC" >&2; exit 2; }

SRC=$(cd "$SRC" && pwd)
DST="examples/$(basename "$SRC" | tr '[:upper:]' '[:lower:]')"

if [ -e "$DST" ] && [ "$FORCE" -eq 0 ]; then
  echo "$DST already exists; pass -f to refresh it" >&2
  exit 1
fi

echo "copying $SRC"
echo "     -> $DST"

( cd "$SRC" && tar cf - \
    --exclude='.lake' --exclude='.git' --exclude='.github' \
    --exclude='*.olean' --exclude='*.ilean' --exclude='*.c' --exclude='*.o' \
    --exclude='*.tar.zst' --exclude='*.zip' --exclude='node_modules' \
    . ) | ( mkdir -p "$DST" && cd "$DST" && tar xf - )

echo
echo "copied: $(du -sh "$DST" | cut -f1)   files: $(find "$DST" -type f | wc -l)"
echo
echo "剩下的 .lake / .git / *.olean 没跟过来 —— 那是构建产物，参考用不上。"
echo "现在去 examples/README.md 的清单表加一行。"