# Working ground

**Current ownership — September 21, 2026:** this is the canonical mathematical
working ground in [decision-interfaces](https://github.com/saykig/decision-interfaces).
Future theorem development, proofs, verification and mathematical provenance live
here. [Cooperation-enforcement](https://github.com/saykig/cooperation-enforcement)
is the Ukraine-focused CEES application/proving ground. See the
[research programme](../../RESEARCH_PROGRAMME.md) and [handoff record](FOUNDATION_HANDOFF.md).
The trajectory below is inherited intact; dated “latest” entries describe their phase.

The research trajectory behind Cooperation & Enforcement, beginning August 13,
2026. This area collects the mathematical questions, proofs, counterexamples,
literature notes, experiments and changes of direction in one place.

- [Research progress](PROGRESS.md)
- [Decisions, failures and corrections](DECISIONS.md)
- [How to revisit and extend the work](RECOVERY.md)
- [Verification ledger](VERIFICATION.md)
- [Formalization backlog](FORMALIZATION_BACKLOG.md)
- [Research north star](research/foundations/NORTH_STAR.md)

## Research phases

| Date | Research |
|---|---|
| August 13, 2026 | [Partial knowledge and causal foundations](research/foundations/manuscript/RESEARCH_NOTE.md) |
| August 13, 2026 | [Revision, provenance and mechanism versions](research/clarification_2026_08_13/RECOMMENDATION.md) |
| August 14, 2026 | [Shared information budgets and incentives](research/information_incentives_2026_08_14/manuscript/RESEARCH_NOTE.md) |
| August 14, 2026 | [Partial certificates and enforcement](research/partial_certificate_frontier_2026_08_14/manuscript/RESEARCH_NOTE.md) |
| August 14, 2026 | [Disclosure discontinuity boundaries](research/disclosure_boundaries_2026_08_14/manuscript/RESEARCH_NOTE.md) |
| August 14, 2026 | [Optimized gates and recovery](research/optimized_gate_recovery_2026_08_14/manuscript/RESEARCH_NOTE.md) |
| September 9, 2026 | [Sequential disclosure and compatible uncertainty](research/sequential_disclosure_2026_09_09/manuscript/RESEARCH_NOTE.md) |
| September 20, 2026 | [Enforcement-sufficient compression and certified codec](research/enforcement_codec_2026_09_20/manuscript/RESEARCH_NOTE.md) |

Each phase includes its available mathematical development, source notes,
experiments, evidence and limitations. The latest phase returns to the composition
question through sequential hard evidence: it derives an exact disclosure-order
criterion and shows that preserving a shared constraint on uncertain local
probabilities can change the robust enforcement requirement even after optimizing
the disclosure order. Novelty and empirical validity remain open. The earlier
large revision experiment remains unrun.

Use the progress and decision ledgers to add later work and corrections. Keep
mathematical proofs, numerical checks and formal verification clearly distinguished.

## Latest result — R09, September 19

[Robust disclosure orders over polytopes](research/robust_order_polytope_2026_09_19/README.md)
gives an exact certificate for a common zero-fine order, sharp counterexamples to
vertex/local-summary shortcuts, and a no-adaptation result for the AND benchmark.
The historical R09 result is preserved; R10 below resolves its next segment-selection attack.

## Latest result — R10, September 19

[Two-prefix selection](research/two_prefix_selection_2026_09_19/manuscript/RESEARCH_NOTE.md)
proves that a common zero-fine order on a rational segment exists exactly when
a prefix of at most two senders works. Selection is polynomial in input bit size.
An implemented exact selector returns checkable success or all-pair rejection
certificates. The dimension-d bound d+1 is proved and attained for d=0,1,2,3;
R11 below establishes the general construction with dimension-dependent payoffs.

## Latest result — R11, September 19

[General sharpness](research/general_sharpness_2026_09_19/manuscript/RESEARCH_NOTE.md)
constructs, for every d, a rational d-dimensional family requiring a prefix of
exactly d+1 senders. The proof specifies thresholds approaching one. It separately
resolves all twenty missing dimension-four witnesses and proves why fixed-q and
fixed-threshold versions of this particular construction fail. Arbitrary-family
sharpness at fixed τ=2/3 remains open. The next algorithmic target is exact
selection over rational polygons; sharpness does not imply hardness.

## Latest result — R12, September 19

[Fixed-dimensional selection](research/fixed_dimension_selection_2026_09_19/README.md)
proves polynomial-time exact order selection for each fixed affine dimension under
explicit rational V/H input. The polygon implementation has independent exact
backend checks and auditable outputs; success certificates retain solver trust.
The independent replay audit passed, including prior Sturm comparisons and three
solver-free AM-GM success certificates. A separate sharpness investigation tightens
the existing ansatz's singleton threshold and constructive margin, without claiming
fixed-threshold general sharpness.

## Latest result — R13, September 19

[Independent game-to-cascade audit](research/game_cascade_audit_2026_09_19/README.md)
reconstructs R08 from its primitives, including unique consistent off-path beliefs
and arbitrary mixed continuations. The original existence theorem and 0-or-B fine
survive. The new exact state/path/tremble checker supports the complete written
derivation; replay and downstream implications are recorded. Formal verification
remains open. No growing-dimension work is included.

## Latest result — R14, September 20

[Lean belief and continuation bridge](research/lean_belief_bridge_2026_09_19/README.md)
formally derives unique consistent beliefs, receiver best replies and full mixed
sender continuation gains from the actual history-dependent game, for arbitrary
finite sender counts. The continuation kernel is identified with a normalized
recursive behavioral tree. A fresh build audits 119 named declarations with
standard Lean axioms only; exact finite model comparisons separately agree with
R13's independent evaluator. Full sequential-equilibrium existence, the backward
construction and the 0-or-B fine theorem remain written proofs.


## Latest result — R15, September 20

[Enforcement-sufficient compression](research/enforcement_codec_2026_09_20/README.md)
identifies an exact contextual discrepancy for enforcement-relevant interfaces,
proves additive error accounting under independent composition, derives
fixed-dimensional storage upper/lower bounds with the same main exponent, and
records a rational proof-carrying planar codec. It also shows that shared scenario
labels must survive until connection. R15 has written proofs and exact executed
checks; no new Lean or historical-novelty certification is claimed.


## Latest result — R16, September 21

[Optimal bits and the composition contract](research/optimal_bits_2026_09_21/README.md)
closes the planar logarithmic storage gap with a rational multiscale codec,
separates source-readable verification from payload size, and proves unlimited
repeat reuse cannot have finite worst-case bits at a fixed final margin. It
extends the information rate to fixed dimension and error budgeting to labelled
trees. Written proofs and exact executable checks; no new Lean or priority claim.
