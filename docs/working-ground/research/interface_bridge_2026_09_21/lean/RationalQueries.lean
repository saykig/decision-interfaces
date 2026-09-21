import Attainment

namespace DecisionInterface
open scoped BigOperators
noncomputable section

theorem rational_log_approximation (c ε : ℝ) (hε : 0 < ε) :
    ∃ r : ℚ, 0 < r ∧ |Real.log (r : ℝ) - c| < ε := by
  obtain ⟨r,hrlo,hrhi⟩ := exists_rat_btwn
    (Real.exp_lt_exp.mpr (by linarith : c-ε < c+ε))
  have hrpos : (0 : ℝ) < r := (Real.exp_pos _).trans hrlo
  have hlo := Real.log_lt_log (Real.exp_pos _) hrlo
  have hhi := Real.log_lt_log hrpos hrhi
  rw [Real.log_exp] at hlo hhi
  refine ⟨r, by exact_mod_cast hrpos, ?_⟩
  rw [abs_lt]
  constructor <;> linarith

theorem margin_cost_perturbation {I J : Type*} [Fintype I] [Fintype J] [Nonempty J]
    {P : Set (I → ℝ)} {A : J → I → ℝ} {c d : J → ℝ} {mc md ε : ℝ}
    (hc : MaxValue P (pointMargin A c) mc) (hd : MaxValue P (pointMargin A d) md)
    (close : ∀ j, |c j-d j| ≤ ε) : |mc-md| ≤ ε := by
  have lower : md ≤ mc + ε := max_transfer hd hc (by
    intro p hp
    refine ⟨p,hp,?_⟩
    apply min_transfer (coordinate_minimum_spec _) (coordinate_minimum_spec _)
    intro j _
    have hj := (abs_le.mp (close j)).2
    linarith)
  have upper : mc ≤ md + ε := max_transfer hc hd (by
    intro p hp
    refine ⟨p,hp,?_⟩
    apply min_transfer (coordinate_minimum_spec _) (coordinate_minimum_spec _)
    intro j _
    have hj := (abs_le.mp (close j)).1
    linarith)
  rw [abs_le]
  constructor <;> linarith

/-- The exact real-cost attainment yields rational positive queries separating
every strictly smaller margin γ<d/2. Exact attainment by rational ratios is not
asserted; density preserves the operational supremum and separated decisions. -/
theorem one_sender_rational_separation {n : ℕ}
    {P Q : Set (Fin n → ℝ)} {HP HQ : (Fin n → ℝ) → ℝ} {d γ : ℝ}
    (nP : P.Nonempty) (nQ : Q.Nonempty) (cP : Convex ℝ P) (cQ : Convex ℝ Q)
    (kP : IsCompact P) (kQ : IsCompact Q) (posP : Positive P) (posQ : Positive Q)
    (hHP : ∀ w ∈ WeightBox, Support P w (HP w))
    (hHQ : ∀ w ∈ WeightBox, Support Q w (HQ w))
    (hdisc : Directed WeightBox HP HQ d) (hγ : γ < d/2) :
    ∃ (π : Equiv.Perm (Fin n)) (r : Fin (n+1) → ℚ) (mp mq : ℝ),
      (∀ j, 0 < r j) ∧
      MaxValue P (pointMargin (suffixMatrix π) (fun j => Real.log (r j : ℝ))) mp ∧
      MaxValue Q (pointMargin (suffixMatrix π) (fun j => Real.log (r j : ℝ))) mq ∧
      γ < mp ∧ mq < -γ := by
  classical
  obtain ⟨π,c,hpc,hqc⟩ := one_sender_opposite_margin
    nP nQ cP cQ kP kQ posP posQ hHP hHQ hdisc
  let ε := (d/2-γ)/2
  have hε : 0 < ε := by dsimp [ε]; linarith
  choose r hrpos hrclose using fun j => rational_log_approximation (c j) ε hε
  let cr : Fin (n+1) → ℝ := fun j => Real.log (r j : ℝ)
  have close : ∀ j, |c j-cr j| ≤ ε := by
    intro j
    rw [abs_sub_comm]
    exact (hrclose j).le
  obtain ⟨mp,hmp⟩ := primal_margin_exists nP kP posP (suffixMatrix π) cr
  obtain ⟨mq,hmq⟩ := primal_margin_exists nQ kQ posQ (suffixMatrix π) cr
  have hpclose := abs_le.mp (margin_cost_perturbation hpc hmp close)
  have hqclose := abs_le.mp (margin_cost_perturbation hqc hmq close)
  refine ⟨π,r,mp,mq,hrpos,hmp,hmq,?_,?_⟩ <;> dsimp [ε] at * <;> linarith

end
end DecisionInterface
