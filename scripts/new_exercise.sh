#!/usr/bin/env bash
# Scaffold a new exercise / experiment file with the house rules baked in.
#   scripts/new_exercise.sh examples/Topics/RingTheory.lean "sample theorem"
set -euo pipefail
cd "$(dirname "$0")/.."

f="${1:-}"
title="${2:-}"

if [ -z "$f" ]; then
  echo "usage: $0 <path.lean> [title]" >&2
  exit 2
fi

if [ -e "$f" ]; then
  echo "already exists: $f" >&2
  exit 1
fi

mkdir -p "$(dirname "$f")"

{
  echo "import Mathlib"
  echo
  echo "-- $(basename "$f" .lean)${title:+ -- $title}"
  echo "--"
  echo "-- TODO: statement goes here."
  echo "-- Try: rewrite the goal into a known mathlib lemma, then apply it."
  echo "theorem exercise : 1 + 1 = 2 := by"
  echo "  -- write the proof yourself; see notes/ for tactic recipes"
  echo "  sorry"
} > "$f"

echo "created: $f"
echo "check:   scripts/check.sh $f"
