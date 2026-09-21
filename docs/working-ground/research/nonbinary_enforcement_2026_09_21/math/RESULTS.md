# One scalar report sanction: a nonbinary frontier

September 21, 2026. Complete written derivations within the declared model;
no new Lean proof. This changes one instrument of R13 and tests mathematical
transfer. It is not a claim that suppressing information is socially desirable.

## 1. Primitive model and credibility

There are n≥1 senders and one receiver. Fix A,B>0 and τ=A/(A+B).
An actual parameter vector p has independent private Bernoulli bits with
0<p_i<τ. Each sender observes only its own bit and the full earlier public
transcript. Type zero can only remain silent S; type one can choose S or report
its authenticated positive bit R. Each sender moves once in a publicly fixed
order π. The receiver observes all reports and then chooses C or D. Its payoff
is zero at C and is B at D when every private bit is one, −A otherwise.

Before Nature draws the bits, the institution commits to one scalar e≥0,
automatically collected from each sender immediately upon its public report.
The original report cost k_i>0 and reward η_i>0 remain fixed. Sender payoff is

    η_i 1_D − k_i 1_{R_i} − e 1_{R_i}.

There is no receiver fine in this model. Public authenticated reports make the
collection trigger observable. Commitment and collection are primitive features
of the mechanism: no discretionary enforcer, later intervention choice, hidden
report, evasion, wealth cap or endogenous collection cost is included. Therefore
credibility is enforceable ex ante commitment, not a separately proved optimal
response of an enforcement player. This is a report levy/sanction, not a sanction
contingent on hidden truth or on the receiver's decision.

Players know actual p and all game primitives. The institution knows a nonempty
compact family P⊂(0,τ)^n and chooses a single (π,e) for that entire family.
For each actual p a different equilibrium may support the target. The target is
all-silent S^n followed by C with probability one. Sequential equilibrium means
sequential rationality at every information set plus beliefs obtained as limits
of Bayes beliefs for completely mixed feasible profiles. Perturbations need not
be equilibria. Favorable ties mean existence of a supporting best-reply choice;
neither uniqueness nor silence in every equilibrium is required.

## 2. Strategic derivation and attained frontier

The substitution k_i↦k_i+e is an exact equality of terminal payoffs, information
sets and available actions with R13 at receiver fine zero. In particular it
preserves the entire assessment predicate, not only a proposed cascade formula.
For completeness, the two backward directions are derived below.

The R13 likelihood factorization is unchanged. Conditional on any transcript,
reported bits equal one, unvisited bits retain independent priors, and a silent
past bit has posterior p_i(1−a)/(1−p_i a)≤p_i<τ. Denominators are positive.
One common sequence of completely mixed feasible profiles yields these beliefs
at every information set, including off-path histories. The receiver therefore
strictly chooses C at every incomplete transcript and D at R^n, for every e.

After a past silence, disclosure strictly loses k_i+e. On the all-report prefix
let a_j be the positive type's report probability at position j. Enumerating
future states and paths gives gain

    η_{π_j} ∏_{ℓ>j}(p_{π_ℓ} a_ℓ) − k_{π_j} − e.          (1)

Put T_j(p)=∏_{ℓ>j}p_{π_ℓ}, including T_n=1.

**Theorem 1 (pointwise exact frontier).** A target sequential equilibrium exists
at e if and only if some j has k_{π_j}+e≥η_{π_j}T_j(p). Consequently its feasible
sanction set is [f_π(p),∞), where

    f_π(p) = max(0, min_j [η_{π_j}T_j(p)−k_{π_j}]).       (2)

**Proof.** If every inequality is strictly reversed, the last sender's gain is
positive, forcing a_n=1. Backward induction forces every a_j=1 using (1), so
the target is impossible; arbitrary mixed continuations cannot rescue it.
If a weak blocker exists, take its latest position b. On all-report prefixes
choose a_j=1 for j>b and a_j=0 for j≤b. At b silence is optimal, including an
exact tie. Earlier reports cannot complete the evidence and strictly lose their
cost; later positive types strictly prefer reporting by maximality of b. Choose
silence at every history containing S and the receiver rule above. Every action
is sequentially rational and the common tremble construction supplies consistent
beliefs. Solving the weak blocker inequality for e yields (2), including its
attained endpoint. ∎

```yaml
LEAN: YES — The cost-substitution transfer and attained threshold are stable consequences of the primitive strategic bridge and will be inherited by frontier queries.
```

**Theorem 2 (family and common-order frontier).** For fixed query
q=(π,k,η,A,B),

    e*(P,q) = max_{p∈P} f_π(p),
    e*_opt(P,k,η,A,B) = min_π max_{p∈P} f_π(p).           (3)

Both minima are attained and every larger sanction works.

**Proof.** The pointwise feasible sets are upward closed intervals. Their
intersection over P is the interval starting at the supremum of f_π.
Continuity of products, finite minima and positive part makes f_π continuous;
compactness attains the supremum. There are finitely many orders. ∎

```yaml
LEAN: YES — Attainment and the order/model quantifiers define the reusable nonbinary query contract.
```

### Smallest probability-sensitive example

Take n=2, A=2,B=1, η_1=η_2=1 and k_1=k_2=1/4. For singleton
p=(t,t), 1/3≤t≤1/2, both orders have

    e* = min(t−1/4,3/4) = t−1/4 ∈ [1/12,1/4].            (4)

The sanction genuinely ranges over an interval, with all payoffs and instrument
fixed. One sender already gives (η_1−k_1)_+, a nonbinary constant; two is the
smallest size at which varying the probability family changes the frontier in
this model. The global 0-or-B conclusion from receiver enforcement does not
survive the change of instrument.

```yaml
LEAN: NO — This two-sender numerical example is an illustrative specialization of Theorem 1.
```

## 3. First attempt to break the old interface

Define D(P)={x≥0: ∃p∈P, x≤p coordinatewise}, as in R15.

**Theorem 3 (sufficiency and contextual coarseness).** Equality D(P)=D(Q)
preserves (3), every fixed-order frontier, and every such frontier after attaching
the same independent exact family. For compact convex P,Q in the positive box,
equality of all contextual fixed-order frontiers for all positive costs/rewards,
with one additional known sender allowed, conversely implies D(P)=D(Q).

**Proof.** Every T_j, hence f_π, is coordinatewise nondecreasing. If p∈P,
the equality of downward sets provides q∈Q with p≤q. Thus f_π(p)≤f_π(q).
Taking suprema and reversing P,Q proves equality for each order; finite order
minima preserve it. Also D(P×R)=D(P)×D(R), so attachments preserve equality.
This direction requires compactness for attainment but not convexity.

For the converse, e*(P,q)=0 is exactly the old safe-order question with
ratios r_i=k_i/η_i. Under convexity and the positive box, R15's exact contextual
interface theorem and one-added-sender separation distinguish unequal D sets
by a fixed order and strictly opposite log margins. Choose η_i=1,k_i=r_i;
positive rational ratios suffice by the established strict-gap approximation.
One family then has e*=0 and the other e*>0 by compactness and Theorem 1,
contradicting equality of the full frontier. ∎

This coarseness is for the entire contextual **fixed-order** query family, not
for optimized-only values. No optimized-only necessity theorem is asserted.
For convex families, R15 identifies D equivalently with the positive log-support
profile H. For nonconvex labelled unions retain the conditional profiles and
mask; a single support aggregate remains insufficient.

```yaml
LEAN: YES — Exact preservation and the contextual query-class boundary are stable interfaces for the first nonbinary transfer.
```

### Failed attacks and retained counterexamples

1. Adding dominated feasible points to a convex family preserves D and cannot
   change this frontier. The monotonicity proof blocks this attempted collision
   for every query, not just tested samples. Changing η or k while keeping only
   D fixed changes the query and is not a counterexample.
2. A single old ZERO/FULL output is not the full interface. In (4), t=1/3 and
   t=1/2 are both old FULL at zero receiver fine, but their new minima are 1/12
   and 1/4. This breaks transferring an old binary answer, not transferring D.
3. Matching separate coordinate ranges is insufficient. For the two-coordinate
   segment Q=conv{(1/4,1/2),(1/2,1/4)} versus the rectangle with the same ranges,
   attach a known sender first with p_0=1/2 and give all three senders η=1,k=1/16.
   In order (0,1,2) the frontier is max xy−1/16: 5/64 on Q, 3/16 on the
   rectangle. These families have unequal D, so this does not break Theorem 3.
4. In that segment the worst model is x=y=3/8, with value 5/64, while both
   source vertices give 1/16. Checking vertices alone underestimates enforcement.
5. For P={(1/2,1/4),(1/4,1/2)}, η_i=1,k_i=1/4, every model has an order needing
   zero sanction but each common order needs 1/4. Taking modelwise optimized
   minima reverses the quantifiers and fails even in the smallest variable example.

```yaml
LEAN: NO — These exact finite counterexamples diagnose incorrect summaries and quantifiers; the general preservation theorem is the formalization priority.
```

## 4. Operational approximation and composition

Let P,Q be nonempty compact convex families in the same positive box and let
δ≥Δ+(P,Q), R15's directed profile discrepancy. Attach any independent exact
context; let K=max_i k_i over all senders in the resulting query. The same
costs, rewards and order are used on both sides.

**Theorem 4 (frontier error, sharp in the declared class).**

    e*_P ≤ exp(δ)e*_Q + (exp(δ)−1)K.                    (5)

The inequality also holds for common-order optimized minima, with the same K.
If D(Q)⊆D(P), then additionally e*_Q≤e*_P.

**Proof.** For e≥0 set r_i(e)=(k_i+e)/η_i and use the inherited margin m_P(e)
at these ratios. By Theorem 1 and compactness, e supports the target family iff
m_P(e)≤0. Let b=e*_Q, a=exp(δ), and E=ab+(a−1)K. For every i,
k_i+E≥a(k_i+b), so every log ratio at E is at least its value at b plus δ.
Hence m_P(E)≤m_P(b)−δ≤m_Q(b)≤0 by R15 contextual discrepancy. This proves
(5). Apply it to an optimizing order of Q to bound the optimized minimum of P.
Downward inclusion gives the lower bound by monotonicity. ∎

For exact rational singletons Q={(1/2,1/3)}, P={(1/2,1/2)}, take
η=(1,2), k=(1/4,1/8), A=2,B=1. In order (1,2), e*_Q=1/12 and e*_P=1/4;
the other order requires 3/4 for both. Thus these are also optimized minima.
Here Δ+(P,Q)=log(3/2), K=1/4, and the right side of (5) is exactly 1/4.
So even the optimized bound is attained on rational two-sender models.

```yaml
LEAN: YES — The directed margin-to-sanction bound is a stable operational guarantee and its exact cost dependence matters for composition.
```

**Corollary (rational sandwiches and reuse).** If a decoded block satisfies
D(Q)⊆D(P)⊆(1+ε)D(Q) in dimension d, take a=(1+ε)^d as a rational upper
bound on exp(Δ+(P,Q)). Then the certified sanction interval is

    [e*_Q, a e*_Q+(a−1)K].                              (6)

For independently compressed blocks, multiply their a factors; each independent
reuse of a payload contributes its factor again. Exact attachments contribute 1.
Equivalently, directed log-discrepancies add. For finitely many compatible labelled
branches use their branchwise bounds under the same order, then finite maximum;
the largest branch factor also gives a valid common bound (6). Optimize over a
single common order only after branch maxima. Tree budget transport can reuse
the existing maximum-sum directed-log budget, then exponentiate it in (5).
These operations transport error bounds, not a complete efficient strategy solver.

**Proof.** R15 bounds the block discrepancy by d log(1+ε), with exact directed
addition under independent products. Theorem 4 is monotone in its a factor.
Finite maxima of branchwise upper bounds preserve the common uniform inequality.
R16's conditional-product tree budget supplies the stated discrepancy bound. ∎

```yaml
LEAN: YES — The rational frontier interval and finite reuse accounting are stable consequences required by a usable nonbinary interface.
```

## 5. Status and next bounded attack

No new candidate-original label is assigned: the strategic frontier follows by
an exact positive-cost substitution in R13, sufficiency/coarseness follow from
R15 plus monotonicity, and (5) follows by a log-threshold shift. The sharp bound
is useful mathematical transfer, with priority unestablished. See the source note
for close disclosure-cost precedents and their different assumptions.

The interface survives this first nonbinary gate; no enrichment is warranted
inside this model. The next substantive test would change observability of the
sanction trigger while holding payoffs and query conventions explicit. That is
a later model and has not been smuggled into this proof. The first manuscript
need not wait for it. Formal status: written proofs, exact rational examples and
solver-trusted primitive checks; no Gate C theorem is yet a new Lean declaration.
