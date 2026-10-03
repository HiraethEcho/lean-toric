#!/usr/bin/env bash
# Run a long command in a NEW herdr pane (never blocks this one).
#   scripts/bg.sh lake build
#   scripts/bg.sh --name cache lake exe cache get
set -euo pipefail
cd "$(dirname "$0")/.."

name="bg"
if [ "${1:-}" = "--name" ]; then
  name="$2"
  shift 2
fi

if [ $# -eq 0 ]; then
  echo "usage: $0 [--name LABEL] <command...>" >&2
  exit 2
fi

log="logs/run/$(date +%Y%m%d-%H%M%S)-$name.log"
mkdir -p logs

pane=$(herdr pane split --current --direction right --ratio 0.45 --cwd "$PWD" --no-focus \
        | grep -o '"pane_id":"[^"]*"' | head -1 | cut -d'"' -f4)

herdr pane rename "$pane" "$name" >/dev/null

herdr pane run "$pane" \
  "cd $(printf '%q' "$PWD") && $* 2>&1 | tee $(printf '%q' "$log"); echo; echo '[ENTER] close pane'; read -r"

echo "pane:    $pane   ($name)"
echo "log:     $log"
echo "watch:   herdr pane read $pane"
echo "close:   herdr pane close $pane"
