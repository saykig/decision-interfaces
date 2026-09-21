import Mathlib.Data.Fin.Tuple.Sort
import Mathlib.Algebra.BigOperators.Fin
import Mathlib.Algebra.BigOperators.Intervals
import Mathlib.Data.Real.Basic
import Mathlib.Tactic

namespace DecisionInterface
open scoped BigOperators
noncomputable section


/-- Extend sorted support weights by the endpoint CDF values zero and one. -/
def weightCDF {n : ℕ} (w : Fin n → ℝ) (k : ℕ) : ℝ :=
  if h : k = 0 then 0 else if h' : k ≤ n then w ⟨k-1, by omega⟩ else 1

lemma weightCDF_zero {n : ℕ} (w : Fin n → ℝ) : weightCDF w 0 = 0 := by
  simp [weightCDF]

lemma weightCDF_end {n : ℕ} (w : Fin n → ℝ) : weightCDF w (n+1) = 1 := by
  simp [weightCDF]

lemma weightCDF_at {n : ℕ} (w : Fin n → ℝ) (i : Fin n) :
    weightCDF w (i.val+1) = w i := by
  simp [weightCDF, show i.val+1 ≤ n by omega]

lemma weightCDF_mono {n : ℕ} {w : Fin n → ℝ} (hw : Monotone w)
    (hb : ∀ i, 0 ≤ w i ∧ w i ≤ 1) : Monotone (weightCDF w) := by
  intro a b hab
  by_cases ha : a = 0
  · subst a
    rw [weightCDF_zero]
    unfold weightCDF
    split_ifs
    · exact le_refl _
    · exact (hb _).1
    · norm_num
  by_cases hb0 : b = 0
  · omega
  by_cases han : a ≤ n
  · by_cases hbn : b ≤ n
    · simp only [weightCDF, dif_neg ha, dif_pos han, dif_neg hb0, dif_pos hbn]
      exact hw (by simp only [Fin.le_iff_val_le_val]; omega)
    · simp only [weightCDF, dif_neg ha, dif_pos han, dif_neg hb0, dif_neg hbn]
      exact (hb _).2
  · have hbn : ¬ b ≤ n := by omega
    simp [weightCDF, ha, hb0, han, hbn]

lemma cumulative_suffix {n : ℕ} (f : ℕ → ℝ) (i : Fin n) :
    (∑ j : Fin (n+1), (f (j.val+1)-f j.val) * (if j.val ≤ i.val then 1 else 0)) =
      f (i.val+1)-f 0 := by
  simp only [mul_ite, mul_one, mul_zero]
  rw [Fin.sum_univ_eq_sum_range (fun j => if j ≤ i.val then f (j+1)-f j else 0) (n+1)]
  calc
    (∑ j ∈ Finset.range (n+1), if j ≤ i.val then f (j+1)-f j else 0) =
        ∑ j ∈ Finset.range (i.val+1), if j ≤ i.val then f (j+1)-f j else 0 := by
      symm
      apply Finset.sum_subset (Finset.range_mono (by omega))
      intro j hj hn
      simp only [Finset.mem_range] at hn
      simp [show ¬j ≤ i.val by omega]
    _ = ∑ j ∈ Finset.range (i.val+1), (f (j+1)-f j) := by
      apply Finset.sum_congr rfl
      intro j hj
      simp only [Finset.mem_range] at hj
      simp [show j ≤ i.val by omega]
    _ = f (i.val+1)-f 0 := Finset.sum_range_sub f (i.val+1)

/-- Any nonnegative unit-box direction is induced by suffix inequalities after
one additional sender placed before the sorted original coordinates. -/
theorem one_sender_suffix_realization {n : ℕ} (w : Fin n → ℝ)
    (hb : ∀ i, 0 ≤ w i ∧ w i ≤ 1) :
    ∃ (π : Equiv.Perm (Fin n)) (a : Fin (n+1) → ℝ),
      (∀ j, 0 ≤ a j) ∧ (∑ j, a j = 1) ∧
      ∀ i : Fin n, (∑ j : Fin (n+1), a j * (if j.val ≤ i.val then 1 else 0)) = w (π i) := by
  let π := Tuple.sort w
  let v := w ∘ π
  let f := weightCDF v
  let a : Fin (n+1) → ℝ := fun (j : Fin (n+1)) => f (j.val+1)-f j.val
  have hv : Monotone v := Tuple.monotone_sort w
  have hf : Monotone f := weightCDF_mono hv (fun i => hb (π i))
  refine ⟨π,a,?_,?_,?_⟩
  · intro j
    exact sub_nonneg.mpr (hf (Nat.le_succ _))
  · change (∑ j : Fin (n+1), (f (j.val+1)-f j.val)) = 1
    rw [Fin.sum_univ_eq_sum_range (fun j => f (j+1)-f j) (n+1), Finset.sum_range_sub]
    simp [f, weightCDF_end, weightCDF_zero]
  · intro i
    change (∑ j : Fin (n+1), (f (j.val+1)-f j.val) * (if j.val ≤ i.val then 1 else 0)) = w (π i)
    rw [cumulative_suffix]
    simp [f,weightCDF_at,weightCDF_zero,v,Function.comp_apply]

end
end DecisionInterface
