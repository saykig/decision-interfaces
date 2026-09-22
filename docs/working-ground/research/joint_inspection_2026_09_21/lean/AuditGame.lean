import Mathlib

/-! R22, with the original report sanction (not a receiver fine).
The payoff definitions enumerate the physical audit leaves before simplifying.
The posterior equations are Bayes' rule at prior 1/2 and authenticated reports.
-/
namespace JointInspection
noncomputable section

def Unit (s : ℝ) : Prop := 0 ≤ s ∧ s ≤ 1

def silentPosterior (s : ℝ) : ℝ := (1-s)/(2-s)

def receiverPayoff (b d : ℝ) : ℝ := d * (3*b-2)

def ReceiverBestReply (b d : ℝ) : Prop :=
  Unit d ∧ ∀ z : ℝ, Unit z → receiverPayoff b z ≤ receiverPayoff b d

def reportPayoff (a r k e q d : ℝ) : ℝ :=
  q*(a*r*d-k-e) + (1-q)*(a*r*d-k)

def senderPayoff (a r k e q dS dR s : ℝ) : ℝ :=
  s*reportPayoff a r k e q dR + (1-s)*(a*r*dS)

def SenderBestReply (a r k e q dS dR s : ℝ) : Prop :=
  Unit s ∧ ∀ z : ℝ, Unit z →
    senderPayoff a r k e q dS dR z ≤ senderPayoff a r k e q dS dR s

structure Assessment where
  report : ℝ
  beliefS : ℝ
  beliefR : ℝ
  actionS : ℝ
  actionR : ℝ

/-- Algebraic Bayes consistency on the feasible one-sender histories.
Off-path report belief is fixed by authentication, not by a choice of equilibrium.
-/
def Consistent (x : Assessment) : Prop :=
  Unit x.report ∧ x.beliefS*(2-x.report) = 1-x.report ∧ x.beliefR = 1

def RationalAssessment (a r k e q : ℝ) (x : Assessment) : Prop :=
  Consistent x ∧ ReceiverBestReply x.beliefS x.actionS ∧
    ReceiverBestReply x.beliefR x.actionR ∧
    SenderBestReply a r k e q x.actionS x.actionR x.report

def SilentTarget (a r k e q : ℝ) : Prop :=
  ∃ x : Assessment, RationalAssessment a r k e q x ∧ x.report = 0

theorem posterior_denominator_pos {s : ℝ} (hs : Unit s) : 0 < 2-s := by
  rcases hs with ⟨h0,h1⟩
  linarith

theorem posterior_bounds {s : ℝ} (hs : Unit s) :
    0 ≤ silentPosterior s ∧ silentPosterior s ≤ 1/2 := by
  have hd := posterior_denominator_pos hs
  constructor
  · exact div_nonneg (sub_nonneg.mpr hs.2) hd.le
  · apply (div_le_iff₀ hd).2
    linarith [hs.1]

theorem posterior_continuous : ContinuousOn silentPosterior (Set.Icc 0 1) := by
  exact (continuous_const.sub continuous_id).continuousOn.div
    (continuous_const.sub continuous_id).continuousOn
    (fun s hs => ne_of_gt (posterior_denominator_pos hs))

theorem consistent_beliefs {x : Assessment} (h : Consistent x) :
    x.beliefS = silentPosterior x.report ∧ x.beliefR = 1 := by
  refine ⟨?_,h.2.2⟩
  exact (eq_div_iff (ne_of_gt (posterior_denominator_pos h.1))).2 h.2.1

theorem receiver_zero_iff {b d : ℝ} (hb : 3*b-2 < 0) :
    ReceiverBestReply b d ↔ d = 0 := by
  constructor
  · intro h
    have hc := h.2 0 ⟨le_rfl,by norm_num⟩
    have hp : 0 ≤ d*(3*b-2) := by simpa [receiverPayoff] using hc
    by_contra hn
    have hd : 0 < d := lt_of_le_of_ne h.1.1 (Ne.symm hn)
    exact (not_lt_of_ge hp) (mul_neg_of_pos_of_neg hd hb)
  · rintro rfl
    refine ⟨⟨le_rfl,by norm_num⟩,?_⟩
    intro z hz
    simpa [receiverPayoff] using mul_nonpos_of_nonneg_of_nonpos hz.1 hb.le

theorem receiver_one_iff {b d : ℝ} (hb : 0 < 3*b-2) :
    ReceiverBestReply b d ↔ d = 1 := by
  constructor
  · intro h
    have hc := h.2 1 ⟨by norm_num,le_rfl⟩
    have hx : 3*b-2 ≤ d*(3*b-2) := by simpa [receiverPayoff] using hc
    have hd : 1 ≤ d := by
      by_contra hn
      have ht := mul_lt_mul_of_pos_right (lt_of_not_ge hn) hb
      have hh : d*(3*b-2) < 3*b-2 := by simpa only [one_mul] using ht
      exact (not_lt_of_ge hx) hh
    exact le_antisymm h.1.2 hd
  · rintro rfl
    refine ⟨⟨by norm_num,le_rfl⟩,?_⟩
    intro z hz
    simpa [receiverPayoff] using mul_le_mul_of_nonneg_right hz.2 hb.le

theorem receiver_actions {x : Assessment} (hc : Consistent x)
    (hS : ReceiverBestReply x.beliefS x.actionS)
    (hR : ReceiverBestReply x.beliefR x.actionR) :
    x.actionS = 0 ∧ x.actionR = 1 := by
  obtain ⟨hbS,hbR⟩ := consistent_beliefs hc
  have hbound := (posterior_bounds hc.1).2
  constructor
  · apply (receiver_zero_iff (b := x.beliefS) (by rw [hbS]; linarith)).1 hS
  · apply (receiver_one_iff (b := x.beliefR) (by rw [hbR]; norm_num)).1 hR

theorem audit_leaf_identity (a r k e q d : ℝ) :
    reportPayoff a r k e q d = a*r*d-k-e*q := by
  unfold reportPayoff
  ring

theorem mixed_payoff_identity (a r k e q s : ℝ) :
    senderPayoff a r k e q 0 1 s = s*(a*r-k-e*q) := by
  simp only [senderPayoff, audit_leaf_identity]
  ring

theorem silent_best_reply_iff (a r k e q : ℝ) :
    SenderBestReply a r k e q 0 1 0 ↔ a*r-k-e*q ≤ 0 := by
  constructor
  · intro h
    have hz := h.2 1 ⟨by norm_num,le_rfl⟩
    simpa only [mixed_payoff_identity, one_mul, zero_mul] using hz
  · intro h
    refine ⟨⟨le_rfl,by norm_num⟩,?_⟩
    intro z hz
    simp only [mixed_payoff_identity, zero_mul]
    exact mul_nonpos_of_nonneg_of_nonpos hz.1 h

/-- At an exact tie all behavioral report mixtures are best replies.
Silence is supported, not made uniquely optimal.
-/
theorem every_mixture_at_tie {a r k e q : ℝ} (h : a*r-k-e*q = 0)
    {s : ℝ} (hs : Unit s) : SenderBestReply a r k e q 0 1 s := by
  refine ⟨hs,?_⟩
  intro z hz
  simp only [mixed_payoff_identity,h,mul_zero,le_refl]

/-- The target predicate contains primitive best replies, not the threshold formula. -/
theorem silent_target_iff (a r k e q : ℝ) :
    SilentTarget a r k e q ↔ a*r-k-e*q ≤ 0 := by
  constructor
  · rintro ⟨x,h,hzero⟩
    obtain ⟨hS,hR⟩ := receiver_actions h.1 h.2.1 h.2.2.1
    have hm := h.2.2.2
    rw [hS,hR,hzero] at hm
    exact (silent_best_reply_iff a r k e q).1 hm
  · intro h
    let x : Assessment := ⟨0,1/2,1,0,1⟩
    refine ⟨x,?_,rfl⟩
    refine ⟨?_,?_,?_,?_⟩
    · norm_num [Consistent,Unit,x]
    · exact (receiver_zero_iff (b := 1/2) (by norm_num)).2 rfl
    · exact (receiver_one_iff (b := 1) (by norm_num)).2 rfl
    · exact (silent_best_reply_iff a r k e q).2 h

end
end JointInspection
