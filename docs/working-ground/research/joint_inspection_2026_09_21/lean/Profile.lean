import RobustFine

namespace JointInspection
noncomputable section

def projective (p : Point) : Point := (p.1/p.2,1/p.2)

def line (t : ℝ) (p : Point) : ℝ := (projective p).1-t*(projective p).2

/-- This profile is defined through its support maximum, independently of fine. -/
noncomputable def profile (S : Source) (t : ℝ) : ℝ := max 0 (worstRatio S 1 t)

theorem line_ratio (t : ℝ) (p : Point) : line t p = Ratio 1 t p := by
  simp only [line,projective,Ratio,one_mul]
  ring

theorem ratio_scale {a : ℝ} (ha : 0 < a) (k : ℝ) (p : Point) :
    Ratio a k p = a * Ratio 1 (k/a) p := by
  simp only [Ratio, one_mul]
  rw [← mul_div_assoc]
  congr 1
  field_simp [ne_of_gt ha] <;> ring

theorem maximum_scaled (S : Source) {a : ℝ} (ha : 0 < a) (k : ℝ) :
    HasMaximum S.carrier (Ratio a k) (a * worstRatio S 1 (k/a)) := by
  obtain ⟨⟨p,hp,he⟩,hu⟩ := worstRatio_spec S 1 (k/a)
  constructor
  · exact ⟨p,hp,by rw [ratio_scale ha,he]⟩
  · intro p hp
    rw [ratio_scale ha]
    exact mul_le_mul_of_nonneg_left (hu p hp) ha.le

theorem fine_profile (S : Source) {a : ℝ} (ha : 0 < a) (k : ℝ) :
    fine S a k = a * profile S (k/a) := by
  have hm := minimum_from_maximum S.positive (maximum_scaled S ha k)
  have he := minimum_unique (fine_spec S a k) hm
  rw [he]
  unfold profile
  by_cases hv : 0 ≤ worstRatio S 1 (k/a)
  · rw [max_eq_right hv, max_eq_right (mul_nonneg ha.le hv)]
  · have hn := le_of_not_ge hv
    rw [max_eq_left hn, max_eq_left (mul_nonpos_of_nonneg_of_nonpos ha.le hn),mul_zero]

/-- Coarseness is for the declared positive multiplier/cost query family. -/
theorem profile_equivalence (S T : Source) :
    (∀ t : ℝ, 0 < t → profile S t = profile T t) ↔
      (∀ a k : ℝ, 0 < a → 0 < k → fine S a k = fine T a k) := by
  constructor
  · intro h a k ha hk
    rw [fine_profile S ha,fine_profile T ha,h (k/a) (div_pos hk ha)]
  · intro h t ht
    exact h 1 t (by norm_num) ht

end
end JointInspection
