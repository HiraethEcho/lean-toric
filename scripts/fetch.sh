#!/usr/bin/env bash
# Parallel chunked downloader.
#
# Why: this network throttles each connection to ~25-65 KB/s but not the
# aggregate, so N connections give roughly N times the throughput.
# elan/lake download over a single connection and would take hours.
#
#   scripts/fetch.sh URL OUT [--conns N] [--sha256 HASH] [--size BYTES]
#   scripts/fetch.sh URL OUT --size 100          # pretend it is 100 bytes (test)
#
# Behaviour:
#   * size comes from the server's Content-Length (override with --size)
#   * the file is cut into N byte ranges, fetched concurrently
#   * each range is written to its own part file and SKIPPED if already the
#     right length, so an interrupted run resumes by just re-running the command
#   * parts are concatenated, then the total length and sha256 are checked
#
# On a failed run the parts are left in place. Re-run the same command to resume.
set -euo pipefail

URL=""; OUT=""; CONNS=8; SHA=""; SIZE=""
TMPKEEP=""

die() { echo "fetch.sh: $*" >&2; exit 1; }
usage() { sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'; exit 2; }

while [ $# -gt 0 ]; do
  case "$1" in
    --conns) CONNS="$2"; shift 2 ;;
    --sha256|--sha) SHA="$2"; shift 2 ;;
    --size) SIZE="$2"; shift 2 ;;
    -h|--help) usage ;;
    -*) die "unknown option $1" ;;
    *) if [ -z "$URL" ]; then URL="$1"; elif [ -z "$OUT" ]; then OUT="$1";
       else die "too many positional args"; fi; shift ;;
  esac
done

[ -n "$URL" ] && [ -n "$OUT" ] || usage
case "$CONNS" in ''|*[!0-9]*) die "--conns must be a positive integer" ;; esac
[ "$CONNS" -ge 1 ] || die "--conns must be >= 1"
[ -z "$SHA" ] || [[ "$SHA" =~ ^[0-9a-fA-F]{64}$ ]] || die "--sha256 must be 64 hex chars"

mkdir -p "$(dirname "$OUT")"
OUT="$(cd "$(dirname "$OUT")" && pwd)/$(basename "$OUT")"
WORK="$OUT.parts"

# ---------------------------------------------------------------- size + ranges
if [ -z "$SIZE" ]; then
  echo ">> HEAD $URL"
  HEADERS=$(curl -fsSIL --connect-timeout 20 --max-time 60 "$URL" 2>/dev/null) \
    || die "HEAD failed (network down, or the URL needs auth?)"
  SIZE=$(printf '%s\n' "$HEADERS" | tr -d '\r' | awk 'tolower($1)=="content-length:"{v=$2} END{print v}')
  RANGES=$(printf '%s\n' "$HEADERS" | tr -d '\r' | awk 'tolower($1)=="accept-ranges:"{print $2}' | tail -1)
  [ -n "$SIZE" ] && [ "$SIZE" -gt 0 ] 2>/dev/null \
    || die "no Content-Length from server; pass --size BYTES"
  [ "${RANGES:-}" = "bytes" ] \
    || echo "!! server did not advertise Accept-Ranges: bytes; range requests may fail" >&2
fi
[ "$SIZE" -gt 0 ] || die "--size must be > 0"

if [ -f "$OUT" ]; then
  HAVE=$(stat -c%s "$OUT")
  if [ "$HAVE" = "$SIZE" ]; then
    if [ -z "$SHA" ] || [ "$(sha256sum "$OUT" | cut -d' ' -f1)" = "${SHA,,}" ]; then
      echo ">> $OUT already complete and verified; nothing to do"
      rm -rf "$WORK"
      exit 0
    fi
  fi
  echo ">> existing $OUT is wrong ($HAVE != $SIZE bytes), re-downloading"
  mv -f "$OUT" "$OUT.bad.$(date +%s)"
fi

mkdir -p "$WORK"

CHUNK=$(( (SIZE + CONNS - 1) / CONNS ))
: > "$WORK/index"
for i in $(seq 0 $((CONNS - 1))); do
  s=$(( i * CHUNK ))
  [ "$s" -lt "$SIZE" ] || break
  e=$(( s + CHUNK - 1 ))
  [ "$e" -lt "$SIZE" ] || e=$(( SIZE - 1 ))
  printf '%d %d %d\n' "$i" "$s" "$e" >> "$WORK/index"
done
NPARTS=$(wc -l < "$WORK/index")

echo ">> $SIZE bytes, $NPARTS range(s) of ~$(( CHUNK / 1024 )) KiB, ${CONNS} connection(s)"
echo ">> work dir: $WORK"

# ---------------------------------------------------------------- one part
partfile() { printf '%s/part.%03d' "$WORK" "$1"; }

fetch_part() {
  local i="$1" s="$2" e="$3"
  local p; p=$(partfile "$i")
  local want=$(( e - s + 1 )) attempt
  if [ -f "$p" ] && [ "$(stat -c%s "$p")" = "$want" ]; then
    return 0                      # already have this range
  fi
  rm -f "$p.tmp"
  for attempt in 1 2 3 4; do
    if curl -fsSL --connect-timeout 20 --max-time 3600 \
            --retry 2 --retry-all-errors \
            --speed-time 45 --speed-limit 2048 \
            -r "$s-$e" -o "$p.tmp" "$URL"; then
      got=$(stat -c%s "$p.tmp")
      if [ "$got" = "$want" ]; then
        mv -f "$p.tmp" "$p"
        return 0
      fi
      # a server ignoring Range sends the whole body: truncate and retry
      if [ "$got" -gt "$want" ]; then
        head -c "$want" "$p.tmp" > "$p" && rm -f "$p.tmp" && return 0
      fi
      echo "   part $i: got $got bytes, want $want" >&2
    fi
    sleep $(( attempt * 3 ))
  done
  rm -f "$p.tmp"
  return 1
}

# ---------------------------------------------------------------- download
for pass in 1 2 3; do
  failed=0; running=0
  : > "$WORK/failed"
  while read -r i s e; do
    ( fetch_part "$i" "$s" "$e" || echo "$i $s $e" >> "$WORK/failed" ) &
    running=$(( running + 1 ))
  done < "$WORK/index"
  wait
  failed=$(wc -l < "$WORK/failed")

  echo ">> pass $pass: $(( NPARTS - failed ))/$NPARTS parts complete"
  [ "$failed" -eq 0 ] && break
  [ "$pass" -lt 3 ] && echo ">> retrying $failed part(s)" && sleep 5
done

if [ "$(wc -l < "$WORK/failed")" -ne 0 ]; then
  echo "FAILED: $(wc -l < "$WORK/failed") part(s) could not be downloaded." >&2
  echo "        parts kept in $WORK -- just re-run this command to resume." >&2
  exit 1
fi

# ---------------------------------------------------------------- assemble
echo ">> concatenating"
cat "$WORK"/part.* > "$OUT.tmp"

GOT=$(stat -c%s "$OUT.tmp")
if [ "$GOT" != "$SIZE" ]; then
  mv -f "$OUT.tmp" "$OUT"
  die "assembled size $GOT != expected $SIZE"
fi

if [ -n "$SHA" ]; then
  GOT_SHA=$(sha256sum "$OUT.tmp" | cut -d' ' -f1)
  if [ "$GOT_SHA" != "${SHA,,}" ]; then
    mv -f "$OUT.tmp" "$OUT"
    echo "FAILED: sha256 mismatch" >&2
    echo "  expected ${SHA,,}" >&2
    echo "  actual   $GOT_SHA" >&2
    echo "  parts kept in $WORK; delete them to force a clean re-download" >&2
    exit 1
  fi
  echo ">> sha256 OK ${GOT_SHA}"
fi

mv -f "$OUT.tmp" "$OUT"
rm -rf "$WORK"
echo ">> done: $OUT ($SIZE bytes)"
