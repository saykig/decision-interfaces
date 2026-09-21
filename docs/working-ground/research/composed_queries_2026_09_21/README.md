# R18 — source-bound composed query reference

September 21, 2026. Gate A integration after R17. The strategic model and its
R13 written proof are unchanged. This is an executable coverage milestone, not
a new efficient arbitrary-dimensional order-selection theorem.

## Declared query contract

An input supplies a catalogue of finite labelled components, a list of independent
occurrences, a nonempty list of allowed label tuples, positive rational sender
cost/reward ratios, and `tau`. Each label branch is either an arbitrary-dimensional
rational V-polytope or an R16 planar binary payload **and its source vertices**.
All actual probabilities satisfy `0 < p_i < tau < 1`. Costs and the permutation
refer to flattened occurrence coordinates. Actual p is known to players; the
institution chooses one order for the entire allowed family. Equilibria may vary
with p. Sender and receiver ties retain R13's favorable existence convention.

Every occurrence has fresh simplex weights, including two occurrences naming the
same payload. This is independent parameter-family reuse and independent physical
Bernoulli draws conditional on the selected model. Sharing one uncertain parameter
across occurrences is not this product operation: `reuse: same_parameter` is
explicitly rejected. Finite labels can constrain branches without identifying their
within-branch continuous parameters. General shared continuous dependence must be
supplied as a single exact joint V-polytope when that representation is valid.

The exact finite `allowed` relation is retained throughout strategic optimization.
`compatible_assignments` converts finite masks, including label-tree edge masks,
into this relation. It enumerates assignments; it is not efficient tree optimization.
An empty family is an input error rather than vacuous strategic success.

R16 payloads are decoded and independently source-sandwich checked. Their expanded
frontier is reduced without changing its downward hull. Every compressed component
must declare `max_uses`; queries exceeding it fail. For allowed scenario s, the
reported rational factor is `prod_occurrence scale_occurrence^dimension`;
its logarithm bounds directed source-minus-decoded support discrepancy. It counts
every occurrence. Source and payload SHA-256 identities accompany each result.
These identities bind the supplied inputs, not their empirical truth.

## Strongest guarantee and proof

Conditional on R13's strategic theorem and correct QF_NRA backend answers, the
implementation is a sound exact bracket reference for every input in this class:

* `ZERO`: an explicit common order with no outer-family strict cascade.
* `FULL`: a rational lower-family strict witness for **every** complete order.
  These witnesses need not be the same model or label tuple.
* `REFINE`: the complete bracket search has decided all relevant feasibility
  queries but establishes neither conclusion.
* `UNKNOWN`: an order budget, solver timeout/unknown, or rational-witness recovery
  budget leaves a needed computation incomplete. UNKNOWN is never REFINE.

For each branch and occurrence, barycentric weights are nonnegative and sum to
one; one weight is eliminated exactly. Each coordinate is rational affine in
these weights. For order pi the strict conditions are
`prod_{l>j} p_{pi_l} > r_{pi_j}`. These are rational polynomial inequalities,
including constant empty products. Closed simplices preserve vertices and all
degenerate faces; strict incentive inequalities preserve favorable ties. QF_NRA
decides whether an interior or boundary model defeats that order, without grids.
SAT models are converted to rational convex weights and rechecked by Fraction
arithmetic. Approximating algebraic weights, clipping at zero and renormalizing
converges to the original simplex point. Strict slack ensures eventual success;
a finite extraction cap instead returns UNKNOWN. UNSAT retains solver trust.

A family is a finite disjunction of these branch predicates. It is queried as a
union, never replaced by its convex hull. A union is unsafe for an order iff at
least one branch has a witness. The outer query must be UNSAT in every branch to
certify a common safe order. Search incompleteness can be overridden only by
sufficient evidence: an outer-safe order or a lower witness for every order.

For each compressed occurrence, R16's source audit proves downward domination
`D(lower) subset D(source) subset D(upper)`. Independent products preserve this
coordinatewise domination, as do unions with the **same** label mask. Every
suffix-product conjunction is increasing on positive coordinates, so lower
feasibility implies source feasibility and source feasibility implies outer
feasibility. The four-status contract follows. Outer points may exceed tau:
they are algebraic overapproximations, not asserted admissible strategic models.
The strategic theorem is applied only to the validated source family.

```yaml
LEAN: YES — The domination-to-common-order decision guarantee is a stable reusable soundness bridge, although this implementation and solver are not Lean checked.
```

No new historical originality label is claimed. Real-algebraic feasibility,
R10/R12's efficient low-dimensional selection, and R15/R16 composition are
inherited. See [the theorem-level source audit](sources/NOTES.md).

## Evidence and replay

`experiments/check.py` compares full orders with R12's independent cvc5 encoding,
compares optimized choices with both R10 and R12, and separately compares singleton
queries with R13's primitive state/path mixed-equilibrium and backward evaluators.
It includes binary-to-query source checks, multiple/repeated compressed components,
arbitrary-dimensional attachments, interior witnesses, an interval narrower than
10^-35, exact product ties, large denominators, point/segment/duplicate degeneracies,
incompatible labels, a modelwise-success/no-common-order example, false
convexification, source mismatch and explicit incompleteness controls.

[The receipt](experiments/receipt.json) records actual counts and hashes; normal
and `python -O` runs must be byte-identical. Tests remain finite evidence, separate
from the written reduction and strategic proof. Install the R12 pinned backends:

```sh
python -m pip install -r experiments/requirements.txt
python experiments/check.py > /tmp/r18.json
python -O experiments/check.py > /tmp/r18-O.json
cmp /tmp/r18.json /tmp/r18-O.json
python experiments/query.py experiments/example.json
```

## Preserved failures and precise boundaries

The fixture with two alternatives `(1/10,3/5)` and `(3/5,1/10)`, a first known
sender of probability `1/2`, and ratios `(1/10,1/100,1/100)` has a common safe order.
Erasing compatibility admits `(3/5,3/5)` and loses every safe order. Convexifying
the two alternatives also loses every safe order: the midpoint has product
`49/400 > 1/10`. This is exact evidence of the inherited nonconvexity obstruction,
not a newly discovered failure of R15's convex-family theorem.

With the same two alternatives and ratios `(2/5,2/5)`, each model has a safe order,
but no order is safe on both. Thus branchwise optimized success cannot establish
common-order success. An exact tie at source `(1/3,1/3)` can remain REFINE after
compression; this does not mean the computation timed out.

```yaml
LEAN: NO — These fixtures are implementation-specific regressions of already recorded quantifier and nonconvexity boundaries.
```

The reference enumerates n! orders and potentially exponentially many assignments.
The Z3 backend has no practical runtime guarantee in growing dimension, and no
NP-hardness result is asserted. R10/R12 retain their faster stated convex
low-dimensional classes and are executed as comparisons here. Decoder/source-audit
runtime and input expansion are not bounded by the order/solver budgets. A highly
compressed payload can be expensive to expand. No source-free authentication,
portable small UNSAT proof, efficient tree strategic optimizer or continuous
shared-parameter compressed representation is supplied.

**Programme change:** Gate A now covers arbitrary exact V attachments, more than
one R16 compressed block, bounded repeated independent use, and finite/tree label
compatibility in an end-to-end full-order reference. Full assessment and operational
interface Lean bridges remain separate Gate B obligations. Next bounded algorithmic
attack: adapt the existing low-dimensional prefix machinery to finite branch
families while preserving the common-order quantifier and explicit backend trust.
