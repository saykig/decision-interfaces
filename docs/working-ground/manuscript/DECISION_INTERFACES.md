# Decision Interfaces: Sufficient Representations for Strategic Decisions under Uncertainty and Composition

**Integrated manuscript, v0.1 — September 21, 2026 continuation.**

This draft assembles the first paper's existing mathematical argument. It is not a
publication-ready or independently reviewed manuscript. The core mathematical
source edition is `1525f20c86f4e14f7fd8baf404f085b3e95ff427`; its tested research
parent is `962ff4fef3d5405f00f9ec2e3abfbd773f108c9b`. Appendix A identifies the exact
proof dependencies. The newly completed joint-inspection transfer R22 is discussed
only as an explicitly different model, not incorporated into the core theorems.

## Abstract

What must a compressed model retain to preserve strategic decisions after it is
connected to other models? We answer this question for a sequential hard-evidence
game with independent private Bernoulli facts, costly authenticated disclosure,
and analyst-side uncertainty about the players' known parameters. First, the
primitive sequential-equilibrium problem reduces to a suffix-product blocker
condition and an attained receiver fine of zero or a fixed threshold. For
nonempty compact convex parameter families, the downward family, equivalently its
positive weighted-log support profile, is an exact interface for the declared
contextual fixed-order query class. A directed support discrepancy equals the
largest contextual incentive-margin change and adds exactly under independent
products. Rational domination sandwiches therefore give source-checkable decision
intervals, with explicit refinement and incomplete-computation outcomes. In a
fixed positive planar box, a rational multiscale codec attains the classical
geometric information exponent with matching worst-case strategic query bits:
Theta(gamma^(-1/2)). Bounded independent reuse changes the per-payload rate to
Theta(sqrt(k/gamma)); unlimited reuse admits no fixed finite worst-case bit budget
at a fixed final margin. Finite dependencies remain visible as compatibility
masks. We separate written proofs, exact computation, Lean checking and unresolved
statement-fidelity and priority review. The result is a scoped interoperability
contract, not a universal enforcement or welfare theory.

## 1. A representation is sufficient only relative to its operations

An uncertainty summary may be adequate for one question and inadequate for the
next. A coordinate range can preserve an extreme probability while discarding
which probabilities can occur together. A numerically accurate approximation can
be harmless in one use and misleading when repeated many times. These failures
suggest specifying a representation by its permitted questions, composition
operations and error guarantees rather than by its size alone.

The present paper takes one bounded proving ground: an institution chooses a
public order and a receiver fine intended to support an all-silent outcome in a
sequential disclosure game. The institution is uncertain about parameters that
are common knowledge among the players. We seek a reusable description of that
uncertainty, not a new information device supplied to the players. This distinction
separates our objects from statistical experiments and from games in which players
receive different signals.

The contribution under investigation is the connection between a specific
strategic query class, its exact representation, quantitative composition and a
finite coding/verification contract. Convex duality, minimax, geometric entropy,
finite disjunction and collision amplification are established ingredients. The
source comparisons in Section 9 delimit what is borrowed and what still requires
an expert priority assessment. Novelty is not inferred from a different vocabulary.

## 2. Primitive game, information and equilibrium

Fix n>=2, receiver payoffs A,B>0 and tau=A/(A+B). Nature independently draws each
sender's bit x_i with probability p_i in (0,tau). A public permutation pi gives
one opportunity for each sender to act. The sender observes its own bit and the
entire earlier public transcript. Type zero can only be silent, S. Type one can
remain silent or authenticate its positive bit by reporting, R, at cost k_i>0.
There is no later recall, coalition deviation, extra private signal or shared
randomization device.

After all opportunities the receiver sees the full transcript and chooses C or D.
Its C payoff is zero. Its D payoff is B-e when all bits are one and -A-e otherwise,
where e>=0 is a credible institutionally committed **receiver** fine. Sender i's
payoff is eta_i times the indicator of D, less k_i times its own report indicator,
with eta_i>0. This fine does not reduce the sender's reward directly.

An assessment specifies behavioral actions and beliefs at every information set.
Sequential equilibrium requires best replies at those sets and beliefs obtained
as limits of Bayes beliefs along fully mixed feasible profiles. The perturbing
profiles need not themselves be equilibria. Type-zero reporting is infeasible,
not an action to be assigned a positive tremble probability. The target is an
all-silent equilibrium path followed by C, not silence at every off-path history.
Favorable ties mean that a target-supporting best-reply selection may exist;
they do not mean that every equilibrium selects silence.

Players know actual p and the other primitives. The analyst knows a nonempty
compact convex family P contained in (0,tau)^n. One institutionally chosen order
and fine must work for every p in P. The equilibrium may depend on p. Thus the
quantifier is one order, every model, some target equilibrium for that model;
it is neither a model-specific order nor one common strategy profile across models.

### Theorem 1 — primitive target existence and attained minimum

For a fixed actual p and order pi, write

    T_j(p) = product over l>j of p_(pi_l), with T_n=1.

For every fine e<B, a target sequential equilibrium exists exactly when some
position j satisfies `k_(pi_j) >= eta_(pi_j)*T_j(p)`. The feasible receiver fines
form [0,infinity) when this blocker exists and [B,infinity) otherwise. The minimum
is attained in both cases.

**Proof.** At a fixed transcript, independence and each sender's private-bit
likelihood factorization imply a product posterior. A reported bit equals one;
an unvisited bit retains its prior; a silent visited bit whose positive type
reports with probability a has posterior `p*(1-a)/(1-p*a)`. Its denominator is
at least 1-p>0. These formulas extend continuously to all feasible behavioral
profiles, including off-path reporting histories. Fully mixed trembles construct
the consistent beliefs, and the same continuous formulas prove their uniqueness.

At an incomplete terminal transcript the posterior probability that all bits are
one is at most some silent sender's p_i<tau. Therefore C is strictly optimal for
the receiver. At the complete transcript D is strictly optimal below B. Once a
past silence occurs, reporting cannot change the receiver's terminal choice and
strictly wastes its positive cost.

Only all-report prefixes remain. Let a_l be the positive type's report probability
at such a prefix. Enumerating the continuation tree gives the current report-minus-
silence gain

    eta_(pi_j) * product over l>j of (p_(pi_l)*a_l) - k_(pi_j).

If every proposed blocker inequality fails strictly, reverse induction forces
a_n=1, then a_(n-1)=1, and ultimately a_1=1. This rules out the target even with
arbitrary mixed continuation strategies. Conversely, choose the latest weak
blocker b. Set a_j=1 after b and a_j=0 at and before b, with silence at every
history containing an earlier silence. The blocker is willing to be silent;
earlier reports cannot complete the chain; later senders have strict incentives
to report. The receiver choices and the already derived consistent beliefs make
this a sequential equilibrium at every history. Finally, at e=B the receiver can
choose C even after complete disclosure, so every sender strictly prefers silence.
The same construction works above B. This proves necessity, sufficiency and
attainment. The full primitive derivation and formal statement map are [P1, P2].

### Corollary 1 — the robust margin, with one common order

Put r_i=k_i/eta_i and

    L_j^pi(p) = sum over l>j of log p_(pi_l),
    m_pi(P,r) = max over p in P of min_j (L_j^pi(p)-log r_(pi_j)),
    M(P,r) = min over pi of m_pi(P,r).

Compactness makes the extrema attainable. Theorem 1 gives zero minimum fine for
the fixed order iff m_pi<=0, and zero minimum fine after common-order optimization
iff M<=0. Otherwise the attained minimum is B. A margin is a log incentive
comparison, not a monetary fine, welfare score or probability of cooperation.
In particular, exchanging max over models with min over orders changes the task.

## 3. The exact contextual interface

For nonnegative vectors define

    D(P) = {x>=0 : x<=p coordinatewise for some p in P},
    H_P(w) = max over p in P of sum_i w_i*log p_i.

An allowed independent attachment R replaces P by P x R and retains the same game
form, with all combined orders and positive cost ratios permitted. This product
means independent selection of uncertain parameter vectors as well as the game's
conditional independence of private facts. It does not authorize erasing a
shared constraint that was present in the source.

### Theorem 2 — exact interface and its query boundary

For nonempty compact convex families, equality of D is equivalent to equality of
H on all nonnegative directions. It is also equivalent to agreement on the whole
declared contextual fixed-order zero-fine query class. A single additional known-
probability sender is sufficient for contextual separation. Positive rational
cost ratios suffice to distinguish unequal interfaces.

**Argument.** The downward log set `{z : z<=log p for some p in P}` is closed and
convex: coordinatewise log concavity and convexity of P show that the interpolated
parameter dominates interpolated logs. Its finite support directions are exactly
the nonnegative ones, and convex separation determines it from those supports.
Exponentiation, with closure on zero coordinates, identifies the same information
as D. The strategic realization in Theorem 3 shows that unequal supports yield a
permitted query with opposite strictly separated margin signs.

The contextual qualifier matters. With no added sender, the collection of all
orders only exposes weights having a zero minimum coordinate. An extra known
sender placed first permits all the remaining directions. Neither this theorem
nor the realization proof establishes minimality for only the single order-
optimized value. Full arguments and rational-query qualifications are [P3, P4].

### Theorem 3 — discrepancy is exactly an operational margin change

Define

    Delta+(P,Q) = max over w in [0,1]^n of (H_P(w)-H_Q(w)),
    Delta(P,Q) = max(Delta+(P,Q), Delta+(Q,P)).

Delta+ is nonnegative because w=0 is allowed. It equals the supremum, over the
permitted independent attachments, orders and positive cost queries, of the
margin difference m_pi(P x R,r)-m_pi(Q x R,r). One added known sender suffices.
Rational cost ratios give the same supremum.

**Upper bound.** Concave minimax, with lambda ranging over the probability
simplex, gives

    m_pi(P,r) = min_lambda [H_P(w^pi(lambda))-sum_j lambda_j*log r_(pi_j)],
    w_(pi_l)^pi(lambda) = sum over j<l of lambda_j.

Every such weight lies in [0,1]. Independent supports add, so attachment terms
cancel when comparing the two minimization objectives. Each objective difference
is at most Delta+, hence so is the difference of their minima. The optimized
margin obeys the same inequality, without an asserted optimized-only equality.

**Realization.** When Delta+>0, choose a maximizing weight and normalize its largest
coordinate to one by homogeneity. Place the added sender first and sort the
original senders by nondecreasing weights. Successive differences of these weights
supply a simplex vector with last entry zero. At a support-maximizing point p*,
choose every log cost ratio to equal the corresponding suffix log at p* minus z.
All margin coordinates then equal z at p*, while their lambda average is at most z
throughout P and at most z-Delta+ throughout Q. The upper bound forces the attained
margin difference to equal Delta+. Taking z=Delta+/2 separates decisions. Rational
cost perturbations preserve every slightly smaller strict separation by continuity.
The zero-discrepancy case uses an immediate blocker. See [P3, P4, P7] for the full
construction, the actual Sion bridge and its formal strategic interpretation.

## 4. Composition, approximation and honest answers

### Theorem 4 — directed independent-product addition

For independent block pairs,

    Delta+(P1 x P2,Q1 x Q2) = Delta+(P1,Q1)+Delta+(P2,Q2).

**Proof.** Weighted-log supports of products add. The weight box is itself a
product, so maximizing the difference separates into the sum of two maxima.
Exact attachments contribute zero error. The symmetric discrepancy is the maximum
of the two directed sums; it is bounded by the sum of symmetric discrepancies,
but symmetric errors need not add with equality. Repeated independent occurrences
charge their directed error once per occurrence. These are source-wise products,
not tied-parameter diagonals or reuse of the same realized random event. [P3, P7]

### Theorem 5 — rational source certificates and margin intervals

For positive rational polytopes P=conv(V), Q=conv(W), suppose rational convex-
combination witnesses establish that each w in W is dominated by a point of P,
and each v in V is dominated by (1+epsilon) times a point of Q. Convexity yields

    D(Q) subset D(P) subset (1+epsilon)*D(Q),
    0 <= H_P(w)-H_Q(w) <= log(1+epsilon)*sum_i w_i,
    Delta+(P,Q) <= n*log(1+epsilon).

Only rational signs, weights and vertex coverage are needed to check the
sandwich; the conversion to log-margin error is a theorem, not a floating-point
calculation. A decoded polytope represents every convex combination. Retaining
only its logged vertices is invalid: on the segment joining (1/4,1/2) and
(1/2,1/4), the product maximum is 9/64 at (3/8,3/8), above both vertex values 1/8.

A directed local bound beta gives `m_Q<=m_P<=m_Q+beta`, and the same for M, after
all declared composition charges. This yields the following answer contract.

| Answer | Required completed evidence | Meaning |
|---|---|---|
| ZERO | An order whose upper margin is <=0 | That one order supports the target throughout the source family. |
| FULL | Strictly positive lower margins for every order | No order avoids the receiver fine B. |
| REFINE | Completed brackets leave the decision unresolved | More representation accuracy is needed for this answer. |
| UNKNOWN | Solver, order search or witness recovery is incomplete | Computation has not established either conclusion or a completed ambiguity bracket. |

An exact tie is a weak blocker, not a small positive number to round away. To
require answers on every query with absolute true margin at least gamma, use a
local/composed budget strictly smaller than gamma. Query-optimization error would
have to be charged separately. An algebraic outer family outside the original
probability box can bound margins without being reinterpreted as an admissible
strategic model. [P3, P5, P6]

Finite shared labels are retained as exact alternatives with compatibility masks.
For a fixed order the source-wide margin is the maximum of branch margins; the
same order is then optimized across that union. Replacing the union by a convex
hull or selecting orders separately in branches changes the problem. Tree messages
can transport worst compatible sums of local errors, but a budget-message theorem
is not an efficient strategic order optimizer. Infeasible assignments must remain
distinct from feasible assignments with zero error. [P6, P7]

## 5. How many bits does the declared contract require?

Fix rational constants `0<ell<u<tau<1`. Consider rational planar convex sources
inside [ell,u]^2 and all contextual order/positive-rational-cost queries. A uniform
deterministic payload and fixed decoder must answer every query whose absolute
true log margin is at least gamma. The query decoder cannot consult the original
source in place of its payload. Source-readable verification is a separate stage.
Storage of the original source is not hidden inside a claim about transmitted bits.

### Theorem 6 — matching planar rate under source-readable verification

For this class the optimal worst-case payload rate is `Theta(gamma^(-1/2))`.
A rational multiscale encoder achieves the upper bound with polynomial work in
explicit input length and 1/gamma. When the verifier may read the source and do
polynomial work, zero extra transmitted witness bits suffice to validate its
sandwich; payload plus such extra certificate bits has the same rate. This is not
a claim about source-free certificates, optimal query time or expanded memory.

**Upper-bound construction.** Parameterize the nondominated planar frontier by
normalized L1 arclength. Both coordinates have the same nonnegative midpoint
surpluses in a dyadic tent expansion. Their total surplus at depth j is bounded
by a constant times 2^(-j). Round endpoints downward and round tent coefficients
at scale-dependent dyadic precision. One tent per depth is active at any point,
so the sum of coefficient errors and the interpolation tail is uniformly small.
Take the convex hull of decoded path points: rounding need not preserve the
concavity of the path itself. This gives a rational downward domination sandwich.

At each depth, encode the entire nonnegative integer coefficient sequence by its
rank among weak compositions with a known sum budget. The logarithm of their
number is a binomial-coefficient length. Summing these lengths across depths costs
O(gamma^(-1/2)), including identities and amplitudes rather than assuming vertex
positions are free. The explicit planar proof [P5] supplies quantization constants,
integer rank/unrank algorithms, rounding and bit-complexity estimates. The decoded
grid may contain O(1/gamma) points: compressed bits and expanded computation are
not the same resource.

**Lower bound.** On a positive concave planar patch, independently include or omit
m optional rational frontier vertices. Positive weighted-log supports distinguish
families differing at a vertex by a gap of order 1/m^2. Theorem 3 turns each such
gap into opposite contextual decision signs with rational query costs. Thus 2^m
families require distinct codes at gamma of that order, giving Omega(gamma^(-1/2))
bits. The inherited packing proof, including constants and fixed-box localization,
is part of [P3, P4, P5], not replaced by a finite numerical experiment here.

The generic geometric exponent is classical convex-set metric entropy, credited
to Bronshtein and its explicit statement in Gardner, Kiderlen and Milanfar. What
is specialized here is the strategic query separation, rational code and source-
verification contract. A uniform bound would fail if probabilities could approach
zero without fixed box control. The complete detailed coding proof remains an
incorporated dependency of this integrated draft, not a newly Lean-checked result.

### Theorem 7 — bounded reuse versus unlimited reuse

Allow at most k independent occurrences of one planar payload while retaining a
fixed separated final margin gamma. The per-payload rate becomes
`Theta(sqrt(k/gamma))`. The upper bound chooses local accuracy of order gamma/k;
the lower bound repeats the separated interface k times and uses contextual
realization. For unlimited independent reuse there is no fixed finite worst-case
payload budget at a fixed final margin. A finite code must identify two distinct
rational singleton interfaces; enough copies amplify their nonzero discrepancy
into a permitted query requiring opposite answers from the same code.

This impossibility uses self-contained deterministic payloads and the obligation
to answer all separated queries. It does not rule out source recovery, refinement,
unbounded storage or a narrower query/reuse contract. Nor is it a new generic
pigeonhole or tensorization principle. The exact bit model and amplification
proof are [P4, P5, P7].

## 6. Executable and formal evidence

R18 supplies a reference from R16 binary payloads through source audit to all-order
queries with multiple planar compressed blocks, independent repeats, arbitrary
exact rational V-polytope attachments and finite masks. Its corrected receipt
records 454 checks, including comparisons with retained optimized selectors,
independent cvc5 encodings, primitive mixed-game/backward computations and rational
witness replays. Exact barycentric polynomial constraints replace logarithms in
the decision backend. Enumeration is factorial in the number of orders; growing
uncertainty dimension has no general polynomial-time guarantee here. UNSAT still
trusts the backend, and resource-limited work returns UNKNOWN. [P6]

R19A formalizes the primitive assessment-to-blocker and attained-minimum chain.
R19B checks the support-to-actual-margin bridge, contextual realization, rational
separation, directed products, reuse, finite labels and tree budget transport.
Its joined result connects the margins directly to raw strategic assessments and
one common order. The retained audits count 163 strategic, 126 interface and 237
joined declarations with overlapping scopes, not their sum as distinct theorems.
The scoped builds use the recorded Lean/Mathlib versions and standard axiom
dependencies. [P2, P7]

The historical research source `962ff4fef3d5405f00f9ec2e3abfbd773f108c9b` passed
all seven jobs in run 35669873531. Later CI runs are separate source-specific
replays. None of these receipts establishes empirical model adequacy, an
independent human assessment of the written statements, a separate proof-kernel
implementation, full encoder/adapter formalization, or publication priority.
The [review packet](REVIEW_PACKET.md) makes those remaining obligations explicit.

## 7. Transfer tests: why scope is a mathematical result

The first paper need not wait for a universal strategic model. Its boundaries
already suggest discriminating tests. R20 changes the instrument to a committed
sender report sanction and obtains a genuinely continuous minimum; the old
interface survives with a sharp operational bound. R21 changes detection and
shows that an upper probability summary can erase the lower detection probability
needed to determine a fine. Neither result silently changes Theorem 1's receiver
fine or its equilibrium assumptions.

R22 then lets one uncertain component jointly determine reward and detection.
Two convex families have the same reward range and detection range but minimum
sender fines 3 and 6. A clipped support profile in reward-to-detection coordinates
repairs the declared one-sender query class, with a sharp error bound and restricted
serial-audit composition. An additional background-reward counterexample breaks
the repaired profile outside its declared directions. These are written proofs
and exact finite checks, not new Lean results, and are not required premises of
Theorems 1–7. They demonstrate the research method: derive the needed interface
from an actual changed decision problem, rather than proclaim the previous one
universal. [P9]

## 8. Limitations and falsifiable next claims

The strategic conclusions concern existential target equilibria with independent
private facts and parameters known by the players. They do not establish universal
stability, rationality of real actors, coalition robustness or desirability of the
target. No claim that enforcement prevents war follows from this theorem alone.
The application repository must independently justify parameter interpretation,
empirical warrant and normative objectives.

Mathematically, optimized-only interface minimality, general revision operations,
compressed continuous shared-parameter coupling and optimal general query/update
costs remain open. Formal assurance still has gaps between executable formats and
formal objects, and the entropy/codec arguments remain written proofs. The next
paper-closing step is a reviewer checking the actual statements and dependencies,
not more test counts. The next bounded transfer-assurance task is R22's primitive-
to-joint-profile formal bridge; a two-sender shared-parameter inspection model is
a separate prospective mathematical test, not a result claimed in this draft.

## 9. Theorem-level source comparison and priority boundary

The following comparisons inherit the actual source-inspection levels recorded
in [P8]. This integration does not claim new full-text readings where only an
abstract or bibliographic record was inspected previously.

| Claim here | Closest comparison and matching-assumption assessment | Outstanding review |
|---|---|---|
| Theorem 1: sequential target and blocker | Kreps–Wilson supplies the equilibrium concept, not this costly hard-evidence blocker construction. Bergemann–Morris Theorem 2 concerns BCE incentive ordering under changing player information, not the present sequential target with analyst uncertainty. | Check the primitive game and equilibrium quantifiers against both formal and written statements. |
| Theorems 2–3: decision-preserving quotient and discrepancy | Van Rooyen–Williamson Theorem 1 identifies statistical deficiency through downstream Bayes values. Our robust parameter-family margins and one-added-sender construction are not identified with those kernel/decision objects. | A precise embedding might make the result a credited specialization; its absence here is not evidence against that possibility. |
| Theorem 4 and finite-label transport | Quantitative assume-guarantee theories already bound composition error; disjunctive abstract semantics already explains retention of alternatives. Exact directed addition and this strategic interpretation require the stated product/support argument. | Match allowed operations and distance semantics, not just additive-looking formulas. |
| Theorem 5 and executable feasibility | Rational domination is ordinary convex reasoning. Real-algebraic decision procedures supply exact polynomial feasibility; R10/R12 already provide scoped efficient selectors. | Solver-free certificates and the executable-to-formal adapter are not completed by backend agreement. |
| Theorem 6: geometric bits and rational encoding | Bronshtein's entropy rate, stated in Gardner–Kiderlen–Milanfar Proposition 5.4, already supplies the geometric exponent. Convex-Pareto approximation addresses related frontier questions; only its abstract was inspected anew in the inherited audit. | Read the complete Pareto comparison and assess the uniform rational coding/assurance specialization. |
| Theorem 7: reuse limit | Product additivity and pigeonhole amplification are established methods. The question here is what the declared strategic decoder contract forces it to preserve. | Do not advertise a new general tensorization or information-theoretic principle. |

R16's provisional candidate label applies to a combined budget-sensitive certified
strategic interface, not to geometric entropy or generic operational sufficiency.
Whether this is best presented as original research, a useful synthesis or a
specialization is unresolved. This draft makes no certified priority claim.

## Appendix A. Exact dependency map for this edition

All P1–P8 core paths below refer to the unchanged source edition
`1525f20c86f4e14f7fd8baf404f085b3e95ff427` in `saykig/decision-interfaces`.
These relative paths are reader conveniences; the full commit above identifies
the version used, not a floating dependency on future main.

- **P1:** [R13 primitive audit, §§1–8](../research/game_cascade_audit_2026_09_19/math/AUDIT.md).
- **P2:** [R19A formal scope](../research/strategic_equilibrium_2026_09_21/FORMAL_SCOPE.md) and [receipt index](../research/strategic_equilibrium_2026_09_21/README.md), including `raw_target_iff_blocker`, `ordered_raw_target_iff_blocker`, `raw_attained_minimum`.
- **P3:** [R15 RESULTS, §§0–6 and composition boundaries](../research/enforcement_codec_2026_09_20/math/RESULTS.md).
- **P4:** [R16 foundation audit](../research/optimal_bits_2026_09_21/math/FOUNDATION_AUDIT.md) and [bit model](../research/optimal_bits_2026_09_21/math/BIT_MODEL.md).
- **P5:** [R16 full planar coding proof](../research/optimal_bits_2026_09_21/math/PLANAR_RATE.md) and [reuse/label extensions](../research/optimal_bits_2026_09_21/math/EXTENSIONS.md).
- **P6:** [R18 reference contract and receipt index](../research/composed_queries_2026_09_21/README.md).
- **P7:** [R19B formal interface and game-join scope](../research/interface_bridge_2026_09_21/README.md), especially `support_error_raw_decisions` and `common_order_raw_target_iff_margin`.
- **P8:** [R16 source comparison](../research/optimal_bits_2026_09_21/sources/NOTES.md) and [R18 theorem-level comparisons](../research/composed_queries_2026_09_21/sources/NOTES.md), with primary-source links and exact inspection limits.
- **P9:** [R20](../research/nonbinary_enforcement_2026_09_21/README.md), [R21](../research/inspection_transfer_2026_09_21/README.md) at the core edition; [R22](../research/joint_inspection_2026_09_21/README.md) at `221354c025861e58e7ba7667321aa305860d7bab`. These transfers are not dependencies of Theorems 1–7.

This manuscript is an integrated exposition with incorporated technical proof
appendices, not a claim that every coding detail has been duplicated into one file.
The [first-paper package](../FIRST_PAPER_PACKAGE.md) retains the historical assembly
map. The [review packet](REVIEW_PACKET.md) records the current closure status.
