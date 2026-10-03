# USAGE

## Start here

```bash
scripts/status.sh          # one screen: toolchain, build, exercise progress
scripts/check.sh           # every exercise: how many holes are left
```

## elan

```bash
elan toolchain list            # installed toolchains
elan default                   # default toolchain
elan show                      # active toolchain + version
elan update stable             # bump to newest stable
```

`~/.elan/toolchains` is a symlink to `/mnt/extra/lean/toolchains`, so toolchains
survive but do not eat `/home`. `elan` is installed system-wide (`/usr/sbin/elan`),
not via `~/.elan/bin` — if `elan` is not found, do not re-run the rust installer.

Toolchain of this project is pinned by the file `lean-toolchain`
(`leanprover/lean4:v4.34.1`). `elan` auto-installs it on first `lake` call —
but see the download note below, we install it ourselves instead.

## Installing the toolchain (why not `elan toolchain install`)

This network throttles each TCP connection to ~25–65 KB/s but not the aggregate:
4 connections measured ~330 KB/s. The Lean tarball is 553 MB, so elan's single
connection would take 2+ hours.

```bash
scripts/install_toolchain.sh                  # version from lean-toolchain
DRYRUN=1 scripts/install_toolchain.sh        # print asset/url/sha256, download nothing
CONNS=32 scripts/install_toolchain.sh        # more connections
```

It fetches the release tarball with `scripts/fetch.sh` (N connections, sha256
checked against the digest GitHub publishes), unpacks it to
`/mnt/extra/lean/versions/v4.34.1/`, then hands elan the directory with
`elan toolchain link`. elan stores that as a symlink named
`leanprover--lean4---v4.34.1` inside `~/.elan/toolchains` — indistinguishable
from an elan-downloaded toolchain.

```bash
scripts/fetch.sh URL OUT --conns 16 --sha256 HASH
```

The downloader splits the file into byte ranges, fetches them concurrently,
keeps each range in `OUT.parts/` so an interrupted run resumes by re-running the
same command, concatenates, and verifies length + sha256. Test it any time with
`scripts/test_fetch.sh` (~2 MB, 15 assertions).

## lake

```bash
lake update                     # fetch/re-resolve dependencies
lake exe cache get              # download mathlib .olean cache (~440MB)
lake build                      # builds src/Toric only
lake build Toric.ToricVariety   # one module
lake clean                      # drop build artifacts (keeps packages)
```

`.lake/packages` and `.lake/build` are symlinks to
`/mnt/extra/lean/packages/lean-v4.34.1/` — see the table above.
`lake clean` drops build artifacts but keeps packages.

## Where the big files go

Every path under `/mnt/extra/lean` carries a version number, so you can keep
two toolchains side by side and roll back by re-pointing a link.

| in the project | on /mnt/extra |
|---|---|
| `~/.elan/toolchains` | `lean/toolchains/leanprover--lean4---v4.34.1` → `lean/versions/v4.34.1/` |
| `.lake/packages` | `lean/packages/lean-v4.34.1/` |
| `.lake/build` | `lean/packages/lean-v4.34.1/build/` |
| — | `lean/downloads/lean-4.34.1-linux.tar.zst` |
| — | `lean/versions/v4.34.1/` (unpacked toolchain, ~2.5 GB) |

The package dir is keyed by Lean version, because that is what decides the
package set: bumping `lean-toolchain` opens a fresh directory instead of mixing
`.olean` files from two compilers. Full rules: `/mnt/extra/lean/README.md`.

```bash
scripts/link_extra.sh            # follows ./lean-toolchain
scripts/link_extra.sh v4.35.0    # point at a different version
```

## Checking your work

`lake build` is slow because it builds the world. For one file, use:

```bash
scripts/check.sh exercise/01Rewriting.lean        # compile + hole count
scripts/check.sh -v exercise/01Rewriting.lean     # list every remaining hole
scripts/check.sh                                  # all exercises + total
```

`scripts/check.sh` is `lake env lean <file>` plus a hole count. The counter
(`scripts/holes.py`) blanks out comments and strings before looking for `sorry`,
so a hint that mentions "sorry" in prose is not counted as a hole. It is a
state machine across lines, because Lean's `/-!` doc comments span many lines.

| output | meaning |
|---|---|
| `洞数` | `sorry` in code = proofs you still owe |
| `声明数` | `example` / `theorem` / `lemma` in the file |
| `待完成声明数` | declarations that own at least one hole |

Exit 0 = compiles, 1 = errors, 2 = bad usage.

## Scripts

| script | what it does |
|---|---|
| `status.sh` | one-screen overview: toolchain, build, exercise progress, git, logs |
| `check.sh [-v] [FILE...]` | the homework checker. Compiles and counts remaining proofs |
| `setup_env.sh` | full setup: links + toolchain + `lake update` + cache + build. Re-runnable |
| `smoke.sh` | checks the environment still works |
| `new_exercise.sh FILE [title]` | scaffold a file in `exercise/` with the house rules |
| `link_extra.sh [v]` | (re)create the `/mnt/extra` symlinks for a Lean version |
| `install_toolchain.sh [TC]` | download + unpack + `elan toolchain link`. `DRYRUN=1` to preview |
| `fetch.sh URL OUT` | parallel chunked downloader (`--conns`, `--sha256`, `--size`). Resumable |
| `test_fetch.sh` | regression test for `fetch.sh`; downloads 2 MB and compares byte for byte |
| `copy_reference.sh [-f] DIR` | copy a reference repo into `examples/`, skipping build junk |
| `holes.py [-v] FILE` | the counter behind `check.sh`: holes / declarations / unfinished |
| `bg.sh [--name L] CMD...` | run a long command in a **new herdr pane**, log to `logs/run/` |

## Background jobs (herdr)

This repo sits inside herdr-managed panes, so long jobs go in their own pane
instead of blocking the one you are typing in.

```bash
scripts/bg.sh --name build lake build       # split right, run, log to logs/run/
herdr pane list                              # see all panes
herdr pane read w2:p4                        # tail a pane without switching
herdr pane close w2:p4
```

Focus is left on the original pane, so a new job never steals your cursor.

## Reference material

`examples/` holds read-only copies of reference repos. Do not edit them, and do
not expect them to compile — they pin older mathlib versions.

```bash
scripts/copy_reference.sh ~/Public/lean-toric        # copy source, skip .lake/.git
scripts/copy_reference.sh -f ~/Public/lean-GlimpseOfLean   # refresh
```

Then add a row to the table in `examples/README.md`.

## Logs

| dir | holds | git |
|---|---|---|
| `logs/run/` | setup, build, fetch, smoke output — machine generated | ignored |
| `logs/dev/` | hand-written journal, dated markdown files | tracked |