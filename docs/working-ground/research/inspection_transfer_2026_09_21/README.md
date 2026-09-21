# R21 — inspection transfer exposes the missing lower probability

September 21, 2026. A bounded mathematical transfer after R20, not a requirement
for the first paper. The old positive-support interface fails under this explicitly
changed use of a probability component. The missing information is its minimum
inspection probability. This is a minimal counterexample and a standard expected
penalty calculation, not a claim of a new inspection theory.

## Model and parameter routing

There is one strategic sender and one receiver, with R13's n=1 boundary model.
The sender's independent private bit has fixed probability p=1/2; A=2,B=1.
Type zero can only be silent S; type one can report an authenticated R at fixed
cost k>0, gaining η>0 if the receiver chooses D. The receiver sees the message,
then acts. Its payoff is zero for C, 1 for D when the bit is one, and −2 otherwise.
By the inherited belief argument it strictly chooses C after S and D after R.

A separate verification component supplies q∈(0,1), the probability that a
post-action audit detects a report. The audit is an independent Bernoulli lottery,
realized **after** the receiver acts. Before the game the institution commits to
collecting e≥0 from the sender only when a report is detected. Detection and the
report are authenticated to the collection mechanism; the lottery's realized
outcome is unavailable to the sender and receiver before their decisions. There
are no false positives on silence. Fixed escrow/automatic collection is a
primitive commitment mechanism, not an optimizing inspector. Players know actual
q, p, η, k and e; the analyst knows a nonempty compact family U⊂(0,1) of q values.
The institution must select one e supporting the silent target for every q∈U,
with favorable sender ties and a possibly different equilibrium at each q.

**Precisely what is being transferred:** q is the output probability coordinate
of the verification component, not a varying query parameter. The candidate
reused interface is `D(U)` or `H_U(w)=max_{q∈U} w log q`, w∈[0,1], the R15
upward-monotone query summary applied to this component. Two source families
will vary U while all query primitives above stay fixed. The original fact prior
p stays fixed. R15 never claimed that this summary supports arbitrary inspection
queries: this test asks whether it can be reused unchanged in a different class.

## Exact frontier and minimal collision

Let g=max(0,η−k). Conditional on type one, reporting has expected payoff

    q(η−k−e) + (1−q)(η−k) = η−k−eq,

while silence yields zero. A mixed report probability a is sequentially rational
exactly when it is a best reply to these two payoffs; the silent target exists
iff η−k−eq≤0. Consistent beliefs and the receiver behavior are unchanged by the
independent later lottery. Hence

    e*(U;η,k) = g / min U,

and the minimum is attained. Positivity and compactness guarantee min U>0.

For η=1,k=1/2, compare the rational convex sources

    U={1/2},       V=[1/4,1/2].

Both have downward set [0,1/2] and exactly the same positive log support for every
weight, but e*(U)=1 and e*(V)=2. At e=1, the q=1/4 model in V still strictly
prefers reporting; at e=2 it has a favorable exact tie. One uncertain detection coordinate
and one informed sender suffice; the receiver retains its own action choice. With no uncertain coordinate
there cannot be two different component families, so this is dimension-minimal
for the stated transfer. No claim of universal game-theoretic minimality is made.

```yaml
LEAN: NO — This exploratory inspection transfer is an elementary specialization of expected-penalty theory, outside the first paper's stable formal chain.
```

The discarded information is the lower endpoint, which the downward hull erases.
Under original disclosure queries larger probabilities make a cascade easier;
here smaller detection probabilities make deterrence harder. Changing this
monotonicity reverses which endpoint the uncertainty interface must preserve.
Convexification is not the cause: both sources are convex, and the collision is
already exact before approximation. More bits devoted to the same exact upper
interface cannot repair the loss.

## Smallest enriched contract and composition

For the inspection-only class, `a(U)=min U` is sufficient for the entire function
e*(U;η,k), for all positive η,k. It is also necessary: whenever a(U)≠a(V), any
fixed η>k produces different frontiers. Thus a is the coarsest exact statistic
for this declared class. If both the old one-dimensional positive-support queries
and the new inspection queries must survive, `(min U,max U)` is sufficient and
necessary: the old class separates different maxima (using an additional sender),
and inspection separates different minima. This is an operational quotient,
not a universal representation for arbitrary later operations.

For positive certified bounds a_lo≤a(U)≤a_hi, the exact sanction interval is

    [g/a_hi, g/a_lo].

For independent serial verification stages that **all** must detect before the
sanction is collected, the detection probability is ∏q_i. Independent uncertainty
families yield a_joint=∏a(U_i), so

    e*_joint = g / ∏a(U_i).

In log units, `−log a_joint=Σ_i −log a(U_i)`. Endpoint log-errors therefore add;
a bound |log a−log â|≤δ implies a multiplicative frontier factor exp(δ) when
g>0. Reusing an approximate component k times charges kδ, not δ. For shared
finite labels the exact lower endpoint is the minimum of the products over
allowed label assignments; independent minimization per component can be false.
An exact label-tree representation may compute this by min-product (equivalently
max-sum of negative logs), retaining compatibility. This is a series-detection
composition claim only, not an OR-audit or correlated-audit theorem.

```yaml
LEAN: YES — If inspection becomes a reusable component, its lower-endpoint quotient and composition/error law are the stable contract to formalize.
```

## Exact evidence, failed transfer and sources

[The checker](experiments/check.py) compares the lottery's primitive expected
payoff with the effective-cost R13 game, asks its arbitrary-mixed equilibrium
solver at and around exact thresholds, and checks the equal-interface collision,
attainment, independent serial products, repeated factors and a shared-mask
counterexample. [Receipt](experiments/receipt.json) records executed counts and
source identities; normal and optimized receipts match. These finite checks
supplement the written algebra, with Z3 trust for the mixed-game queries. No new
Lean proof or independent human review is claimed.

The failed conjecture is explicit: equal positive log-support interfaces do not
preserve every scalar enforcement frontier after transfer to verification. The
stronger conclusion that R15/R20 themselves are false is also rejected: their
supported operations and incentive monotonicity differ. A fixed audit query
outside the declared class requires source recovery or the lower endpoint.

**Closest theorem/implication audit.** Becker, *Crime and Punishment: An Economic
Approach* (1968), [original article, pp.177–178, footnotes 16–17](https://archiv.soms.ethz.ch/sociology_course/lecture6/becker1968.pdf),
states the expected utility of an act under probabilistic punishment and its
risk-neutral expected-income specialization. With linear utility, fixed gain g,
and fine e, that calculation directly supplies g−qe. Our pointwise frontier is
therefore an elementary direct corollary; maximizing over a compact uncertainty
family supplies the lower endpoint. The counterexample is a small diagnostic of
the previously chosen interface, not an original expected-sanction theorem.

Von Stengel, *Recursive Inspection Games*, [author preprint, Theorem 5, §5](https://arxiv.org/pdf/1412.0129),
studies a leadership game where an inspector commits to inspection probabilities.
Its explicit equilibrium involves finite inspection resources and continuation
rewards, which are absent here. It supplies relevant commitment prior art but its
formula is not being imported into this independent lottery model. The exact
statement and surrounding commitment discussion were inspected; no exhaustive
priority review is claimed. No **CANDIDATE ORIGINAL THEOREM** label is earned.

**Programme change:** scalar fines alone do not determine a universal interface;
the information needed also depends on what the sanction observes. The first
paper's disclosure interface remains intact. Next bounded attack, if inspection
is pursued: determine the joint interface when the same uncertain parameter
controls both disclosure rewards and detection probabilities. Marginal endpoint
pairs may then lose the required dependence. No bargaining, dynamics or vector
instrument model is introduced here.
