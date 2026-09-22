import Profile

namespace JointInspection
noncomputable section

theorem profile_nonnegative (S : Source) (t : ℝ) : 0 ≤ profile S t :=
  le_max_left _ _

theorem profile_directed_change (S : Source) {q0 : ℝ} (hq0 : 0 < q0)
    (hf : ∀ p ∈ S.carrier, q0 ≤ p.2) (t u : ℝ) :
    profile S t ≤ profile S u + |t-u|/q0 := by
  apply (robust_iff_fine_le S 1 t _).1
  have hd : 0 ≤ |t-u|/q0 := div_nonneg (abs_nonneg _) hq0.le
  refine ⟨add_nonneg (profile_nonnegative S u) hd,?_⟩
  intro p hp
  rw [silent_target_iff]
  have old := (silent_target_iff 1 p.1 u (profile S u) p.2).1
    ((fine_spec S 1 u).1.2 p hp)
  have hm := mul_le_mul_of_nonneg_left (hf p hp) hd
  have hid : (|t-u|/q0)*q0=|t-u| := by field_simp [ne_of_gt hq0]
  rw [hid] at hm
  have ha := neg_le_abs (t-u)
  nlinarith

theorem profile_distance_bound (S : Source) {q0 : ℝ} (hq0 : 0 < q0)
    (hf : ∀ p ∈ S.carrier, q0 ≤ p.2) (t u : ℝ) :
    |profile S t-profile S u| ≤ |t-u|/q0 := by
  have h1 := profile_directed_change S hq0 hf t u
  have h2 := profile_directed_change S hq0 hf u t
  rw [abs_sub_comm u t] at h2
  rw [abs_le]
  constructor <;> linarith

theorem profile_lipschitz (S : Source) {q0 : ℝ} (hq0 : 0 < q0)
    (hf : ∀ p ∈ S.carrier, q0 ≤ p.2) :
    LipschitzWith ⟨1/q0,(one_div_pos.mpr hq0).le⟩ (profile S) := by
  refine lipschitzWith_iff_dist_le_mul.2 ?_
  intro t u
  simpa [Real.dist_eq,div_eq_mul_inv,mul_comm] using profile_distance_bound S hq0 hf t u

theorem profile_continuous (S : Source) : Continuous (profile S) := by
  obtain ⟨q0,hq0,hf⟩ := detection_floor_exists S.nonempty S.compact S.positive
  exact (profile_lipschitz S hq0 hf).continuous

/-- Rational queries separate the full positive-cost profile. The proof uses
an explicit positive rational neighborhood, not a sampled rational grid. -/
theorem profile_eq_of_positive_rationals (S T : Source)
    (h : ∀ r : ℚ, 0 < r → profile S (r:ℝ) = profile T (r:ℝ)) :
    ∀ t : ℝ, 0 < t → profile S t = profile T t := by
  obtain ⟨c,hc,hSc⟩ := detection_floor_exists S.nonempty S.compact S.positive
  obtain ⟨d,hd,hTd⟩ := detection_floor_exists T.nonempty T.compact T.positive
  intro t ht
  by_contra hn
  let D := |profile S t-profile T t|
  have hD : 0 < D := abs_pos.mpr (sub_ne_zero.mpr hn)
  let C := 1/c+1/d
  have hC : 0 < C := add_pos (one_div_pos.mpr hc) (one_div_pos.mpr hd)
  let ε := min (t/2) (D/(2*C))
  have he : 0 < ε := lt_min (by positivity) (div_pos hD (mul_pos (by norm_num) hC))
  have het : ε ≤ t/2 := min_le_left _ _
  have heD : ε ≤ D/(2*C) := min_le_right _ _
  have hscale : ε*C ≤ D/2 := by
    have hh := (le_div_iff₀ (mul_pos (by norm_num : (0:ℝ)<2) hC)).1 heD
    nlinarith
  obtain ⟨r,hrlo,hrhi⟩ := exists_rat_btwn (show t-ε < t+ε by linarith)
  have hrpos : (0:ℝ)<r := by linarith
  have hrposQ : (0:ℚ)<r := by exact_mod_cast hrpos
  have heq := h r hrposQ
  have hdist : |t-(r:ℝ)| < ε := by rw [abs_lt]; constructor <;> linarith
  have hS := profile_distance_bound S hc hSc t (r:ℝ)
  have hT := profile_distance_bound T hd hTd (r:ℝ) t
  have hsum : D ≤ |t-(r:ℝ)| * C := by
    dsimp [D,C]
    calc
      |profile S t-profile T t| ≤
          |profile S t-profile S (r:ℝ)|+|profile S (r:ℝ)-profile T t| := abs_sub_le _ _ _
      _ = |profile S t-profile S (r:ℝ)|+|profile T (r:ℝ)-profile T t| := by rw [heq]
      _ ≤ |t-(r:ℝ)|/c+|(r:ℝ)-t|/d := add_le_add hS hT
      _ = |t-(r:ℝ)| * (1/c+1/d) := by rw [abs_sub_comm (r:ℝ) t]; ring
  have hsmall := mul_lt_mul_of_pos_right hdist hC
  linarith

theorem rational_query_equivalence (S T : Source) :
    (∀ t : ℝ, 0 < t → profile S t = profile T t) ↔
    (∀ a k : ℚ, 0 < a → 0 < k → fine S (a:ℝ) (k:ℝ) = fine T (a:ℝ) (k:ℝ)) := by
  constructor
  · intro h a k ha hk
    apply (profile_equivalence S T).1 h
    · exact_mod_cast ha
    · exact_mod_cast hk
  · intro h
    apply profile_eq_of_positive_rationals S T
    intro r hr
    have hh := h 1 r (by norm_num) hr
    simpa only [Rat.cast_one,fine,profile] using hh

/-- T4's one-sided error transport requires matched JOINT points. It does not
follow merely from separately close reward and detection projections. -/
theorem directed_fine_bound (P Q : Source) {a k q0 er eq : ℝ}
    (ha : 0 ≤ a) (hq0 : 0 < q0) (her : 0 ≤ er) (heq : 0 ≤ eq)
    (hf : ∀ p ∈ P.carrier, q0 ≤ p.2)
    (hm : ∀ p ∈ P.carrier, ∃ z ∈ Q.carrier, p.1 ≤ z.1+er ∧ z.2-eq ≤ p.2) :
    fine P a k ≤ fine Q a k + (a*er+fine Q a k*eq)/q0 := by
  let E := fine Q a k
  let δ := (a*er+E*eq)/q0
  have hE : 0 ≤ E := (fine_spec Q a k).1.1
  have hδ : 0 ≤ δ := div_nonneg (add_nonneg (mul_nonneg ha her) (mul_nonneg hE heq)) hq0.le
  apply (robust_iff_fine_le P a k _).1
  refine ⟨add_nonneg hE hδ,?_⟩
  intro p hp
  obtain ⟨z,hz,hr,hq⟩ := hm p hp
  have old := (silent_target_iff a z.1 k E z.2).1 ((fine_spec Q a k).1.2 z hz)
  have hreward := mul_le_mul_of_nonneg_left hr ha
  have hdetect := mul_le_mul_of_nonneg_left hq hE
  have hfloor := mul_le_mul_of_nonneg_left (hf p hp) hδ
  have hid : δ*q0=a*er+E*eq := by dsimp [δ]; field_simp [ne_of_gt hq0]
  rw [hid] at hfloor
  apply (silent_target_iff a p.1 k (E+δ) p.2).2
  nlinarith

end
end JointInspection
