# R17 — arbitrary orders and an explicit interface contract

21 September 2026. Baseline: `91bfb6fc58ff33959e6f5c9029c8a3e32c789509`.
New exact reference implementation and research-goal refinement, not a new
historical-novelty claim or a new Lean theorem. Earlier records are unchanged.

## What is implemented

The R16 query suite fixes a known first sender. This addition permits EVERY order
of two uncertain senders and any finite number of exact known-probability senders.
It accepts a rational vertex description of the planar source, a decoded convex
hull, a rational multiplicative sandwich scale, and positive rational cost ratios.
It verifies the source-relative sandwich before using the compressed bracket.

`ZERO` returns one common order whose outer model blocks disclosure. `FULL`
requires a strict lower-model counterexample for every order; these may be
different models. `REFINE` means the fully evaluated compressed bracket does not
settle the decision. `UNKNOWN` means the order-search work budget was exhausted.
Malformed inputs and failed source checks are errors, not strategic conclusions.

This closes the arbitrary-ORDER restriction for this declared planar/known-context
class. It does not implement arbitrary uncertain attachments, several compressed
blocks, tree-connected strategic optimization, or a continuous fine frontier.
It consumes decoded rational hulls; binary-payload decoding is not newly integrated
or tested here. R10/R12 already contain more efficient selection results for
specified low-dimensional exact families; this is a reference oracle, not a new
polynomial-time result. The worst-case order enumeration is factorial.

## Why the reference calculation is exact

Condition on the inherited R08/R13 game-to-cascade theorem. In any order, each
suffix product has form `c`, `c*x`, `c*y`, or `c*x*y`, where c is a positive rational
product of known probabilities. Dividing each strict condition by c and retaining
the largest threshold for each form gives exactly the original conjunction.

The conjunction is increasing in both positive coordinates. If any point in the
convex hull satisfies it, some Pareto-boundary point does. That point lies on an
edge or vertex with endpoints among the supplied vertices. Enumerating all pairs
therefore includes it; no vertex-only success test or sampled grid is used.
On a pair segment, linear thresholds restrict an interval, and `x*y` is quadratic.
Its maximum on the closed interval is at an endpoint or a concave stationary
point. A separate strict-interior check prevents weak ties becoming cascades.
If the maximum is strictly above the threshold at an excluded boundary, approaching
it from the strict linear interior supplies a rational feasible witness.

The tested functions implement this reduction; the brief proof does not newly
establish the extensive-form strategic bridge. The existence query retains
favorable equilibrium ties. `FULL` denotes the inherited fine B, not social cost.

## Executed evidence

2,822 checks passed locally: 2,616 full-order singleton comparisons at n=2..6;
150 separate SymPy raw-polynomial comparisons over all orders at n=3,4,5;
30 returned-witness checks against original suffix products; and explicit safe,
unsafe, tie, narrow-gap, refinement, source-binding, input and work-budget controls.
Normal and optimized Python gave byte-identical outputs. The SymPy comparator does
not use the threshold aggregation, but both evaluators inherit the same strategic
formula. These are not independent game proofs or Lean verification.

From `experiments/`:

```sh
python -m pip install -r requirements.txt
python check_all_orders.py > /tmp/r17.json
python -O check_all_orders.py > /tmp/r17-O.json
cmp /tmp/r17.json /tmp/r17-O.json
```

[Receipt](experiments/receipt.json) binds the two source files. The new CI job
repeats these commands and validates the retained counts and hashes. Adding a job
is not itself evidence that a remote run has passed.

## Decisions and next attack

- D53: full-order enumeration is a useful oracle; do not call it efficient selection.
- D54: `REFINE` is representational uncertainty; `UNKNOWN` is incomplete computation.
- D55: no empirical transfer or degree requirement is a prerequisite for the
  mathematical paper. Compare mathematical model classes inside this repository;
  investigate empirical case selection separately.

Read [the interface contract](INTERFACE_CONTRACT.md) and
[the next mathematical goals](../../../ACTIVE_GOALS.md). First integrate the
existing R16 decoder with a full-order exact reference on general rational contexts;
then independently compare against the R10/R12 selection machinery. Preserve the
source/witness/trust boundaries instead of claiming the general target is already
implemented. Formalize the strategic existence and interface-soundness bridges in
parallel with mathematical exploration; do not make all new research wait for
completion of every Lean lemma.
