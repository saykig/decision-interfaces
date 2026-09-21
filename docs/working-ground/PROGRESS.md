# Working timeline — starting August 13, 2026

Research chronology begins August 13, 2026, as supplied by the author.
Same-day ordering follows the sequence of the investigations. Findings and
evidence statuses are drawn from the corresponding research notes.

## R01 — 13 August: reassess the mathematical foundations

**Question:** how should partial knowledge combine, and how should causal mechanisms
and interventions be represented? Compared information/valuation algebras,
local-to-global compatibility and compositional causal models.

**Outcome:** use complementary established theories, not a new universal algebra.
Selected finite acyclic causal modules with relational uncertainty over complete
mechanism choices. Derived extension, gluing, intervention and outer-approximation
results; later distinguished scalar ranges from complete query signatures.

**Evidence:** written proofs; exact finite enumeration; selected Lean lemmas.
These do not establish novelty, empirical adequacy or general strategic applications.
**History:** repository initially appeared empty; existing main was recovered and
historical artifacts preserved. Milestones: `e3cb988`, `7602659`, `e3a6a92`.

**Recover:** [original August 13 log](research/foundations/history/RESEARCH_LOG.md),
[initial audit](research/foundations/history/2026-08-13-initial-audit.md),
[repository inspection](research/foundations/history/2026-08-13-repository-inspection.md),
[note](research/foundations/manuscript/RESEARCH_NOTE.md),
[claim standing](research/foundations/CURRENT_STATE.md),
[rejected routes](research/foundations/REJECTED.md).

**Then-next question:** which dependencies must a representation retain under later
composition? R02 reconsidered this emphasis; it did not invalidate R01's results.

## R02 — 13 August: clarify revision and provenance

**Question:** what must be retained when named premises are added or withdrawn,
or a named mechanism is replaced? This is a related branch of the foundations
question, not a completed general theory of revision.

**Outcome:** an anonymous current-model family cannot implement every named
withdrawal. Two independent warrants can support the same present conclusion but
respond differently to withdrawal. Mechanism versions and intervention interfaces
also matter. Selected a bounded provenance-sensitive experiment.

**Evidence:** written arguments and executed small probes, including the recorded
32/0/20 interface counts. The larger 96-record experiment was specified and its
runner prepared, **not executed**. Its practical value and quotient size remain open.
**Git at the time:** uncommitted at `e3a6a92`; preserved by R06.

**Recover:** [recommendation](research/clarification_2026_08_13/RECOMMENDATION.md),
[current state and recovery map](research/clarification_2026_08_13/CURRENT_STATE.md),
[translation/proofs](research/clarification_2026_08_13/TRANSLATION.md),
[actual probe results](research/clarification_2026_08_13/probe-results.json),
[unexecuted next specification](research/clarification_2026_08_13/EXPERIMENT_SPEC.md).

**Still open:** this revision experiment was not completed by the later strategic
research. The trajectory branches here; later work must not be described as having
settled named revision in general.

## R03 — 14 August: shared information budgets and active incentives

**Question:** combine supplied information–incentive components without spending
the same information budget independently in each component; include disclosure.
External source notes and an audit were inspected and hashed.

**Outcome:** information-cost profiles, joint attainability, a six-branch expected
joint-vulnerability formula, and a solved disclosure benchmark. Separate expected
maxima and separate credible punishments can give wrong answers. A partial
certificate requires one continuation that deters all eligible sender types.

**Evidence:** analytical Theorems A–G; original-cell optimization and payoff checks;
50 tree identities and exact certificate arithmetic; narrow Lean checks of maximum
and threshold identities. The full equilibrium and entropy theory were not formalized.
The binary benchmark's controlled fine ≈.09018 and disclosure penalty 1 are specific
to that game and cannot be compared as identical objects with R04's numbers.
**Git at the time:** uncommitted at `e3a6a92`; preserved by R06.

**Recover:** [log](research/information_incentives_2026_08_14/RESEARCH_LOG.md),
[note](research/information_incentives_2026_08_14/manuscript/RESEARCH_NOTE.md),
[standing](research/information_incentives_2026_08_14/CURRENT_STATE.md),
[input identities](research/information_incentives_2026_08_14/sources/INPUT_MANIFEST.json),
[rejected routes](research/information_incentives_2026_08_14/REJECTED.md).

**Then-next:** a three-state robust partial-certificate frontier, pursued in R04.

## R04 — 14 August: partial certificates and the perfect-gate obstruction

**Question:** solve an explicit three-state two-receiver game with a shared budget,
common gate/fine and a partial certificate; examine valid composition boundaries.

**Outcome:** noisy-gate frontier and a distinct perfect-gate regime when an eligible
type becomes impossible. Established a scalar-profile result not specific to KL,
upper-image composition with retained interfaces, and counterexamples to arbitrary
convexification and unrestricted multi-sender belief choices. The game differs
from R03; optimality is only over the declared symmetric binary gates.

**Evidence:** written proofs; 36 original-cell comparisons, 200 sampled laws,
304 continuation checks, 72 finite feasibility queries and six narrow Lean lemmas.
SLSQP failed on nonsmooth total variation; the appropriate LP replaced that check.
**Prior-art reassessment:** close signaling/communication and set-optimization work
already contains the common-payoff logic and algebra; novelty remains unestablished.
**Git at the time:** uncommitted at `e3a6a92`; preserved by R06.

**Recover:** [log](research/partial_certificate_frontier_2026_08_14/RESEARCH_LOG.md),
[note](research/partial_certificate_frontier_2026_08_14/manuscript/RESEARCH_NOTE.md),
[standing](research/partial_certificate_frontier_2026_08_14/CURRENT_STATE.md),
[source audit](research/partial_certificate_frontier_2026_08_14/sources/AUDIT.md),
[rejected routes](research/partial_certificate_frontier_2026_08_14/REJECTED.md).

**Then-next:** explain the discontinuity with asymmetric priors and overlapping
certificates, before further network/multiple-sender expansion. Pursued in R05.

## R05 — 14 August: classify disclosure discontinuities

**Question:** first vary only prior/gate/budget with fixed payoffs and costs; then
classify full-parameter boundaries. Are support and equilibrium changes exhaustive?

**Outcome:** exact information-only criterion in the full KL family (Theorem I),
exact phase criterion within the payoff family (F), and a regular-region theorem
from established parametric optimization (R). Support loss can be masked. A discrete
source catalogue supplies another jump mechanism without posterior-support change.
Separate examples isolate incentive thresholds and loss of deterrent equilibrium
branches. Optimizing the gate removes the supplied-perfect-gate jump in this family.

**Evidence:** analytical proofs and counterexamples, 56 original-cell optimization
comparisons and exact rational checks. One unsuccessful solver status is retained.
Lean derives the fixed-information E12 threshold from utilities, including operations
and a full-support wrapper; it does not prove the global continuity theorem.
**Commits:** `26d3415`, `ad16961`, pushed to main.

**Recover:** [log](research/disclosure_boundaries_2026_08_14/RESEARCH_LOG.md),
[note](research/disclosure_boundaries_2026_08_14/manuscript/RESEARCH_NOTE.md),
[audit](research/disclosure_boundaries_2026_08_14/AUDIT.md),
[rejections](research/disclosure_boundaries_2026_08_14/REJECTED_APPROACHES.md),
[Lean scope](research/disclosure_boundaries_2026_08_14/lean/README.md).

**Open next question:** can a nontrivial continuation switch survive joint gate
optimization? This remains a proposal, not a result or automatically active goal.

## R06 — 14 August: consolidate the trajectory for recovery

**User request:** keep the whole research trajectory in one ledger area, including
the record begun August 13, so earlier work can be revisited and corrected.

Located R01's original log and the research-purpose statement. Reconstructed R01–R05
from retained logs/status notes, indexed decisions and recovery dependencies, and
inventoried exact bytes. Preserved the 60 previously untracked artifacts of R02–R04
and the existing research-purpose statement without rewriting them. Their original
“uncommitted” statements remain historically accurate; this is the later preservation
event. Git identifies this event under the commit subject **Preserve prior research
phases and consolidate the research trajectory ledgers**.

No mathematical claim was newly proved or revalidated in this pass. No unexecuted
experiment was run. External source files remain outside the repository where
previous manifests say so; hashes alone do not recover those bytes.

## R07a — 14 August: activate endogenous-gate recovery research

Explicit active goal, starting from `5661f9e`, following R05's open question.
The [new bounded investigation](research/optimized_gate_recovery_2026_08_14/README.md)
first rejects a fixed-fine continuation switch in the inherited full-information,
fixed-support public model. A candidate fixed-payoff information-only obstruction
uses a sender observing certificate eligibility rather than the exact state;
the user explicitly authorized analysing both and labelling that change.
Analytical development begun; computation and final theorem audit pending at this
milestone. No claim of refuting strong persistence, minimality or novelty.

## R07b — 14 August: exact optimized jump and recovery boundary

Following activation commit `a3bb951`, derived the
[fixed-payoff counterexample](research/optimized_gate_recovery_2026_08_14/math/COUNTEREXAMPLE.md):
V(0)=0 and V(t)=1+t/2 for t>0, over a compact two-dimensional noisy gate menu.
Prior and costs are fixed; a continuous interval of source laws varies. Public
posteriors have global full support; certificate posteriors have uniform support
on the eligible states. The sender observes eligibility, not the exact state;
sequential consistency, rather than arbitrary off-path PBE beliefs, pins beliefs.
The low-fine deterrent disappears, so strong persistence is not refuted.

[F1/F2](research/optimized_gate_recovery_2026_08_14/math/FULL_INFORMATION.md)
prove fixed-fine invariance in the full-information model and a primitive smoothing
theorem for one receiver. [R1–R3](research/optimized_gate_recovery_2026_08_14/math/RECOVERY_THEOREM.md)
give the established compact recovery boundary and finite-cover sufficient
conditions. Exact arithmetic checks 2,025 original-cell cases, both model controls
and stale/wrong-value rejection; no formal proof or global minimality is claimed.
Final author audit/programme handoff pending at this milestone.

## R07c — 14 August: completed boundary and programme handoff

Mathematical/evidence edition `e2daee7` follows activation `a3bb951` and baseline
`5661f9e`. [Author completion audit](research/optimized_gate_recovery_2026_08_14/AUDIT.md)
closes deliverable 3: exact small optimized-discontinuity witness plus primitive
smoothing and necessary/sufficient recovery under compact closedness. No new
universal theorem, strong-persistence refutation, global minimality or formal
verification is claimed. README/programme steering now retain the sender's
information partition and consistency rule. A repository release note records
this transition; no GitHub Release or product changes. Prior frozen records and
unrelated foundations local files are preserved. The R02 experiment remains unrun.

## R08 — 9 September: sequential disclosure and compatible uncertainty

**Question:** after the multi-sender novelty audit, what composition problem remains
that is both mathematically real and connected to the enforcement programme?
Can separately retained local probability ranges misstate the enforcement needed
when disclosure occurs sequentially?

**Literature correction:** minimum payments supporting a fixed information scheme,
multi-sender persuasion, product restrictions, sequential persuasion and costly
multi-sender disclosure already have substantial foundations. The phase therefore
rejects a broad novelty claim based only on combining information with incentives.

**Negative results:** enlarging the family of information structures that must all
be tolerated cannot lower a universal robust fine; this is different from enlarging
the institution's design menu. For fixed obedience constraints, convex mixtures of
already-admissible information kernels do not change the universal threshold.
The proposed simultaneous all-silent rank-one obstruction also fails in the stated
unilateral-deviation model: a single sender deviation reaches a solo-message
history, not a joint-disclosure history.

**Positive result:** in a declared complementary-evidence game with independent
binary facts, costly authenticated positive reports and a sequential disclosure
order, an exact criterion determines whether fine 0 suffices or the full-information
fine B is necessary. For order pi, a disclosure cascade occurs exactly when every
sender j satisfies

    k_{pi_j} < eta_{pi_j} * product_{l>j} p_{pi_l}.

At a known probability vector, some order supports zero fine iff some sender i has

    k_i / eta_i >= product_{j!=i} p_j.

**Composition example:** with three senders and one shared one-dimensional
constraint on their local positive probabilities, order (1,2,3) supports zero
fine for every admissible model even though the identity of the sender blocking
the cascade changes across models. Replacing that shared family by the same
separate local probability ranges admits an impossible upper-corner combination
under which every order cascades, raising the optimized robust fine from 0 to 1.
The interval relaxation is conservative: it demands unnecessary enforcement.

**Evidence:** analytical derivations plus 4,802 exact rational checks:
960 sequential-fine checks, 1,824 order comparisons, 918 shared-family/outer-box
checks, 900 exact tremble/posterior checks and 200 hidden-mixture obedience checks.
No Lean or other formal proof checker was run. Computational checks corroborate
the formulas but do not establish the continuum proofs, novelty or empirical fit.

**Recover:** [phase README](research/sequential_disclosure_2026_09_09/README.md),
[research note](research/sequential_disclosure_2026_09_09/manuscript/RESEARCH_NOTE.md),
[current state](research/sequential_disclosure_2026_09_09/CURRENT_STATE.md),
[source audit](research/sequential_disclosure_2026_09_09/sources/NOTES.md), and
[experiment summary](research/sequential_disclosure_2026_09_09/experiments/README.md).

**Next bounded attack:** characterize robust sequential order choice under a
declared class of genuinely shared uncertainty constraints. Rectangular uncertainty
is already solved by the upper corner. For a class such as compact polytopes in
local probabilities, seek a necessary-and-sufficient certificate or a complexity
boundary. Do not replace the shared family by independent coordinate ranges.

## R09 — September 19: robust-order certificates and the projection boundary

Read and preserved all R08 records at `254f5d9`; first new mathematical milestone
`317ba53`. The [new phase](research/robust_order_polytope_2026_09_19/README.md)
keeps the common-order/shared-uncertainty question and exact complementary-evidence
benchmark. Some order works at zero fine iff one order admits a universal weighted
log-product inequality; for a polytope this has a finite tangent/normal certificate.
The proof specializes established minimax and convex optimization.

**Counterexamples:** three senders and a segment disprove vertex-only testing.
Full pairwise feasible regions suffice at three senders but fail at four; generally
all (n−1)-projections suffice and all (n−2)-projections can fail. Simple cost sorting
and poset/antimatroid/greedoid representations of successful orders also fail.

**Additional proved structure:** stable r_i p_i ranking yields a valid sorted order;
deterministic public adaptive ordering has the same enforcement value as its unique
all-positive path. Rational-segment fixed-order verification is polynomial via
univariate sign determination, so common-order existence on segments is in NP.
No NP-hardness or general polynomial selection algorithm was established.

**Evidence:** analytical proofs plus 15,653 new exact rational checks, including
independent continuation-game/tree recursion and a rational continuum certificate.
The general root-isolation algorithm is a written reduction, not implemented.
No Lean run. R08 retains only a summary of its 4,802 checks, so those historical
checks were not claimed as reproduced. No novelty or empirical validity claim.

**Next attack:** keep the main question; settle variable-n rational-segment order
selection by a polynomial algorithm or a genuine hardness reduction. See the
[research note](research/robust_order_polytope_2026_09_19/manuscript/RESEARCH_NOTE.md),
[audit](research/robust_order_polytope_2026_09_19/AUDIT.md) and
[research log](research/robust_order_polytope_2026_09_19/RESEARCH_LOG.md).

## R10a — September 19: two-prefix theorem and implemented exact selector

The [new phase](research/two_prefix_selection_2026_09_19/README.md) resolves R09's
rational-segment selection question in polynomial bit time. Finite Helly selects
at most two strict cascade inequalities; moving their senders to the front preserves
their empty intersection. Enumerate ordered pairs and use exact polynomial signs.
The proof covers favorable ties, degenerate segments, constant coordinates and
empty products. In affine dimension d it gives a prefix of at most d+1 senders.

**First implementation evidence:** 2,271 exact checks; exhaustive full-order
comparison on 96 instances, 240 comparisons with the historical independent
quadratic oracle, portable certificate checks and deliberate certificate corruption.
Includes the midpoint, changing-blocker and distinct-witness quantifier examples,
tangencies, shared/endpoint roots and a feasible interval narrower than 10^-29.
No Lean verification or implementation bit-complexity guarantee. The polynomial
algorithm reduction credits Helly and established root-isolation machinery.
Higher-dimensional sharpness testing continues after this completed segment milestone.

## R10b — September 19: completed segment selector and dimension sharpness

Following milestone `ce06375`, completed the
[research note](research/two_prefix_selection_2026_09_19/manuscript/RESEARCH_NOTE.md),
source audit and completion audit. Preserved the first execution receipt and added
105 checks for algebraic roots, symmetries and large endpoint denominators.
Normal/optimized runs agree on the original 2,271 checks and certificates.

**Sharpness:** a four-sender triangle needs a three-prefix: all 12 pairs have exact
vertex witnesses, while weighted AM-GM certifies a successful triple everywhere
on the triangle. A five-sender, dimension-three hull likewise needs a four-prefix;
all 60 ordered triples have certified witnesses. These retain R08's strategic
model but choose new admissible payoff parameters. General d≥4 tightness remains
open; a bounded d=4 search was inconclusive, not a nonexistence result.

**Question retained:** segment selection is now solved by borrowed geometry and
root machinery plus the move-to-front argument. Next attack: general within-game
sharpness, including whether keeping a particular receiver threshold changes the
bound. No historical novelty, formal verification or production performance claim.

## R11a — September 19: resolve every missing dimension-four prefix

The [general sharpness gate](research/general_sharpness_2026_09_19/README.md) keeps
R08's game and the main question. All twenty missing prefixes in R10's bounded
search begin with sender 1. Maximizing their minimum log cascade margins, then
rationalizing and checking products exactly, finds a strict witness for EACH at
the original parameters. Rational tangent/knapsack/log-series certificates also
bound each optimal margin; the widest bracket is below 4.7·10^-8. Thus that failed
search provides no dimension-four obstruction. The arbitrary-d construction and
fixed-threshold distinction remain the next parts of this gate.

## R11b — September 19: general sharpness construction and its parameter boundary

Following `5518615`, proved the arbitrary-d theorem: for every d, an explicit
rational family of affine dimension d and n=d+2 senders has minimum successful
prefix length d+1. Weighted AM-GM certifies the canonical prefix throughout the
hull. A running-maxima/block-deficit construction gives a strict rational witness
for EVERY shorter prefix, with a uniform positive slack. Dimension-spanning points
prove actual dimension. The theorem chooses q_d and τ_d approaching one explicitly.

**Construction limitations:** keeping q=4/5 fails for m≥11. At any fixed τ<1 the
uniform-AM-GM ansatz eventually has a singleton blocker regardless of q; at τ≤2/3
it does for every m≥2. These are not universal game bounds. All-d sharpness outside
that ansatz at fixed τ=2/3 remains open, and R08 guards against overgeneralization.

**Evidence:** complete written proof; 23,115 exhaustive rational prefix checks
plus 75 larger-m controls through m=100; exact margin-certificate replay for the
twenty optimized cases; exact affine-rank and obstruction controls. No Lean proof,
independent trusted kernel or historical novelty claim. Updated the verification
ledger and added scoped CI replay steps, preserving the other task's CI changes.

**Gate conclusion:** achieved a general construction plus proved limitations,
not more isolated examples. Keep the main question. The next algorithmic attack
is exact common-order selection on rational polygons; prefix sharpness alone does
not imply computational hardness. See the
[note](research/general_sharpness_2026_09_19/manuscript/RESEARCH_NOTE.md) and
[goal audit](research/general_sharpness_2026_09_19/AUDIT.md).

## R12a — September 19: fixed-dimension theorem and first polygon milestone

The [new gate](research/fixed_dimension_selection_2026_09_19/README.md) proves
polynomial-bit selection for every fixed affine dimension, on explicit rational
V/H polytopes. This combines the existing short-prefix reduction with borrowed
effective quantifier elimination. It does not settle growing dimension.

An exact polygon/segment/point implementation returns rational rejection witnesses
or an emptiness bundle replayed with Z3 and independent barycentric cvc5. CPC
skeletons include trusted covering steps: no external kernel or Lean claim.
Fourteen designed fixtures agree with all 84 independently checked full orders.
The final direct-order/Sturm replay and synthesis remain to close this gate.

The separately delegated review proves an exact threshold for avoiding one
singleton obstruction in R11's ansatz, plus improved all-d construction parameters
and margins. It does not resolve full sharpness at a fixed receiver threshold.

## R12b — September 19: fixed-dimensional gate closed at stated trust level

Following `0f94556`, replayed all 14 stored bundles and compared the primary and
independent methods directly on 132 full orders, including symmetry/redundant-vertex
variants. Forty-two segment/point orders also agree with the prior exact Sturm
checker. A genuinely two-dimensional strip narrower than 10^-30 has an exact
witness. Three weighted-AM-GM certificates independently prove the key zero-margin
successes with rational arithmetic alone. Normal and optimized Python agree.

The [final note](research/fixed_dimension_selection_2026_09_19/manuscript/RESEARCH_NOTE.md)
distinguishes the polynomial-bit theorem, measured fixture runtime, general
solver-trusted emptiness bundles and the special solver-free certificates. It
retains the smallest fixed-order vertex-test counterexample and explicit novelty
limits. No Lean or external CPC-kernel verification is claimed.

The independent side review establishes the exact distinguished-singleton ansatz
threshold, asymptotic deficit 2/m², and improved all-d construction parameters with
sufficient deficit of order m^-6. Its proofs are supported by 2,955 exhaustive
prefixes, 20 larger controls and 29 two-sided threshold checks; they are not a
fixed-threshold general sharpness theorem.

**Question retained.** Fixed affine dimension is settled algorithmically by the
R10 reduction plus established mathematics. Next confidence attack: independently
rederive/check R08's strategic bridge. Growing dimension remains the subsequent
complexity frontier, without a hardness claim.

## R13a — September 19: reconstruct the strategic bridge independently

The [game audit](research/game_cascade_audit_2026_09_19/README.md) begins from Nature,
messages, information sets and payoffs, not from suffix products. It proves unique
consistent beliefs at every information set by likelihood factorization and an
explicit completely mixed limit. Full continuation incentives include future
disclosure probabilities before backward induction earns R08's original criterion.
Both directions and the attained minimum fine 0 or B survive the written audit.

New finite evidence: 3,324 exhaustive pure profiles, 139 arbitrary-mixed real
feasibility queries, 142 constructed assessments and 312 exact belief-limit checks.
An exact mixed tie example rejects “every equilibrium is silent,” while preserving
the claimed existence result. Historical R08 artifacts remain intact; no replay
of its missing executable is asserted. Final replay/implication audit is pending.

## R13b — September 19: strategic audit completed without changing the game

Following `9df1f77`, normal and optimized executions agree on every mathematical
receipt field. The [complete research note](research/game_cascade_audit_2026_09_19/manuscript/RESEARCH_NOTE.md)
states the assumptions, arbitrary-n proof, mixed tie counterexample to an
overstatement, detailed R09–R12 consequences, source comparison and assurance
limits. The original theorem survives; no historical formula or artifact is changed.

The new suite reconstructs payoffs and beliefs from states, paths and polynomial
trembles, rather than using the suffix formula to solve the game. Exact mixed
feasibility supplements exhaustive pure plans, while the written proof establishes
the arbitrary-n result. Added CI replay for the new suite. No Lean or external
proof-kernel claim is made, and the missing historical R08 executable remains a
distinct historical gap rather than being silently replaced.

**Question retained.** The next bounded confidence step is formalizing the unique
consistent-belief lemma and continuation bridge. No growing-dimension complexity
work was begun in this gate.

## R14a — September 20: primitive-game belief bridge in Lean

The [R14 formalization](research/lean_belief_bridge_2026_09_19/README.md) derives
Bayes beliefs from independent Nature draws, full history-dependent behavior and
transcript likelihoods. For arbitrary finite sender counts it proves normalization,
positive denominators, silent-bit bounds, and existence and uniqueness of all
consistent public/private beliefs, including zero-reach histories. One global
perturbation sequence works for every information set; receiver behavior admits
a perturbation with the same index.

Fresh compilation plus an audit of all 64 local declarations found only the
standard dependencies `propext`, `Classical.choice`, and `Quot.sound`. This closes
the belief portion, not the whole goal: receiver expected-payoff derivation and
primitive state/path continuation gains are next. Full assessment rationality,
backward construction, target existence and the 0-or-B theorem remain unformalized.

## R14b — September 20: Lean belief and continuation bridge completed

Following `a11ae37`, the [complete note](research/lean_belief_bridge_2026_09_19/manuscript/RESEARCH_NOTE.md)
and six Lean modules now derive receiver best replies from finite primitive
expected payoffs and sender gains from the full state/path expectation. Below B,
the report-minus-silence gain after all reports is η_j∏_{i>j}(p_i q_i)−k_j; after
any past silence it is −k_j. Future behavior is arbitrary and may be mixed.
The receiver's complete-history tie at B and strict choices on either side are
proved. A recursive behavioral-tree identity additionally proves that the actual
continuation weights are nonnegative and sum to one.

The fresh build audits **119 named declarations** with only standard Lean axioms.
The retained receipt binds every source and the verifier. Exact finite fidelity
checks independently compare R14's definitions with R13's recursive evaluator:
844 posteriors, 4, 944 normalized kernels, 9,888 path expectations, 408 sender gains,
and 204 cascade comparisons across 28 designed profiles at n=1..4. Normal and
optimized Python agree. These computations supplement, rather than prove, the
arbitrary-n formal statements. Added CI replay of the full audit and fidelity suite.

**Boundary retained:** full assessment/sequential-equilibrium existence, backward
no-mixed-rescue and largest-blocker construction, silent-target equivalence and
the attained 0-or-B minimum remain written R13 proofs. The bridge alone does not
upgrade all of R08–R12 to Lean. No external kernel replay or publication novelty
is claimed. The main research question is unchanged; no growing-dimension work
was begun. The next formal attack is the assessment and backward construction.


## R15 — September 20: enforcement-sufficient compression and proof-carrying codec

**Question:** what is the smallest reusable representation of an uncertain
information component that preserves the enforcement decisions we need, including
after composition?

**Outcome:** the exact independent-composition interface is the downward hull /
complete positive weighted-log support profile. A directed discrepancy between
interfaces equals the worst change in a permitted contextual incentive-margin
query, and one additional sender can attain it. Directed errors add exactly across
independent compressed blocks; exact attachments add no error.

For fixed affine dimension d>=2 and probabilities bounded away from zero, the
phase derives reusable-storage bounds
`O(gamma^{-(d-1)/2} log(1/gamma))` and
`Omega(gamma^{-(d-1)/2})` for all gamma-separated enforcement queries. A
working planar encoder produces a convex-hull summary and rational sandwich
certificate; the decoder returns zero fine, full fine or `refine` near ties.
A finite shared-label rule preserves matched dependencies, while an exact
counterexample shows that erasing the label can invent a cascade.

**Evidence:** written proofs plus 19,264 exact rational checks, 250 valid compact
bundle comparisons and 250 corruption-rejection controls. Normal and optimized
Python receipts agreed, and the full originating package replayed cleanly before
the repository record was created. The executable package itself is not yet stored
in this phase directory, so these R15 computations are currently recorded evidence,
not repository-CI replay. No new Lean or Palomar proof was run.

**Limits:** convex/Pareto approximation machinery is borrowed; historical novelty
of the enforcement specialization remains open. The general-dimensional codec is
not implemented here, a logarithmic storage gap remains, optimized-value-only
minimality is unproved, and arbitrary later evidence can require source recovery.

**Recover:** [phase README](research/enforcement_codec_2026_09_20/README.md),
[research note](research/enforcement_codec_2026_09_20/manuscript/RESEARCH_NOTE.md),
[complete results](research/enforcement_codec_2026_09_20/math/RESULTS.md),
[verification status](research/enforcement_codec_2026_09_20/VERIFICATION.json),
and [source notes](research/enforcement_codec_2026_09_20/sources/NOTES.md).

**Next attack:** close or explain the constructive logarithmic storage gap and
jointly control reusable representation size, certificate size and query cost for
proof-carrying shared interfaces. Formalize the sandwich/contextual-margin bridge
after the R08/R14 target-existence theorem is completed in Lean.


## R16a — September 21: independent foundation audit

Read R13–R15 and rederived the five R15 foundations; all survive within their
stated scope. Added an explicit rational-query separation lemma, strict-margin
boundary examples, and warnings about nonconvex aggregation and source-relative
verification. New Fraction-based probes pass 32,847 checks, with byte-identical
normal/optimized receipts. This is written proof plus exact finite evidence, not
Lean or a replay of the missing R15 executable.

Recover: [foundation audit](research/optimal_bits_2026_09_21/math/FOUNDATION_AUDIT.md).
Next: declare composition budgets and separate representation, certificate,
verification/query and refinement costs before closing the planar bit rate.


## R16b — September 21: log-free bits and the reuse boundary

[The completed gates](research/optimal_bits_2026_09_21/README.md) establish
Theta(gamma^-1/2) planar reusable bits with an explicit rational multiscale
codec. Source-readable sandwich verification uses no additional witness bits
and polynomial work in source size and 1/gamma; source retention and expanded
query memory remain separate costs. Bronshtein already supplies the generic
geometric entropy rate. A uniform finite construction extends the bit theorem
to fixed affine d>=2, with Theta(log(1/gamma)) at dimensions zero/one.

Up to k repeated uses require Theta(sqrt(k/gamma)) planar bits per reusable
code. Unlimited repetition at fixed final margin forces exact interface
distinguishability and unbounded worst-case bits. Finite shared labels retain
a direct-sum rate when label selection is permitted; tree conditional products
admit a max-sum error budget without convexifying the wired union.

**Evidence:** 1,637 exact codec controls including 63 continuum sandwich checks;
4,608 exact contextual queries and 3 tie controls; 168 tree comparisons against
2,500 compatible assignments. Normal/optimized receipts match. Added CI replay.
These supplement written proofs, not Lean or independent human review.
**Remaining:** optimal verification/query/update tradeoffs, optimized-only
minimality, practical higher-d codecs and the full strategic formalization.
The storage question is resolved under the explicit finite-budget contract;
continuous fine frontiers were not begun.


## September 21, 2026 — canonical mathematical repository handoff

Inherited the complete cooperation-enforcement main history through `7dfd6ae183ce8a1e68648993661be2e39b31f16a`
and its research snapshot into decision-interfaces. Future mathematical development,
proofs, verification and provenance belong here; the Ukraine-focused CEES application
remains in cooperation-enforcement and cites foundation results by full commit.
Research artifacts and their evidence statuses are unchanged. This is an
organizational handoff, not a new mathematical phase or proof. See
[handoff provenance](FOUNDATION_HANDOFF.md) and [programme](../../RESEARCH_PROGRAMME.md).


## R18 — September 21: composed end-to-end query reference

Integrated R16 binary decoding and source-relative sandwich verification with a
new arbitrary-dimensional rational V-polytope product/all-order reference. Supports
multiple compressed blocks, explicitly independent repeated occurrences with use
limits, finite compatibility masks and tree-mask expansion. Preserves nonconvex
unions and one common order; source hashes and per-scenario reuse errors accompany
results. ZERO has a safe order; FULL has rational lower witnesses for every order;
REFINE requires completed unresolved brackets; UNKNOWN records incomplete work.

[Phase proof and evidence](research/composed_queries_2026_09_21/README.md) explain
the exact barycentric polynomial reduction and solver trust. The new suite compares
R10/R12 optimized selection, independent cvc5 full orders, R13 mixed and backward
primitive games, source-bound codecs, interior/narrow/tie/degenerate fixtures,
mask convexification failures and budget controls. Retained receipt gives counts
and hashes; normal/optimized receipts agree. No new polynomial-time algorithm,
Lean proof or historical-originality claim. Gate B proceeds separately; the
main programme is unchanged. Next: finish the strategic/interface Lean bridges
and test nonbinary scalar enforcement rather than optimize codec constants.


## R20 — September 21: nonbinary scalar enforcement frontier

The [declared committed report sanction](research/nonbinary_enforcement_2026_09_21/README.md)
has attained frontier max_p max(0,min_j(η_j suffix_j−k_j)), optimized over one
common order. Two senders with fixed payoffs give a continuum of minima. Attempts
to break D(P) fail throughout this class by monotonicity; contextual fixed-order
coarseness follows from the old one-sender separation. The sharp operational bound
is eP ≤ exp(δ)eQ+(exp(δ)−1)max k, including a rational optimized-order equality
example. Independent and repeated factors, exact attachments and compatible labels
inherit the error accounting. No optimized-only coarseness claim is made.

**Evidence:** complete written cost-substitution/backward proofs; 94 primitive
mixed queries, 94 backward assessments, 912 payoff identities, 98 exhaustive pure
profiles, 64 exact continuum queries; normal/optimized receipts match. No new Lean
or candidate-original label. Next: change only sanction observability and test
whether the interface still preserves the minimum.

## R21 — September 21: inspection transfer requires lower detection bounds

The [one-dimensional verification component](research/inspection_transfer_2026_09_21/README.md)
has minimum credible committed fine g/min U. Families U={1/2} and V=[1/4,1/2]
have equal old downward/log-support interfaces but minima 1 and 2 when g=1/2.
All query primitives stay fixed; the component parameter now controls an independent
post-action detection lottery. This is an explicitly different mathematical class,
not a contradiction of R15/R20. The lower endpoint is coarsest for inspection;
retaining both endpoint extrema preserves the combined one-dimensional query class.
Serial independent verification multiplies detection floors and adds log-error;
finite shared masks must survive. 249 exact checks include 75 primitive mixed
threshold decisions,75 assessments and 75 lottery payoff identities. Normal/-O
receipts agree. Written proof, no new Lean or originality claim. The next bounded
transfer problem is shared dependence between reward and detection parameters;
no other model classes were added.


### R18 follow-up — provenance collision and repeated-parameter attack

An adversarial review found that concatenating component and label names with a
colon could overwrite a provenance binding, although strategic answers remained
correct. Nested component/label maps now preserve both source identities. A new
fixture distinguishes independent reuse (FULL) from the same-parameter diagonal
(ZERO) at all ratios 17/256 on the two-coordinate tradeoff segment. The updated
suite passes 454 checks with 213 rational witness replays; normal/-O outputs agree.
The original 424-check receipt is preserved as receipt_b030010.json. This corrects
an implementation provenance bug without rewriting the earlier evidence.


## R19A — September 21: full assessment-to-blocker Lean bridge

[R19A](research/strategic_equilibrium_2026_09_21/README.md) proves the actual
sequential-equilibrium target-existence theorem from R14's primitive game for
arbitrary finite positive sender count. An unrestricted assessment carries public
and private belief fields; consistency is an actual common fully mixed sequence.
The normalization theorem derives its canonical beliefs. Sequential rationality
compares primitive expected utilities, not an assumed cascade condition. Reverse
induction excludes every mixed rescue; the latest-blocker construction verifies
all histories. A named permutation corollary and raw-assessment IsLeast theorem
establish the attained 0-or-B minimum with favorable ties.

**Formal evidence:** fresh Lean 4.33.1/pinned Mathlib build of seven modules,
163 axiom-audited declarations (119 inherited, 44 new), only propext,
Classical.choice and Quot.sound. Source/verifier hashes match the receipt.
No original R14 source or receipt was changed. This resolves Gate B1's prior
formal gap; empirical validity, external kernel replay and human model review
remain separate. Next: complete Gate B2's operational interface bridge.


## R19B — September 21: checked interface-to-strategy chain

[R19B](research/interface_bridge_2026_09_21/README.md) completes Gate B2:
vertex domination lifts to the actual log support; Sion derives the actual max-min
margin formula; a sorted suffix construction with one extra sender attains the
discrepancy; rational cost perturbations preserve every strictly separated query.
Actual independent-product supports factor, directed errors add, and finite-code
collisions under unlimited reuse amplify into opposite rational-query decisions.
Finite labels and common orders retain their quantifiers. Masked tree messages
compute maxima over full compatible assignments, distinguishing infeasibility
from a feasible zero budget. The concrete recursive tree is binary; an arbitrary
finite-child node induction contract is also checked.

The additional joined proof connects these margins directly to R19A raw strategic
assessments, including one common order across all models. Fresh audits cover
126 interface declarations and 237 joined declarations (overlapping counts),
using only standard axioms; all source/verifier hashes match retained receipts.
No entropy theorem or executable adapter is claimed formalized. Seven explicit
LEAN judgments, proof-route corrections, borrowed ingredients and replay limits
are recorded in the phase README.

[The first-paper package](FIRST_PAPER_PACKAGE.md) now maps all nine obligations
to evidence and remaining gaps. Gates A/B/C and one subsequent inspection test
have been executed. Next bounded paper task: integrate the manuscript and conduct
independent statement/source review; next implementation assurance: certify the
adapter. Further mathematical transfer remains a separate follow-on.
