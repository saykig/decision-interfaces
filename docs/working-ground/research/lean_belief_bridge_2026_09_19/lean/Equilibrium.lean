import Bridge

open scoped BigOperators
open Filter Topology
namespace Cooperation
noncomputable section

/-- An assessment in the canonical belief normal form established uniquely by R14.
Public and private beliefs are derived from Nature and transcript Bayes limits,
not from an incentive or cascade inequality. -/
structure Assessment (n : ℕ) where
  sender : Strategy n
  receiver : (Fin n → Bool) → ℝ

def Assessment.publicBelief {n : ℕ} (s : Assessment n) (p : Fin n → ℝ)
    (h : Hist n) (x : Fin n → Bool) : ℝ :=
  belief p (rateAt s.sender h) (observed h) x

def Assessment.privateBelief {n : ℕ} (s : Assessment n) (p : Fin n → ℝ)
    (h : Info n) (b : Bool) (x : Fin n → Bool) : ℝ :=
  belief p (rateAt s.sender ⟨h.val,h.property.le⟩) (privateObserved h b) x

/-- Consistency is an actual common sequence of completely mixed assessments. -/
def Assessment.Consistent {n : ℕ} (s : Assessment n) (p : Fin n → ℝ) : Prop :=
  ∃ (σs : ℕ → Strategy n) (ρs : ℕ → (Fin n → Bool) → ℝ),
    (∀ t, FullyMixed (σs t)) ∧
    (∀ t y, 0 < ρs t y ∧ ρs t y < 1) ∧
    (∀ h, Tendsto (fun t => σs t h) atTop (𝓝 (s.sender h))) ∧
    (∀ y, Tendsto (fun t => ρs t y) atTop (𝓝 (s.receiver y))) ∧
    (∀ h x, Tendsto (fun t => transcriptBayes p (σs t) h x) atTop
      (𝓝 (s.publicBelief p h x))) ∧
    (∀ h b x, Tendsto (fun t => senderBayes p (σs t) h b x) atTop
      (𝓝 (s.privateBelief p h b x)))

/-- Sequential rationality compares primitive expected utilities at EVERY history,
against every feasible mixed deviation. Type zero has only its compulsory action. -/
def SequentialEquilibrium {n : ℕ} (p η k : Fin n → ℝ) (A B e : ℝ)
    (s : Assessment n) : Prop :=
  Feasible s.sender ∧ s.Consistent p ∧
    (∀ y, BestReply
      (receiverGain p (rateAt s.sender (terminalHist y)) (observed (terminalHist y)) A B e)
      (s.receiver y)) ∧
    (∀ h : Info n, SenderBestReply
      (senderPayoff p s.sender h s.receiver (η ⟨h.val.length,h.property⟩)
        (k ⟨h.val.length,h.property⟩) true)
      (senderPayoff p s.sender h s.receiver (η ⟨h.val.length,h.property⟩)
        (k ⟨h.val.length,h.property⟩) false)
      (s.sender h))

/-- An unrestricted assessment also carries its proposed public/private beliefs.
The normalization theorem below proves, rather than assumes, their canonical form. -/
structure RawAssessment (n : ℕ) where
  profile : Assessment n
  mu : Hist n → (Fin n → Bool) → ℝ
  nu : Info n → Bool → (Fin n → Bool) → ℝ

def RawAssessment.Consistent {n : ℕ} (s : RawAssessment n) (p : Fin n → ℝ) : Prop :=
  ∃ (σs : ℕ → Strategy n) (ρs : ℕ → (Fin n → Bool) → ℝ),
    (∀ t, FullyMixed (σs t)) ∧
    (∀ t y, 0 < ρs t y ∧ ρs t y < 1) ∧
    (∀ h, Tendsto (fun t => σs t h) atTop (𝓝 (s.profile.sender h))) ∧
    (∀ y, Tendsto (fun t => ρs t y) atTop (𝓝 (s.profile.receiver y))) ∧
    (∀ h x, Tendsto (fun t => transcriptBayes p (σs t) h x) atTop (𝓝 (s.mu h x))) ∧
    (∀ h b x, Tendsto (fun t => senderBayes p (σs t) h b x) atTop (𝓝 (s.nu h b x)))

def rawSenderPayoff {n : ℕ} (s : RawAssessment n) (h : Info n) (η k : ℝ) (a : Bool) : ℝ :=
  η * (∑ x : Fin n → Bool, s.nu h true x *
    pathExpectation s.profile.sender h a s.profile.receiver x) - (if a then k else 0)

def RawSequentialEquilibrium {n : ℕ} (p η k : Fin n → ℝ) (A B e : ℝ)
    (s : RawAssessment n) : Prop :=
  Feasible s.profile.sender ∧ s.Consistent p ∧
    (∀ y, BestReply (∑ x : Fin n → Bool, s.mu (terminalHist y) x * defectPayoff A B e x)
      (s.profile.receiver y)) ∧
    (∀ h : Info n, SenderBestReply
      (rawSenderPayoff s h (η ⟨h.val.length,h.property⟩) (k ⟨h.val.length,h.property⟩) true)
      (rawSenderPayoff s h (η ⟨h.val.length,h.property⟩) (k ⟨h.val.length,h.property⟩) false)
      (s.profile.sender h))

/-- There is no hidden belief selection in the canonical assessment predicate:
EVERY consistent assessment has precisely these derived beliefs. -/
theorem raw_equilibrium_normalization {n : ℕ} {p η k : Fin n → ℝ} {A B e : ℝ}
    (hp : ∀ i, 0 < p i ∧ p i < 1) (s : RawAssessment n) :
    RawSequentialEquilibrium p η k A B e s ↔
      SequentialEquilibrium p η k A B e s.profile ∧
      s.mu = s.profile.publicBelief p ∧ s.nu = s.profile.privateBelief p := by
  constructor
  · rintro ⟨hσ,hc,hr,hs⟩
    obtain ⟨σs,ρs,hm,hrm,hconv,hrconv,hμ,hν⟩ := hc
    obtain ⟨hμeq,hνeq⟩ := global_consistency_unique hp hσ hm hconv s.mu s.nu hμ hν
    have hpub : s.mu = s.profile.publicBelief p := by
      funext h x; exact hμeq h x
    have hpriv : s.nu = s.profile.privateBelief p := by
      funext h b x; exact hνeq h b x
    refine ⟨⟨hσ,?_,?_,?_⟩,hpub,hpriv⟩
    · exact ⟨σs,ρs,hm,hrm,hconv,hrconv,by simpa [hpub] using hμ,by simpa [hpriv] using hν⟩
    · simpa only [hpub,Assessment.publicBelief,receiverGain] using hr
    · simpa only [rawSenderPayoff,hpriv,Assessment.privateBelief,senderPayoff] using hs
  · rintro ⟨⟨hσ,hc,hr,hs⟩,hpub,hpriv⟩
    refine ⟨hσ,?_,?_,?_⟩
    · obtain ⟨σs,ρs,hm,hrm,hconv,hrconv,hμ,hν⟩ := hc
      exact ⟨σs,ρs,hm,hrm,hconv,hrconv,by simpa [hpub] using hμ,by simpa [hpriv] using hν⟩
    · simpa only [hpub,Assessment.publicBelief,receiverGain] using hr
    · simpa only [rawSenderPayoff,hpriv,Assessment.privateBelief,senderPayoff] using hs

/-- The all-silent target only restricts the on-path histories. -/
def SilentTarget {n : ℕ} (s : Assessment n) : Prop :=
  (∀ h : Info n, (∀ j : Fin h.val.length, h.val[j.val] = false) → s.sender h = 0) ∧
    s.receiver (fun _ => false) = 0

def TargetExists {n : ℕ} (p η k : Fin n → ℝ) (A B e : ℝ) : Prop :=
  ∃ s : Assessment n, SequentialEquilibrium p η k A B e s ∧ SilentTarget s

def RawTargetExists {n : ℕ} (p η k : Fin n → ℝ) (A B e : ℝ) : Prop :=
  ∃ s : RawAssessment n, RawSequentialEquilibrium p η k A B e s ∧ SilentTarget s.profile

lemma raw_target_iff_canonical {n : ℕ} {p η k : Fin n → ℝ} {A B e : ℝ}
    (hp : ∀ i, 0 < p i ∧ p i < 1) :
    RawTargetExists p η k A B e ↔ TargetExists p η k A B e := by
  constructor
  · rintro ⟨s,hs,hT⟩
    exact ⟨s.profile,((raw_equilibrium_normalization hp s).mp hs).1,hT⟩
  · rintro ⟨s,hs,hT⟩
    let r : RawAssessment n := ⟨s,s.publicBelief p,s.privateBelief p⟩
    exact ⟨r,(raw_equilibrium_normalization hp r).mpr ⟨hs,rfl,rfl⟩,hT⟩

def completeInfo {n : ℕ} (i : Fin n) : Info n :=
  ⟨List.replicate i.val true, by simpa using i.isLt⟩

def suffixProduct {n : ℕ} (p : Fin n → ℝ) (i : Fin n) : ℝ :=
  ∏ j : Fin n, if i.val < j.val then p j else 1

def WeakBlocker {n : ℕ} (p η k : Fin n → ℝ) (i : Fin n) : Prop :=
  η i * suffixProduct p i ≤ k i

lemma completeInfo_length {n : ℕ} (i : Fin n) : (completeInfo i).val.length = i.val := by
  simp [completeInfo]

lemma completeInfo_complete {n : ℕ} (i : Fin n) : CompletePast (completeInfo i) := by
  intro j
  simp [completeInfo]

lemma pastInfo_complete {n : ℕ} (i : Fin n) :
    pastInfo (terminalHist (fun _ : Fin n => true)) i = completeInfo i := by
  apply Subtype.ext
  simp [pastInfo,terminalHist,completeInfo,List.ofFn_const]

lemma completePast_eq {n : ℕ} (h : Info n) (hc : CompletePast h) :
    h = completeInfo ⟨h.val.length,h.property⟩ := by
  apply Subtype.ext
  apply List.ext_getElem
  · simp [completeInfo]
  · intro i hi hj
    simpa [completeInfo] using hc ⟨i,hi⟩

/-- Derived reduction of full primitive sequential rationality, with all mixed
continuations retained. This is a theorem, not an equilibrium definition. -/
theorem equilibrium_chain_gain {n : ℕ} {p η k : Fin n → ℝ} {A B e : ℝ}
    {s : Assessment n} (hp : ∀ i, 0 < p i ∧ p i < 1)
    (hA : 0 < A) (hB : 0 < B) (he : 0 ≤ e) (heB : e < B)
    (ht : ∀ i, p i < A/(A+B)) (hs : SequentialEquilibrium p η k A B e s)
    (i : Fin n) :
    BestReply (η i * (∏ j : Fin n, if i.val < j.val then
      p j * s.sender (completeInfo j) else 1) - k i) (s.sender (completeInfo i)) := by
  have hr := hs.2.2.2 (completeInfo i)
  rw [sender_bestReply_gain] at hr
  rw [continuation_bridge hp hs.1 hA hB he heB ht s.receiver hs.2.2.1] at hr
  rw [if_pos (completeInfo_complete i)] at hr
  simpa only [completeInfo_length,pastInfo_complete,Fin.eta] using hr

/-- Reverse induction rules out every mixed rescue when all blocker inequalities
fail strictly. No purity is assumed in the assessment. -/
theorem no_mixed_rescue {n : ℕ} {p η k : Fin n → ℝ} {A B e : ℝ}
    {s : Assessment n} (hp : ∀ i, 0 < p i ∧ p i < 1)
    (hA : 0 < A) (hB : 0 < B) (he : 0 ≤ e) (heB : e < B)
    (ht : ∀ i, p i < A/(A+B)) (hs : SequentialEquilibrium p η k A B e s)
    (hn : ∀ i, k i < η i * suffixProduct p i) :
    ∀ i : Fin n, s.sender (completeInfo i) = 1 := by
  have aux : ∀ d : ℕ, ∀ i : Fin n, n - i.val = d → s.sender (completeInfo i) = 1 := by
    intro d
    induction d using Nat.strong_induction_on with
    | h d ih =>
      intro i hid
      have hg := equilibrium_chain_gain hp hA hB he heB ht hs i
      have hp' : (∏ j : Fin n, if i.val < j.val then
          p j * s.sender (completeInfo j) else 1) = suffixProduct p i := by
        apply Finset.prod_congr rfl
        intro j _
        by_cases hij : i.val < j.val
        · have hj := ih (n-j.val) (by omega) j rfl
          simp [hij,hj]
        · simp [hij]
      rw [hp'] at hg
      exact (bestReply_positive (sub_pos.mpr (hn i))).mp hg
  intro i
  exact aux (n-i.val) i rfl

/-- Necessity reaches the actual on-path first information set. -/
theorem target_requires_blocker {n : ℕ} (hn : 0 < n) {p η k : Fin n → ℝ} {A B e : ℝ}
    (hp : ∀ i, 0 < p i ∧ p i < 1) (hA : 0 < A) (hB : 0 < B)
    (he : 0 ≤ e) (heB : e < B) (ht : ∀ i, p i < A/(A+B))
    (hE : TargetExists p η k A B e) : ∃ i, WeakBlocker p η k i := by
  classical
  by_contra! hb
  obtain ⟨s,hs,hT⟩ := hE
  have hstrict : ∀ i, k i < η i * suffixProduct p i := by
    intro i
    exact lt_of_not_ge (hb i)
  have hr := no_mixed_rescue hp hA hB he heB ht hs hstrict ⟨0,hn⟩
  have hz := hT.1 (completeInfo ⟨0,hn⟩) (by intro j; simpa [completeInfo] using j.isLt)
  linarith


/-- Report only after an unbroken report prefix strictly beyond the selected blocker. -/
def blockerStrategy {n : ℕ} (b : Fin n) : Strategy n :=
  fun h => if CompletePast h ∧ b.val < h.val.length then 1 else 0

lemma blocker_feasible {n : ℕ} (b : Fin n) : Feasible (blockerStrategy b) := by
  intro h
  unfold blockerStrategy
  split_ifs <;> constructor <;> norm_num

lemma blocker_at_complete {n : ℕ} (b i : Fin n) :
    blockerStrategy b (completeInfo i) = if b.val < i.val then 1 else 0 := by
  unfold blockerStrategy
  by_cases hbi : b.val < i.val
  · rw [if_pos ⟨completeInfo_complete i, by simpa only [completeInfo_length] using hbi⟩,
      if_pos hbi]
  · rw [if_neg (by
      intro hh
      exact hbi (by simpa only [completeInfo_length] using hh.2)),if_neg hbi]

lemma blocker_future_after {n : ℕ} (p : Fin n → ℝ) (b i : Fin n) (hi : b.val ≤ i.val) :
    (∏ j : Fin n, if i.val < j.val then
      p j * blockerStrategy b (completeInfo j) else 1) = suffixProduct p i := by
  apply Finset.prod_congr rfl
  intro j _
  by_cases hij : i.val < j.val
  · simp [hij,blocker_at_complete,show b.val < j.val by omega]
  · simp [hij]

lemma blocker_future_before {n : ℕ} (p : Fin n → ℝ) (b i : Fin n) (hi : i.val < b.val) :
    (∏ j : Fin n, if i.val < j.val then
      p j * blockerStrategy b (completeInfo j) else 1) = 0 := by
  apply Finset.prod_eq_zero (Finset.mem_univ b)
  simp [hi,blocker_at_complete]

lemma bestReply_nonpos_zero {g : ℝ} (hg : g ≤ 0) : BestReply g 0 := by
  refine ⟨le_rfl,by norm_num,?_⟩
  intro a ha _
  simpa using mul_nonpos_of_nonneg_of_nonpos ha hg

/-- The largest-blocker strategy is rational at every sender information set,
including all histories off the report chain. -/
theorem blocker_sender_rational {n : ℕ} (p η k : Fin n → ℝ) (hk : ∀ i, 0 < k i)
    (b : Fin n) (hb : WeakBlocker p η k b)
    (hlast : ∀ i : Fin n, b.val < i.val → k i < η i * suffixProduct p i) :
    ∀ h : Info n, SenderBestReply
      (senderPayoff p (blockerStrategy b) h completeRule
        (η ⟨h.val.length,h.property⟩) (k ⟨h.val.length,h.property⟩) true)
      (senderPayoff p (blockerStrategy b) h completeRule
        (η ⟨h.val.length,h.property⟩) (k ⟨h.val.length,h.property⟩) false)
      (blockerStrategy b h) := by
  intro h
  rw [sender_bestReply_gain]
  by_cases hc : CompletePast h
  · rw [sender_gain_complete p (blockerStrategy b) h hc]
    simp only [pastInfo_complete]
    let i : Fin n := ⟨h.val.length,h.property⟩
    change BestReply (η i * (∏ j : Fin n, if i.val < j.val then
      p j * blockerStrategy b (completeInfo j) else 1) - k i) (blockerStrategy b h)
    by_cases hbi : b.val < i.val
    · rw [blocker_future_after p b i (Nat.le_of_lt hbi)]
      have hq : blockerStrategy b h = 1 := by simp [blockerStrategy,hc,show b.val < h.val.length from hbi]
      rw [hq]
      exact (bestReply_positive (sub_pos.mpr (hlast i hbi))).mpr rfl
    · have hq : blockerStrategy b h = 0 := by simp [blockerStrategy,hc,show ¬ b.val < h.val.length from hbi]
      rw [hq]
      by_cases hib : i = b
      · rw [hib,blocker_future_after p b b le_rfl]
        exact bestReply_nonpos_zero (sub_nonpos.mpr hb)
      · have hib' : i.val < b.val := by
          have : i.val ≠ b.val := fun heq => hib (Fin.ext heq)
          omega
        rw [blocker_future_before p b i hib']
        simp only [mul_zero,zero_sub]
        exact (bestReply_negative (neg_neg_of_pos (hk i))).mpr rfl
  · rw [sender_gain_broken p (blockerStrategy b) h hc]
    have hq : blockerStrategy b h = 0 := by simp [blockerStrategy,hc]
    rw [hq]
    exact (bestReply_negative (neg_neg_of_pos (hk _))).mpr rfl

lemma blocker_silent_path {n : ℕ} (b : Fin n) (h : Info n)
    (hs : ∀ j : Fin h.val.length, h.val[j.val] = false) : blockerStrategy b h = 0 := by
  unfold blockerStrategy
  split_ifs with hc
  · have hh : 0 < h.val.length := lt_of_le_of_lt (Nat.zero_le _) hc.2
    have ht := hc.1 ⟨0,hh⟩
    have hf := hs ⟨0,hh⟩
    simp_all
  · rfl

/-- Construction uses receiver optimality and the R14 perturbation theorem,
not a stipulated cascade or a PBE-only assessment. -/
theorem blocker_target_equilibrium {n : ℕ} {p η k : Fin n → ℝ} {A B e : ℝ}
    (hp : ∀ i, 0 < p i ∧ p i < 1) (hk : ∀ i, 0 < k i)
    (hA : 0 < A) (hB : 0 < B) (he : 0 ≤ e) (heB : e < B)
    (ht : ∀ i, p i < A/(A+B)) (b : Fin n) (hb : WeakBlocker p η k b)
    (hlast : ∀ i : Fin n, b.val < i.val → k i < η i * suffixProduct p i) :
    TargetExists p η k A B e := by
  let s : Assessment n := ⟨blockerStrategy b,completeRule⟩
  have hρ : ∀ y : Fin n → Bool, 0 ≤ completeRule y ∧ completeRule y ≤ 1 := by
    intro y
    unfold completeRule
    split_ifs <;> constructor <;> norm_num
  refine ⟨s,⟨blocker_feasible b,?_,?_,?_⟩,?_,?_⟩
  · exact full_profile_consistency hp (blocker_feasible b) completeRule hρ
  · intro y
    exact (terminal_bestReply_below hp (blocker_feasible b) hA hB he heB ht y _).mpr rfl
  · exact blocker_sender_rational p η k hk b hb hlast
  · exact blocker_silent_path b
  · change completeRule (fun _ : Fin n => false) = 0
    have hh : (fun _ : Fin n => false) ≠ (fun _ => true) := by
      intro h
      have := congrFun h b
      simp at this
    simp [completeRule,hh]

/-- A finite nonempty set of weak blockers has a last member. -/
lemma last_blocker {n : ℕ} (p η k : Fin n → ℝ) (hb : ∃ i, WeakBlocker p η k i) :
    ∃ b : Fin n, WeakBlocker p η k b ∧
      ∀ i : Fin n, b.val < i.val → k i < η i * suffixProduct p i := by
  classical
  let S := Finset.univ.filter (WeakBlocker p η k)
  have hS : S.Nonempty := by
    obtain ⟨i,hi⟩ := hb
    exact ⟨i,Finset.mem_filter.mpr ⟨Finset.mem_univ _,hi⟩⟩
  let b := S.max' hS
  have hbS : b ∈ S := Finset.max'_mem S hS
  refine ⟨b,(Finset.mem_filter.mp hbS).2,?_⟩
  intro i hi
  by_contra! hn
  have hiS : i ∈ S := Finset.mem_filter.mpr ⟨Finset.mem_univ _,hn⟩
  have hil : i ≤ b := Finset.le_max' S i hiS
  exact (not_lt_of_ge hil) hi

/-- Full target-existence equivalence, with weak blockers and favorable ties.
The order is represented by position-indexed primitive vectors; any permutation
is covered by precomposing all three vectors with that permutation. -/
theorem target_iff_blocker {n : ℕ} (hn : 0 < n) {p η k : Fin n → ℝ} {A B e : ℝ}
    (hp : ∀ i, 0 < p i ∧ p i < 1) (hk : ∀ i, 0 < k i)
    (hA : 0 < A) (hB : 0 < B) (he : 0 ≤ e) (heB : e < B)
    (ht : ∀ i, p i < A/(A+B)) :
    TargetExists p η k A B e ↔ ∃ i, WeakBlocker p η k i := by
  constructor
  · exact target_requires_blocker hn hp hA hB he heB ht
  · intro hb
    obtain ⟨b,hb,hlast⟩ := last_blocker p η k hb
    exact blocker_target_equilibrium hp hk hA hB he heB ht b hb hlast


/-- At and above the boundary, cooperation at every receiver history is optimal.
Equality at the complete transcript is retained, which makes B attained. -/
theorem receiver_silence_at_boundary {n : ℕ} {p : Fin n → ℝ} {σ : Strategy n}
    {A B e : ℝ} (hp : ∀ i, 0 < p i ∧ p i < 1) (hσ : Feasible σ)
    (hA : 0 < A) (hB : 0 < B) (he : B ≤ e)
    (ht : ∀ i, p i < A/(A+B)) (y : Fin n → Bool) :
    BestReply (receiverGain p (rateAt σ (terminalHist y)) (observed (terminalHist y)) A B e) 0 := by
  by_cases hc : y = (fun _ => true)
  · subst y
    have ho : observed (terminalHist (fun _ : Fin n => true)) = (fun _ => .report) := by
      funext i
      simp [terminal_observed]
    rw [ho,complete_receiver_gain]
    exact bestReply_nonpos_zero (sub_nonpos.mpr he)
  · obtain ⟨i,hi⟩ : ∃ i, y i = false := by
      by_contra! hh
      apply hc
      funext i
      cases hy : y i <;> simp_all
    have hs : observed (terminalHist y) i = .silent := by simp [terminal_observed,hi]
    have hg := incomplete_receiver_strict hp (rate_feasible hσ (terminalHist y))
      hA hB ((le_of_lt hB).trans he) ht i hs
    exact (bestReply_negative hg).mpr rfl

/-- Primitive utilities against a receiver who always cooperates, at all histories. -/
lemma sender_gain_zero_receiver {n : ℕ} (p : Fin n → ℝ) (σ : Strategy n) (h : Info n)
    (η k : ℝ) :
    senderPayoff p σ h (fun _ => 0) η k true -
      senderPayoff p σ h (fun _ => 0) η k false = -k := by
  simp [senderPayoff,pathExpectation]

theorem target_at_or_above_boundary {n : ℕ} {p η k : Fin n → ℝ} {A B e : ℝ}
    (hp : ∀ i, 0 < p i ∧ p i < 1) (hk : ∀ i, 0 < k i)
    (hA : 0 < A) (hB : 0 < B) (he : B ≤ e) (ht : ∀ i, p i < A/(A+B)) :
    TargetExists p η k A B e := by
  let s : Assessment n := ⟨fun _ => 0,fun _ => 0⟩
  have hσ : Feasible s.sender := by intro h; exact ⟨le_rfl,by norm_num⟩
  have hρ : ∀ y, 0 ≤ s.receiver y ∧ s.receiver y ≤ 1 := by
    intro y; exact ⟨le_rfl,by norm_num⟩
  refine ⟨s,⟨hσ,?_,?_,?_⟩,?_,rfl⟩
  · exact full_profile_consistency hp hσ s.receiver hρ
  · exact receiver_silence_at_boundary hp hσ hA hB he ht
  · intro h
    rw [sender_bestReply_gain]
    change BestReply (senderPayoff p s.sender h (fun _ => 0) _ _ true -
      senderPayoff p s.sender h (fun _ => 0) _ _ false) 0
    rw [sender_gain_zero_receiver]
    exact (bestReply_negative (neg_neg_of_pos (hk _))).mpr rfl
  · intro h _; rfl

/-- The complete feasible-fine classification, not only an infimum statement. -/
theorem feasible_fines {n : ℕ} (hn : 0 < n) {p η k : Fin n → ℝ} {A B e : ℝ}
    (hp : ∀ i, 0 < p i ∧ p i < 1) (hk : ∀ i, 0 < k i)
    (hA : 0 < A) (hB : 0 < B) (he : 0 ≤ e) (ht : ∀ i, p i < A/(A+B)) :
    TargetExists p η k A B e ↔ (∃ i, WeakBlocker p η k i) ∨ B ≤ e := by
  by_cases hbe : B ≤ e
  · exact ⟨fun _ => Or.inr hbe,fun _ => target_at_or_above_boundary hp hk hA hB hbe ht⟩
  · rw [or_iff_left hbe]
    exact target_iff_blocker hn hp hk hA hB he (lt_of_not_ge hbe) ht

def minimumFine {n : ℕ} (p η k : Fin n → ℝ) (B : ℝ) : ℝ := by
  classical
  exact if ∃ i, WeakBlocker p η k i then 0 else B

/-- The least credible fine is attained and equals exactly zero or B. -/
theorem attained_minimum {n : ℕ} (hn : 0 < n) {p η k : Fin n → ℝ} {A B : ℝ}
    (hp : ∀ i, 0 < p i ∧ p i < 1) (hk : ∀ i, 0 < k i)
    (hA : 0 < A) (hB : 0 < B) (ht : ∀ i, p i < A/(A+B)) :
    IsLeast {e : ℝ | 0 ≤ e ∧ TargetExists p η k A B e}
      (minimumFine p η k B) := by
  classical
  unfold minimumFine
  split_ifs with hb
  · refine ⟨⟨le_rfl,?_⟩,?_⟩
    · exact (target_iff_blocker hn hp hk hA hB le_rfl hB ht).mpr hb
    · intro e he
      exact he.1
  · refine ⟨⟨hB.le,target_at_or_above_boundary hp hk hA hB le_rfl ht⟩,?_⟩
    intro e he
    exact ((feasible_fines hn hp hk hA hB he.1 ht).mp he.2).resolve_left hb


/-- Headline theorem for assessments with unrestricted explicit belief fields. -/
theorem raw_target_iff_blocker {n : ℕ} (hn : 0 < n) {p η k : Fin n → ℝ} {A B e : ℝ}
    (hp : ∀ i, 0 < p i ∧ p i < 1) (hk : ∀ i, 0 < k i)
    (hA : 0 < A) (hB : 0 < B) (he : 0 ≤ e) (heB : e < B)
    (ht : ∀ i, p i < A/(A+B)) :
    RawTargetExists p η k A B e ↔ ∃ i, WeakBlocker p η k i := by
  rw [raw_target_iff_canonical hp]
  exact target_iff_blocker hn hp hk hA hB he heB ht

theorem raw_attained_minimum {n : ℕ} (hn : 0 < n) {p η k : Fin n → ℝ} {A B : ℝ}
    (hp : ∀ i, 0 < p i ∧ p i < 1) (hk : ∀ i, 0 < k i)
    (hA : 0 < A) (hB : 0 < B) (ht : ∀ i, p i < A/(A+B)) :
    IsLeast {e : ℝ | 0 ≤ e ∧ RawTargetExists p η k A B e}
      (minimumFine p η k B) := by
  simpa only [raw_target_iff_canonical hp] using attained_minimum hn hp hk hA hB ht


/-- Explicit permutation form of the strategic theorem, matching named actors
with publicly ordered protocol positions. -/
theorem ordered_raw_target_iff_blocker {n : ℕ} (hn : 0 < n)
    {p η k : Fin n → ℝ} {A B e : ℝ} (π : Equiv.Perm (Fin n))
    (hp : ∀ i, 0 < p i ∧ p i < 1) (hk : ∀ i, 0 < k i)
    (hA : 0 < A) (hB : 0 < B) (he : 0 ≤ e) (heB : e < B)
    (ht : ∀ i, p i < A/(A+B)) :
    RawTargetExists (p ∘ π) (η ∘ π) (k ∘ π) A B e ↔
      ∃ i : Fin n, η (π i) * (∏ j : Fin n, if i.val < j.val then p (π j) else 1) ≤ k (π i) := by
  simpa only [WeakBlocker,suffixProduct,Function.comp_apply] using
    raw_target_iff_blocker (p := p ∘ π) (η := η ∘ π) (k := k ∘ π) hn
      (fun i => hp (π i)) (fun i => hk (π i))
      hA hB he heB (fun i => ht (π i))

end
end Cooperation
