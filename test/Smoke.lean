import Mathlib

-- Environment smoke test. Touches one thing from each corner of mathlib so a
-- broken toolchain or a missing cache entry fails loudly instead of silently.
-- Run with: scripts/smoke.sh

-- core + tactics
example : (2 : Nat) + 2 = 4 := by decide

-- linear order arithmetic
example (n : ℕ) : n + 0 = n := Nat.add_zero n

-- algebra / linear algebra
example (a b : ℝ) : (a + b) ^ 2 = a ^ 2 + 2 * a * b + b ^ 2 := by ring

-- Fin index arithmetic, needed constantly in the toric formalisation
example : (⟨3, by omega⟩ : Fin 5).val = 3 := rfl

-- total division in ℚ (used by divisorIntersection)
example : (2 : ℚ) / 4 = 1 / 2 := by norm_num

-- a structure with a proof field, like WallData
structure Point where
  x : ℤ
  y : ℤ

-- structure instance syntax -- the form you will use for WallData-style records
example : ({ x := 1, y := 2 } : Point) = ⟨1, 2⟩ := rfl
