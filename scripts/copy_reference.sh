#!/usr/bin/env bash
# Copy a reference Lean repository into references/ without the build junk.
#
#   scripts/copy_reference.sh ~/Public/lean-toric Toric Toric.lean
#   scripts/copy_reference.sh ~/Public/lean-GlimpseOfLean Introduction Exercises
#   scripts/copy_reference.sh -f ~/Public/lean-toric Toric Toric.lean   # refresh
#
# Optional trailing arguments are the paths to take; with none, the whole repo
# minus the junk below. Name the subdirectories you actually want -- a bare
# copy drags in website/, CI config and license files that have no reading value.
#
# Destination is always `references/<name>` where <name> is the source directory
# with a leading "lean-" stripped and lowercased. references/ is the read-only
# side: exercise trees and upstream sources. Worked answers that you want on a
# shelf go into examples/ by hand.
#
# Skips .lake, .git, .github, .gitpod.yml, .devcontainer, .vscode, node_modules,
# *.olean, *.ilean, *.c, *.o, archives, and the blueprint build output
# (print/, web/, doc-gen/, lean_decls) -- those are gigabytes or CI noise.
# The compiled blueprint PDF is not copied either; it is built locally from
# upstream and lives at references/toric/Toric.pdf.
#
# Never overwrite: refuses if the destination directory already exists,
# unless you pass -f. A -f refresh keeps any *.pdf already in the destination,
# because those are ours (compiled blueprints), and upstream cannot replace them.
set -euo pipefail
cd "$(dirname "$0")/.."

FORCE=0
case "${1:-}" in
  -f|--force) FORCE=1; shift ;;
  -h|--help) sed -n '2,25p' "$0" | sed 's/^# \{0,1\}//'; exit 2 ;;
esac

SRC="${1:-}"
[ -n "$SRC" ] || { echo "usage: $0 [-f] <path-to-reference-repo> [path...]" >&2; exit 2; }
[ -d "$SRC" ] || { echo "not a directory: $SRC" >&2; exit 2; }
shift
PATHS=("$@")
[ "${#PATHS[@]}" -gt 0 ] || PATHS=(.)
for p in "${PATHS[@]}"; do
  [ -e "$SRC/$p" ] || { echo "no such path in $SRC: $p" >&2; exit 2; }
done

SRC=$(cd "$SRC" && pwd)
DST="references/$(basename "$SRC" | sed 's/^lean-//' | tr '[:upper:]' '[:lower:]')"

if [ -e "$DST" ] && [ "$FORCE" -eq 0 ]; then
  echo "$DST already exists; pass -f to refresh it" >&2
  exit 1
fi

echo "copying $SRC (${PATHS[*]})"
echo "     -> $DST"

( cd "$SRC" && tar cf - \
    --exclude='.lake' --exclude='.git' --exclude='.github' --exclude='.gitpod.yml' \
    --exclude='.devcontainer' --exclude='.vscode' \
    --exclude='*.olean' --exclude='*.ilean' --exclude='*.c' --exclude='*.o' \
    --exclude='*.tar.zst' --exclude='*.zip' --exclude='node_modules' \
    --exclude='print' --exclude='web' --exclude='lean_decls' --exclude='doc-gen' \
    "${PATHS[@]}" ) | ( rm -rf "$DST.tmp" && mkdir -p "$DST.tmp" && cd "$DST.tmp" && tar xf - )

rm -rf "$DST.old"
if [ -e "$DST" ]; then
  # A refresh must not throw away PDFs we compiled ourselves -- upstream has
  # nothing to replace them with (the blueprint source is not even copied in).
  keep=$(mktemp -d)
  found=0
  while IFS= read -r -d '' pdf; do
    rel=${pdf#"$DST"/}
    mkdir -p "$keep/$(dirname "$rel")"
    cp "$pdf" "$keep/$rel"
    found=1
  done < <(find "$DST" -name '*.pdf' -print0)
  mv "$DST" "$DST.old"
  mv "$DST.tmp" "$DST"
  if [ "$found" -eq 1 ]; then
    while IFS= read -r -d '' pdf; do
      rel=${pdf#"$keep"/}
      mkdir -p "$DST/$(dirname "$rel")"
      cp "$pdf" "$DST/$rel"
    done < <(find "$keep" -name '*.pdf' -print0)
    echo "kept our own PDFs across the refresh:"
    find "$DST" -name '*.pdf' -printf '  %P\n'
  fi
  rm -rf "$DST.old" "$keep"
else
  mv "$DST.tmp" "$DST"
fi

echo
echo "copied: $(du -sh "$DST" | cut -f1)   files: $(find "$DST" -type f | wc -l)"
echo
echo "剩下的 .lake / .git / *.olean 没跟过来 —— 那是构建产物，参考用不上。"
echo "blueprint 的 print/ 和 web/ 也没跟过来。要那个 PDF，去上游编："
echo "  cd <repo>/blueprint/src && latexmk        # 产物 ../print/print.pdf，需要 xelatex"
echo "现在去 references/README.md 的清单表加一行。"
