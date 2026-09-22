# R22 formalization and boundary testing

September 21, 2026 formalization continuation (CI timestamps are September 22 UTC).
This record supplements the original R22 README; it does not rewrite that phase's
historical proof status or its 33,205-check receipt.

## Result and evidence

**Successful proof-source edition:** `594d34027f654c7f1b3c449b2f6aec9567a34003`.
[Formal CI run 35680227655](https://github.com/saykig/decision-interfaces/actions/runs/35680227655)
compiled 11 modules: nine new library modules, the unchanged R14 belief module,
and one generated fixture module. The 252 audited named declarations comprise
105 new library declarations, 39 inherited declarations and 108 finite test
statements. Transitive axiom dependencies are only `propext`, `Classical.choice`
and `Quot.sound`; no admitted proof or custom axiom is accepted.

The same run passed the exact boundary replay in normal and optimized Python.
At that same source edition, the existing seven-job research workflow
[35680227644](https://github.com/saykig/decision-interfaces/actions/runs/35680227644)
and historical R22 replay
[35680227673](https://github.com/saykig/decision-interfaces/actions/runs/35680227673)
also passed. These are nine successful jobs across three workflows, not an
assertion that every historical workflow was triggered.

[Source/axiom summary](results/lean_summary_594d340.json) and
[exact boundary receipt](results/boundaries_594d340.json) retain the source binding.
The full raw Lean receipt, generated fixture statements, compiler log and exact
source archive were retrieved from CI; every recorded source hash was checked
against that archive. The summary identifies the full raw receipt by SHA-256.
The later documentation/evidence commit does not change the checked proof files.

The declared one-sender inspection bridge is now an importable chain, not merely
a threshold formula assumed inside an equilibrium definition. The mathematical
source is R22 T1/T3 at base commit `5ea1f5059d155b0d6fdcd62768f7fa46bd75fd6d`.
The original model, Python implementation and earlier Lean phases were preserved.

## What the formal statements cover

| Source claim | Formal objects and representative declarations | Coverage |
|---|---|---|
| T1 actual audit leaves and behavioral incentives | `reportPayoff`, `senderPayoff`, `audit_leaf_identity`, `silent_best_reply_iff`, `every_mixture_at_tie` | Expected payoff is derived from the two audit outcomes; arbitrary report mixtures and favorable equality are explicit. |
| T1 receiver behavior and consistent assessments | `ReceiverBestReply`, `receiver_actions`, `BayesianConsistency`, `bayesian_consistency_iff`, `sequential_silent_gain` | Bayes conditioning uses the unchanged R14 atom/mass definitions; one feasible completely mixed sequence supplies report and both receiver-choice trembles and both belief limits. |
| T1 attained robust minimum | `Source`, `ratio_maximum_exists`, `detection_floor_exists`, `attained_robust_fine`, `below_minimum_witness`, `audit_fine_sequential` | Nonempty compact positive-detection sources attain their worst case. A smaller nonnegative fine has an actual violating model. |
| Core T3 operational equivalence | `profile`, `fine_profile`, `profile_equivalence`, `rational_query_equivalence` | Equality of the profile on positive arguments is equivalent to equality of all permitted real fine queries, and also of all permitted rational queries. The rational result uses continuity/density, not a grid. |
| T3 projective and V-input interpretation | `projective_convexHull`, `vertex_minimum`, `fine_vertex_formula`, `cast_rationalFine`, `checked_input_minimum` | Standard Mathlib convex hulls; detection-dependent reweighting, not a false affine-map argument. Finite rational output is the minimum over the whole real convex hull. |
| T4 directed inequality | `directed_fine_bound`, `audit_target_from_approximation` | One-sided joint-point matching error transfers to the fine with an explicit positive detection floor, and then to actual target assessments. |
| Selected boundaries | `zero_detection_no_target`, `missing_floor_no_uniform_fine`, `exact_tie_not_forced_silence`, rational 3/6 examples | Zero detection and absence of a uniform floor have explicit obstruction theorems. Equality permits reporting as well as silence. |

`Inspection.lean` is the public entry point. Its `audit_interface_iff_target`
connects the actual sequential target directly to the profile criterion. Its
`audit_target_from_approximation` is a downstream theorem obtained by importing
and applying the earlier bridges, demonstrating reuse without redefining them.

## Strategic interpretation and domain

The receiver's action probability is its probability of choosing D; probability
zero is the original action C. The prior is one half. A type-zero sender cannot
report. Type one may make an authenticated report, paying cost k. The sender fine
e is collected only when a report is detected. Silence has no false-positive fine.
The audit draw is exogenous, unavailable before the strategic decisions, and has
known conditional detection probability. There is no optimizing inspector.

`AuditSource` retains positive rewards and detection strictly between zero and
one; `InspectionQuery` retains positive multiplier and cost. The lower-level
`Source` deliberately supports more general positive-denominator algebra. A value
outside the probability interval is not given an audit interpretation merely
because an algebraic helper accepts it.

The conclusion is existence of a consistent all-silent target, model by model,
with one common fine. It is not universal silence across all equilibria, one
strategy across all models, an empirical behavioral law, or a welfare claim.
Ties are favorable to existence. The trembled strategies establish consistency;
they are not required to be equilibria themselves.

The operational equivalence is restricted to positive-cost queries. Internal
helpers may be mathematically defined for other real arguments, but profile reuse
outside the declared domain is not authorized by the equivalence theorem.

## Boundary suite and Python-to-Lean fidelity

`experiments/boundary_checks.py` performs 332,763 elementary exact checks across
696 one-, two- and three-point source families and 15 queries per family. They
are finite checks, not that many theorems or proof by dense sampling. Normal and
`python -O` outputs agree; checks are not removable Python assertions.

The suite checks primitive audit payoffs, exact ties, strictly subthreshold fines,
convex interior points, projective forward/inverse weights, and exact envelope
breakpoints. It replays equal marginals with fines 3 and 6; equal base profiles
with unsupported reward shifts giving 10 and 26; vanishing-detection sensitivity;
sharp singleton error cases; independence versus one shared lottery; AND versus
OR audit semantics; fresh repetitions; finite masks; malformed inputs and empty
mask versus a feasible zero fine. It also checks that agreement on a finite query
interval cannot justify extrapolation. Eight deliberately false semantic rules
are falsified by concrete witnesses; these are not source-level mutation tests.

`generate_adapter.py` calls the unchanged Python `joint.frontier` and generates
96 valid and 12 invalid Lean fixture statements using only rational literals.
Lean checks these outputs against the separately defined `checkedFine` spec.
The fixture text and both Python sources are hashed in the formal receipt.
This is actual cross-language finite replay, not a proof of all Python executions.

`checkedFine` is a guarded mathematical specification, not an extracted Lean
parser. Its invalid-input error is distinct from zero; a nonempty validated source
is required. Empty compatibility masks belong to T5's separate `None` semantics,
which remains written and tested here rather than newly formalized.

## Remaining scope, not hidden assumptions

T4's general sharpness statement and exact interval-discrepancy/envelope algorithm
remain written proofs with finite exact checks. T5's serial-product, repeated-stage
and finite-mask laws are not Lean-formalized in this continuation. Serial means
both independent stages must succeed for collection; OR detection or reusing one
realized lottery is a different model.

The full canonical envelope algorithm, parser/serialization, Python execution,
complexity claims, full-hull marginal equalities in the illustrative examples,
and general reward-shift counterexample are not all Lean theorems. The proved
T3 target is the query/profile and projective/vertex bridge, not every sentence
of the original T3 exposition. No new entropy, codec, R10, multi-sender,
shared-parameter, dynamic or bargaining theorem is claimed.

No independent human model/statement review, separate proof-kernel replay,
publication-priority result or empirical application has been established here.
The original first-paper dependency structure and the application repository are
unchanged. This is not a declaration that Foundation v1 or the manuscript is complete.

## Reuse and replay

Use the existing Lean `v4.33.1` and Mathlib commit
`0df444a360eaa60ab8c11dca51a86af692955474`. From the repository root:

```sh
ROOT="$PWD"
cd docs/working-ground/research/information_incentives_2026_08_14/lean
lake update
lake exe cache get
cd "$ROOT"
python3 docs/working-ground/research/joint_inspection_2026_09_21/lean/verify.py \
  --packages docs/working-ground/research/information_incentives_2026_08_14/lean/.lake/packages \
  --output /tmp/r22-fresh-lean.json
python3 docs/working-ground/research/joint_inspection_2026_09_21/experiments/boundary_checks.py \
  > /tmp/r22-fresh-boundaries.json
python3 -O docs/working-ground/research/joint_inspection_2026_09_21/experiments/boundary_checks.py \
  > /tmp/r22-fresh-boundaries-O.json
cmp /tmp/r22-fresh-boundaries.json /tmp/r22-fresh-boundaries-O.json
```

Choose a fresh output path: the verifier refuses to overwrite a receipt. Add a
later `.lean` module with `import Inspection` and place it after `Inspection` in
the verifier's module order, or build it with the same dependency search paths.
The verifier's temporary compiled files are discarded after the audit; reusable
source imports, not a new standalone Lake package or binary release, are supplied.

Execution used the connected repository and GitHub CI for Lean, because this
chat's shell had no Lean toolchain or working GitHub DNS. Exact Python tests ran
locally. A later CI source archive supplied a complete immutable source snapshot;
this is not a git checkout and was not used to claim all earlier suites ran locally.
The user's macOS working tree was not accessed.

## Progress and decisions

D68: use a shared importable formal vocabulary, including actual Bayes/tremble
machinery from R14, and expose the joined strategic/profile theorem as the API.
D69: separate generic algebra, the physical audit domain, malformed input, empty
model masks, and a feasible zero result. A successful helper call is not permission
to extrapolate a profile or substitute a different audit-composition mechanism.
D70: record formal theorem coverage, finite cross-language replay, boundary tests,
and independent human review as different evidence classes.

Next bounded work: formalize T4 sharpness and the declared T5 serial/finite-mask
composition on these existing definitions; then audit the v1 dependency boundary.
Do not introduce a new model merely to avoid finishing the current interface.
