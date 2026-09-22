import Profile

namespace JointInspection
noncomputable section

theorem positive_combination {x y a b : ℝ} (hx : 0 < x) (hy : 0 < y)
    (ha : 0 ≤ a) (hb : 0 ≤ b) (hab : a+b=1) : 0 < a*x+b*y := by
  by_cases hz : a=0
  · have hbone : b=1 := by linarith
    simpa only [hz,hbone,zero_mul,zero_add,one_mul] using hy
  · exact add_pos_of_pos_of_nonneg
      (mul_pos (lt_of_le_of_ne ha (Ne.symm hz)) hx) (mul_nonneg hb hy.le)

/-- Projective, NOT affine: weights must be renormalized by detection. -/
theorem projective_combination {p q : Point} {a b : ℝ}
    (hp : 0 < p.2) (hq : 0 < q.2) (ha : 0 ≤ a) (hb : 0 ≤ b) (hab : a+b=1) :
    projective (a • p + b • q) =
      (a*p.2/(a*p.2+b*q.2)) • projective p +
      (b*q.2/(a*p.2+b*q.2)) • projective q := by
  have hd := positive_combination hp hq ha hb hab
  apply Prod.ext <;> dsimp [projective]
  · field_simp [ne_of_gt hp,ne_of_gt hq,ne_of_gt hd] <;> ring
  · field_simp [ne_of_gt hp,ne_of_gt hq,ne_of_gt hd] <;> nlinarith [hab]

theorem projective_involutive {p : Point} (hp : 0 < p.2) :
    projective (projective p) = p := by
  apply Prod.ext <;> dsimp [projective] <;> field_simp [ne_of_gt hp]

theorem projective_lift_convex {C : Set Point} (hc : Convex ℝ C) :
    Convex ℝ {p : Point | 0 < p.2 ∧ projective p ∈ C} := by
  intro p hp q hq a b ha hb hab
  have hd := positive_combination hp.1 hq.1 ha hb hab
  refine ⟨hd,?_⟩
  rw [projective_combination hp.1 hq.1 ha hb hab]
  apply hc hp.2 hq.2
  · exact div_nonneg (mul_nonneg ha hp.1.le) hd.le
  · exact div_nonneg (mul_nonneg hb hq.1.le) hd.le
  · rw [← add_div]
    exact div_self (ne_of_gt hd)

theorem hull_positive {K : Set Point} (hp : PositiveDetection K) :
    PositiveDetection (convexHull ℝ K) := by
  apply convexHull_min hp
  intro p hp q hq a b ha hb hab
  exact positive_combination hp hq ha hb hab

theorem projective_hull_subset {K : Set Point} (hp : PositiveDetection K) :
    projective '' (convexHull ℝ K) ⊆ convexHull ℝ (projective '' K) := by
  have hsub : K ⊆ {p : Point | 0 < p.2 ∧ projective p ∈ convexHull ℝ (projective '' K)} := by
    intro p hm
    exact ⟨hp p hm,subset_convexHull ℝ (projective '' K) ⟨p,hm,rfl⟩⟩
  have hlift := convexHull_min hsub (projective_lift_convex (convex_convexHull ℝ _))
  rintro z ⟨p,hm,rfl⟩
  exact (hlift hm).2

/-- Full Mathlib convex-hull identity, not a custom hull or an affine shortcut. -/
theorem projective_convexHull {K : Set Point} (hp : PositiveDetection K) :
    projective '' (convexHull ℝ K) = convexHull ℝ (projective '' K) := by
  have hT : PositiveDetection (projective '' K) := by
    rintro z ⟨p,hm,rfl⟩
    exact one_div_pos.mpr (hp p hm)
  have hTT : projective '' (projective '' K) = K := by
    ext p
    constructor
    · rintro ⟨z,⟨y,hy,rfl⟩,he⟩
      rw [projective_involutive (hp y hy)] at he
      simpa only [he] using hy
    · intro hm
      exact ⟨projective p,⟨p,hm,rfl⟩,projective_involutive (hp p hm)⟩
  apply Set.Subset.antisymm
  · exact projective_hull_subset hp
  · intro z hz
    have ht : projective z ∈ convexHull ℝ (projective '' (projective '' K)) :=
      projective_hull_subset hT ⟨z,hz,rfl⟩
    rw [hTT] at ht
    exact ⟨projective z,ht,projective_involutive (hull_positive hT z hz)⟩

theorem incentive_halfspace_convex (a k e : ℝ) :
    Convex ℝ {p : Point | a*p.1-k-e*p.2 ≤ 0} := by
  intro p hp q hq u v hu hv huv
  change a*(u*p.1+v*q.1)-k-e*(u*p.2+v*q.2) ≤ 0
  have h1 := mul_nonpos_of_nonneg_of_nonpos hu hp
  have h2 := mul_nonpos_of_nonneg_of_nonpos hv hq
  have hk : (u+v)*k=k := by rw [huv,one_mul]
  nlinarith

theorem hull_ratio_bound {K : Set Point} (hp : PositiveDetection K)
    {a k e : ℝ} (h : ∀ p ∈ K, Ratio a k p ≤ e) :
    ∀ p ∈ convexHull ℝ K, Ratio a k p ≤ e := by
  have hh : K ⊆ {p : Point | a*p.1-k-e*p.2 ≤ 0} := by
    intro p hm
    have hd := (div_le_iff₀ (hp p hm)).1 (h p hm)
    change a*p.1-k-e*p.2 ≤ 0
    linarith
  have hhull := convexHull_min hh (incentive_halfspace_convex a k e)
  intro p hm
  apply (div_le_iff₀ (hull_positive hp p hm)).2
  have hi := hhull hm
  change a*p.1-k-e*p.2 ≤ 0 at hi
  linarith

theorem maximum_convexHull {K : Set Point} {a k v : ℝ}
    (hp : PositiveDetection K) (hv : HasMaximum K (Ratio a k) v) :
    HasMaximum (convexHull ℝ K) (Ratio a k) v := by
  obtain ⟨p,hm,he⟩ := hv.1
  exact ⟨⟨p,subset_convexHull ℝ K hm,he⟩,hull_ratio_bound hp hv.2⟩

/-- Executable finite reduction retains clipping when every ratio is negative. -/
def vertexFine (ps : List Point) (a k : ℝ) : ℝ :=
  ps.foldr (fun p v => max (Ratio a k p) v) 0

theorem vertexFine_le (ps : List Point) (a k e : ℝ) :
    vertexFine ps a k ≤ e ↔ 0 ≤ e ∧ ∀ p ∈ ps, Ratio a k p ≤ e := by
  induction ps with
  | nil => simp [vertexFine]
  | cons p ps ih =>
      simp only [vertexFine,List.foldr_cons,max_le_iff] at *
      rw [ih]
      simp only [List.mem_cons,forall_eq_or_imp]
      tauto

/-- The finite query answers the ENTIRE convex hull, not just sample points. -/
theorem vertex_minimum (ps : List Point) (hp : ∀ p ∈ ps, 0 < p.2) (a k : ℝ) :
    MinimumFine (convexHull ℝ {p | p ∈ ps}) a k (vertexFine ps a k) := by
  have hself := (vertexFine_le ps a k (vertexFine ps a k)).1 le_rfl
  have hpos : PositiveDetection {p | p ∈ ps} := hp
  constructor
  · refine ⟨hself.1,?_⟩
    intro p hm
    exact (target_iff_ratio (hull_positive hpos p hm)).2 (hull_ratio_bound hpos hself.2 p hm)
  · intro e he
    apply (vertexFine_le ps a k e).2
    refine ⟨he.1,?_⟩
    intro p hm
    exact (target_iff_ratio (hp p hm)).1
      (he.2 p (subset_convexHull ℝ {p | p ∈ ps} hm))

theorem fine_vertex_formula (S : Source) (ps : List Point)
    (hS : S.carrier = convexHull ℝ {p | p ∈ ps}) (a k : ℝ) :
    fine S a k = vertexFine ps a k := by
  have hp : ∀ p ∈ ps, 0 < p.2 := by
    intro p hm
    apply S.positive p
    rw [hS]
    exact subset_convexHull ℝ {p | p ∈ ps} hm
  have hv := vertex_minimum ps hp a k
  rw [← hS] at hv
  exact minimum_unique (fine_spec S a k) hv

end
end JointInspection
