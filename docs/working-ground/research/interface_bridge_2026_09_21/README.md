# R19B — enforcement-interface Lean bridge

September 21, 2026. This phase formalizes the mathematical R15/R16 interface,
independently of the byte codec. The source theorem is R15
[`math/RESULTS.md`](../enforcement_codec_2026_09_20/math/RESULTS.md), sections 2,
3 and 7; R16's [`EXTENSIONS.md`](../optimal_bits_2026_09_21/math/EXTENSIONS.md)
section 3 supplies the labelled-tree contract. R19A owns the strategic assessment
and target-existence theorem. No geometric entropy theorem is re-proved here.

## Formal objects and scope

`logScore w p` is the sum of `w_i log p_i`. `Support P w h` means **an actual
attained maximum of that function over all points of P**, not over its listed
vertices. `MaxValue` and `MinValue` expose a witness plus the universal optimality
inequality. `pointMargin A c p` is the actual finite minimum of the log-score rows
minus log costs. Its maximum over P is the fixed-order incentive margin.

`A` may be any matrix with entries in [0,1]; suffix incidence matrices are an
important special case. `suffixMatrix π` has n+1 rows for n original coordinates:
row zero is the additional sender, positioned first; original coordinate i is
at position `1+π⁻¹(i)`. The added sender's fixed probability is absent from every
suffix. Costs are positive ratios `exp(c_j)`.

The strategic interpretation retains the R15 assumptions: independent private
facts in each actual model, complementary authenticated evidence, positive costs,
model-aware players, one institution-selected common order, favorable ties and
the inherited receiver threshold. The interface proofs are valid for all positive
compact convex families; the application back to the game additionally restricts
probabilities below its threshold. Mathematical log margins are not fine amounts.

## Checked theorem chain

1. **Vertex certificate to support bound.** `vertex_domination_lifts` proves
   that domination witnesses on source vertices cover the entire convex hull.
   `rational_vertex_sandwich`, `sandwich_support` and `sandwich_box_error` derive
   `0 ≤ H_P(w)-H_Q(w) ≤ log(1+η)∑w_i ≤ nη` on the unit weight box. Theorems are
   over reals, so exact rational vertices and convex-combination witnesses embed
   without rounding. Rational arithmetic and byte parsing are not axiomatized.

   ```yaml
   LEAN: YES — This inherited certificate-to-error bridge now has a kernel-checkable proof.
   ```

2. **Support discrepancy to the actual margin interval.**
   `primal_margin_has_dual` derives the minimax formula using mathlib's Sion
   saddle-point theorem, log concavity, log continuity and the compact simplex.
   `contextual_primal_interval` and `contextual_primal_upper` transfer support
   discrepancies to actual max-min margins. They do not assume the minimax
   identity in the definition of a margin. Coordinate minima, support maxima
   and primal maxima have separate existence proofs.

   ```yaml
   LEAN: YES — The operational interpretation of approximation error is a thesis-bearing dependency.
   ```

3. **One additional sender attains discrepancy.** `Realization.lean` sorts any
   unit-box direction and constructs simplex weights from cumulative differences,
   including dimension zero. `Attainment.lean` combines that actual suffix
   realization with support-maximizer cost calibration and the upper bound.
   For every z it obtains exactly `m_P=z` and `m_Q=z-d`, hence opposite margins
   `±d/2`. `RationalQueries.lean` then proves rational log-density, an ε bound
   for perturbing every log cost by at most ε, and positive rational query
   separation at every strict margin `γ<d/2`. Exact rational attainment is not
   asserted; the real-query maximum and rational-query supremum agree.

   ```yaml
   LEAN: YES — Attainment connects interface distinctions to permitted contextual decisions.
   ```

4. **Independent products and bounded reuse.** `log_score_product` and
   `log_support_product` prove factorization on actual disjoint Sum coordinates.
   `directed_sum_product` proves exact directed-discrepancy addition on their
   weight boxes. `max_finite_product` and `directed_kfold` give k-fold accounting;
   `scalar_repeated_directed` separately instantiates repeated actual singleton
   supports for the impossibility construction. These are independent products,
   not diagonal copies constrained to share an uncertain parameter choice.

   ```yaml
   LEAN: YES — Product and reuse errors are repeatedly inherited by query and storage claims.
   ```

5. **Unlimited reuse.** `Reuse.lean` uses the infinite rational scalar family
   `p_i=1/4+1/[4(i+2)]` in the fixed box `(1/4,3/8]`. Finite codes collide by
   pigeonhole; a finite repeat count amplifies the positive log gap; actual
   one-added-sender attainment produces opposite margins beyond any fixed γ.
   `no_finite_code_unlimited_reuse` and
   `no_finite_code_unlimited_rational_reuse` rule out a deterministic self-contained
   finite code correct on every such separated contextual query. It does not
   assume contradictory outputs as the substantive premise. The stronger
   restriction already permits only positive rational cost ratios, using the
   formal density/perturbation result. Source-assisted refinement and non-finite
   code alphabets are outside its hypothesis.
   A finite alphabet covers every fixed worst-case finite bit budget; it does
   not forbid unbounded variable-length codes that are finite for each input.

   ```yaml
   LEAN: YES — The representation impossibility depends on the complete collision-to-query chain.
   ```

6. **Labels, common orders and tree budgets.** `label_budget_transport` and
   `common_order_transport` operate on the same allowed labels/orders on both
   sides. `tree_local_profile_transport` adds local profile errors within each
   compatible assignment, applies the contextual dual bound, then maximizes
   over the exact unchanged compatibility mask. No union is convexified and
   no minimax interchange across labels is made. An empty allowed set cannot
   supply a `MaxValue` witness. `assignment_budget_transport` applies to trees
   and other finite compatibility structures alike. `TreeBudget.lean` separately
   proves the masked max-sum recurrence against complete compatible assignment
   semantics: an arbitrary finite-child node induction contract and a full
   induction for rooted binary labelled trees. `none` denotes infeasibility,
   while `some 0` is a feasible zero budget. Empty branches and a globally empty
   family therefore remain distinct from numerical zero.

   ```yaml
   LEAN: YES — Shared-dependency error transport is part of the reusable composition contract.
   ```

7. **Join to primitive strategic assessments.** `GameInterface.lean` proves
   `raw_target_iff_margin` from R19A's `raw_target_iff_blocker` by converting actual
   suffix products to log scores. `robust_raw_target_iff_margin` preserves
   `∀ model, ∃ assessment`; `common_order_raw_target_iff_margin` explicitly places
   `∃ one allowed order` before that quantifier. `support_error_raw_decisions`
   applies the proved contextual interval directly to raw equilibrium assessments
   for every sub-B nonnegative fine. The zero boundary remains favorable.
   Its positive lower-bound conclusion defeats the specified order; claiming
   FULL still requires defeating every allowed order.

   ```yaml
   LEAN: YES — The explicit game-to-margin join prevents a correct interface theorem from being attached to an assumed strategic criterion.
   ```

## Boundaries and remaining work

- The concrete recursive tree datatype is binary, with a separately proved
  arbitrary finite-child induction step. An adapter from the executable R16
  arbitrary-arity tables to that datatype is not certified. The mathematical
  max-sum recurrence and its compatibility/emptiness semantics are checked;
  no exact byte-for-byte equivalence with the Python implementation is claimed.
- Byte encoding, parsing, rational LP certificates and their query-engine wiring
  are executable obligations, not claims made by these Lean statements.
- Entropy/rate upper and lower bounds, exact-interface
  coarseness and source-free cryptographic verification are not newly formalized.
- The bridge proves decision-margin preservation, not empirical warrant, welfare,
  historical novelty, or an unrestricted nonbinary enforcement frontier.
- The joined theorem includes the explicit R19A game parameters and query
  quantifiers. New strategic models still require their own interpretation proof;
  neither this interface nor its joined theorem changes the benchmark game.

## Proof outline and borrowed mathematics

Vertex witnesses lift because the set of vectors dominated by `cQ` is convex.
Monotonicity and additivity of log give the support sandwich. A simplex-weighted
minimum row is bounded by its weighted mean; Sion provides the reverse minimax
inequality under the compact/convex assumptions. Sorting weights constructs the
suffix simplex; costs calibrated at a support maximizer make all its margins z.
The directed upper bound makes the separating construction exact. Independent
maxima split, so their errors add. Finite-label maxima and common-order minima
preserve uniform intervals. Finally, pigeonhole plus repeated-use amplification
turns any finite scalar-code collision into a wrong separated decision.

Sion (1958), standard convex hull/log facts, compact extreme-value theorems,
finite-product maximization and pigeonhole are borrowed ingredients. The exact
mathlib dependency is commit `0df444a360eaa60ab8c11dca51a86af692955474`, including
`Sion.exists_isSaddlePointOn'`. Formalizing the existing R15/R16 chain is not a
new historical-priority claim and is not labelled CANDIDATE ORIGINAL THEOREM.

Proof shortcuts explicitly rejected during this phase: treating the dual
objective as the definition of a strategic margin; assuming that an arbitrary
weight direction is already a suffix query; assuming product support addition
without proving log-score factorization; and calling contradictory Boolean
outputs alone a finite-code impossibility proof. The completed files supply the
missing Sion bridge, sorted suffix realization, actual product factorization,
and pigeonhole/amplification/rational-query construction respectively. These
were incomplete proof routes, not counterexamples to the retained R15 theorems.

The dated receipt records the exact compiled source hashes and transitive axiom
audit. It is a local Lean replay, not an independent external or human replay.
The [interface receipt](results/lean_interface_2026_09_21.json) audits 126 named
declarations across six modules. The separate
[joined game receipt](results/lean_game_interface_2026_09_21.json) audits 237
declarations after freshly rebuilding R14/R19A, `Interface` and `GameInterface`.
These audit counts overlap and must not be added as independent theorem counts.

Replay from the repository root with Lean 4.33.1 and the pinned mathlib package
cache (including its Lake dependencies):

```sh
python3 docs/working-ground/research/interface_bridge_2026_09_21/lean/verify.py \
  --packages /path/to/pinned-lake-packages \
  --output /path/to/new-replay-receipt.json
```

The verifier checks the mathlib revision, builds all six phase modules in a fresh
temporary directory, audits all 126 named definitions/theorems/data declarations,
and rejects dependencies beyond `propext`, `Classical.choice` and `Quot.sound`.
It refuses to overwrite a historical receipt. Dependency oleans are reused;
phase oleans are rebuilt. This is not a rebuild of the Lean kernel or all mathlib.

## Next bounded attack

Connect executable R16/R18 tables to the formal tree/query datatypes, and complete
independent replay and theorem-statement review. The programme now has a checked
operational core while implementation-adapter and review boundaries remain visible.
