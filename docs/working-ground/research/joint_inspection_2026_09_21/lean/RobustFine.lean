import AuditGame

namespace JointInspection
noncomputable section

abbrev Point := ℝ × ℝ

def PositiveDetection (K : Set Point) : Prop := ∀ p ∈ K, 0 < p.2

def Ratio (a k : ℝ) (p : Point) : ℝ := (a*p.1-k)/p.2

def HasMaximum (K : Set Point) (f : Point → ℝ) (v : ℝ) : Prop :=
  (∃ p ∈ K, f p = v) ∧ ∀ p ∈ K, f p ≤ v

def RobustTarget (K : Set Point) (a k e : ℝ) : Prop :=
  0 ≤ e ∧ ∀ p ∈ K, SilentTarget a p.1 k e p.2

def MinimumFine (K : Set Point) (a k E : ℝ) : Prop :=
  RobustTarget K a k E ∧ ∀ e, RobustTarget K a k e → E ≤ e

theorem ratio_continuous {K : Set Point} (hp : PositiveDetection K) (a k : ℝ) :
    ContinuousOn (Ratio a k) K := by
  exact ((continuous_const.mul continuous_fst).sub continuous_const).continuousOn.div
    continuous_snd.continuousOn (fun p hm => ne_of_gt (hp p hm))

theorem ratio_maximum_exists {K : Set Point} (hn : K.Nonempty)
    (hc : IsCompact K) (hp : PositiveDetection K) (a k : ℝ) :
    ∃ v, HasMaximum K (Ratio a k) v := by
  obtain ⟨p,hm,hmax⟩ := hc.exists_isMaxOn hn (ratio_continuous hp a k)
  exact ⟨Ratio a k p,⟨⟨p,hm,rfl⟩,hmax⟩⟩

theorem detection_floor_exists {K : Set Point} (hn : K.Nonempty)
    (hc : IsCompact K) (hp : PositiveDetection K) :
    ∃ q0, 0 < q0 ∧ ∀ p ∈ K, q0 ≤ p.2 := by
  obtain ⟨p,hm,hmin⟩ := hc.exists_isMinOn hn continuous_snd.continuousOn
  exact ⟨p.2,hp p hm,hmin⟩

theorem target_iff_ratio {p : Point} {a k e : ℝ} (hq : 0 < p.2) :
    SilentTarget a p.1 k e p.2 ↔ Ratio a k p ≤ e := by
  rw [silent_target_iff, Ratio, div_le_iff₀ hq]
  constructor <;> intro h <;> linarith

/-- The clipped, attained maximum is exactly the minimum feasible fine. -/
theorem minimum_from_maximum {K : Set Point} {a k v : ℝ}
    (hp : PositiveDetection K) (hv : HasMaximum K (Ratio a k) v) :
    MinimumFine K a k (max 0 v) := by
  constructor
  · refine ⟨le_max_left _ _,?_⟩
    intro p hm
    exact (target_iff_ratio (hp p hm)).2 ((hv.2 p hm).trans (le_max_right _ _))
  · intro e he
    apply max_le he.1
    obtain ⟨p,hm,hvalue⟩ := hv.1
    have h := (target_iff_ratio (hp p hm)).1 (he.2 p hm)
    simpa only [hvalue] using h

theorem minimum_unique {K : Set Point} {a k E F : ℝ}
    (hE : MinimumFine K a k E) (hF : MinimumFine K a k F) : E = F :=
  le_antisymm (hE.2 F hF.1) (hF.2 E hE.1)

theorem attained_robust_fine {K : Set Point} (hn : K.Nonempty)
    (hc : IsCompact K) (hp : PositiveDetection K) (a k : ℝ) :
    ∃ v, HasMaximum K (Ratio a k) v ∧ MinimumFine K a k (max 0 v) := by
  obtain ⟨v,hv⟩ := ratio_maximum_exists hn hc hp a k
  exact ⟨v,hv,minimum_from_maximum hp hv⟩

/-- An actual maximizing model rejects every smaller nonnegative fine. -/
theorem below_minimum_witness {K : Set Point} {a k v e : ℝ}
    (hp : PositiveDetection K) (hv : HasMaximum K (Ratio a k) v)
    (he : 0 ≤ e) (hlt : e < max 0 v) :
    ∃ p ∈ K, 0 < a*p.1-k-e*p.2 := by
  have ev : e < v := (lt_max_iff.mp hlt).resolve_left (not_lt_of_ge he)
  obtain ⟨p,hm,hv⟩ := hv.1
  refine ⟨p,hm,?_⟩
  have hh : e < Ratio a k p := by rw [hv]; exact ev
  have hmul := (lt_div_iff₀ (hp p hm)).1 hh
  linarith

/-- A source carries its nonemptiness/compactness, so an empty source cannot
silently masquerade as a zero-fine environment. -/
structure Source where
  carrier : Set Point
  nonempty : carrier.Nonempty
  compact : IsCompact carrier
  positive : PositiveDetection carrier

noncomputable def worstRatio (S : Source) (a k : ℝ) : ℝ :=
  Classical.choose (ratio_maximum_exists S.nonempty S.compact S.positive a k)

theorem worstRatio_spec (S : Source) (a k : ℝ) :
    HasMaximum S.carrier (Ratio a k) (worstRatio S a k) :=
  Classical.choose_spec (ratio_maximum_exists S.nonempty S.compact S.positive a k)

noncomputable def fine (S : Source) (a k : ℝ) : ℝ := max 0 (worstRatio S a k)

theorem fine_spec (S : Source) (a k : ℝ) : MinimumFine S.carrier a k (fine S a k) :=
  minimum_from_maximum S.positive (worstRatio_spec S a k)

theorem robust_iff_fine_le (S : Source) (a k e : ℝ) :
    RobustTarget S.carrier a k e ↔ fine S a k ≤ e := by
  constructor
  · exact (fine_spec S a k).2 e
  · intro h
    refine ⟨(fine_spec S a k).1.1.trans h,?_⟩
    intro p hp
    exact (target_iff_ratio (S.positive p hp)).2
      (((target_iff_ratio (S.positive p hp)).1 ((fine_spec S a k).1.2 p hp)).trans h)

end
end JointInspection
