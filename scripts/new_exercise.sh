#!/usr/bin/env bash
# Scaffold a new exercise file with the house rules baked in.
#
#   scripts/new_exercise.sh exercise/02Iff.lean "iff and propositional logic"
#   scripts/new_exercise.sh exercise/Topics/RingTheory.lean
#
# The skeleton, the comment header, and the first 1-2 tactics of each proof are
# yours to fill in. This script only creates the shell.
set -euo pipefail
cd "$(dirname "$0")/.."

f="${1:-}"
title="${2:-}"

if [ -z "$f" ]; then
  echo "usage: $0 <path.lean> [title]" >&2
  exit 2
fi

case "$f" in
  exercise/*) ;;
  *) echo "练习应该放在 exercise/ 下：$f" >&2; exit 2 ;;
esac

if [ -e "$f" ]; then
  echo "already exists: $f" >&2
  exit 1
fi

mkdir -p "$(dirname "$f")"

{
  echo "import Mathlib"
  echo
  echo "-- $(basename "$f" .lean)${title:+  — $title}"
  echo "--"
  echo "-- 题目来源：examples/GlimpseOfLean/Exercises/"
  echo "-- 对应的答案在 examples/GlimpseOfLean/Solutions/（最后才看）"
  echo "-- 讲解见 notes/00-GlimpseOfLean.md"
  echo
  echo "/-- 第一个例子：先自己试，卡住了再往下看提示。 -/"
  echo "theorem exercise : 1 + 1 = 2 := by"
  echo "  -- 你写证明。检查：scripts/check.sh $f"
  echo "  sorry"
} > "$f"

echo "created: $f"
echo "check:   scripts/check.sh $f"
echo "hint:    看 examples/GlimpseOfLean/Solutions/ 同名文件的第一题"