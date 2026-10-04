# lean

Learning Lean 4 by rebuilding `lean-toric`, then proving the Fujino–Sato
foliation mission on Prove2Me.

Toolchain: **Lean v4.34.1 + mathlib v4.34.1** (latest stable).
The reference repo `lean-toric` was built against mathlib `62d0e07`
(toolchain `v4.34.0-rc2`), so a few APIs shifted — that gap is deliberate
practice, not an accident.

## Three phases

| # | Phase | Source | Size |
|---|-------|--------|------|
| 1 | Learn the language | `references/GlimpseOfLean/Exercises` + `examples/GlimpseOfLean/Solutions` | 137 proofs to fill |
| 2 | Reproduce `lean-toric` | `references/toric/Toric` | 18 files / 2050 lines |
| 3 | Prove2Me mission | `~/Public/lean-prove2me-toric-foliation` (not copied yet) | 1 definition + 5 theorems |

Budget: ~2 h/day.

**The full roadmap is [`PLAN.md`](PLAN.md)** — daily rhythm,
per-file order with self-tests at the end of each phase, and the known pitfalls
of each phase. Start there.

## Layout

```
exercise/     the student's exercises -- skeletons in, proofs out
src/Toric/    Phase 2, not created yet -- the lean-toric reproduction
examples/     worked examples: GlimpseOfLean Solutions + its Library/ (read-only)
references/   read-only upstream: exercise text, lean-toric source, its blueprint PDF
notes/        knowledge worth keeping
PLAN.md       the roadmap
logs/run/     machine output from setup/builds (gitignored)
logs/dev/     hand-written journal
scripts/      helper scripts; scripts/tests/ holds the smoke test
```

`exercise/`, `examples/`, `references/` and `notes/` are **not** `lean_lib`s —
exercises have `sorries` in them and the other two are read-only, so none of
them belongs in the build. There is no `lean_lib` at all until Phase 2 lands,
so `lake build` has nothing to do (it prints a "no default targets" warning).
To check a file use `scripts/check.sh`; to check the toolchain use
`scripts/smoke.sh`.

## Phase 1 order

`01Rewriting` → `02Iff` → `03Forall` → `04Exists` → `Shorter` → one `Topics/*`
file. Full table of hole counts and the Chinese guide: `notes/00-GlimpseOfLean.md`.

## Phase 2 file order (smallest first)

`src/Toric/` will mirror `references/toric/Toric/` exactly, so `diff -ru`
works. The directory does not exist yet and `lakefile.toml` has no target for it.

| # | File | lines |
|---|------|-------|
| 1 | `Mathlib/LinearAlgebra/Finsupp/LinearCombination.lean` | 16 |
| 2 | `Mathlib/Algebra/Category/Ring/Under/Basic.lean` | 16 |
| 3 | `Imports.lean` | 20 |
| 4 | `Mathlib/Algebra/Polynomial/Bivariate.lean` | 25 |
| 5 | `MvLaurentPolynomial.lean` | 36 |
| 6 | `SphericalVariety.lean` | 37 |
| 7 | `Examples/CharCocharPairing.lean` | 49 |
| 8 | `ToricVariety/FromMonoid.lean` | 54 |
| 9 | `Hopf/GrpAlg.lean` | 56 |
| 10 | `Mathlib/RingTheory/HopfAlgebra/Convolution.lean` | 61 |
| 11 | `ToricVariety/Defs.lean` | 66 |
| 12 | `ToricIdeal.lean` | 89 |
| 13 | `Hopf/Diagonalisable.lean` | 118 |
| 14 | `GroupScheme/MonoidAlgebra.lean` | 171 |
| 15 | `GroupScheme/Torus.lean` | 179 |
| 16 | `GroupScheme/Character.lean` | 198 |
| 17 | `Examples/SO2.lean` | 425 |
| 18 | `GroupScheme/Diagonalizable.lean` | 434 |

## Working rules

- `exercise/` and `src/` are yours. I write the skeleton and comments; you write
  the proof. I supply at most the first 1–2 tactics to show its shape.
- `notes/` — knowledge you want to keep (tactic recipes, syntax, concepts).
- `logs/dev/` — day-to-day journal of what happened.
- `examples/` holds finished proofs to read. `references/` holds upstream text:
  exercises, source trees, the blueprint PDF. Both are read-only — never edit them.
- Big data and package caches live on `/mnt/extra/lean/`, version-keyed and
  symlinked in — see `USAGE.md` and `/mnt/extra/lean/README.md`.

See `USAGE.md` for commands and `AGENTS.md` for the agent rules.