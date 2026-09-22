import RationalInput
import Operational

namespace JointInspection
noncomputable section

/-- With zero detection, an arbitrarily large fine cannot remove a positive gain. -/
theorem zero_detection_no_target {a r k : ℝ} (h : k < a*r) (e : ℝ) :
    ¬ SequentialSilentTarget a r k e 0 := by
  rw [sequential_silent_gain]
  simp only [mul_zero,sub_zero]
  linarith

/-- Even strictly positive probabilities do not give a uniform finite fine
when the admitted family has no positive detection floor. -/
theorem missing_floor_no_uniform_fine (e : ℝ) (he : 0 ≤ e) :
    ∃ q : ℝ, 0 < q ∧ q < 1 ∧ ¬ SequentialSilentTarget 1 1 (1/2) e q := by
  let q := 1/(2*e+2)
  have hd : 0 < 2*e+2 := by linarith
  have hq : 0 < q := one_div_pos.mpr hd
  have hq1 : q < 1 := by
    apply (div_lt_one hd).2
    linarith
  refine ⟨q,hq,hq1,?_⟩
  rw [sequential_silent_gain]
  have hid : q*(2*e+2)=1 := by dsimp [q]; field_simp [ne_of_gt hd]
  nlinarith

/-- The binding endpoint in the 3-versus-6 counterexample still permits reporting. -/
theorem exact_tie_not_forced_silence :
    SenderBestReply 1 2 (1/2) 6 (1/4) 0 1 1 := by
  apply every_mixture_at_tie <;> norm_num [Unit]

theorem marginal_example_A : rationalFine [(1,1/4),(2,1/2)] 1 (1/2) = 3 := by
  norm_num [rationalFine]

theorem marginal_example_B : rationalFine [(1,1/2),(2,1/4)] 1 (1/2) = 6 := by
  norm_num [rationalFine]

end
end JointInspection
