#!/usr/bin/env bash
# (Re)create the symlinks that keep big files on /mnt/extra.
#
#   scripts/link_extra.sh            # version taken from ./lean-toolchain
#   scripts/link_extra.sh v4.34.1    # force a specific package dir
#
# Layout is documented in /mnt/extra/lean/README.md.
# Safe to re-run; existing links are replaced, real directories are left alone.
set -euo pipefail
cd "$(dirname "$0")/.."

ROOT=/mnt/extra/lean
PROJ=$(basename "$PWD")

V="${1:-$(sed -n 's|.*:\(v[0-9][^ ]*\).*|\1|p' lean-toolchain)}"
[ -n "$V" ] || { echo "cannot determine version from lean-toolchain" >&2; exit 1; }

PKG="$ROOT/packages/$PROJ-$V"

mkdir -p "$ROOT/toolchains" "$ROOT/downloads" "$PKG/build" .lake

link() {  # link <link-path> <target> <description>
  if [ -e "$1" ] && [ ! -L "$1" ]; then
    echo "SKIP  $1 is a real directory, not a symlink -- move it yourself first"
    return
  fi
  ln -sfn "$2" "$1"
  echo "link  $1 -> $(readlink -f "$1")"
}

link "$HOME/.elan/toolchains" "$ROOT/toolchains"                     "elan store"
link ".lake/packages"          "$PKG"                                "lake sources"
link ".lake/build"             "$PKG/build"                           "lake build"

echo
echo "Lean version : $V"
echo "package dir  : $PKG"
echo "now run:     scripts/setup_env.sh"
