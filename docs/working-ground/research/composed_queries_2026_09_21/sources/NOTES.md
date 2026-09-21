# Gate A/B theorem-level source audit

Inspected September 21, 2026. This is an additive audit of the R15/R16 source
notes, not a systematic priority certification. The primary papers and author
records below were opened online; where only an abstract or record was inspected,
that limitation is explicit. Search functions included decision-preserving
compression, approximate sufficiency, downstream distortion, Blackwell/Le Cam
comparison, abstract-domain completeness, quantitative assume-guarantee reasoning,
Pareto approximation, information complexity, repeated-use amplification, and
robust incentive representations. No new empirical claim is made.

## 1. Exact rational products and all-order feasibility

**Closest existing project results.** R10's `math/THEOREM.md`, Theorem 2 and
Corollary 3, already reduce robust order selection on a convex family of affine
dimension d to prefixes of length at most d+1, and to ordered pairs on a segment.
R12's `math/THEOREM.md`, Theorem 1, already gives polynomial bit complexity for
every fixed affine dimension with explicit rational V/H input. Its Lemma 2
explains why strict feasible witnesses can be rational even when the best
log-support point is interior. R17 already exhausts every order for its planar
block/known-sender contract. Gate A must cite these as inherited results.

**External decision procedure.** Basu, *Algorithms in Real Algebraic Geometry:
A Survey*, [author preprint](https://arxiv.org/pdf/1409.1534), §2.5.2, Theorem
2.27 (printed pp.16–17), provides block quantifier elimination, including integer
coefficient bit-size control. Theorem 2.16 supplies sign-condition sample points.
For a fixed number of variables, these bounds give polynomial dependence on the
remaining polynomial-description parameters. This directly supplies the algebraic
ingredient of R12 after its intrinsic-coordinate reduction. It does not make a
growing barycentric encoding polynomial time.

Jovanović and de Moura, *Solving Non-linear Arithmetic*, IJCAR 2012,
[author institution record](https://www.microsoft.com/en-us/research/publication/solving-non-linear-arithmetic/),
describes the established CDCL/CAD-based satisfiability algorithm. The inspected
record, rather than a new independent reconstruction of its full proof, supports
crediting NLSAT as borrowed machinery. Backend answers remain trusted exact
computation unless replayed in a separate checked proof system.

**Matching-assumption implication.** For each allowed branch, use a separate
simplex variable vector per independently selected V-polytope occurrence. Every
probability coordinate is affine in those variables. The strict cascade predicate
is a conjunction of rational polynomial inequalities. Finite branch disjunction
and finite order enumeration stay within this decision problem. Thus exact
decidability is a direct specialization of established real-algebraic mathematics,
conditional on the inherited strategic equivalence. Logs need not enter the
solver, and rational cost ratios can be coefficients; variable division is
unnecessary. This implication establishes neither efficiency at growing dimension
nor a checked proof of the external solver implementation.

**Scope controls.** Reusing one payload as independent occurrences requires fresh
parameter variables. Sharing the same uncertain parameter is a different diagonal
constraint. A finite mask is a disjunction, not permission to convexify its union.
The quantifier is `exists order, for every allowed model`; independently choosing
an order within each branch solves a different problem. An unfinished solver/order
search is UNKNOWN; completed inconclusive brackets are REFINE.

**Assessment:** implementation/assurance completion, not a new real-algebraic
algorithm or new arbitrary-dimensional polynomial-time theorem.

```yaml
LEAN: NO — The general solver reduction is standard borrowed mathematics and this gate's backend integration is implementation-specific.
```

## 2. Operational discrepancy versus statistical deficiency

Van Rooyen and Williamson, *Le Cam meets LeCun: Deficiency and Generic Feature
Learning*, [arXiv:1402.4884](https://arxiv.org/pdf/1402.4884), §4.1, Theorem 1
(PDF p.8), states that weighted symmetric deficiency equals the supremum of
absolute Bayes-value differences normalized by the loss sup norm. The preceding
randomization theorem gives the directed version; Theorem 2 bounds downstream
feature deficiency by reconstruction deficiency. Definitions and theorem/proof
sections were inspected. This is a close precedent for defining representation
quality operationally through all downstream decisions.

**Implication test for R15 Theorem A.** Their objects are Markov kernels with a
common parameter space, priors, loss functions and randomized decision rules.
Ours are analyst uncertainty families of Bernoulli parameters, with a robust
max-min log margin and a restricted strategic query family. No identification of
R15's H-profile discrepancy with their deficiency has been proved. In particular,
their theorem does not itself supply the one-added-sender construction realizing
every positive support direction. The upper bound uses familiar minimax and
support duality; the specific realization step remains the substantive bridge.
An embedding proving equivalence would weaken the originality claim and is an
open priority task, not something ruled out by terminology.

Blackwell's original [1953 publication record](https://doi.org/10.1214/aoms/1177729032)
is a historical pointer; its full original text was not newly inspected. The
Blackwell–Sherman–Stein statement was read in the above author preprint. Do not
equate a compressed uncertainty set with a less informative signal to the players.

```yaml
LEAN: YES — The support-discrepancy-to-strategic-margin realization remains a stable reusable bridge regardless of its eventual priority classification.
```

## 3. Downstream distortion and information complexity

Kipnis, Rini and Goldsmith, *The Rate-Distortion Risk in Estimation from
Compressed Data*, [arXiv:1602.02201v9](https://arxiv.org/pdf/1602.02201), Theorem
IV.1, characterizes asymptotic expected estimation loss in the discrete memoryless
setting under its A-RD, A-C1 and A-C2 assumptions. It includes a converse for
uniformly Lipschitz estimators; Theorem V.1 handles a Gaussian setting. These
statements and their assumption warnings were inspected. **Implication:** they
do not directly give a worst-case deterministic finite-payload guarantee over
all rational model families and all margin-separated queries. Such a guarantee
would require a reduction replacing the source distribution, asymptotic coding
criterion and expected loss by the present uniform contract.

Tishby, Pereira and Bialek, *The Information Bottleneck Method*,
[author preprint abstract](https://arxiv.org/abs/physics/0004057), derives a
compression/relevance tradeoff from a joint distribution of source and relevance
variables. Only the abstract was inspected anew. It establishes strong prior art
for purpose-dependent compression, not the present adversarial margin, source
binding or bit-length result.

Braverman and Rao, *Information Equals Amortized Communication*,
[author manuscript](https://www.cs.utoronto.ca/~mbraverm/Papers/amortizedcommunication.pdf),
abstract/main claim, identifies internal information cost with amortized
communication for independent copies under a fixed input distribution and
per-copy error criterion. Only the opening statement was inspected. Its
interactive, distributional communication model does not directly imply the
R16 self-contained deterministic payload bound. It is a relevant comparison,
not a replacement of metric entropy by Shannon mutual information.

```yaml
LEAN: NO — These are literature comparisons of borrowed results, not new statements in the reusable theorem chain.
```

## 4. Completeness and finite nonconvex interfaces

Cousot and Cousot, *Systematic Design of Program Analysis Frameworks* (1979),
[author record](https://www.di.ens.fr/~cousot/COUSOTpapers/POPL79.shtml), and the
[author exposition, §§3.3 and 3.15–3.16](https://www.di.ens.fr/~cousot/AI/), explain
disjunctive completion and refinement sufficient to preserve specified semantics.
The records/exposition were inspected, not a new complete reading of the 1979
proof. This is direct prior art for preserving alternatives instead of merging
them into an inexact abstract state.

Giacobazzi and Ranzato, *Completeness in Abstract Interpretation: A Domain
Perspective*, [author paper](https://www.math.unipd.it/~ranzato/papers/amast97.pdf),
states existence of greatest complete restrictions and least complete extensions
for continuous semantic functions. The abstract and opening formulation were
retrieved; subsequent text extraction failed, so no numbered full-proof audit is
claimed. Its hypotheses require a concrete/abstract ordered semantics and the
appropriate continuity. An instantiation for our operations must be supplied
before using that theorem as a proof of the specific H-profile quotient.

**Implication test.** Once each convex branch's margin guarantee is known,
retaining branch labels and taking the same finite maxima is ordinary disjunctive
semantics. The generic soundness idea is inherited. The R15 explicit example
shows exactly why max-aggregating support functions loses the information needed
by this strategic query; abstract interpretation predicts possible loss but
does not supply those particular rational models or strategic costs.

The common-order quantifier is also essential. `min_order max_branch` generally
differs from `max_branch min_order`. Completeness cannot be inferred from a
branchwise optimizer or from a tree algorithm transporting only error budgets.

```yaml
LEAN: YES — Finite-label and tree transport are stable assurance rules inherited by every composed query, although max/min monotonicity and disjunctive semantics are standard.
```

## 5. Quantitative composition and assume-guarantee reasoning

Fahrenberg and Legay, *General Quantitative Specification Theories with Modal
Transition Systems*, [author manuscript](https://ulifahrenberg.github.io/Research/2014/fahrenberg14-gqst.pdf),
Theorem 2 (printed p.17), bounds composition refinement distance by a function
P of component distances under its label-composition compatibility assumptions.
The theorem, its premise, and the additive specialization on p.18 were inspected.
**Implication:** this is close prior art for quantitative independent
implementability. Applying it here would require a faithful modal-system
encoding and proof that its refinement distance equals our discrepancy.
Even then its generic upper bound does not by itself prove R15's exact directed
addition or contextual attainment. Treat additive error accounting as an
established architectural principle; the exact strategic calibration needs its
own argument.

Kwiatkowska, Norman, Parker and Qu, *Assume-Guarantee Verification for
Probabilistic Systems*, [author/project paper](https://www.prismmodelchecker.org/papers/tacas10.pdf),
Theorem 3 (PDF p.11), gives an asynchronous probabilistic assume-guarantee rule
under disjoint component alphabets and explicit safety assumptions; its bound
uses p+q−pq. Statement and surrounding discussion were inspected. It establishes
prior quantitative compositional verification. Its probability-of-safety
guarantee and scheduler semantics differ from robust strategic log margins.
The numerical composition law therefore cannot be imported without changing
objects and proving an interpretation theorem.

```yaml
LEAN: YES — Directed product addition and its downstream margin consequence are exact stable interfaces whose assumptions must remain explicit in composition.
```

## 6. Pareto compression, entropy and repeated use

Diakonikolas and Yannakakis, *Succinct Approximate Convex Pareto Curves* (SODA
2008), [author abstract](https://www.cs.columbia.edu/~ilias/papers/convex-pareto.html),
characterizes polynomial construction through a monotone linear-combination
optimization routine and gives minimum-cardinality guarantees in two objectives.
Only the author abstract was inspected anew. This precedes compact convex Pareto
representation; cardinality is not arbitrary binary code length, and the abstract
does not establish the exact source-relative strategic contract. A full-paper
comparison remains outstanding.

For geometric bits, the R16 audit already identified Bronshtein's entropy order
and the explicit statement in Gardner–Kiderlen–Milanfar Proposition 5.4. Their
scope and reading limitations remain in
[R16's sources](../../optimal_bits_2026_09_21/sources/NOTES.md). No new geometric
rate or priority claim is earned by integrating the codec into Gate A.

Van Erven and Harremoës, *Rényi Divergence and Kullback-Leibler Divergence*,
[author preprint v2](https://arxiv.org/pdf/1206.2459), Theorem 28 (PDF pp.15–16),
states additivity over independent product distributions (including its stated
infinite-product conditions). The finite-product identity is a close standard
analogue of amplification. Their divergence compares probability measures;
R15's discrepancy compares support profiles of parameter families, so the
theorem is not a direct identification of the two quantities.

**Implication test for R16 reuse.** Once the project-specific directed product
identity and contextual distinguishability are available, k-fold scaling is an
induction. The unlimited-reuse collision argument then follows by pigeonhole:
two distinct rational singleton interfaces sharing one bounded payload become
separated by an arbitrarily large contextual margin after sufficient independent
reuse. No new tensorization principle is claimed. The model-specific content is
which differences are operationally detectable and which decoder/reuse contract
forces their preservation. Repeated samples from an unknown experiment and
repeated occurrences in a strategic product are distinct operations.

```yaml
LEAN: YES — Bounded reuse and collision impossibility are short but repeatedly inherited consequences of the exact product and distinguishability bridges.
```

## 7. Strategic equilibrium and robust incentive representations

Kreps and Wilson, *Sequential Equilibria* (1982),
[author institution record](https://www.gsb.stanford.edu/faculty-research/publications/sequential-equilibrium),
is the equilibrium-concept source, not a source for the model-specific blocker
formula. The record was rechecked; no new complete original-paper inspection is
claimed. R13/R14's source notes identify the separately inspected definitions of
consistency and sequential rationality in Bonanno. Gate B should preserve that
primitive assessment meaning rather than encode the desired cascade conclusion
into the equilibrium predicate.

Bergemann and Morris, *Bayes Correlated Equilibrium and the Comparison of
Information Structures in Games* (2016),
[author-hosted article](https://economics.mit.edu/sites/default/files/publications/paper_79_bce.pdf),
Theorem 2 (printed p.502), equates individual sufficiency with the incentive
ordering given by BCE outcome-set inclusion across basic games. The statement,
definition context and proof opening were inspected. **Implication:** this is
strong prior art for incentive-sufficient representations. Its varying player
information structures/BCE outcomes do not immediately give the all-silent
sequential-equilibrium blocker theorem with costly authenticated disclosure,
known actual parameters and analyst uncertainty. A normal-form reduction would
still need to recover sequential credibility, the target-selection quantifier,
and the explicit suffix-product condition. No such implication has been shown.

```yaml
LEAN: YES — Deriving target-equilibrium existence from the primitive assessment is the central stable strategic bridge and cannot be replaced by a definition of the blocker condition.
```

## 8. Candidate status and remaining priority work

Gate A's finite-product/mask/all-order implementation receives **no new candidate
original-theorem label** from this audit: the decision reduction and composition
guarantees are inherited or standard once R13/R15/R16 are accepted. Gate B checks
correctness of existing statements and does not itself establish originality.

The existing **CANDIDATE ORIGINAL THEOREM** label for R16's budget-sensitive
certified enforcement interface remains provisional. Its exact statement,
assumptions and proof are recorded in the linked R16 source note. The closest
newly examined comparators reinforce two restrictions on that label:

1. Operational comparison by all downstream losses and compositional quantitative
   refinement are established ideas; the possible contribution is their specific
   strategic realization, finite representation and assurance contract.
2. No matching-assumption reduction found here directly supplies the complete
   package, but failure to find one is not a priority result. The one-sender
   realization, exact quotient and uniform reuse contract deserve focused expert
   comparison with deficiency/complete-abstraction representations before a
   manuscript advertises novelty.

Next bounded audit: construct or refute a precise embedding of the positive
log-support family into a statistical decision experiment, preserving the same
query class and discrepancy; separately read the full convex-Pareto paper. If
either produces a direct implication, record the theorem as a credited
specialization while retaining the strategic proof, implementation and Lean
assurance work. Human proof review, exhaustive priority review and independent
external formal replay remain unperformed.
