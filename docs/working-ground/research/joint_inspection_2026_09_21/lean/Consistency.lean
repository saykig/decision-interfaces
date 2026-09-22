import Beliefs
import RobustFine

/-! R22 reuses the unchanged R14 atom/Bayes/tremble definitions.
The perturbing strategies are feasible and completely mixed; they need not be
best replies. Type-zero reports remain infeasible, exactly as in the source.
-/
namespace JointInspection
open Filter Topology
noncomputable section

def singleBayes (s : ℝ) (o : Cooperation.Observation) : ℝ :=
  Cooperation.atom (1/2) s o true / Cooperation.localMass (1/2) s o

theorem singleBayes_posterior {s : ℝ} (hs : 0 < s ∧ s < 1)
    (o : Cooperation.Observation) :
    singleBayes s o = Cooperation.posterior (1/2) s o := by
  have hp : (0:ℝ) < 1/2 ∧ (1:ℝ)/2 < 1 := by norm_num
  have hd := ne_of_gt (Cooperation.localMass_pos hp hs o)
  unfold singleBayes
  rw [Cooperation.atom_factor hp ⟨hs.1.le,hs.2.le⟩]
  simp [Cooperation.bern,hd]

theorem silent_posterior_translation {s : ℝ} (hs : Unit s) :
    Cooperation.posterior (1/2) s .silent = silentPosterior s := by
  have hd := ne_of_gt (posterior_denominator_pos hs)
  have hd' := ne_of_gt (Cooperation.silent_den_pos
    (by norm_num : (0:ℝ)<1/2 ∧ (1:ℝ)/2<1) hs)
  dsimp [Cooperation.posterior,silentPosterior]
  field_simp [hd,hd'] <;> ring

theorem singleBayes_limit {s : ℝ} {ss : ℕ → ℝ} (hs : Unit s)
    (hm : ∀ n, 0 < ss n ∧ ss n < 1)
    (ht : Tendsto ss atTop (𝓝 s)) (o : Cooperation.Observation) :
    Tendsto (fun n => singleBayes (ss n) o) atTop
      (𝓝 (Cooperation.posterior (1/2) s o)) := by
  have heq : (fun n => singleBayes (ss n) o) =
      (fun n => Cooperation.posterior (1/2) (ss n) o) := by
    funext n
    exact singleBayes_posterior (hm n) o
  rw [heq]
  exact Cooperation.posterior_tendsto (by norm_num) hs ht o

/-- One simultaneous, completely mixed sequence of all feasible strategic
choices generates both beliefs by conditioning actual state/message masses. -/
def BayesianConsistency (x : Assessment) : Prop :=
  Unit x.report ∧ Unit x.actionS ∧ Unit x.actionR ∧
  ∃ ss ds dr : ℕ → ℝ,
    (∀ n, (0 < ss n ∧ ss n < 1) ∧ (0 < ds n ∧ ds n < 1) ∧
      (0 < dr n ∧ dr n < 1)) ∧
    Tendsto ss atTop (𝓝 x.report) ∧
    Tendsto ds atTop (𝓝 x.actionS) ∧
    Tendsto dr atTop (𝓝 x.actionR) ∧
    Tendsto (fun n => singleBayes (ss n) .silent) atTop (𝓝 x.beliefS) ∧
    Tendsto (fun n => singleBayes (ss n) .report) atTop (𝓝 x.beliefR)

theorem bayesian_consistency_iff (x : Assessment) :
    BayesianConsistency x ↔ Consistent x ∧ Unit x.actionS ∧ Unit x.actionR := by
  constructor
  · rintro ⟨hs,hdS,hdR,ss,ds,dr,hm,ht,hds,hdr,hbs,hbr⟩
    have bs := tendsto_nhds_unique hbs
      (singleBayes_limit hs (fun n => (hm n).1) ht .silent)
    have br := tendsto_nhds_unique hbr
      (singleBayes_limit hs (fun n => (hm n).1) ht .report)
    rw [silent_posterior_translation hs] at bs
    refine ⟨⟨hs,?_,br⟩,hdS,hdR⟩
    exact (eq_div_iff (ne_of_gt (posterior_denominator_pos hs))).1 bs
  · rintro ⟨hc,hdS,hdR⟩
    have beliefs := consistent_beliefs hc
    refine ⟨hc.1,hdS,hdR,
      (fun n => Cooperation.tremble n x.report),
      (fun n => Cooperation.tremble n x.actionS),
      (fun n => Cooperation.tremble n x.actionR),?_,
      Cooperation.tremble_tendsto _,Cooperation.tremble_tendsto _,
      Cooperation.tremble_tendsto _,?_,?_⟩
    · intro n
      exact ⟨Cooperation.tremble_mixed n hc.1,
        Cooperation.tremble_mixed n hdS,Cooperation.tremble_mixed n hdR⟩
    · have h := singleBayes_limit hc.1 (fun n => Cooperation.tremble_mixed n hc.1)
        (Cooperation.tremble_tendsto _) .silent
      rw [silent_posterior_translation hc.1,← beliefs.1] at h
      exact h
    · have h := singleBayes_limit hc.1 (fun n => Cooperation.tremble_mixed n hc.1)
        (Cooperation.tremble_tendsto _) .report
      simpa only [Cooperation.posterior,beliefs.2] using h

def SequentialAssessment (a r k e q : ℝ) (x : Assessment) : Prop :=
  BayesianConsistency x ∧ ReceiverBestReply x.beliefS x.actionS ∧
    ReceiverBestReply x.beliefR x.actionR ∧
    SenderBestReply a r k e q x.actionS x.actionR x.report

theorem sequential_assessment_iff (a r k e q : ℝ) (x : Assessment) :
    SequentialAssessment a r k e q x ↔ RationalAssessment a r k e q x := by
  constructor
  · rintro ⟨hc,hS,hR,hs⟩
    exact ⟨((bayesian_consistency_iff x).1 hc).1,hS,hR,hs⟩
  · rintro ⟨hc,hS,hR,hs⟩
    exact ⟨(bayesian_consistency_iff x).2 ⟨hc,hS.1,hR.1⟩,hS,hR,hs⟩

def SequentialSilentTarget (a r k e q : ℝ) : Prop :=
  ∃ x : Assessment, SequentialAssessment a r k e q x ∧ x.report = 0

theorem sequential_silent_iff (a r k e q : ℝ) :
    SequentialSilentTarget a r k e q ↔ SilentTarget a r k e q := by
  simp only [SequentialSilentTarget,SilentTarget,sequential_assessment_iff]

theorem sequential_silent_gain (a r k e q : ℝ) :
    SequentialSilentTarget a r k e q ↔ a*r-k-e*q ≤ 0 := by
  rw [sequential_silent_iff,silent_target_iff]

/-- Physical admissibility is added to the more general positive-denominator
algebraic source. An arbitrary positive real is not called a probability. -/
structure AuditSource extends Source where
  rewardPositive : ∀ p ∈ carrier, 0 < p.1
  detectionLTOne : ∀ p ∈ carrier, p.2 < 1

structure InspectionQuery where
  multiplier : ℝ
  cost : ℝ
  multiplierPositive : 0 < multiplier
  costPositive : 0 < cost

/-- Public T1 bridge: the minimum fine supports an actual consistent target
assessment in every admitted model, with one fine across models. -/
theorem audit_fine_sequential (S : AuditSource) (Q : InspectionQuery) (e : ℝ) :
    (0 ≤ e ∧ ∀ p ∈ S.carrier,
      SequentialSilentTarget Q.multiplier p.1 Q.cost e p.2) ↔
    fine S.toSource Q.multiplier Q.cost ≤ e := by
  simpa only [sequential_silent_iff] using
    robust_iff_fine_le S.toSource Q.multiplier Q.cost e

end
end JointInspection
