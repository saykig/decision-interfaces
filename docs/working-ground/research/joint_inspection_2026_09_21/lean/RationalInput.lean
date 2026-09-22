import Projective
import Consistency

namespace JointInspection
noncomputable section

abbrev RationalPoint := ℚ × ℚ

def realPoint (p : RationalPoint) : Point := ((p.1:ℝ),(p.2:ℝ))

/-- A rational specification, separate from the Python implementation. -/
def rationalFine (ps : List RationalPoint) (a k : ℚ) : ℚ :=
  ps.foldr (fun p v => max ((a*p.1-k)/p.2) v) 0

theorem cast_rationalFine (ps : List RationalPoint) (a k : ℚ) :
    (rationalFine ps a k : ℝ) = vertexFine (ps.map realPoint) (a:ℝ) (k:ℝ) := by
  induction ps with
  | nil => simp [rationalFine,vertexFine]
  | cons p ps ih =>
      simp only [rationalFine,List.foldr_cons,List.map_cons,vertexFine] at *
      push_cast
      rw [ih]
      rfl

def ValidInput (ps : List RationalPoint) (a k : ℚ) : Prop :=
  ps ≠ [] ∧ 0 < a ∧ 0 < k ∧ ∀ p ∈ ps, 0 < p.1 ∧ 0 < p.2 ∧ p.2 < 1

/-- Error is malformed input; it is not a feasible zero and not an empty mask. -/
noncomputable def checkedFine (ps : List RationalPoint) (a k : ℚ) : Except String ℚ :=
  by
    classical
    exact if ValidInput ps a k then .ok (rationalFine ps a k) else .error "outside R22 input domain"

theorem checkedFine_ok_iff (ps : List RationalPoint) (a k e : ℚ) :
    checkedFine ps a k = .ok e ↔ ValidInput ps a k ∧ rationalFine ps a k = e := by
  classical
  unfold checkedFine
  split_ifs with h <;> simp [h]

theorem invalid_rejected (ps : List RationalPoint) (a k : ℚ) (h : ¬ ValidInput ps a k) :
    checkedFine ps a k = .error "outside R22 input domain" := by
  simp [checkedFine,h]

/-- The adapter's rational result is the minimum for the entire real convex hull. -/
theorem rational_input_minimum (ps : List RationalPoint) (a k : ℚ)
    (h : ValidInput ps a k) :
    MinimumFine (convexHull ℝ {p | p ∈ ps.map realPoint})
      (a:ℝ) (k:ℝ) (rationalFine ps a k : ℝ) := by
  rw [cast_rationalFine]
  apply vertex_minimum
  intro p hp
  obtain ⟨z,hz,rfl⟩ := List.mem_map.mp hp
  have hzq := (h.2.2.2 z hz).2.1
  change 0 < (z.2:ℝ)
  exact_mod_cast hzq

theorem checked_input_minimum (ps : List RationalPoint) (a k e : ℚ)
    (h : checkedFine ps a k = .ok e) :
    MinimumFine (convexHull ℝ {p | p ∈ ps.map realPoint}) (a:ℝ) (k:ℝ) (e:ℝ) := by
  obtain ⟨hv,he⟩ := (checkedFine_ok_iff ps a k e).1 h
  rw [← he]
  exact rational_input_minimum ps a k hv

/-- Exact threshold semantics imported by downstream users of a valid query. -/
theorem checked_input_sequential (ps : List RationalPoint) (a k e : ℚ)
    (h : checkedFine ps a k = .ok e) :
    0 ≤ (e:ℝ) ∧ ∀ p ∈ convexHull ℝ {p | p ∈ ps.map realPoint},
      SequentialSilentTarget (a:ℝ) p.1 (k:ℝ) (e:ℝ) p.2 := by
  simpa only [sequential_silent_iff] using (checked_input_minimum ps a k e h).1

end
end JointInspection
