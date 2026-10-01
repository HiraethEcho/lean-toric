# lean

Learning Lean 4 by rebuilding `lean-toric`, then proving the Fujino–Sato
foliation mission on Prove2Me.

Toolchain: **Lean v4.34.1 + mathlib v4.34.1** (latest stable).
The reference repo `~/Public/lean-toric` was built against mathlib `62d0e07`
(toolchain `v4.34.0-rc2`), so a few APIs shifted — that gap is deliberate
practice, not an accident.

## Three phases

| # | Phase | Source | Size |
|---|-------|--------|------|
| 1 | Learn the language | `~/Public/lean-GlimpseOfLean` | 3040 lines of exercises |
| 2 | Reproduce `lean-toric` | `~/Public/lean-toric/Toric` | 18 files / 2050 lines |
| 3 | Prove2Me mission | `~/Public/lean-prove2me-toric-foliation` | 1 definition + 5 theorems |

Budget: ~2 h/day.

## Phase 2 file order (smallest first)

`src/Toric/` mirrors the reference tree exactly, so `diff -ru` works.

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

- `src/` is yours. I write the skeleton and comments; you write the proof.
  I supply at most the first 1–2 tactics to show the shape of the proof.
- `notes/` — knowledge you want to keep (tactic recipes, syntax, concepts).
- `devlogs/` — day-to-day journal of what happened.
- `logs/` — raw program output, written by scripts.
- Big data and package caches live on `/mnt/extra/lean/`, version-keyed and
  symlinked in — see `USAGE.md` and `/mnt/extra/lean/README.md`.

See `USAGE.md` for commands and `AGENTS.md` for the agent rules.
