import Mathlib.Data.Real.Basic
import Mathlib.Data.Fintype.Basic
import Mathlib.Data.Finset.Dedup
import Mathlib.Tactic

namespace DecisionInterface
noncomputable section

/-- `none` is infeasibility, not the numerical budget zero. -/
def BudgetMax : Option ℝ → Option ℝ → Option ℝ
  | none, b => b
  | b, none => b
  | some a, some b => some (max a b)

def BudgetAdd : Option ℝ → Option ℝ → Option ℝ
  | some a, some b => some (a+b)
  | _, _ => none

/-- A returned budget is attained and bounds every feasible assignment value.
An infeasibility result means there is no feasible value. -/
def BudgetRepresents (b : Option ℝ) (S : Set ℝ) : Prop :=
  match b with
  | none => S = ∅
  | some a => a ∈ S ∧ ∀ x ∈ S, x ≤ a

def BudgetSumSet (S T : Set ℝ) : Set ℝ :=
  {x | ∃ s ∈ S, ∃ t ∈ T, x = s+t}

lemma budget_none : BudgetRepresents none (∅ : Set ℝ) := rfl

lemma budget_singleton (a : ℝ) : BudgetRepresents (some a) {a} := by
  exact ⟨rfl,fun x hx => le_of_eq (Set.mem_singleton_iff.mp hx)⟩

/-- Choice recurrence proved against union semantics, including empty branches. -/
theorem budget_max_correct {a b : Option ℝ} {S T : Set ℝ}
    (ha : BudgetRepresents a S) (hb : BudgetRepresents b T) :
    BudgetRepresents (BudgetMax a b) (S ∪ T) := by
  cases a with
  | none =>
    change S = ∅ at ha
    subst S
    simpa only [BudgetMax,Set.empty_union] using hb
  | some a =>
    cases b with
    | none =>
      change T = ∅ at hb
      subst T
      simpa only [BudgetMax,Set.union_empty] using ha
    | some b =>
      change a ∈ S ∧ (∀ x ∈ S, x ≤ a) at ha
      change b ∈ T ∧ (∀ x ∈ T, x ≤ b) at hb
      change max a b ∈ S ∪ T ∧ ∀ x ∈ S ∪ T, x ≤ max a b
      constructor
      · by_cases h : a ≤ b
        · rw [max_eq_right h]; exact Or.inr hb.1
        · rw [max_eq_left (le_of_not_ge h)]; exact Or.inl ha.1
      · intro x hx
        rcases hx with hx | hx
        · exact (ha.2 x hx).trans (le_max_left _ _)
        · exact (hb.2 x hx).trans (le_max_right _ _)

/-- Independent-child recurrence proved against independently chosen values. -/
theorem budget_add_correct {a b : Option ℝ} {S T : Set ℝ}
    (ha : BudgetRepresents a S) (hb : BudgetRepresents b T) :
    BudgetRepresents (BudgetAdd a b) (BudgetSumSet S T) := by
  cases a with
  | none =>
    change S = ∅ at ha
    subst S
    simp [BudgetAdd,BudgetRepresents,BudgetSumSet]
  | some a =>
    cases b with
    | none =>
      change T = ∅ at hb
      subst T
      simp [BudgetAdd,BudgetRepresents,BudgetSumSet]
    | some b =>
      change a ∈ S ∧ (∀ x ∈ S, x ≤ a) at ha
      change b ∈ T ∧ (∀ x ∈ T, x ≤ b) at hb
      refine ⟨⟨a,ha.1,b,hb.1,rfl⟩,?_⟩
      rintro x ⟨s,hs,t,ht,rfl⟩
      exact add_le_add (ha.2 s hs) (hb.2 t ht)

/-- Finite branch elimination, without convexifying the union. -/
def BudgetChoices {L : Type*} : List L → (L → Option ℝ) → Option ℝ
  | [], _ => none
  | a::as, f => BudgetMax (f a) (BudgetChoices as f)

def BudgetChoiceSet {L : Type*} (labels : List L) (S : L → Set ℝ) : Set ℝ :=
  {x | ∃ label ∈ labels, x ∈ S label}

theorem budget_choices_correct {L : Type*} (labels : List L)
    (f : L → Option ℝ) (S : L → Set ℝ)
    (hf : ∀ label ∈ labels, BudgetRepresents (f label) (S label)) :
    BudgetRepresents (BudgetChoices labels f) (BudgetChoiceSet labels S) := by
  induction labels with
  | nil => simp [BudgetChoices,BudgetChoiceSet,BudgetRepresents]
  | cons a as ih =>
    have hset : BudgetChoiceSet (a::as) S = S a ∪ BudgetChoiceSet as S := by
      ext x
      simp only [BudgetChoiceSet,Set.mem_setOf_eq,List.mem_cons,Set.mem_union]
      aesop
    rw [hset]
    exact budget_max_correct (hf a (by simp)) (ih (fun l hl => hf l (by simp [hl])))

/-- Independent sums over any finite number of children. The empty forest has
one feasible total, zero; a nonempty infeasible child makes the whole forest infeasible. -/
def BudgetSums {I : Type*} : List I → (I → Option ℝ) → Option ℝ
  | [], _ => some 0
  | i::is, f => BudgetAdd (f i) (BudgetSums is f)

def BudgetForestSet {I : Type*} : List I → (I → Set ℝ) → Set ℝ
  | [], _ => {0}
  | i::is, S => BudgetSumSet (S i) (BudgetForestSet is S)

/-- General finite-child induction contract; child semantics may themselves be
assignment sets of arbitrary finite subtrees. -/
theorem budget_forest_correct {I : Type*} (children : List I)
    (f : I → Option ℝ) (S : I → Set ℝ)
    (hf : ∀ i ∈ children, BudgetRepresents (f i) (S i)) :
    BudgetRepresents (BudgetSums children f) (BudgetForestSet children S) := by
  induction children with
  | nil => exact budget_singleton 0
  | cons i is ih =>
    exact budget_add_correct (hf i (by simp)) (ih (fun j hj => hf j (by simp [hj])))

/-- General masked child elimination. The mask is applied before the maximum. -/
theorem budget_masked_choices_correct {L : Type*} [Fintype L]
    (allowed : L → Bool) (f : L → Option ℝ) (S : L → Set ℝ)
    (hf : ∀ l, BudgetRepresents (f l) (S l)) :
    BudgetRepresents
      (BudgetChoices Finset.univ.toList (fun l => if allowed l then f l else none))
      {x | ∃ l, allowed l = true ∧ x ∈ S l} := by
  classical
  let T : L → Set ℝ := fun l => if allowed l then S l else ∅
  have hset : BudgetChoiceSet Finset.univ.toList T =
      {x | ∃ l, allowed l = true ∧ x ∈ S l} := by
    ext x
    simp only [BudgetChoiceSet,Set.mem_setOf_eq,Finset.mem_toList,Finset.mem_univ,true_and,T]
    constructor
    · rintro ⟨l,hl⟩
      cases hm : allowed l with
      | false => simp [hm] at hl
      | true => exact ⟨l,hm,by simpa [hm] using hl⟩
    · rintro ⟨l,hl,hx⟩
      exact ⟨l,by simpa [hl] using hx⟩
  rw [← hset]
  apply budget_choices_correct
  intro l _
  cases hm : allowed l
  · simp [hm,T,BudgetRepresents]
  · simpa [hm,T] using hf l

/-- Arbitrary finite-arity max-sum node contract. Once the shared parent label is
fixed, each compatible child chooses its own complete subtree assignment. Thus
this is an induction step for general finite labelled trees, not only binary ones. -/
theorem finite_masked_node_correct {I L : Type*} [Fintype L]
    (children : List I) (localCost : ℝ) (root : L)
    (mask : I → L → L → Bool) (f : I → L → Option ℝ) (S : I → L → Set ℝ)
    (hf : ∀ i ∈ children, ∀ l, BudgetRepresents (f i l) (S i l)) :
    BudgetRepresents
      (BudgetAdd (some localCost) (BudgetSums children (fun i =>
        BudgetChoices Finset.univ.toList (fun l => if mask i root l then f i l else none))))
      (BudgetSumSet {localCost} (BudgetForestSet children (fun i =>
        {x | ∃ l, mask i root l = true ∧ x ∈ S i l}))) := by
  apply budget_add_correct (budget_singleton localCost)
  apply budget_forest_correct
  intro i hi
  exact budget_masked_choices_correct (mask i root) (f i) (S i) (hf i hi)

/-- A rooted binary label tree. Each edge preserves its own Boolean compatibility
mask; node costs are evaluated at that node's chosen label. -/
inductive BudgetTree (L : Type*) where
  | leaf (cost : L → ℝ)
  | fork (cost : L → ℝ) (leftMask rightMask : L → L → Bool)
      (left right : BudgetTree L)

/-- Actual assignments choose one label at EVERY node, not just one root label. -/
def BudgetTree.Assignment {L : Type*} : BudgetTree L → Type _
  | .leaf _ => L
  | .fork _ _ _ left right => L × left.Assignment × right.Assignment

def BudgetTree.rootLabel {L : Type*} : (t : BudgetTree L) → t.Assignment → L
  | .leaf _, a => a
  | .fork _ _ _ _ _, a => a.1

def BudgetTree.Compatible {L : Type*} : (t : BudgetTree L) → t.Assignment → Prop
  | .leaf _, _ => True
  | .fork _ lm rm left right, a =>
      lm a.1 (left.rootLabel a.2.1) = true ∧
      rm a.1 (right.rootLabel a.2.2) = true ∧
      left.Compatible a.2.1 ∧ right.Compatible a.2.2

def BudgetTree.assignmentTotal {L : Type*} : (t : BudgetTree L) → t.Assignment → ℝ
  | .leaf cost, a => cost a
  | .fork cost _ _ left right, a =>
      cost a.1 + (left.assignmentTotal a.2.1 + right.assignmentTotal a.2.2)

def BudgetTree.attainable {L : Type*} (t : BudgetTree L) (root : L) : Set ℝ :=
  {x | ∃ a : t.Assignment, t.rootLabel a = root ∧ t.Compatible a ∧ x = t.assignmentTotal a}

def BudgetTree.branchValues {L : Type*} (t : BudgetTree L) (mask : L → L → Bool)
    (root : L) : Set ℝ :=
  {x | ∃ label, mask root label = true ∧ x ∈ t.attainable label}

/-- Bottom-up max-sum recurrence, independently defined from assignments. -/
def BudgetTree.message {L : Type*} [Fintype L] : BudgetTree L → L → Option ℝ
  | .leaf cost, root => some (cost root)
  | .fork cost lm rm left right, root =>
      BudgetAdd (some (cost root))
        (BudgetAdd
          (BudgetChoices Finset.univ.toList (fun l => if lm root l then left.message l else none))
          (BudgetChoices Finset.univ.toList (fun l => if rm root l then right.message l else none)))

lemma budget_branch_correct {L : Type*} [Fintype L] (t : BudgetTree L)
    (mask : L → L → Bool) (root : L)
    (ht : ∀ label, BudgetRepresents (t.message label) (t.attainable label)) :
    BudgetRepresents
      (BudgetChoices Finset.univ.toList (fun l => if mask root l then t.message l else none))
      (t.branchValues mask root) := by
  classical
  let S : L → Set ℝ := fun l => if mask root l then t.attainable l else ∅
  have hset : BudgetChoiceSet Finset.univ.toList S = t.branchValues mask root := by
    ext x
    simp only [BudgetChoiceSet,BudgetTree.branchValues,Set.mem_setOf_eq,
      Finset.mem_toList,Finset.mem_univ,true_and,S]
    constructor
    · rintro ⟨l,hl⟩
      cases hm : mask root l with
      | false => simp [hm] at hl
      | true => exact ⟨l,hm,by simpa [hm] using hl⟩
    · rintro ⟨l,hl,hx⟩
      exact ⟨l,by simpa [hl] using hx⟩
  rw [← hset]
  apply budget_choices_correct
  intro l _
  cases hm : mask root l
  · simp [hm,S,BudgetRepresents]
  · simpa [hm,S] using ht l

lemma budget_leaf_attainable {L : Type*} (cost : L → ℝ) (root : L) :
    (BudgetTree.leaf cost).attainable root = {cost root} := by
  ext x
  constructor
  · rintro ⟨a,ha,_,hx⟩
    change a = root at ha
    subst a
    exact hx
  · intro hx
    exact ⟨root,rfl,True.intro,hx⟩

/-- Assignment decomposition is proved from node/edge semantics. In particular,
shared root labels are fixed before independently maximizing child assignments. -/
lemma budget_fork_attainable {L : Type*} (cost : L → ℝ) (lm rm : L → L → Bool)
    (left right : BudgetTree L) (root : L) :
    (BudgetTree.fork cost lm rm left right).attainable root =
      BudgetSumSet {cost root} (BudgetSumSet (left.branchValues lm root) (right.branchValues rm root)) := by
  ext x
  constructor
  · rintro ⟨⟨label,a,b⟩,hr,hc,hx⟩
    change label = root at hr
    subst label
    rcases hc with ⟨hl,hr,ha,hb⟩
    exact ⟨cost root,rfl,left.assignmentTotal a + right.assignmentTotal b,
      ⟨left.assignmentTotal a,⟨left.rootLabel a,hl,a,rfl,ha,rfl⟩,
        right.assignmentTotal b,⟨right.rootLabel b,hr,b,rfl,hb,rfl⟩,rfl⟩,hx⟩
  · rintro ⟨c,hc,z,⟨u,⟨la,hla,a,har,hac,hu⟩,v,⟨lb,hlb,b,hbr,hbc,hv⟩,hz⟩,hx⟩
    have hc' : c = cost root := hc
    refine ⟨⟨root,a,b⟩,rfl,?_,?_⟩
    · exact ⟨by simpa [har] using hla,by simpa [hbr] using hlb,hac,hbc⟩
    · change x = cost root + (left.assignmentTotal a + right.assignmentTotal b)
      rw [hx,hc',hz,hu,hv]

/-- Exact finite-tree DP theorem: a numerical message is an attained maximum over
all compatible assignments; `none` means no compatible assignment exists. -/
theorem tree_message_correct {L : Type*} [Fintype L] (t : BudgetTree L) (root : L) :
    BudgetRepresents (t.message root) (t.attainable root) := by
  induction t generalizing root with
  | leaf cost =>
    rw [budget_leaf_attainable]
    exact budget_singleton _
  | fork cost lm rm left right ihl ihr =>
    rw [budget_fork_attainable]
    exact budget_add_correct (budget_singleton _)
      (budget_add_correct (budget_branch_correct left lm root ihl)
        (budget_branch_correct right rm root ihr))

/-- The root label can also be selected, retaining infeasibility for an empty label set. -/
def BudgetTree.globalMessage {L : Type*} [Fintype L] (t : BudgetTree L) : Option ℝ :=
  BudgetChoices Finset.univ.toList t.message

theorem tree_global_message_correct {L : Type*} [Fintype L] (t : BudgetTree L) :
    BudgetRepresents t.globalMessage {x | ∃ a : t.Assignment, t.Compatible a ∧ x = t.assignmentTotal a} := by
  classical
  have hh := budget_choices_correct Finset.univ.toList t.message t.attainable
    (fun l _ => tree_message_correct t l)
  have heq : BudgetChoiceSet Finset.univ.toList t.attainable =
      {x | ∃ a : t.Assignment, t.Compatible a ∧ x = t.assignmentTotal a} := by
    ext x
    simp only [BudgetChoiceSet,Set.mem_setOf_eq,Finset.mem_toList,Finset.mem_univ,true_and,
      BudgetTree.attainable]
    constructor
    · rintro ⟨l,a,_,ha,hx⟩
      exact ⟨a,ha,hx⟩
    · rintro ⟨a,ha,hx⟩
      exact ⟨t.rootLabel a,a,rfl,ha,hx⟩
  simpa only [BudgetTree.globalMessage,heq] using hh


/-- A certified bound on each compatible assignment is transported by the DP.
The per-assignment error law is an explicit premise, supplied downstream by
independent-product addition and local interface bounds. -/
theorem tree_error_transport {L : Type*} [Fintype L] (t : BudgetTree L)
    (error : t.Assignment → ℝ) (B : ℝ)
    (herror : ∀ a, t.Compatible a → error a ≤ t.assignmentTotal a)
    (hmessage : t.globalMessage = some B) :
    ∀ a, t.Compatible a → error a ≤ B := by
  have hc := tree_global_message_correct t
  rw [hmessage] at hc
  intro a ha
  exact (herror a ha).trans (hc.2 _ ⟨a,ha,rfl⟩)

/-- Incompatible label trees remain empty; a missing branch never becomes zero. -/
theorem tree_infeasible_iff {L : Type*} [Fintype L] (t : BudgetTree L) :
    t.globalMessage = none ↔ ¬ ∃ a : t.Assignment, t.Compatible a := by
  constructor
  · intro hm he
    have hc := tree_global_message_correct t
    rw [hm] at hc
    change {x | ∃ a : t.Assignment, t.Compatible a ∧ x = t.assignmentTotal a} = ∅ at hc
    obtain ⟨a,ha⟩ := he
    have hh : t.assignmentTotal a ∈ {x | ∃ b : t.Assignment, t.Compatible b ∧ x = t.assignmentTotal b} :=
      ⟨a,ha,rfl⟩
    rw [hc] at hh
    exact hh
  · intro he
    cases hm : t.globalMessage with
    | none => rfl
    | some b =>
      have hc := tree_global_message_correct t
      rw [hm] at hc
      obtain ⟨a,ha,_⟩ := hc.1
      exact False.elim (he ⟨a,ha⟩)

end
end DecisionInterface
