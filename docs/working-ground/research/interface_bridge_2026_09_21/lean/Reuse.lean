import RationalQueries
import Mathlib.Data.Fintype.Pigeonhole

namespace DecisionInterface
open scoped BigOperators
noncomputable section

/-- An infinite rational scalar family in the fixed positive box (1/4,3/8]. -/
def scalarProbability (i : ℕ) : ℝ := 1/4 + 1/(4*((i : ℝ)+2))

theorem scalar_probability_bounds (i : ℕ) :
    1/4 < scalarProbability i ∧ scalarProbability i ≤ 3/8 := by
  have hi : (0 : ℝ) ≤ i := Nat.cast_nonneg i
  have hd : (0 : ℝ) < 4*((i : ℝ)+2) := by linarith
  have hlo : (0 : ℝ) < 1/(4*((i : ℝ)+2)) := one_div_pos.mpr hd
  have hhi : (1 : ℝ)/(4*((i : ℝ)+2)) ≤ 1/8 :=
    one_div_le_one_div_of_le (by norm_num) (by linarith)
  dsimp [scalarProbability]
  constructor <;> linarith

theorem scalar_probability_rational (i : ℕ) :
    ∃ r : ℚ, (r : ℝ) = scalarProbability i := by
  refine ⟨1/4 + 1/(4*((i : ℚ)+2)), ?_⟩
  dsimp [scalarProbability]
  push_cast
  rfl

theorem scalar_probability_strictAnti : StrictAnti scalarProbability := by
  intro i j hij
  have hij' : (i : ℝ) < j := by exact_mod_cast hij
  have hi : (0 : ℝ) ≤ i := Nat.cast_nonneg i
  have h := one_div_lt_one_div_of_lt
    (by linarith : (0 : ℝ) < 4*((i : ℝ)+2))
    (by linarith : (4 : ℝ)*((i : ℝ)+2) < 4*((j : ℝ)+2))
  dsimp [scalarProbability]
  linarith

theorem scalar_probability_injective : Function.Injective scalarProbability :=
  scalar_probability_strictAnti.injective

theorem singleton_support {I : Type*} [Fintype I] (p w : I → ℝ) :
    Support {p} w (logScore w p) := by
  constructor
  · exact ⟨p,Set.mem_singleton p,rfl⟩
  · intro q hq
    rw [Set.mem_singleton_iff.mp hq]

/-- k independent occurrences of a scalar singleton have exactly k times the
positive directed log gap, on the actual log-support profiles. -/
theorem scalar_repeated_directed {p q : ℝ} (_hp : 0 < p) (hq : 0 < q) (hqp : q ≤ p)
    (k : ℕ) :
    Directed (WeightBox : Set (Fin k → ℝ))
      (fun w => logScore w (fun _ => p)) (fun w => logScore w (fun _ => q))
      ((k : ℝ) * (Real.log p - Real.log q)) := by
  have hd : 0 ≤ Real.log p - Real.log q := sub_nonneg.mpr (Real.log_le_log hq hqp)
  have gap (w : Fin k → ℝ) :
      logScore w (fun _ => p) - logScore w (fun _ => q) =
        ∑ i, w i * (Real.log p - Real.log q) := by
    simp only [logScore, ← Finset.sum_sub_distrib, mul_sub]
  constructor
  · refine ⟨fun _ => 1, fun _ => by norm_num, ?_⟩
    dsimp only
    rw [gap]
    simp only [one_mul, Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
  · intro w hw
    dsimp only
    rw [gap]
    calc
      (∑ i, w i * (Real.log p - Real.log q)) ≤ ∑ _i : Fin k, (Real.log p - Real.log q) :=
        Finset.sum_le_sum (fun i _ => by simpa using mul_le_mul_of_nonneg_right (hw i).2 hd)
      _ = _ := by simp only [Finset.sum_const, Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]

structure ReuseQuery where
  repeats : ℕ
  order : Equiv.Perm (Fin repeats)
  logCost : Fin (repeats+1) → ℝ

/-- The required answers only concern margins strictly beyond γ. `true` means
positive/full, `false` means negative/zero; behavior near the boundary is free. -/
def ScalarDecoderCorrect {Code : Type*} (encode : ℕ → Code)
    (decode : Code → ReuseQuery → Bool) (γ : ℝ) : Prop :=
  ∀ (i : ℕ) (k : ℕ) (π : Equiv.Perm (Fin k)) (c : Fin (k+1) → ℝ) (m : ℝ),
    MaxValue {fun _ : Fin k => scalarProbability i} (pointMargin (suffixMatrix π) c) m →
    (γ < m → decode (encode i) ⟨k,π,c⟩ = true) ∧
    (m < -γ → decode (encode i) ⟨k,π,c⟩ = false)

/-- A collision between distinct scalar systems is refuted by an actual
repeated-use, one-added-sender query with calibrated positive cost ratios. -/
theorem scalar_collision_impossible {Code : Type*} (encode : ℕ → Code)
    (decode : Code → ReuseQuery → Bool) (γ : ℝ)
    (correct : ScalarDecoderCorrect encode decode γ)
    {i j : ℕ} (hij : i < j) (collision : encode i = encode j) : False := by
  have hp : 0 < scalarProbability i := by linarith [(scalar_probability_bounds i).1]
  have hq : 0 < scalarProbability j := by linarith [(scalar_probability_bounds j).1]
  have hqp := scalar_probability_strictAnti hij
  have hlog : 0 < Real.log (scalarProbability i) - Real.log (scalarProbability j) :=
    sub_pos.mpr (Real.log_lt_log hq hqp)
  obtain ⟨k,hk⟩ := unbounded_reuse_amplifies (γ := 2*γ) hlog
  let p : Fin k → ℝ := fun _ => scalarProbability i
  let q : Fin k → ℝ := fun _ => scalarProbability j
  have posp : Positive {p} := by
    intro x hx t
    rw [Set.mem_singleton_iff.mp hx]
    exact hp
  have posq : Positive {q} := by
    intro x hx t
    rw [Set.mem_singleton_iff.mp hx]
    exact hq
  obtain ⟨π,c,hmP,hmQ⟩ := one_sender_opposite_margin
    (Set.singleton_nonempty p) (Set.singleton_nonempty q)
    (convex_singleton p) (convex_singleton q) isCompact_singleton isCompact_singleton
    posp posq (fun w _ => singleton_support p w) (fun w _ => singleton_support q w)
    (scalar_repeated_directed hp hq hqp.le k)
  have yes := (correct i k π c _ hmP).1 (by linarith)
  have no := (correct j k π c _ hmQ).2 (by linarith)
  exact collision_impossible encode decode collision yes no

/-- No finite self-contained code can answer all γ-separated contexts under
unlimited independent reuse, even for rational one-dimensional singletons in
a fixed positive box. The proof derives a collision by pigeonhole, amplifies
its log gap, constructs the query, and invokes decoder correctness. -/
theorem no_finite_code_unlimited_reuse {Code : Type*} [Finite Code]
    (encode : ℕ → Code) (decode : Code → ReuseQuery → Bool) (γ : ℝ) :
    ¬ ScalarDecoderCorrect encode decode γ := by
  intro correct
  obtain ⟨i,j,hij,hcode⟩ := Finite.exists_ne_map_eq_of_infinite encode
  rcases lt_or_gt_of_ne hij with hij | hji
  · exact scalar_collision_impossible encode decode γ correct hij hcode
  · exact scalar_collision_impossible encode decode γ correct hji hcode.symm

def ScalarRationalDecoderCorrect {Code : Type*} (encode : ℕ → Code)
    (decode : Code → ReuseQuery → Bool) (γ : ℝ) : Prop :=
  ∀ (i : ℕ) (k : ℕ) (π : Equiv.Perm (Fin k)) (r : Fin (k+1) → ℚ) (m : ℝ),
    (∀ j, 0 < r j) →
    MaxValue {fun _ : Fin k => scalarProbability i}
      (pointMargin (suffixMatrix π) (fun j => Real.log (r j : ℝ))) m →
    (γ < m → decode (encode i) ⟨k,π,fun j => Real.log (r j : ℝ)⟩ = true) ∧
    (m < -γ → decode (encode i) ⟨k,π,fun j => Real.log (r j : ℝ)⟩ = false)

theorem scalar_rational_collision_impossible {Code : Type*} (encode : ℕ → Code)
    (decode : Code → ReuseQuery → Bool) (γ : ℝ)
    (correct : ScalarRationalDecoderCorrect encode decode γ)
    {i j : ℕ} (hij : i < j) (collision : encode i = encode j) : False := by
  have hp : 0 < scalarProbability i := by linarith [(scalar_probability_bounds i).1]
  have hq : 0 < scalarProbability j := by linarith [(scalar_probability_bounds j).1]
  have hqp := scalar_probability_strictAnti hij
  have hlog : 0 < Real.log (scalarProbability i) - Real.log (scalarProbability j) :=
    sub_pos.mpr (Real.log_lt_log hq hqp)
  obtain ⟨k,hk⟩ := unbounded_reuse_amplifies (γ := 2*γ) hlog
  let p : Fin k → ℝ := fun _ => scalarProbability i
  let q : Fin k → ℝ := fun _ => scalarProbability j
  have posp : Positive {p} := by
    intro x hx t
    rw [Set.mem_singleton_iff.mp hx]
    exact hp
  have posq : Positive {q} := by
    intro x hx t
    rw [Set.mem_singleton_iff.mp hx]
    exact hq
  obtain ⟨π,r,mp,mq,hr,hmp,hmq,hmpγ,hmqγ⟩ := one_sender_rational_separation
    (Set.singleton_nonempty p) (Set.singleton_nonempty q)
    (convex_singleton p) (convex_singleton q) isCompact_singleton isCompact_singleton
    posp posq (fun w _ => singleton_support p w) (fun w _ => singleton_support q w)
    (scalar_repeated_directed hp hq hqp.le k) (by linarith : γ < _ / 2)
  have yes := (correct i k π r mp hr hmp).1 hmpγ
  have no := (correct j k π r mq hr hmq).2 hmqγ
  exact collision_impossible encode decode collision yes no

/-- The impossibility already holds when queries are restricted to positive
rational cost ratios, using density only to preserve strict γ separation. -/
theorem no_finite_code_unlimited_rational_reuse {Code : Type*} [Finite Code]
    (encode : ℕ → Code) (decode : Code → ReuseQuery → Bool) (γ : ℝ) :
    ¬ ScalarRationalDecoderCorrect encode decode γ := by
  intro correct
  obtain ⟨i,j,hij,hcode⟩ := Finite.exists_ne_map_eq_of_infinite encode
  rcases lt_or_gt_of_ne hij with hij | hji
  · exact scalar_rational_collision_impossible encode decode γ correct hij hcode
  · exact scalar_rational_collision_impossible encode decode γ correct hji hcode.symm

end
end DecisionInterface
