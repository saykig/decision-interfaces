import Interface
import Realization

namespace DecisionInterface
open scoped BigOperators
noncomputable section

/-- Original coordinate i is at position 1 + π⁻¹(i). Position zero is the
additional known sender, whose probability is absent from every suffix. -/
def suffixMatrix {n : ℕ} (π : Equiv.Perm (Fin n)) : Fin (n+1) → Fin n → ℝ :=
  fun j i => if j.val ≤ (π.symm i).val then 1 else 0

theorem suffix_matrix_box {n : ℕ} (π : Equiv.Perm (Fin n)) :
    ∀ j i, 0 ≤ suffixMatrix π j i ∧ suffixMatrix π j i ≤ 1 := by
  intro j i
  unfold suffixMatrix
  split_ifs <;> norm_num

/-- Full single-added-sender contextual attainment. The source families are
compact, convex and positive; no profile ordering or domination is assumed.
The directed discrepancy hypothesis supplies an actual maximizing direction.
All cost ratios are exp(c), hence strictly positive. -/
theorem one_sender_contextual_attainment {n : ℕ}
    {P Q : Set (Fin n → ℝ)} {HP HQ : (Fin n → ℝ) → ℝ} {d : ℝ}
    (nP : P.Nonempty) (nQ : Q.Nonempty) (cP : Convex ℝ P) (cQ : Convex ℝ Q)
    (kP : IsCompact P) (kQ : IsCompact Q) (posP : Positive P) (posQ : Positive Q)
    (hHP : ∀ w ∈ WeightBox, Support P w (HP w))
    (hHQ : ∀ w ∈ WeightBox, Support Q w (HQ w))
    (hdisc : Directed WeightBox HP HQ d) (z : ℝ) :
    ∃ (π : Equiv.Perm (Fin n)) (c : Fin (n+1) → ℝ),
      MaxValue P (pointMargin (suffixMatrix π) c) z ∧
      MaxValue Q (pointMargin (suffixMatrix π) c) (z-d) ∧
      (∀ j, 0 < Real.exp (c j)) := by
  classical
  obtain ⟨w, hw, hd⟩ := hdisc.1
  obtain ⟨π, a, ha0, ha1, hreal⟩ := one_sender_suffix_realization w hw
  have ha : a ∈ Simplex := ⟨ha0,ha1⟩
  have hweight : inducedWeight (suffixMatrix π) a = w := by
    funext i
    simpa only [inducedWeight, suffixMatrix, Equiv.apply_symm_apply] using hreal (π.symm i)
  obtain ⟨pstar, hpstar, hstar⟩ := (hHP w hw).1
  let c : Fin (n+1) → ℝ := fun j => logScore (suffixMatrix π j) pstar - z
  obtain ⟨mp, hmp⟩ := primal_margin_exists nP kP posP (suffixMatrix π) c
  obtain ⟨mq, hmq⟩ := primal_margin_exists nQ kQ posQ (suffixMatrix π) c
  have hcal := contextual_attainment_certificate (A := suffixMatrix π) (a := a)
    (z := z) ha hpstar (by simpa only [hweight] using hstar)
    (by simpa only [hweight] using hHP w hw)
    (by simpa only [hweight] using hHQ w hw)
    (fun p _ => coordinate_minimum_spec _) (fun q _ => coordinate_minimum_spec _) hmp hmq
  have hu := contextual_primal_upper nP nQ cP cQ kP kQ posP posQ
    (suffix_matrix_box π) hHP hHQ hmp hmq hdisc.2
  have ep : mp = z := hcal.1
  have eq : mq = z - d := by linarith [hcal.2]
  refine ⟨π,c,?_,?_,fun j => Real.exp_pos _⟩
  · simpa only [ep] using hmp
  · simpa only [eq] using hmq

theorem one_sender_opposite_margin {n : ℕ}
    {P Q : Set (Fin n → ℝ)} {HP HQ : (Fin n → ℝ) → ℝ} {d : ℝ}
    (nP : P.Nonempty) (nQ : Q.Nonempty) (cP : Convex ℝ P) (cQ : Convex ℝ Q)
    (kP : IsCompact P) (kQ : IsCompact Q) (posP : Positive P) (posQ : Positive Q)
    (hHP : ∀ w ∈ WeightBox, Support P w (HP w))
    (hHQ : ∀ w ∈ WeightBox, Support Q w (HQ w))
    (hdisc : Directed WeightBox HP HQ d) :
    ∃ (π : Equiv.Perm (Fin n)) (c : Fin (n+1) → ℝ),
      MaxValue P (pointMargin (suffixMatrix π) c) (d/2) ∧
      MaxValue Q (pointMargin (suffixMatrix π) c) (-d/2) := by
  obtain ⟨π,c,hp,hq,_⟩ := one_sender_contextual_attainment
    nP nQ cP cQ kP kQ posP posQ hHP hHQ hdisc (d/2)
  refine ⟨π,c,hp,?_⟩
  have heq : d/2-d = -d/2 := by ring
  simpa only [heq] using hq

/-- All support/discrepancy attainment premises of the operational theorem
follow from positive compact families. Convexity is used only in the minimax
step, not hidden inside the support definitions. -/
theorem one_sender_attainment_from_families {n : ℕ}
    {P Q : Set (Fin n → ℝ)}
    (nP : P.Nonempty) (nQ : Q.Nonempty) (cP : Convex ℝ P) (cQ : Convex ℝ Q)
    (kP : IsCompact P) (kQ : IsCompact Q) (posP : Positive P) (posQ : Positive Q) :
    ∃ d : ℝ, 0 ≤ d ∧ Directed WeightBox (supportValue P) (supportValue Q) d ∧
      ∀ z : ℝ, ∃ (π : Equiv.Perm (Fin n)) (c : Fin (n+1) → ℝ),
        MaxValue P (pointMargin (suffixMatrix π) c) z ∧
        MaxValue Q (pointMargin (suffixMatrix π) c) (z-d) ∧
        (∀ j, 0 < Real.exp (c j)) := by
  obtain ⟨d,hd⟩ := directed_value_exists kP kQ posP posQ
  refine ⟨d,directed_value_nonnegative nP nQ kP kQ posP posQ hd,hd,?_⟩
  intro z
  exact one_sender_contextual_attainment nP nQ cP cQ kP kQ posP posQ
    (fun w _ => support_value_spec nP kP posP w)
    (fun w _ => support_value_spec nQ kQ posQ w) hd z

end
end DecisionInterface
