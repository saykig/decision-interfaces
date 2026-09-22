/-!
# Simple Lean theorems

This file is a small playground for learning Lean. It uses only Lean's core
library, so no Mathlib download is required.

Place your cursor inside a proof in VS Code to see the current goal and the
available assumptions in the Lean Infoview.
-/

namespace SimpleTheorems

/- `#eval` asks Lean to compute an expression. -/
#eval 1 + 1
#eval 2 * 3

/- `#check` asks Lean to display the type of an expression. -/
#check 1 + 1
#check Nat.add_comm

/-
`rfl` proves an equality when both sides reduce to the same value by
computation. Lean computes `1 + 1`, sees `2 = 2`, and closes the goal.
-/
theorem one_plus_one : 1 + 1 = 2 := by
  rfl

theorem two_times_three : 2 * 3 = 6 := by
  rfl

/- Variables let one theorem cover every natural number. -/
theorem adding_zero_changes_nothing (n : Nat) : n + 0 = n := by
  exact Nat.add_zero n

theorem zero_plus_n (n : Nat) : 0 + n = n := by
  exact Nat.zero_add n

/- `rw` rewrites the goal using a known equality. -/
theorem adding_equal_numbers_gives_equal_results
    (a b : Nat) (h : a = b) : a + 1 = b + 1 := by
  rw [h]

/- `intro` moves the premise of an implication into the local context. -/
theorem equality_is_symmetric (a b : Nat) : a = b → b = a := by
  intro h
  exact h.symm

/- `constructor` splits a conjunction into two goals. -/
theorem two_facts_at_once : 1 + 1 = 2 ∧ 2 + 2 = 4 := by
  constructor
  · rfl
  · rfl

/- `decide` can prove concrete propositions for which Lean has a decision procedure. -/
theorem three_is_less_than_five : 3 < 5 := by
  decide

/-
Try these exercises by replacing `by` with a tactic block. Uncomment one at a
time. It is fine to experiment here; Lean will show any unfinished goals.

example : 3 + 4 = 7 := by
  rfl

example (n : Nat) : n = n := by
  rfl

example (a b c : Nat) (hab : a = b) (hbc : b = c) : a = c := by
  exact hab.trans hbc
-/

end SimpleTheorems
