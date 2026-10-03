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
| 1 | Learn the language | `examples/GlimpseOfLean` | 137 proofs to fill |
| 2 | Reproduce `lean-toric` | `~/Public/lean-toric` | 18 files / 2050 lines |
| 3 | Prove2Me mission | `~/Public/lean-prove2me-toric-foliation` | 1 definition + 5 theorems |

Budget: ~2 h/day.

**The full roadmap is [`examples/PLAN.md`](examples/PLAN.md)** — daily rhythm,
per-file order with self-tests at the end of each phase, and the known pitfalls
of each phase. Start there.

## Layout

```
exercise/     the student's exercises -- skeletons in, proofs out
src/Toric/    the lean-toric reproduction, paths mirror the reference
examples/     read-only copies of reference repos (see examples/README.md)
notes/        knowledge worth keeping
logs/run/     machine output from setup/builds (gitignored)
logs/dev/     hand-written journal
scripts/      helper scripts; scripts/tests/ holds the smoke test
```

`exercise/`, `examples/` and `notes/` are **not** `lean_lib`s — exercises have
`sorries` in them and examples are read-only, so neither belongs in the build.
`lake build` only builds `src/`. To check a file use `scripts/check.sh`.

## Phase 1 order

`01Rewriting` → `02Iff` → `03Forall` → `04Exists` → `Shorter` → one `Topics/*`
file. Full table of hole counts and the Chinese guide: `notes/00-GlimpseOfLean.md`.

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

- `exercise/` and `src/` are yours. I write the skeleton and comments; you write
  the proof. I supply at most the first 1–2 tactics to show its shape.
- `notes/` — knowledge you want to keep (tactic recipes, syntax, concepts).
- `logs/dev/` — day-to-day journal of what happened.
- `examples/` is reference material. Read it, never edit it.
- Big data and package caches live on `/mnt/extra/lean/`, version-keyed and
  symlinked in — see `USAGE.md` and `/mnt/extra/lean/README.md`.

See `USAGE.md` for commands and `AGENTS.md` for the agent rules.