# Verification ledger

**Last structural audit:** September 21, 2026.

This file records what kind of evidence exists for each mathematical phase. It is
deliberately conservative. A written proof, an exact finite computation, a
numerical optimizer, and a proof-assistant check establish different things.

## Vocabulary

- **Written proof** — an informal mathematical proof is recorded in the phase.
  It may still contain a human error.
- **Exact check** — finite examples, exhaustive searches, rational arithmetic or
  certificate verification were recomputed without floating-point tolerance.
  This can falsify and independently check formulas on the declared cases; it is
  not a proof of an arbitrary continuum statement unless the certificate itself
  covers that continuum.
- **Numerical check** — floating-point optimization or sampling supports the
  calculation. Residuals and failures must remain visible. This is not proof.
- **Lean checked** — the named formal statements compiled in Lean without
  `sorry`/custom axioms beyond the explicitly recorded standard dependencies.
  This verifies the formal statement, not that it faithfully models the intended
  strategic situation.
- **Independent kernel / external replay** — the same formal statement has been
  replayed by a separate checker or external registry. **None of the current
  thesis results has this status yet.**
- **Open / unrun** — proposed work or a claim not yet covered by one of the above.

Never write simply "verified" in this repository. State **what was verified and
by which method**.

## Phase matrix

| Phase | Main mathematical content | Computation | Formal proof status | Main remaining verification gap |
|---|---|---|---|---|
| R01 foundations | relational compatibility, gluing, replacement and stochastic/causal extensions | exhaustive finite relation/kernel checks; signature enumeration | **Lean checked:** selected relational core in `foundations/lean/Compatibility.lean` | finite DAG normalization, stochastic marginal/intervention theorem and full query-signature results are not formalized |
| R02 clarification | provenance-sensitive revision and mechanism-version examples | exact small probes; retained 32/0/20 counts | none | the larger 96-record experiment was specified but never run; general revision theory is not proved |
| R03 information incentives | shared information budgets, six-branch benchmark, disclosure benchmark, tree/KL identities | exact arithmetic plus NumPy/SciPy optimization and independent original-cell checks | **Lean checked:** four narrow algebraic/disclosure lemmas | game-to-formula derivation, KL duality, tree gluing, PBE correspondence and full Theorems A–G are not formalized |
| R04 partial certificates | three-state robust frontier, cost profiles, upper-image composition, disclosure obstruction | exact finite queries plus numerical original-cell checks | **Lean checked:** six profile/disclosure/determinant lemmas | entropy/conjugacy, complete game equilibrium and network elimination remain written proofs |
| R05 disclosure boundaries | information-only discontinuity criterion and full boundary classification | exact rational witnesses plus numerical source-law optimization | **Lean checked:** fixed-information disclosure game and threshold bridge | global continuity classification, KL family optimization and overlapping-certificate theorem are not formalized |
| R07 optimized gate recovery | optimized discontinuity counterexample and compact recovery boundary | **2,025 exact rational checks** with separate producer/receiver roles | none | counterexample, full-information smoothing theorem and recovery statements remain written proofs; the general recovery principle is borrowed optimization theory |
| R08 sequential disclosure | exact disclosure-cascade/order criterion and shared-family vs separate-range enforcement gap | historical **4,802 exact rational checks** are documented, but the originating executable was not retained; R13 adds a separate independent primitive-game suite | R14 formally checks beliefs/receiver/continuation bridge; full existence theorem not formalized | R13 supplies the complete written strategic audit; backward equilibrium construction and original historical executable remain missing |
| R09 robust order polytope | minimax certificate, projection boundary, ordering/adaptation results, fixed-order segment verification | **15,653 exact rational checks**; replayable Python suite | none | minimax specialization, projection impossibility and no-adaptation theorem remain written proofs |
| R10 two-prefix selection | move-to-front lemma, Helly dimension bound, polynomial segment selector and sharpness through d=3 | exact certificate selector/checker, exhaustive small-order comparisons and retained receipts | none | the central R08→R10 theorem chain is not yet proof-assistant checked; current Python selector/checker share arithmetic code and are not an independent trusted kernel |
| R11 general sharpness | **Written proof:** arbitrary-d sharpness with dimension-dependent thresholds; fixed-q and fixed-threshold obstructions for the uniform-AM–GM ansatz | 20 numerical optimizations followed by exact rational witnesses and certified supremum brackets; 23,115 exhaustive-prefix checks plus 75 higher-dimensional controls; exact certificate replay | none | arbitrary-d theorem and strategic fidelity remain unformalized; fixed τ=2/3 sharpness outside this ansatz and historical novelty remain open |
| R12 fixed-dimensional selection | **Written proof:** polynomial-bit decision/order output at fixed affine dimension; two scoped sharpness refinements | 14 saved bundles replayed; 132 direct full-order comparisons with independent cvc5 encoding, 42 prior-Sturm comparisons, three rational AM-GM success certificates; exact side-refinement checks | none; general emptiness uses solver-trusted replay, not an external CPC kernel | R08 full target-existence theorem remains unformalized (R14 closes its primitive bridge); growing dimension unresolved; no complete solver-free polygon certificate format claimed |
| R13 independent strategic audit | **Complete written primitive derivation:** unique consistent beliefs, full mixed continuation conditions, both directions of R08 and attained fine 0 or B | 3,324 exhaustive pure profiles; 139 mixed real-arithmetic decisions; 142 constructed assessments; 312 polynomial-tremble belief checks; normal/optimized receipts agree | none; exact mixed solver retains backend trust | R14 formalizes its belief/receiver/continuation bridge; arbitrary-n equilibrium-existence construction remains informal; fixed-order suite is not an exhaustive check of adaptive policies |

| R14 Lean belief and continuation bridge | Unique consistent beliefs, receiver best replies, full mixed sender gains and normalized behavioral continuation kernel for arbitrary finite n | fresh pinned compilation of six modules; all 119 named declarations axiom-audited; 844 posterior, 4,944 kernel, 9,888 path, 408 sender-gain and 204 cascade comparisons; normal/optimized receipts agree | **Lean checked:** actual Nature/action likelihoods and Bayesian conditioning, global off-path limit existence/uniqueness, primitive expected payoffs and derived mixed continuation gain; only standard axioms | full assessment/sequential-equilibrium existence, backward construction, silent-target characterization and attained 0-or-B minimum remain unformalized; no external kernel or independent human model review |
| R15 enforcement compression and codec | exact contextual interface discrepancy, independent-composition error law, gamma-separated storage bounds, planar proof-carrying codec, finite shared-label rule | originating run: **19,264 exact rational checks**, **250 valid compact bundles**, **250 corruption rejections**, clean pre-transfer replay; executable package not yet committed for CI replay | none for R15; written proofs only | operational metric, storage bounds and shared-interface theorem remain unformalized; general-dimensional encoder, logarithmic gap, optimized-value-only minimality and historical novelty remain open |

R06 was a preservation/trajectory phase and introduced no new mathematical claim.

## Continuous integration

`.github/workflows/research-verification.yml` reruns every retained executable
research suite that is suitable for CI and rechecks the existing Lean sources.
A green workflow means those specific programs/formal files passed at that commit.
It does **not** upgrade written theorems outside their coverage.

R08's original 4,802-check receipt remains non-replayable: no executable was
retained when the phase was transferred. R13 now supplies a SEPARATE independent
primitive-game suite and detailed derivation. Its counts/evidence must not be
presented as replay of the original historical checks.

## Why Lean, not "more languages"

Changing Python to Julia or Rust does not make mathematics true. Use another
implementation when it reduces a specific correlated-error risk.

Current priorities:

1. **Lean:** formalize the thesis-bearing R08→R10 chain.
2. **Independent exact checker:** a small Rust verifier for R10 certificates would
   be useful because the current Python verifier shares polynomial arithmetic with
   the producer.
3. **Julia:** use only if future convex/numerical work benefits materially from its
   optimization ecosystem; it would remain numerical evidence.
4. **Palomar:** consider only after a stable research theorem has a complete,
   fidelity-reviewed Lean statement and proof. Palomar is an external registry and
   replay layer for Lean-verified mathematics, not a substitute for building the
   formal proof in this repository.

See [FORMALIZATION_BACKLOG.md](FORMALIZATION_BACKLOG.md) for the order of work.


## R16a — September 21 independent R15 foundation audit

**Written proof:** rederived operational discrepancy, single-sender attainment,
directed product addition, arbitrary-encoder packing and rational sandwich;
added rational-query continuity and strict-boundary qualifications.
**Exact computation:** 32,847 Fraction checks; normal and optimized Python
receipts agree. [Evidence](research/optimal_bits_2026_09_21/experiments/foundation_receipt.json).
**Limits:** no R16 Lean, external kernel or independent human audit; historical
R15 executable remains unavailable here. See the linked foundation audit for
which identities the finite checks cover.


## R16b — September 21 optimal-bit and composition gates

**Written proofs:** matching planar rate via rational multiscale rank coding;
source-relative zero-additional-witness audit model; finite-repeat rate and
unlimited-repeat impossibility; fixed-d entropy construction; finite label
selection lower bound and tree error-budget transport. Geometric entropy is
borrowed from Bronshtein; the enforcement foundations are inherited R15.
**Exact computation:** 1,637 codec controls (63 sandwich fixtures), 4,608
contextual queries plus 3 tie controls, 168 tree instances / 2,500 compatible
assignments; all normal/optimized receipts agree.
[Bound source/receipt manifest](research/optimal_bits_2026_09_21/VERIFICATION.json).
**Scope:** no R16 Lean or external kernel, no independent human proof audit;
no implemented high-dimensional codebook, general order optimizer or optimal
query-time theorem. Repository workflow added; local checks are the evidence
recorded here. See [gate reports](research/optimal_bits_2026_09_21/README.md).

## R17 — September 21 all-order reference and interface contract

[Phase record and D53–D55](research/order_contracts_2026_09_21/README.md).
**Implemented:** exact full-permutation reference for one planar convex block and
any finite number of exact known-probability senders; source-backed lower/outer
sandwich checks; ZERO/FULL/REFINE and a distinct UNKNOWN work-budget result.
**Executed:** 2,822 checks, including 150 independent raw-polynomial SymPy
comparisons across every order of selected n=3,4,5 instances. Tests through n=6
for singleton sources. Normal and optimized Python outputs agree; saved source
hashes match the committed files. The new order-contract CI passed at `56b97ab`.
**Not established:** new historical novelty, Lean proof, fast selection, binary
codec integration, arbitrary uncertain attachments or tree strategic optimization.
The comparator shares the inherited cascade theorem, not its threshold-reduction
code. No independent extensive-form game rederivation was executed in R17.

The next assurance priority is still full R08/R14 target existence and the R15
interface-to-margin bridge. Mathematical exploration and general query integration
may proceed in parallel; see [ACTIVE_GOALS.md](ACTIVE_GOALS.md).


## R18 composed query reference — September 21, 2026

**Written guarantee:** source-relative downward domination is preserved through
independent occurrences and unions with the same finite mask; monotone strict
suffix products therefore justify the four-result all-order contract.
**Exact computation:** [retained receipt](research/composed_queries_2026_09_21/experiments/receipt.json)
binds codec/query/test sources and records R10/R12 comparisons, independent cvc5
full-order checks, primitive mixed/backward game comparisons, rational witnesses,
and adversarial scope/budget controls. Normal and optimized runs agree.
**Formal status:** no new Lean result for this implementation. Strategic meaning
inherits R13's written theorem and R14's scoped formal bridge. General emptiness
trusts Z3; finite comparisons with cvc5 are not independent proof-kernel replay.
**Limits:** factorial order enumeration, enumerated finite/tree labels, compressed
planar blocks only, arbitrary exact V attachments, no diagonal compressed reuse.
[Full contract, proof and literature](research/composed_queries_2026_09_21/README.md).


## R20/R21 nonbinary and inspection transfers — September 21, 2026

**R20 written proof:** actual report-sanction cost substitution; attained family
and common-order frontier; D sufficiency/contextual fixed-order coarseness; sharp
error and composition law. [Receipt](research/nonbinary_enforcement_2026_09_21/experiments/receipt.json):
94 mixed queries,94 primitive assessments,912 payoff identities,98 pure profiles,
64 polytope queries. **R21 written proof:** probabilistic-detection minimum,
equal-interface collision, lower-endpoint quotient and serial composition.
[Receipt](research/inspection_transfer_2026_09_21/experiments/receipt.json):249 checks,
including75 mixed queries and75 primitive assessments. Both normal/-O receipts
match. Primitive game and Z3 dependencies are explicit; no new Lean statements,
independent human review, or historical novelty established by these phases.


### R18 corrected provenance edition

The post-b030010 receipt has454 checks, including213 rational witness replays,
structured-name source-binding controls and a decisive independent-vs-diagonal
reuse fixture. The previous424-check receipt remains under its commit-labelled
filename. Normal/-O receipts match. The provenance-key fix does not change the
mathematical query reduction or backend trust; it repairs source identity loss.
