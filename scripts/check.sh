#!/usr/bin/env bash
# Check one exercise file, and show how far along you are.
#
#   scripts/check.sh exercise/01Rewriting.lean
#   scripts/check.sh -v exercise/01Rewriting.lean   # list every remaining hole
#   scripts/check.sh                                # every exercise + a total
#
# `lake env lean <file>` plus a hole count, so you can watch the number go down
# without reading compiler warnings. See scripts/holes.py for the counting.
#
# Exit 0 = compiles (sorries allowed), 1 = errors, 2 = bad usage.
set -uo pipefail
cd "$(dirname "$0")/.."

VERBOSE=0
case "${1:-}" in
  -v|--verbose) VERBOSE=1; shift ;;
  -h|--help) sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'; exit 2 ;;
esac

holes_of() { python3 scripts/holes.py "$1" | head -1; }

report() {
  local f="$1" out rc
  out=$(lake env lean "$f" 2>&1); rc=$?

  local holes decls unfinished
  read -r holes decls unfinished <<<"$(holes_of "$f")"

  printf '\n%s\n' "$f"
  if [ "$unfinished" -eq 0 ]; then
    printf '  \033[32m全部完成 ✓\033[0m  %d 个声明\n' "$decls"
  else
    printf '  声明 %d 个，其中 \033[1m%d\033[0m 个待完成，共 %d 个证明待填\n' \
      "$decls" "$unfinished" "$holes"
  fi

  if [ "$rc" -eq 0 ]; then
    printf '  \033[32m编译通过\033[0m\n'
  else
    printf '  \033[31m编译失败\033[0m\n'
    printf '%s\n' "$out" | grep -v 'declaration uses `sorry`' | sed 's/^/    /' | head -30
  fi

  [ "$VERBOSE" -eq 1 ] && [ "$holes" -gt 0 ] && python3 scripts/holes.py -v "$f" | tail -n +2
  return $rc
}

if [ $# -eq 0 ]; then
  shopt -s nullglob
  files=(exercise/*.lean exercise/*/*.lean)
  [ ${#files[@]} -gt 0 ] || { echo "exercise/ 里没有 .lean 文件" >&2; exit 2; }
  rc=0; th=0; tu=0; td=0
  for f in "${files[@]}"; do
    report "$f" || rc=1
    read -r h d u <<<"$(holes_of "$f")"
    th=$((th+h)); tu=$((tu+u)); td=$((td+d))
  done
  printf '\n合计：%d 个声明，%d 个待完成，%d 个证明待填\n' "$td" "$tu" "$th"
  exit $rc
fi

rc=0
for f in "$@"; do
  [ -f "$f" ] || { echo "no such file: $f" >&2; rc=2; continue; }
  report "$f" || rc=1
done
exit $rc