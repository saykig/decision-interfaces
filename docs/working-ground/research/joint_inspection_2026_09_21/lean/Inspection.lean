import RationalInput
import Operational

/-! Public entry point. Later theorems import this module rather than redefine
an audit, a robust fine, or a profile. Generic algebra lives in the helper modules;
these public strategic statements retain the physical R22 domain explicitly.
-/
namespace JointInspection
noncomputable section

/-- End-to-end T1/T3: the profile criterion is equivalent to existence of the
actual consistent all-silent target for every model, using the same fine. -/
theorem audit_interface_iff_target (S : AuditSource) (Q : InspectionQuery) (e : ℝ) :
    (0 ≤ e ∧ ∀ p ∈ S.carrier,
      SequentialSilentTarget Q.multiplier p.1 Q.cost e p.2) ↔
    Q.multiplier * profile S.toSource (Q.cost/Q.multiplier) ≤ e := by
  have h := audit_fine_sequential S Q e
  rw [fine_profile S.toSource Q.multiplierPositive] at h
  exact h

/-- A downstream theorem built entirely by importing the proved approximation
and strategic bridges: the corrected recommendation supports the target.
This is mathematical robustness, not an empirical endorsement of a sanction.
-/
theorem audit_target_from_approximation (P Q : AuditSource) (I : InspectionQuery)
    {q0 er eq e : ℝ} (hq0 : 0 < q0) (her : 0 ≤ er) (heq : 0 ≤ eq)
    (hf : ∀ p ∈ P.carrier, q0 ≤ p.2)
    (hm : ∀ p ∈ P.carrier, ∃ z ∈ Q.carrier, p.1 ≤ z.1+er ∧ z.2-eq ≤ p.2)
    (he : fine Q.toSource I.multiplier I.cost +
      (I.multiplier*er+fine Q.toSource I.multiplier I.cost*eq)/q0 ≤ e) :
    0 ≤ e ∧ ∀ p ∈ P.carrier,
      SequentialSilentTarget I.multiplier p.1 I.cost e p.2 := by
  apply (audit_fine_sequential P I e).2
  exact (directed_fine_bound P.toSource Q.toSource I.multiplierPositive.le
    hq0 her heq hf hm).trans he

end
end JointInspection
