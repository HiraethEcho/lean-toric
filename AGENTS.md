# AGENTS

## Rules

- `exercise/` and `src/` are the student's code: write skeletons + comments
  only, never the proof. You may show the first 1–2 tactics; they write the
  rest.
- `examples/` and `references/` are read-only. Never edit them — they are the
  only clean comparison object, and editing one destroys its value.
- When they say an exercise is done, run `scripts/check.sh <file>` and report
  the remaining count. If it still has holes, say so plainly.
- Talk zh/en mixed, keep technical terms in English. Code and its identifiers
  in English.
- Be concise. Write only what is necessary; no filler.
- Never `git commit` without explicit approval.
- Big files (data, models, package caches) live on `/mnt/extra`, version-keyed,
  symlinked into the repo — see `USAGE.md`.
- Long jobs (lake update, cache get, lake build, latexmk) go into another herdr
  pane via `scripts/bg.sh`, never blocking this one.

## Layout

```
exercise/     the student's code — skeletons in, proofs out
src/          the student's real Lean library (Phase 2 target: src/Toric/)
examples/     worked examples: GlimpseOfLean Solutions + its Library/
references/   read-only upstream: GlimpseOfLean Exercises, lean-toric Toric/ + its blueprint PDF
notes/        knowledge worth keeping (markdown)
logs/run/     machine output, gitignored
logs/dev/     hand-written journal, tracked
scripts/      helper scripts; scripts/tests/ holds the Lean smoke test
README.md     for humans      USAGE.md for commands      PLAN.md for the roadmap
```

| path | what |
|---|---|
| `exercise/` | their exercises, `sorry` holes to fill |
| `src/Toric/` | the `lean-toric` reproduction, mirrors `references/toric/Toric/` (Phase 2 — does not exist yet). This is a *hand-typing* exercise: a machine-copied, already-compiling version exists in the sibling project repo, so do not treat copying as the exercise. See "Not this repo" below |
| `examples/GlimpseOfLean/Solutions/` | full answers. Look only after 30 minutes stuck |
| `examples/GlimpseOfLean/Library/` | the upstream teaching-patch layer `Solutions/` imports |
| `references/GlimpseOfLean/Exercises/` | exercise text, `sorry` version — where the skeletons come from |
| `references/GlimpseOfLean/Introduction.lean` | the tutorial's read-along first proof |
| `references/toric/Toric/` | the lean-toric source tree, 18 files |
| `references/toric/Toric.pdf` | the compiled blueprint, 30 pages. Its LaTeX source stays upstream |
| `notes/` | knowledge worth keeping (markdown) |
| `logs/` | `run/` machine output, `dev/` journal |
| `scripts/` | helpers |

Neither `exercise/`, `examples/` nor `references/` is a `lean_lib`: exercises
carry `sorry`s and the other two are read-only.

Correction to what this file used to say: `references/toric/Toric/` **does** compile
here. It claimed it "cannot compile here at all" because upstream pins toolchain
`v4.34.0-rc2` + mathlib `62d0e07` while this repo is `v4.34.1`. The pin difference is
real; the conclusion was not. All 19 modules build with zero errors and zero
deprecation warnings across that 119-commit mathlib gap. Reproducible, and recorded
in `~/Projects/lean-toric/logs/dev/2026-10-07.md`. It stays read-only here: it is the
Phase 2 comparison object.

## Not this repo

The **formalization project** is a sibling worktree of the same git repository:
`~/Projects/lean-toric`, branch `toric`. It holds the `ToricFan/` library, the `spec/`
contract, and the optional `Toric` lib built from `references/toric`. `main` (here) is
the curriculum, and the `toric` branch no longer carries it — the two trees are
disjoint by design.

Exercises, GlimpseOfLean and the Phase 1–3 study plan go here. New theorems, fan
combinatorics, and anything that must satisfy `spec/SPEC.md` §4 go there. Do not merge
`toric` into `main`.
