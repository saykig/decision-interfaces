import Mathlib.Analysis.SpecialFunctions.Log.Basic
import Mathlib.Analysis.SpecialFunctions.Exp
import Mathlib.Analysis.Convex.Hull
import Mathlib.Analysis.Convex.StdSimplex
import Mathlib.Analysis.Convex.SpecificFunctions.Basic
import Mathlib.Topology.Sion
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring
import Mathlib.Tactic.NormNum
import Mathlib.Tactic.Choose

/-!
The real-valued mathematical interface, independently of a binary codec.
Extremum witnesses below state actual attainment and all-point optimality;
they are not wrappers around the desired comparison conclusion.
-/
namespace DecisionInterface
open scoped BigOperators
noncomputable section

def MaxValue {X : Type*} (S : Set X) (f : X → ℝ) (v : ℝ) : Prop :=
  (∃ x ∈ S, f x = v) ∧ ∀ x ∈ S, f x ≤ v

def MinValue {X : Type*} (S : Set X) (f : X → ℝ) (v : ℝ) : Prop :=
  (∃ x ∈ S, f x = v) ∧ ∀ x ∈ S, v ≤ f x

theorem max_transfer {X Y : Type*} {S : Set X} {T : Set Y}
    {f : X → ℝ} {g : Y → ℝ} {a b e : ℝ}
    (ha : MaxValue S f a) (hb : MaxValue T g b)
    (h : ∀ x ∈ S, ∃ y ∈ T, f x ≤ g y + e) : a ≤ b + e := by
  obtain ⟨x, hx, hfx⟩ := ha.1
  obtain ⟨y, hy, hxy⟩ := h x hx
  have := hb.2 y hy
  linarith

theorem min_transfer {X : Type*} {S : Set X} {f g : X → ℝ} {a b e : ℝ}
    (ha : MinValue S f a) (hb : MinValue S g b)
    (h : ∀ x ∈ S, f x ≤ g x + e) : a ≤ b + e := by
  obtain ⟨x, hx, hgx⟩ := hb.1
  have := ha.2 x hx
  have := h x hx
  linarith

def logScore {I : Type*} [Fintype I] (w p : I → ℝ) : ℝ :=
  ∑ i, w i * Real.log (p i)

def Positive {I : Type*} (P : Set (I → ℝ)) : Prop :=
  ∀ p ∈ P, ∀ i, 0 < p i

def Dominated {I : Type*} (P Q : Set (I → ℝ)) (c : ℝ) : Prop :=
  ∀ p ∈ P, ∃ q ∈ Q, ∀ i, p i ≤ c * q i

def Support {I : Type*} [Fintype I] (P : Set (I → ℝ)) (w : I → ℝ) (h : ℝ) : Prop :=
  MaxValue P (logScore w) h

/-- The finite rational vertex certificate lifts to the entire convex hull.
This real theorem also accepts the coerced exact rational witnesses. -/
theorem vertex_domination_lifts {I : Type*} {V Q : Set (I → ℝ)} {c : ℝ}
    (hQ : Convex ℝ Q)
    (vertices : ∀ v ∈ V, ∃ q ∈ Q, ∀ i, v i ≤ c * q i) :
    Dominated (convexHull ℝ V) Q c := by
  have hc : Convex ℝ {p : I → ℝ | ∃ q ∈ Q, ∀ i, p i ≤ c * q i} := by
    intro x hx y hy a b ha hb hab
    obtain ⟨q, hq, hxq⟩ := hx
    obtain ⟨r, hr, hyr⟩ := hy
    refine ⟨a • q + b • r, hQ hq hr ha hb hab, ?_⟩
    intro i
    simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
    have hx' := mul_le_mul_of_nonneg_left (hxq i) ha
    have hy' := mul_le_mul_of_nonneg_left (hyr i) hb
    nlinarith
  exact convexHull_min vertices hc

theorem rational_vertex_sandwich {I : Type*} (V W : Set (I → ℝ)) (η : ℝ)
    (lower : ∀ w ∈ W, ∃ p ∈ convexHull ℝ V, ∀ i, w i ≤ p i)
    (upper : ∀ v ∈ V, ∃ q ∈ convexHull ℝ W, ∀ i, v i ≤ (1 + η) * q i) :
    Dominated (convexHull ℝ W) (convexHull ℝ V) 1 ∧
    Dominated (convexHull ℝ V) (convexHull ℝ W) (1 + η) := by
  constructor
  · apply vertex_domination_lifts (convex_convexHull ℝ V)
    simpa only [one_mul] using lower
  · exact vertex_domination_lifts (convex_convexHull ℝ W) upper

theorem log_score_domination {I : Type*} [Fintype I]
    {p q w : I → ℝ} {c : ℝ} (hp : ∀ i, 0 < p i) (hq : ∀ i, 0 < q i)
    (hw : ∀ i, 0 ≤ w i) (hc : 0 < c) (h : ∀ i, p i ≤ c * q i) :
    logScore w p ≤ logScore w q + Real.log c * ∑ i, w i := by
  calc
    logScore w p ≤ ∑ i, w i * (Real.log c + Real.log (q i)) := by
      apply Finset.sum_le_sum
      intro i _
      apply mul_le_mul_of_nonneg_left _ (hw i)
      rw [← Real.log_mul (ne_of_gt hc) (ne_of_gt (hq i))]
      exact Real.log_le_log (hp i) (h i)
    _ = logScore w q + Real.log c * ∑ i, w i := by
      simp only [mul_add, Finset.sum_add_distrib, ← Finset.sum_mul, logScore]
      ring

theorem support_domination {I : Type*} [Fintype I]
    {P Q : Set (I → ℝ)} {w : I → ℝ} {c hp hq : ℝ}
    (hP : Positive P) (hQ : Positive Q) (hw : ∀ i, 0 ≤ w i)
    (hc : 0 < c) (hdom : Dominated P Q c)
    (sp : Support P w hp) (sq : Support Q w hq) :
    hp ≤ hq + Real.log c * ∑ i, w i := by
  apply max_transfer sp sq
  intro p hp'
  obtain ⟨q, hq', hd⟩ := hdom p hp'
  exact ⟨q, hq', log_score_domination (hP p hp') (hQ q hq') hw hc hd⟩

/-- Semantic sandwich; rationals embed into this real theorem without rounding. -/
theorem sandwich_support {I : Type*} [Fintype I]
    {P Q : Set (I → ℝ)} {w : I → ℝ} {η hp hq : ℝ}
    (hP : Positive P) (hQ : Positive Q) (hw : ∀ i, 0 ≤ w i) (hη : 0 ≤ η)
    (lower : Dominated Q P 1) (upper : Dominated P Q (1 + η))
    (sp : Support P w hp) (sq : Support Q w hq) :
    0 ≤ hp - hq ∧ hp - hq ≤ Real.log (1 + η) * ∑ i, w i := by
  have hl := support_domination hQ hP hw (by norm_num : (0 : ℝ) < 1) lower sq sp
  have hu := support_domination hP hQ hw (by linarith : 0 < 1 + η) upper sp sq
  simp only [Real.log_one, zero_mul, add_zero] at hl
  constructor <;> linarith

def WeightBox {I : Type*} : Set (I → ℝ) := {w | ∀ i, 0 ≤ w i ∧ w i ≤ 1}

theorem sandwich_box_error {I : Type*} [Fintype I]
    {P Q : Set (I → ℝ)} {w : I → ℝ} {η hp hq : ℝ}
    (hP : Positive P) (hQ : Positive Q) (hw : w ∈ WeightBox) (hη : 0 ≤ η)
    (lower : Dominated Q P 1) (upper : Dominated P Q (1 + η))
    (sp : Support P w hp) (sq : Support Q w hq) :
    0 ≤ hp - hq ∧ hp - hq ≤ (Fintype.card I : ℝ) * η := by
  have hs := sandwich_support hP hQ (fun i => (hw i).1) hη lower upper sp sq
  have hw_sum : (∑ i, w i) ≤ (Fintype.card I : ℝ) := by
    calc
      (∑ i, w i) ≤ ∑ _i : I, (1 : ℝ) := Finset.sum_le_sum (fun i _ => (hw i).2)
      _ = _ := by simp
  have hlog : Real.log (1 + η) ≤ η := by
    have := Real.log_le_sub_one_of_pos (by linarith : 0 < 1 + η)
    linarith
  have hsum : 0 ≤ ∑ i, w i := Finset.sum_nonneg (fun i _ => (hw i).1)
  refine ⟨hs.1, hs.2.trans ?_⟩
  calc
    Real.log (1 + η) * ∑ i, w i ≤ η * ∑ i, w i := mul_le_mul_of_nonneg_right hlog hsum
    _ ≤ η * (Fintype.card I : ℝ) := mul_le_mul_of_nonneg_left hw_sum hη
    _ = _ := mul_comm _ _

/-! Contextual dual objectives. Their equivalence to the actual primal margin
is proved below by `primal_margin_has_dual`, using Sion's theorem. -/
def Simplex {J : Type*} [Fintype J] : Set (J → ℝ) :=
  {a | (∀ j, 0 ≤ a j) ∧ ∑ j, a j = 1}

def inducedWeight {I J : Type*} [Fintype J] (A : J → I → ℝ) (a : J → ℝ) : I → ℝ :=
  fun i => ∑ j, a j * A j i

theorem induced_weight_box {I J : Type*} [Fintype J] {A : J → I → ℝ}
    (hA : ∀ j i, 0 ≤ A j i ∧ A j i ≤ 1) {a : J → ℝ} (ha : a ∈ Simplex) :
    inducedWeight A a ∈ WeightBox := by
  intro i
  constructor
  · exact Finset.sum_nonneg (fun j _ => mul_nonneg (ha.1 j) (hA j i).1)
  · calc
      inducedWeight A a i ≤ ∑ j, a j * 1 := by
        exact Finset.sum_le_sum (fun j _ => mul_le_mul_of_nonneg_left (hA j i).2 (ha.1 j))
      _ = 1 := by simpa using ha.2

def dualObjective {I J : Type*} [Fintype J] (H : (I → ℝ) → ℝ)
    (A : J → I → ℝ) (c : J → ℝ) (a : J → ℝ) : ℝ :=
  H (inducedWeight A a) - ∑ j, a j * c j

theorem contextual_dual_interval {I J : Type*} [Fintype J]
    {HP HQ : (I → ℝ) → ℝ} {A : J → I → ℝ} {c : J → ℝ} {mp mq e : ℝ}
    (hA : ∀ j i, 0 ≤ A j i ∧ A j i ≤ 1)
    (hprofile : ∀ w ∈ WeightBox, 0 ≤ HP w - HQ w ∧ HP w - HQ w ≤ e)
    (hp : MinValue Simplex (dualObjective HP A c) mp)
    (hq : MinValue Simplex (dualObjective HQ A c) mq) :
    mq ≤ mp ∧ mp ≤ mq + e := by
  have lo : mq ≤ mp + 0 := min_transfer hq hp (by
    intro a ha
    have := (hprofile _ (induced_weight_box hA ha)).1
    dsimp [dualObjective]
    linarith)
  have hi : mp ≤ mq + e := min_transfer hp hq (by
    intro a ha
    have := (hprofile _ (induced_weight_box hA ha)).2
    dsimp [dualObjective]
    linarith)
  exact ⟨by linarith, hi⟩

theorem min_le_weighted {J : Type*} [Fintype J] {a v : J → ℝ} {m : ℝ}
    (ha : a ∈ Simplex) (hm : MinValue Set.univ v m) : m ≤ ∑ j, a j * v j := by
  calc
    m = ∑ j, a j * m := by rw [← Finset.sum_mul, ha.2, one_mul]
    _ ≤ ∑ j, a j * v j :=
      Finset.sum_le_sum (fun j _ => mul_le_mul_of_nonneg_left (hm.2 j (Set.mem_univ j)) (ha.1 j))

theorem weighted_score_identity {I J : Type*} [Fintype I] [Fintype J]
    (A : J → I → ℝ) (a : J → ℝ) (p : I → ℝ) :
    (∑ j, a j * logScore (A j) p) = logScore (inducedWeight A a) p := by
  simp only [logScore, inducedWeight, Finset.mul_sum, Finset.sum_mul]
  rw [Finset.sum_comm]
  apply Finset.sum_congr rfl
  intro i _
  apply Finset.sum_congr rfl
  intro j _
  ring

/-- The support-maximizer cost construction, on the actual max-min margin.
For a one-sender context A is the suffix incidence matrix after sorting w;
the external combinatorial obligation is to produce a simplex a with induced w.
No minimax identity is needed for this direction. -/
theorem contextual_attainment_certificate {I J : Type*} [Fintype I] [Fintype J]
    {P Q : Set (I → ℝ)} {A : J → I → ℝ} {a : J → ℝ}
    {pstar : I → ℝ} {HP HQ z mp mq : ℝ} {fp fq : (I → ℝ) → ℝ}
    (ha : a ∈ Simplex) (hpstar : pstar ∈ P)
    (hstar : logScore (inducedWeight A a) pstar = HP)
    (hP : Support P (inducedWeight A a) HP) (hQ : Support Q (inducedWeight A a) HQ)
    (fp_def : ∀ p ∈ P, MinValue Set.univ
      (fun j => logScore (A j) p - (logScore (A j) pstar - z)) (fp p))
    (fq_def : ∀ q ∈ Q, MinValue Set.univ
      (fun j => logScore (A j) q - (logScore (A j) pstar - z)) (fq q))
    (hp : MaxValue P fp mp) (hq : MaxValue Q fq mq) :
    mp = z ∧ mq ≤ z - (HP - HQ) := by
  have weighted (p : I → ℝ) :
      (∑ j, a j * (logScore (A j) p - (logScore (A j) pstar - z))) =
      logScore (inducedWeight A a) p - HP + z := by
    simp only [mul_sub, Finset.sum_sub_distrib, ← Finset.sum_mul]
    rw [weighted_score_identity, weighted_score_identity, hstar, ha.2]
    ring
  have fp_le (p) (hp' : p ∈ P) : fp p ≤ z := by
    have hh := min_le_weighted ha (fp_def p hp')
    rw [weighted] at hh
    have := hP.2 p hp'
    linarith
  have fs : fp pstar = z := by
    obtain ⟨j, _, hj⟩ := (fp_def pstar hpstar).1
    linarith
  have ml := hp.2 pstar hpstar
  obtain ⟨p, hp', heq⟩ := hp.1
  have mu := fp_le p hp'
  have hm : mp = z := by linarith
  refine ⟨hm, ?_⟩
  obtain ⟨q, hq', heq⟩ := hq.1
  have hh := min_le_weighted ha (fq_def q hq')
  rw [weighted] at hh
  have := hQ.2 q hq'
  linarith

theorem attainment_costs_positive {J : Type*} (c : J → ℝ) :
    (∀ j, 0 < Real.exp (c j)) ∧ ∀ j, Real.log (Real.exp (c j)) = c j := by
  exact ⟨fun j => Real.exp_pos _, fun j => Real.log_exp _⟩

/-- Sion's saddle-point theorem discharges the primal/dual identity; this is
not an assumption that the strategic margin already is the dual formula. -/
theorem minimax_dual_min {E F : Type*}
    [TopologicalSpace E] [AddCommGroup E] [Module ℝ E]
    [IsTopologicalAddGroup E] [ContinuousSMul ℝ E]
    [TopologicalSpace F] [AddCommGroup F] [Module ℝ F]
    [IsTopologicalAddGroup F] [ContinuousSMul ℝ F]
    {X : Set E} {Y : Set F} {f : E → F → ℝ}
    {dual : E → ℝ} {inner : F → ℝ} {m : ℝ}
    (nx : X.Nonempty) (ny : Y.Nonempty) (cx : Convex ℝ X) (cy : Convex ℝ Y)
    (kx : IsCompact X) (ky : IsCompact Y)
    (lsc : ∀ y ∈ Y, LowerSemicontinuousOn (fun x => f x y) X)
    (qconv : ∀ y ∈ Y, QuasiconvexOn ℝ X (fun x => f x y))
    (usc : ∀ x ∈ X, UpperSemicontinuousOn (f x) Y)
    (qconc : ∀ x ∈ X, QuasiconcaveOn ℝ Y (f x))
    (hdual : ∀ x ∈ X, MaxValue Y (f x) (dual x))
    (hinner : ∀ y ∈ Y, MinValue X (fun x => f x y) (inner y))
    (hprimal : MaxValue Y inner m) : MinValue X dual m := by
  obtain ⟨a, ha, p, hp, hs⟩ := Sion.exists_isSaddlePointOn'
    nx kx lsc qconv cy ky usc qconc cx ny
  have hi : inner p = f a p := by
    obtain ⟨b, hb, heq⟩ := (hinner p hp).1
    have hlow := (hinner p hp).2 a ha
    have hhigh := hs b hb p hp
    linarith
  have hd : dual a = f a p := by
    obtain ⟨q, hq, heq⟩ := (hdual a ha).1
    have hlow := (hdual a ha).2 p hp
    have hhigh := hs a ha q hq
    linarith
  have hm : m = f a p := by
    obtain ⟨q, hq, heq⟩ := hprimal.1
    have hlow := hprimal.2 p hp
    have hinnerq := (hinner q hq).2 a ha
    have hhigh := hs a ha q hq
    linarith
  refine ⟨⟨a, ha, by linarith⟩, ?_⟩
  intro b hb
  have h1 := (hinner p hp).2 b hb
  have h2 := (hdual b hb).2 p hp
  linarith

def weightedPayoff {I J : Type*} [Fintype I] [Fintype J]
    (A : J → I → ℝ) (c : J → ℝ) (a : J → ℝ) (p : I → ℝ) : ℝ :=
  ∑ j, a j * (logScore (A j) p - c j)

theorem weighted_payoff_eq {I J : Type*} [Fintype I] [Fintype J]
    (A : J → I → ℝ) (c : J → ℝ) (a : J → ℝ) (p : I → ℝ) :
    weightedPayoff A c a p = logScore (inducedWeight A a) p - ∑ j, a j * c j := by
  simp only [weightedPayoff, mul_sub, Finset.sum_sub_distrib, weighted_score_identity]

theorem simplex_min_value {J : Type*} [Fintype J] {v : J → ℝ} {m : ℝ}
    (hm : MinValue Set.univ v m) :
    MinValue Simplex (fun a => ∑ j, a j * v j) m := by
  classical
  constructor
  · obtain ⟨j, _, hj⟩ := hm.1
    refine ⟨Pi.single j 1, ?_, ?_⟩
    · exact single_mem_stdSimplex ℝ j
    · simpa [Pi.single_apply] using hj
  · intro a ha
    exact min_le_weighted ha hm

theorem log_score_continuous {I : Type*} [Fintype I]
    {P : Set (I → ℝ)} (hP : Positive P) (w : I → ℝ) :
    ContinuousOn (logScore w) P := by
  apply continuousOn_finsetSum
  intro i _
  exact continuousOn_const.mul ((continuous_apply i).continuousOn.log
    (fun p hp => ne_of_gt (hP p hp i)))

theorem support_exists {I : Type*} [Fintype I] {P : Set (I → ℝ)}
    (nP : P.Nonempty) (kP : IsCompact P) (hP : Positive P) (w : I → ℝ) :
    ∃ h, Support P w h := by
  obtain ⟨p, hp, hmax⟩ := kP.exists_isMaxOn nP (log_score_continuous hP w)
  exact ⟨logScore w p, ⟨⟨p, hp, rfl⟩, fun q hq => hmax hq⟩⟩

def supportValue {I : Type*} [Fintype I] (P : Set (I → ℝ)) (w : I → ℝ) : ℝ :=
  sSup (logScore w '' P)

theorem support_value_spec {I : Type*} [Fintype I] {P : Set (I → ℝ)}
    (nP : P.Nonempty) (kP : IsCompact P) (hP : Positive P) (w : I → ℝ) :
    Support P w (supportValue P w) := by
  obtain ⟨p, hp, heq, hmax⟩ := kP.exists_sSup_image_eq_and_ge nP (log_score_continuous hP w)
  exact ⟨⟨p, hp, heq.symm⟩, fun q hq => by rw [supportValue, heq]; exact hmax q hq⟩

theorem support_value_continuous {I : Type*} [Fintype I] {P : Set (I → ℝ)}
    (kP : IsCompact P) (hP : Positive P) : Continuous (supportValue P) := by
  let : CompactSpace P := isCompact_iff_compactSpace.mp kP
  have joint : Continuous (fun z : (I → ℝ) × P => logScore z.1 z.2) := by
    apply continuous_finsetSum
    intro i _
    apply ((continuous_apply i).comp continuous_fst).mul
    apply Continuous.log
    · exact (continuous_apply i).comp (continuous_subtype_val.comp continuous_snd)
    · intro z
      exact ne_of_gt (hP z.2 z.2.property i)
  have hc := (isCompact_univ : IsCompact (Set.univ : Set P)).continuous_sSup
    (f := fun (w : I → ℝ) (p : P) => logScore w (p : I → ℝ)) joint
  convert hc using 1
  funext w
  apply congrArg sSup
  ext t
  constructor
  · rintro ⟨p, hp, ht⟩
    exact ⟨⟨p,hp⟩, Set.mem_univ _, ht⟩
  · rintro ⟨p, _, ht⟩
    exact ⟨p, p.property, ht⟩

theorem weight_box_compact {I : Type*} [Fintype I] :
    IsCompact (WeightBox : Set (I → ℝ)) := by
  have heq : (WeightBox : Set (I → ℝ)) = Set.Icc 0 1 := by
    ext w
    constructor
    · intro hw
      exact ⟨fun i => (hw i).1, fun i => (hw i).2⟩
    · intro hw i
      exact ⟨hw.1 i,hw.2 i⟩
  rw [heq]
  exact isCompact_Icc

def coordinateMinimum {J : Type*} [Fintype J] [Nonempty J] (v : J → ℝ) : ℝ :=
  Finset.univ.inf' Finset.univ_nonempty v

theorem coordinate_minimum_spec {J : Type*} [Fintype J] [Nonempty J] (v : J → ℝ) :
    MinValue Set.univ v (coordinateMinimum v) := by
  constructor
  · obtain ⟨j, _, hj⟩ := Finset.exists_mem_eq_inf' Finset.univ_nonempty v
    exact ⟨j, Set.mem_univ j, hj.symm⟩
  · intro j _
    exact Finset.inf'_le _ (Finset.mem_univ j)

def pointMargin {I J : Type*} [Fintype I] [Fintype J] [Nonempty J]
    (A : J → I → ℝ) (c : J → ℝ) (p : I → ℝ) : ℝ :=
  coordinateMinimum (fun j => logScore (A j) p - c j)

theorem point_margin_continuous {I J : Type*} [Fintype I] [Fintype J] [Nonempty J]
    {P : Set (I → ℝ)} (hP : Positive P) (A : J → I → ℝ) (c : J → ℝ) :
    ContinuousOn (pointMargin A c) P := by
  exact ContinuousOn.finset_inf'_apply Finset.univ_nonempty
    (fun j _ => (log_score_continuous hP (A j)).sub continuousOn_const)

theorem primal_margin_exists {I J : Type*} [Fintype I] [Fintype J] [Nonempty J]
    {P : Set (I → ℝ)} (nP : P.Nonempty) (kP : IsCompact P) (hP : Positive P)
    (A : J → I → ℝ) (c : J → ℝ) : ∃ m, MaxValue P (pointMargin A c) m := by
  obtain ⟨p, hp, hmax⟩ := kP.exists_isMaxOn nP (point_margin_continuous hP A c)
  exact ⟨pointMargin A c p, ⟨⟨p, hp, rfl⟩, fun q hq => hmax hq⟩⟩

theorem log_score_concave {I : Type*} [Fintype I]
    {P : Set (I → ℝ)} (hP : Positive P) (cP : Convex ℝ P)
    {w : I → ℝ} (hw : ∀ i, 0 ≤ w i) : ConcaveOn ℝ P (logScore w) := by
  refine ⟨cP, ?_⟩
  intro p hp q hq a b ha hb hab
  change a * logScore w p + b * logScore w q ≤ logScore w (a • p + b • q)
  calc
    a * logScore w p + b * logScore w q =
        ∑ i, w i * (a * Real.log (p i) + b * Real.log (q i)) := by
      simp only [logScore, Finset.mul_sum, ← Finset.sum_add_distrib]
      apply Finset.sum_congr rfl
      intro i _
      ring
    _ ≤ logScore w (a • p + b • q) := by
      apply Finset.sum_le_sum
      intro i _
      apply mul_le_mul_of_nonneg_left _ (hw i)
      exact strictConcaveOn_log_Ioi.concaveOn.2 (hP p hp i) (hP q hq i) ha hb hab

theorem weighted_payoff_continuous_left {I J : Type*} [Fintype I] [Fintype J]
    (A : J → I → ℝ) (c : J → ℝ) (p : I → ℝ) :
    Continuous (fun a => weightedPayoff A c a p) := by
  apply continuous_finsetSum
  intro j _
  exact (continuous_apply j).mul continuous_const

theorem weighted_payoff_convex_left {I J : Type*} [Fintype I] [Fintype J]
    (A : J → I → ℝ) (c : J → ℝ) (p : I → ℝ) :
    ConvexOn ℝ Simplex (fun a => weightedPayoff A c a p) := by
  refine ⟨convex_stdSimplex ℝ J, ?_⟩
  intro a ha b hb s t hs ht hst
  change weightedPayoff A c (s • a + t • b) p ≤
    s * weightedPayoff A c a p + t * weightedPayoff A c b p
  simp only [weightedPayoff, Pi.add_apply, Pi.smul_apply, smul_eq_mul,
    add_mul, Finset.sum_add_distrib, mul_assoc, ← Finset.mul_sum, le_refl]

/-- Actual compact-convex max-min log margin has the support-profile dual.
Only ordinary attainment of the coordinate minima/support/primal maximum is
required; no cascade or minimax equation is assumed. -/
theorem primal_margin_has_dual {I J : Type*} [Fintype I] [Fintype J] [Nonempty J]
    {P : Set (I → ℝ)} {A : J → I → ℝ} {c : J → ℝ}
    {H : (I → ℝ) → ℝ} {inner : (I → ℝ) → ℝ} {m : ℝ}
    (nP : P.Nonempty) (cP : Convex ℝ P) (kP : IsCompact P) (hP : Positive P)
    (hA : ∀ j i, 0 ≤ A j i ∧ A j i ≤ 1)
    (hH : ∀ w ∈ WeightBox, Support P w (H w))
    (hinner : ∀ p ∈ P, MinValue Set.univ (fun j => logScore (A j) p - c j) (inner p))
    (hprimal : MaxValue P inner m) : MinValue Simplex (dualObjective H A c) m := by
  classical
  have nx : (Simplex : Set (J → ℝ)).Nonempty :=
    ⟨Pi.single (Classical.arbitrary J) 1, single_mem_stdSimplex ℝ _⟩
  apply minimax_dual_min (f := weightedPayoff A c) nx nP (convex_stdSimplex ℝ J) cP
    (isCompact_stdSimplex ℝ J) kP
  · intro p hp
    exact (weighted_payoff_continuous_left A c p).continuousOn.lowerSemicontinuousOn
  · intro p hp
    exact (weighted_payoff_convex_left A c p).quasiconvexOn
  · intro a ha
    change UpperSemicontinuousOn (fun p => weightedPayoff A c a p) P
    simp_rw [weighted_payoff_eq]
    exact ((log_score_continuous hP _).sub continuousOn_const).upperSemicontinuousOn
  · intro a ha
    change QuasiconcaveOn ℝ P (fun p => weightedPayoff A c a p)
    simp_rw [weighted_payoff_eq]
    have hc := (log_score_concave hP cP
      (fun i => (induced_weight_box hA ha i).1)).add_const (-(∑ j, a j * c j))
    simpa only [Pi.add_def, sub_eq_add_neg] using hc.quasiconcaveOn
  · intro a ha
    have hs := hH _ (induced_weight_box hA ha)
    constructor
    · obtain ⟨p, hp, heq⟩ := hs.1
      exact ⟨p, hp, by simp only [weighted_payoff_eq, dualObjective, heq]⟩
    · intro p hp
      simpa only [weighted_payoff_eq, dualObjective] using
        sub_le_sub_right (hs.2 p hp) (∑ j, a j * c j)
  · intro p hp
    exact simplex_min_value (hinner p hp)
  · exact hprimal

theorem contextual_primal_interval {I J : Type*} [Fintype I] [Fintype J] [Nonempty J]
    {P Q : Set (I → ℝ)} {A : J → I → ℝ} {c : J → ℝ}
    {HP HQ : (I → ℝ) → ℝ} {fp fq : (I → ℝ) → ℝ} {mp mq e : ℝ}
    (nP : P.Nonempty) (nQ : Q.Nonempty) (cP : Convex ℝ P) (cQ : Convex ℝ Q)
    (kP : IsCompact P) (kQ : IsCompact Q) (posP : Positive P) (posQ : Positive Q)
    (hA : ∀ j i, 0 ≤ A j i ∧ A j i ≤ 1)
    (hHP : ∀ w ∈ WeightBox, Support P w (HP w))
    (hHQ : ∀ w ∈ WeightBox, Support Q w (HQ w))
    (hfp : ∀ p ∈ P, MinValue Set.univ (fun j => logScore (A j) p - c j) (fp p))
    (hfq : ∀ q ∈ Q, MinValue Set.univ (fun j => logScore (A j) q - c j) (fq q))
    (hmp : MaxValue P fp mp) (hmq : MaxValue Q fq mq)
    (hprofile : ∀ w ∈ WeightBox, 0 ≤ HP w - HQ w ∧ HP w - HQ w ≤ e) :
    mq ≤ mp ∧ mp ≤ mq + e := by
  exact contextual_dual_interval hA hprofile
    (primal_margin_has_dual nP cP kP posP hA hHP hfp hmp)
    (primal_margin_has_dual nQ cQ kQ posQ hA hHQ hfq hmq)

theorem contextual_primal_upper {I J : Type*} [Fintype I] [Fintype J] [Nonempty J]
    {P Q : Set (I → ℝ)} {A : J → I → ℝ} {c : J → ℝ}
    {HP HQ : (I → ℝ) → ℝ} {mp mq e : ℝ}
    (nP : P.Nonempty) (nQ : Q.Nonempty) (cP : Convex ℝ P) (cQ : Convex ℝ Q)
    (kP : IsCompact P) (kQ : IsCompact Q) (posP : Positive P) (posQ : Positive Q)
    (hA : ∀ j i, 0 ≤ A j i ∧ A j i ≤ 1)
    (hHP : ∀ w ∈ WeightBox, Support P w (HP w))
    (hHQ : ∀ w ∈ WeightBox, Support Q w (HQ w))
    (hmp : MaxValue P (pointMargin A c) mp) (hmq : MaxValue Q (pointMargin A c) mq)
    (hprofile : ∀ w ∈ WeightBox, HP w - HQ w ≤ e) : mp - mq ≤ e := by
  have dp := primal_margin_has_dual nP cP kP posP hA hHP
    (fun p _ => coordinate_minimum_spec _) hmp
  have dq := primal_margin_has_dual nQ cQ kQ posQ hA hHQ
    (fun p _ => coordinate_minimum_spec _) hmq
  have h : mp ≤ mq + e := min_transfer dp dq (by
    intro a ha
    have := hprofile _ (induced_weight_box hA ha)
    dsimp [dualObjective]
    linarith)
  linarith

/-- A maximum over an independent product separates, with actual witnesses. -/
theorem max_product {X Y : Type*} {S : Set X} {T : Set Y}
    {f : X → ℝ} {g : Y → ℝ} {a b : ℝ}
    (ha : MaxValue S f a) (hb : MaxValue T g b) :
    MaxValue (S ×ˢ T) (fun z => f z.1 + g z.2) (a + b) := by
  constructor
  · obtain ⟨x, hx, hfx⟩ := ha.1
    obtain ⟨y, hy, hgy⟩ := hb.1
    exact ⟨(x,y), ⟨hx,hy⟩, by simp [hfx,hgy]⟩
  · intro z hz
    exact add_le_add (ha.2 z.1 hz.1) (hb.2 z.2 hz.2)

def productFamily {I J : Type*} (P : Set (I → ℝ)) (Q : Set (J → ℝ)) :
    Set (Sum I J → ℝ) :=
  {z | (fun i => z (Sum.inl i)) ∈ P ∧ (fun j => z (Sum.inr j)) ∈ Q}

theorem log_score_product {I J : Type*} [Fintype I] [Fintype J]
    (w p : Sum I J → ℝ) : logScore w p =
      logScore (fun i => w (Sum.inl i)) (fun i => p (Sum.inl i)) +
      logScore (fun j => w (Sum.inr j)) (fun j => p (Sum.inr j)) := by
  exact Fintype.sum_sum_type _

/-- Actual log support factorization on an independent family, before applying
the abstract directed-discrepancy addition theorem. -/
theorem log_support_product {I J : Type*} [Fintype I] [Fintype J]
    {P : Set (I → ℝ)} {Q : Set (J → ℝ)} {w : Sum I J → ℝ} {hp hq : ℝ}
    (sp : Support P (fun i => w (Sum.inl i)) hp)
    (sq : Support Q (fun j => w (Sum.inr j)) hq) :
    Support (productFamily P Q) w (hp + hq) := by
  constructor
  · obtain ⟨p, hp', heqp⟩ := sp.1
    obtain ⟨q, hq', heqq⟩ := sq.1
    refine ⟨Sum.elim p q, ⟨hp', hq'⟩, ?_⟩
    rw [log_score_product]
    exact congrArg₂ (· + ·) heqp heqq
  · intro z hz
    rw [log_score_product]
    exact add_le_add (sp.2 _ hz.1) (sq.2 _ hz.2)

def Directed {W : Type*} (weights : Set W) (HP HQ : W → ℝ) (d : ℝ) : Prop :=
  MaxValue weights (fun w => HP w - HQ w) d

theorem directed_value_exists {I : Type*} [Fintype I] {P Q : Set (I → ℝ)}
    (kP : IsCompact P) (kQ : IsCompact Q) (posP : Positive P) (posQ : Positive Q) :
    ∃ d, Directed WeightBox (supportValue P) (supportValue Q) d := by
  have nb : (WeightBox : Set (I → ℝ)).Nonempty := ⟨0, fun _ => by norm_num⟩
  obtain ⟨w, hw, hmax⟩ := weight_box_compact.exists_isMaxOn nb
    ((support_value_continuous kP posP).sub (support_value_continuous kQ posQ)).continuousOn
  exact ⟨supportValue P w - supportValue Q w, ⟨⟨w,hw,rfl⟩,fun v hv => hmax hv⟩⟩

theorem support_value_zero {I : Type*} [Fintype I] {P : Set (I → ℝ)}
    (nP : P.Nonempty) (kP : IsCompact P) (hP : Positive P) : supportValue P 0 = 0 := by
  obtain ⟨p, _, hp⟩ := (support_value_spec nP kP hP 0).1
  simpa [logScore] using hp.symm

theorem directed_value_nonnegative {I : Type*} [Fintype I] {P Q : Set (I → ℝ)} {d : ℝ}
    (nP : P.Nonempty) (nQ : Q.Nonempty) (kP : IsCompact P) (kQ : IsCompact Q)
    (posP : Positive P) (posQ : Positive Q)
    (hd : Directed WeightBox (supportValue P) (supportValue Q) d) : 0 ≤ d := by
  have h := hd.2 0 (fun _ => by norm_num)
  simpa only [support_value_zero nP kP posP, support_value_zero nQ kQ posQ, sub_self] using h

theorem directed_product_addition {U V : Type*} {S : Set U} {T : Set V}
    {HP HQ : U → ℝ} {HR HT : V → ℝ} {a b : ℝ}
    (ha : Directed S HP HQ a) (hb : Directed T HR HT b) :
    Directed (S ×ˢ T) (fun z => HP z.1 + HR z.2)
      (fun z => HQ z.1 + HT z.2) (a + b) := by
  have h := max_product ha hb
  have heq : (fun z : U × V => HP z.1 + HR z.2 - (HQ z.1 + HT z.2)) =
      (fun z => HP z.1 - HQ z.1 + (HR z.2 - HT z.2)) := by
    funext z
    ring
  unfold Directed
  rw [heq]
  exact h

theorem directed_sum_product {I J : Type*}
    {HP HQ : (I → ℝ) → ℝ} {HR HT : (J → ℝ) → ℝ} {d e : ℝ}
    (hd : Directed WeightBox HP HQ d) (he : Directed WeightBox HR HT e) :
    Directed (WeightBox : Set (Sum I J → ℝ))
      (fun w => HP (fun i => w (Sum.inl i)) + HR (fun j => w (Sum.inr j)))
      (fun w => HQ (fun i => w (Sum.inl i)) + HT (fun j => w (Sum.inr j))) (d + e) := by
  constructor
  · obtain ⟨w, hw, hwv⟩ := hd.1
    obtain ⟨v, hv, hvv⟩ := he.1
    refine ⟨Sum.elim w v, ?_, ?_⟩
    · intro i
      cases i with
      | inl i => exact hw i
      | inr j => exact hv j
    · change HP w + HR v - (HQ w + HT v) = d + e
      linarith
  · intro w hw
    have hi := hd.2 (fun i => w (Sum.inl i)) (fun i => hw (Sum.inl i))
    have hj := he.2 (fun j => w (Sum.inr j)) (fun j => hw (Sum.inr j))
    dsimp
    linarith

/-- Independent k uses add directed discrepancies. This theorem carries all
maximizers separately and so does not identify repeated parameters diagonally. -/
theorem max_finite_product {K X : Type*} [Fintype K]
    {S : K → Set X} {f : K → X → ℝ} {e : K → ℝ}
    (h : ∀ k, MaxValue (S k) (f k) (e k)) :
    MaxValue {x : K → X | ∀ k, x k ∈ S k} (fun x => ∑ k, f k (x k)) (∑ k, e k) := by
  constructor
  · choose x hx he using fun k => (h k).1
    exact ⟨x, hx, by simp only [he]⟩
  · intro x hx
    exact Finset.sum_le_sum (fun k _ => (h k).2 (x k) (hx k))

theorem directed_kfold {X : Type*} {S : Set X} {HP HQ : X → ℝ} {d : ℝ}
    (h : Directed S HP HQ d) (k : ℕ) :
    Directed {x : Fin k → X | ∀ i, x i ∈ S}
      (fun x => ∑ i, HP (x i)) (fun x => ∑ i, HQ (x i)) ((k : ℝ) * d) := by
  have hp := max_finite_product (K := Fin k) (fun _ => h)
  simpa only [Directed, ← Finset.sum_sub_distrib, Finset.sum_const, Finset.card_univ,
    Fintype.card_fin, nsmul_eq_mul] using hp

theorem sum_profile_budget {Node W : Type*} [Fintype Node]
    {HP HQ : Node → W → ℝ} {allowed : Set W} {e : Node → ℝ}
    (local_profile : ∀ v w, w ∈ allowed →
      0 ≤ HP v w - HQ v w ∧ HP v w - HQ v w ≤ e v) :
    ∀ w ∈ allowed,
      0 ≤ (∑ v, HP v w) - ∑ v, HQ v w ∧
      (∑ v, HP v w) - ∑ v, HQ v w ≤ ∑ v, e v := by
  intro w hw
  rw [← Finset.sum_sub_distrib]
  exact ⟨Finset.sum_nonneg (fun v _ => (local_profile v w hw).1),
    Finset.sum_le_sum (fun v _ => (local_profile v w hw).2)⟩

theorem unbounded_reuse_amplifies {d γ : ℝ} (hd : 0 < d) :
    ∃ k : ℕ, γ < (k : ℝ) * d := by
  obtain ⟨k, hk⟩ := exists_nat_gt (γ / d)
  exact ⟨k, (div_lt_iff₀ hd).mp hk⟩

theorem unlimited_reuse_forces_zero {d γ : ℝ} (hd : 0 ≤ d)
    (budget : ∀ k : ℕ, (k : ℝ) * d ≤ γ) : d = 0 := by
  by_contra hn
  have hpos : 0 < d := lt_of_le_of_ne hd (Ne.symm hn)
  obtain ⟨k, hk⟩ := unbounded_reuse_amplifies (γ := γ) hpos
  exact (not_lt_of_ge (budget k)) hk

/-- A single code and deterministic decoder cannot answer both sides of an
opposite-margin collision; the decoder's query may include a repeat count. -/
theorem collision_impossible {System Code Query : Type*}
    (encode : System → Code) (decode : Code → Query → Bool)
    {P Q : System} {q : Query} (collision : encode P = encode Q)
    (p_answer : decode (encode P) q = true) (q_answer : decode (encode Q) q = false) : False := by
  rw [collision, q_answer] at p_answer
  contradiction

/-! Finite labels are maxima on the SAME allowed set, with no convexification. -/
theorem label_budget_transport {Label : Type*} {allowed : Set Label}
    {p q e : Label → ℝ} {mp mq E : ℝ}
    (hp : MaxValue allowed p mp) (hq : MaxValue allowed q mq)
    (he : MaxValue allowed e E)
    (per_label : ∀ s ∈ allowed, 0 ≤ p s - q s ∧ p s - q s ≤ e s) :
    0 ≤ mp - mq ∧ mp - mq ≤ E := by
  have hlo : mq ≤ mp + 0 := max_transfer hq hp (by
    intro s hs
    exact ⟨s, hs, by have := (per_label s hs).1; linarith⟩)
  have hhi : mp ≤ mq + E := max_transfer hp hq (by
    intro s hs
    refine ⟨s, hs, ?_⟩
    have := (per_label s hs).2
    have := he.2 s hs
    linarith)
  constructor <;> linarith

theorem common_order_transport {Order : Type*} {allowed : Set Order}
    {p q : Order → ℝ} {mp mq E : ℝ}
    (hp : MinValue allowed p mp) (hq : MinValue allowed q mq)
    (per_order : ∀ o ∈ allowed, 0 ≤ p o - q o ∧ p o - q o ≤ E) :
    mq ≤ mp ∧ mp ≤ mq + E := by
  have hlo : mq ≤ mp + 0 := min_transfer hq hp (by
    intro o ho
    have := (per_order o ho).1
    linarith)
  have hhi := min_transfer hp hq (by
    intro o ho
    have := (per_order o ho).2
    linarith)
  exact ⟨by linarith, hhi⟩

/-- Global tree/graph budget transport. Compatibility lives in `allowed`.
The max-sum tree algorithm computing E is a separate algorithmic obligation. -/
theorem assignment_budget_transport {Node Assignment : Type*} [Fintype Node]
    {allowed : Set Assignment} {p q : Assignment → ℝ} {e : Node → Assignment → ℝ}
    {mp mq E : ℝ} (hp : MaxValue allowed p mp) (hq : MaxValue allowed q mq)
    (he : MaxValue allowed (fun s => ∑ v, e v s) E)
    (per_assignment : ∀ s ∈ allowed,
      0 ≤ p s - q s ∧ p s - q s ≤ ∑ v, e v s) :
    0 ≤ mp - mq ∧ mp - mq ≤ E :=
  label_budget_transport hp hq he per_assignment

/-- Local node support errors -> compatible-assignment margins -> wired margin.
The actual branch primal/dual link is supplied by `primal_margin_has_dual`;
the only shared-label operation is max over the unchanged compatibility mask. -/
theorem tree_local_profile_transport {Node Assignment I J : Type*}
    [Fintype Node] [Fintype J]
    {allowed : Set Assignment} {A : J → I → ℝ} {c : J → ℝ}
    {HP HQ : Assignment → Node → (I → ℝ) → ℝ}
    {e : Assignment → Node → ℝ} {p q : Assignment → ℝ} {mp mq E : ℝ}
    (hA : ∀ j i, 0 ≤ A j i ∧ A j i ≤ 1)
    (local_profile : ∀ s ∈ allowed, ∀ v w, w ∈ WeightBox →
      0 ≤ HP s v w - HQ s v w ∧ HP s v w - HQ s v w ≤ e s v)
    (dp : ∀ s ∈ allowed, MinValue Simplex
      (dualObjective (fun w => ∑ v, HP s v w) A c) (p s))
    (dq : ∀ s ∈ allowed, MinValue Simplex
      (dualObjective (fun w => ∑ v, HQ s v w) A c) (q s))
    (hp : MaxValue allowed p mp) (hq : MaxValue allowed q mq)
    (he : MaxValue allowed (fun s => ∑ v, e s v) E) :
    0 ≤ mp - mq ∧ mp - mq ≤ E := by
  apply label_budget_transport hp hq he
  intro s hs
  have h := contextual_dual_interval hA (sum_profile_budget (local_profile s hs))
    (dp s hs) (dq s hs)
  constructor <;> linarith

end
end DecisionInterface
