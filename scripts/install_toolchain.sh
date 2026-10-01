#!/usr/bin/env bash
# Install the Lean toolchain from the GitHub release tarball, in parallel.
#
# Why not `elan toolchain install`: elan downloads over a single connection,
# and this network caps one connection at ~25-65 KB/s -- 553 MB would take
# 2+ hours. scripts/fetch.sh uses N connections; the aggregate is several times
# faster. Everything else (the tarball, its sha256, the unpacked tree) is the
# same, and `elan toolchain link` hands elan a directory it cannot tell apart
# from one it downloaded itself.
#
#   scripts/install_toolchain.sh                     # version from lean-toolchain
#   scripts/install_toolchain.sh leanprover/lean4:v4.34.1
#   CONNS=32 scripts/install_toolchain.sh            # more connections
#
# Idempotent: re-running is a no-op once the toolchain works.
set -euo pipefail
cd "$(dirname "$0")/.."

ROOT=/mnt/extra/lean
CONNS="${CONNS:-16}"
DRYRUN="${DRYRUN:-0}"
TC="${1:-$(cat lean-toolchain)}"

die() { echo "install_toolchain.sh: $*" >&2; exit 1; }

case "$TC" in
  *:v*) VER="${TC##*:v}" ;;          # v4.34.1 -> 4.34.1, leading v stripped
  *)    die "cannot read a version out of '$TC'" ;;
esac
REPO="${TC%:*}"                 # e.g. leanprover/lean4
ORG="${REPO%%/*}"; NAME="${REPO##*/}"
ASSET="lean-$VER-linux.tar.zst"

[ "$(uname -s)" = Linux ] || { echo "only linux is handled here" >&2; exit 1; }
case "$(uname -m)" in x86_64|amd64) ;; aarch64|arm64) ASSET="lean-$VER-linux_aarch64.tar.zst" ;; esac

URL="https://github.com/$ORG/$NAME/releases/download/v$VER/$ASSET"
DL="$ROOT/downloads/$ASSET"
TREE="$ROOT/versions/v$VER"

echo "=== install toolchain $TC ==="
echo "    asset    $ASSET"
echo "    download $DL"
echo "    tree     $TREE"

# ---------------------------------------------------------------- already there?
if elan toolchain list 2>/dev/null | grep -qx "$TC" && lean --version 2>/dev/null | grep -q .; then
  echo "--- $TC is already installed and working:"
  lean --version
  exit 0
fi

# ---------------------------------------------------------------- digest
SHA=""
digest_api() {
  # GitHub publishes a sha256 per release asset; python3 is always here, jq may not be.
  curl -fsSL --max-time 30 "https://api.github.com/repos/$ORG/$NAME/releases/tags/v$VER" 2>/dev/null \
  | python3 -c "
import sys, json
try: d = json.load(sys.stdin)
except Exception: sys.exit(0)
for a in d.get('assets', []):
    if a['name'] == '$ASSET':
        print((a.get('digest') or '').removeprefix('sha256:'))
" || true
}
SHA=$(digest_api)
if [ -n "$SHA" ]; then
  echo "    sha256   $SHA"
else
  echo "    sha256   (none published, or the GitHub API is unreachable;" \
       "download will NOT be verified)" >&2
fi

if [ "$DRYRUN" = 1 ]; then
  echo "    DRYRUN: stopping before the download"
  exit 0
fi

# ---------------------------------------------------------------- fetch
bash scripts/fetch.sh "$URL" "$DL" --conns "$CONNS" ${SHA:+--sha256 "$SHA"}

# ---------------------------------------------------------------- unpack
if [ ! -x "$TREE/bin/lean" ]; then
  mkdir -p "$ROOT/versions"
  TMP=$(mktemp -d "$ROOT/versions/.unpack-$VER.XXXXXX")
  trap 'rm -rf "$TMP"' EXIT
  echo "--- unpacking (this takes a few minutes, ~2.5 GB)"
  tar --zstd -xf "$DL" -C "$TMP"
  INNER=$(find "$TMP" -maxdepth 1 -mindepth 1 -type d | head -1)
  [ -n "$INNER" ] || { echo "tarball did not contain a top-level directory" >&2; exit 1; }
  rm -rf "$TREE"
  mv "$INNER" "$TREE"
  rm -rf "$TMP"; trap - EXIT
else
  echo "--- $TREE already unpacked"
fi
"$TREE/bin/lean" --version >/dev/null || { echo "unpacked tree does not run" >&2; exit 1; }

# ---------------------------------------------------------------- hand to elan
echo "--- linking into elan"
elan toolchain link "$TC" "$TREE"
elan default "$TC"

echo "--- result"
elan show 2>&1 | head -4
echo "OK"
