#!/usr/bin/env bash
# One screen: where the project stands right now.
#
#   scripts/status.sh
#
# Reads, never writes. Safe to run any time.
set -uo pipefail
cd "$(dirname "$0")/.."

line() { printf '%s\n' "────────────────────────────────────────────────────────"; }

line
echo "lean · $(date '+%Y-%m-%d %H:%M')"
line

echo "TOOLCHAIN"
if lean --version >/dev/null 2>&1; then
  lean --version | head -1 | sed 's/^/  /'
  printf '  mathlib rev: '
  python3 - <<'PY' 2>/dev/null || echo "(no lake-manifest.json)"
import json
for p in json.load(open('lake-manifest.json'))['packages']:
    if p['name'] == 'mathlib':
        print(p.get('inputRev') or p.get('rev')); break
PY
else
  echo "  NOT INSTALLED — run scripts/setup_env.sh"
fi
printf '  disk on /mnt/extra: %s used\n' "$(du -sh /mnt/extra/lean 2>/dev/null | cut -f1)"

line
echo "BUILD"
if lake build >/dev/null 2>&1; then
  echo "  lake build  ok"
else
  echo "  lake build  FAILED — run: lake build"
fi

line
echo "EXERCISES"
shopt -s nullglob
files=(exercise/*.lean exercise/*/*.lean)
if [ ${#files[@]} -gt 0 ]; then
  th=0; tu=0; td=0
  for f in "${files[@]}"; do
    read -r h d u <<<"$(python3 scripts/holes.py "$f" | head -1)"
    printf '  %-40s %2d/%-2d 声明待完成  %3d 个洞\n' "$f" "$u" "$d" "$h"
    th=$((th+h)); tu=$((tu+u)); td=$((td+d))
  done
  printf '  %-40s %2d/%-2d 声明待完成  %3d 个洞\n' "TOTAL" "$tu" "$td" "$th"
  echo
  echo "  看每一个洞在哪:  scripts/check.sh -v exercise/01Rewriting.lean"
else
  echo "  (空)"
fi

line
echo "RECENT COMMITS"
git --no-pager log --oneline -5 2>/dev/null | sed 's/^/  /' || echo "  (no commits)"

n=$(git status --porcelain 2>/dev/null | grep -c . || true)
[ "$n" -gt 0 ] && echo "  uncommitted changes: $n"

line
echo "LATEST LOGS"
find logs -type f -printf '%T@ %p\n' 2>/dev/null | sort -rn | head -4 \
  | awk '{printf "  %s  %s\n", strftime("%m-%d %H:%M",$1), $2}'

line
echo "NEXT"
echo "  scripts/check.sh            # 每个练习还剩几个洞"
echo "  notes/                      # 记下你学到的东西"
line