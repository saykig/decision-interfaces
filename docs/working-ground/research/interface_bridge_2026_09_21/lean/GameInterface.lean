import Equilibrium
import Interface

namespace DecisionInterface
open scoped BigOperators
noncomputable section

/-- Incidence of the actual ordered game's strict suffixes, with no extra sender. -/
def gameSuffix {n : ℕ} (j i : Fin n) : ℝ := if j.val < i.val then 1 else 0

lemma game_suffix_log {n : ℕ} {p : Fin n → ℝ}
    (hp : ∀ i, 0 < p i) (j : Fin n) :
    logScore (gameSuffix j) p = Real.log (Cooperation.suffixProduct p j) := by
  classical
  unfold Cooperation.suffixProduct
  rw [Real.log_prod (fun i _ => by split_ifs <;> simp_all [ne_of_gt (hp i)])]
  apply Finset.sum_congr rfl
  intro i _
  by_cases h : j.val < i.val
  · simp [gameSuffix, h]
  · simp [gameSuffix, h]

lemma suffix_positive {n : ℕ} {p : Fin n → ℝ} (hp : ∀ i, 0 < p i) (j : Fin n) :
    0 < Cooperation.suffixProduct p j := by
  apply Finset.prod_pos
  intro i _
  split_ifs
  · exact hp i
  · norm_num

lemma margin_nonpos_iff_blocker {n : ℕ} [Nonempty (Fin n)]
    {p η k : Fin n → ℝ} (hp : ∀ i, 0 < p i)
    (hη : ∀ i, 0 < η i) (hk : ∀ i, 0 < k i) :
    pointMargin gameSuffix (fun i => Real.log (k i / η i)) p ≤ 0 ↔
      ∃ i, Cooperation.WeakBlocker p η k i := by
  have hm := coordinate_minimum_spec
    (fun i : Fin n => logScore (gameSuffix i) p - Real.log (k i / η i))
  have row (i : Fin n) :
      logScore (gameSuffix i) p - Real.log (k i / η i) ≤ 0 ↔
        Cooperation.WeakBlocker p η k i := by
    rw [sub_nonpos,game_suffix_log hp i,Real.log_le_log_iff (suffix_positive hp i) (div_pos (hk i) (hη i))]
    unfold Cooperation.WeakBlocker
    rw [le_div_iff₀ (hη i)]
    rw [mul_comm]
  constructor
  · intro h
    obtain ⟨i,_,hi⟩ := hm.1
    exact ⟨i,(row i).mp (by change _ = pointMargin _ _ _ at hi; linarith)⟩
  · rintro ⟨i,hi⟩
    have hu := hm.2 i (Set.mem_univ i)
    have hr := (row i).mpr hi
    change pointMargin _ _ _ ≤ _ at hu
    linarith

/-- The actual explicit-belief equilibrium theorem is connected to the actual
max-min log-margin formalization, with the favorable zero boundary retained. -/
theorem raw_target_iff_margin {n : ℕ} [Nonempty (Fin n)]
    {p η k : Fin n → ℝ} {A B e : ℝ}
    (hp : ∀ i, 0 < p i ∧ p i < 1) (hη : ∀ i, 0 < η i) (hk : ∀ i, 0 < k i)
    (hA : 0 < A) (hB : 0 < B) (he : 0 ≤ e) (heB : e < B)
    (ht : ∀ i, p i < A/(A+B)) :
    Cooperation.RawTargetExists p η k A B e ↔
      pointMargin gameSuffix (fun i => Real.log (k i/η i)) p ≤ 0 := by
  rw [Cooperation.raw_target_iff_blocker (Fin.pos_iff_nonempty.mpr inferInstance)
    hp hk hA hB he heB ht]
  exact (margin_nonpos_iff_blocker (fun i => (hp i).1) hη hk).symm

/-- A common fixed-order robust query permits a different assessment for every p.
Its quantifiers are forall models / exists equilibrium, with the order held fixed. -/
theorem robust_raw_target_iff_margin {n : ℕ} [Nonempty (Fin n)]
    {P : Set (Fin n → ℝ)} {η k : Fin n → ℝ} {A B e m : ℝ}
    (hp : ∀ p ∈ P, ∀ i, 0 < p i ∧ p i < 1)
    (hη : ∀ i, 0 < η i) (hk : ∀ i, 0 < k i)
    (hA : 0 < A) (hB : 0 < B) (he : 0 ≤ e) (heB : e < B)
    (ht : ∀ p ∈ P, ∀ i, p i < A/(A+B))
    (hm : MaxValue P (pointMargin gameSuffix (fun i => Real.log (k i/η i))) m) :
    (∀ p ∈ P, Cooperation.RawTargetExists p η k A B e) ↔ m ≤ 0 := by
  constructor
  · intro h
    obtain ⟨p,hpP,heq⟩ := hm.1
    have hx := (raw_target_iff_margin (hp p hpP) hη hk hA hB he heB (ht p hpP)).mp (h p hpP)
    linarith
  · intro h p hpP
    apply (raw_target_iff_margin (hp p hpP) hη hk hA hB he heB (ht p hpP)).mpr
    exact (hm.2 p hpP).trans h

/-- A certified margin bracket licenses strategic conclusions; undecided signs
are intentionally absent from the conclusions of this theorem. -/
theorem certified_raw_decisions {n : ℕ} [Nonempty (Fin n)]
    {P : Set (Fin n → ℝ)} {η k : Fin n → ℝ} {A B e m lower error : ℝ}
    (hp : ∀ p ∈ P, ∀ i, 0 < p i ∧ p i < 1)
    (hη : ∀ i, 0 < η i) (hk : ∀ i, 0 < k i)
    (hA : 0 < A) (hB : 0 < B) (he : 0 ≤ e) (heB : e < B)
    (ht : ∀ p ∈ P, ∀ i, p i < A/(A+B))
    (hm : MaxValue P (pointMargin gameSuffix (fun i => Real.log (k i/η i))) m)
    (bracket : lower ≤ m ∧ m ≤ lower+error) :
    (lower+error ≤ 0 → ∀ p ∈ P, Cooperation.RawTargetExists p η k A B e) ∧
    (0 < lower → ¬ ∀ p ∈ P, Cooperation.RawTargetExists p η k A B e) := by
  have eq := robust_raw_target_iff_margin hp hη hk hA hB he heB ht hm
  constructor
  · intro h
    exact eq.mpr (bracket.2.trans h)
  · intro h hx
    have := eq.mp hx
    linarith [bracket.1]

/-- The institution chooses one allowed order before model uncertainty resolves.
Equilibria may depend on the model; the chosen order cannot. -/
theorem common_order_raw_target_iff_margin {n : ℕ} [Nonempty (Fin n)]
    {P : Set (Fin n → ℝ)} {η k : Fin n → ℝ} {A B e : ℝ}
    {allowed : Set (Equiv.Perm (Fin n))} {m : Equiv.Perm (Fin n) → ℝ}
    (hp : ∀ p ∈ P, ∀ i, 0 < p i ∧ p i < 1)
    (hη : ∀ i, 0 < η i) (hk : ∀ i, 0 < k i)
    (hA : 0 < A) (hB : 0 < B) (he : 0 ≤ e) (heB : e < B)
    (ht : ∀ p ∈ P, ∀ i, p i < A/(A+B))
    (hm : ∀ π ∈ allowed, MaxValue P
      (fun p => pointMargin gameSuffix (fun i => Real.log (k (π i)/η (π i))) (p ∘ π)) (m π)) :
    (∃ π ∈ allowed, ∀ p ∈ P,
      Cooperation.RawTargetExists (p ∘ π) (η ∘ π) (k ∘ π) A B e) ↔
    ∃ π ∈ allowed, m π ≤ 0 := by
  constructor
  · rintro ⟨π,hπ,hE⟩
    obtain ⟨p,hpP,heq⟩ := (hm π hπ).1
    have hx := (raw_target_iff_margin (fun i => hp p hpP (π i))
      (fun i => hη (π i)) (fun i => hk (π i)) hA hB he heB
      (fun i => ht p hpP (π i))).mp (hE p hpP)
    exact ⟨π,hπ,by rw [← heq]; exact hx⟩
  · rintro ⟨π,hπ,hzero⟩
    refine ⟨π,hπ,?_⟩
    intro p hpP
    apply (raw_target_iff_margin (fun i => hp p hpP (π i))
      (fun i => hη (π i)) (fun i => hk (π i)) hA hB he heB
      (fun i => ht p hpP (π i))).mpr
    exact ((hm π hπ).2 p hpP).trans hzero

/-- End-to-end mathematical contract: an actual log-support error certificate
implies safe/unsafe conclusions about raw sequential-equilibrium assessments. -/
theorem support_error_raw_decisions {n : ℕ} [Nonempty (Fin n)]
    {P Q : Set (Fin n → ℝ)} {η k : Fin n → ℝ} {A B e mp mq δ : ℝ}
    {HP HQ : (Fin n → ℝ) → ℝ}
    (nP : P.Nonempty) (nQ : Q.Nonempty) (cP : Convex ℝ P) (cQ : Convex ℝ Q)
    (kP : IsCompact P) (kQ : IsCompact Q) (posQ : Positive Q)
    (hp : ∀ p ∈ P, ∀ i, 0 < p i ∧ p i < 1)
    (hη : ∀ i, 0 < η i) (hk : ∀ i, 0 < k i)
    (hA : 0 < A) (hB : 0 < B) (he : 0 ≤ e) (heB : e < B)
    (ht : ∀ p ∈ P, ∀ i, p i < A/(A+B))
    (hHP : ∀ w ∈ WeightBox, Support P w (HP w))
    (hHQ : ∀ w ∈ WeightBox, Support Q w (HQ w))
    (hmp : MaxValue P (pointMargin gameSuffix (fun i => Real.log (k i/η i))) mp)
    (hmq : MaxValue Q (pointMargin gameSuffix (fun i => Real.log (k i/η i))) mq)
    (hprofile : ∀ w ∈ WeightBox, 0 ≤ HP w-HQ w ∧ HP w-HQ w ≤ δ) :
    (mq+δ ≤ 0 → ∀ p ∈ P, Cooperation.RawTargetExists p η k A B e) ∧
    (0 < mq → ¬ ∀ p ∈ P, Cooperation.RawTargetExists p η k A B e) := by
  have hmatrix : ∀ j i : Fin n, 0 ≤ gameSuffix j i ∧ gameSuffix j i ≤ 1 := by
    intro j i
    unfold gameSuffix
    split_ifs <;> norm_num
  have hbracket := contextual_primal_interval nP nQ cP cQ kP kQ
    (fun p hpP i => (hp p hpP i).1) posQ hmatrix hHP hHQ
    (fun p _ => coordinate_minimum_spec _) (fun q _ => coordinate_minimum_spec _)
    hmp hmq hprofile
  exact certified_raw_decisions hp hη hk hA hB he heB ht hmp hbracket

end
end DecisionInterface
