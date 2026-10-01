#!/usr/bin/env bash
# Regression test for scripts/fetch.sh.
#
# Uses a 2 MB slice of the real Lean release tarball: the server must support
# Range requests, the bytes must be verifiable, and the download must be fast
# enough not to hurt. Ground truth is fetched once, serially, and every case is
# compared against it byte for byte.
#
#   scripts/test_fetch.sh            # against lean 4.34.1 linux
#   scripts/test_fetch.sh <url> <bytes>
set -uo pipefail
cd "$(dirname "$0")/.."

URL="${1:-https://github.com/leanprover/lean4/releases/download/v4.34.1/lean-4.34.1-linux.tar.zst}"
BYTES="${2:-2000000}"
T=/tmp/fetchtest
PASS=0; FAIL=0

ok()   { echo "  PASS  $*"; PASS=$((PASS+1)); }
bad()  { echo "  FAIL  $*"; FAIL=$((FAIL+1)); }
check(){ if [ "$1" = 0 ]; then ok "$2"; else bad "$2"; fi; }

rm -rf "$T"; mkdir -p "$T"
LAST=$(echo "$BYTES" | awk '{print $1-1}')

echo "== ground truth: serial range download of $BYTES bytes"
if ! curl -fsSL --max-time 600 -r "0-$LAST" -o "$T/ref.bin" "$URL"; then
  echo "SKIP: cannot reach the server right now"; exit 77
fi
REF=$(sha256sum "$T/ref.bin" | cut -d' ' -f1)
echo "  sha256 = $REF"
echo

echo "== case 1: 8 parallel connections, sha256 enforced"
rm -f "$T/a.bin"
scripts/fetch.sh "$URL" "$T/a.bin" --conns 8 --size "$BYTES" --sha256 "$REF" >"$T/a.log" 2>&1
check $? "exit 0"
cmp -s "$T/ref.bin" "$T/a.bin"; check $? "bytes identical to serial download"
grep -q "8 range(s)" "$T/a.log"; check $? "split into 8 ranges"

echo "== case 2: re-run on a complete file does nothing"
before=$(date +%s)
scripts/fetch.sh "$URL" "$T/a.bin" --conns 8 --size "$BYTES" --sha256 "$REF" >"$T/b.log" 2>&1
check $? "exit 0"
grep -q "nothing to do" "$T/b.log"; check $? "short-circuits on a verified file"
after=$(date +%s)
[ $((after-before)) -lt 5 ]; check $? "returned immediately ($((after-before))s, no download)"

echo "== case 3: resume -- one good part kept, one truncated, rest missing"
CHUNK=$(( (BYTES + 7) / 8 ))
mkdir -p "$T/c.bin.parts"
: > "$T/c.bin.parts/index"
for i in 0 1 2 3 4 5 6 7; do
  s=$((i*CHUNK)); e=$((s+CHUNK-1)); [ "$e" -lt "$BYTES" ] || e=$((BYTES-1))
  [ "$s" -lt "$BYTES" ] || break
  printf '%d %d %d\n' "$i" "$s" "$e" >> "$T/c.bin.parts/index"
done
# part 000 is already correct and must be skipped
dd if="$T/ref.bin" of="$T/c.bin.parts/part.000" bs=1 count="$CHUNK" status=none
# part 001 is the right NAME but truncated -> must be re-fetched
head -c 100 /dev/zero | tr '\0' 'X' > "$T/c.bin.parts/part.001"
scripts/fetch.sh "$URL" "$T/c.bin" --conns 8 --size "$BYTES" --sha256 "$REF" >"$T/c.log" 2>&1
check $? "exit 0"
cmp -s "$T/ref.bin" "$T/c.bin"; check $? "resumed file is byte-identical"

echo "== case 4: wrong sha256 is rejected"
rm -f "$T/d.bin"
BAD_SHA=$(printf '%064d' 0)
scripts/fetch.sh "$URL" "$T/d.bin" --conns 4 --size "$BYTES" --sha256 "$BAD_SHA" >"$T/d.log" 2>&1
[ $? -ne 0 ]; check $? "exit non-zero on mismatch"
grep -q "sha256 mismatch" "$T/d.log"; check $? "reports the mismatch"

echo "== case 5: --conns 1 (degenerate, must still work)"
rm -f "$T/e.bin"
scripts/fetch.sh "$URL" "$T/e.bin" --conns 1 --size "$BYTES" --sha256 "$REF" >"$T/e.log" 2>&1
check $? "exit 0"
cmp -s "$T/ref.bin" "$T/e.bin"; check $? "bytes identical"

echo "== case 6: bad arguments are refused"
scripts/fetch.sh "$URL" "$T/f.bin" --conns 0            >/dev/null 2>&1; [ $? -ne 0 ]; check $? "--conns 0 rejected"
scripts/fetch.sh "$URL" "$T/f.bin" --sha256 deadbeef    >/dev/null 2>&1; [ $? -ne 0 ]; check $? "short sha rejected"
scripts/fetch.sh                                          >/dev/null 2>&1; [ $? -ne 0 ]; check $? "no args rejected"

echo
echo "passed $PASS, failed $FAIL   (artifacts in $T)"
[ "$FAIL" -eq 0 ]
