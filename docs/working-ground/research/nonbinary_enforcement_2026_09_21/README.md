# R20 — First nonbinary enforcement transfer

September 21, 2026. Gate C tests one explicit changed instrument: an automatically
collected scalar sanction on each authenticated report. The receiver is not
fined. Credibility means declared ex ante commitment with public observability;
there is no discretionary enforcement player.

The minimum sanction for fixed order π and model family P is

    e*(P,π,k,η) = max_{p∈P} max(0,min_j(η_{π_j}∏_{ℓ>j}p_{π_ℓ}−k_{π_j})).

The institution minimizes this over one common order. All minima are attained.
With two identical senders, η=1,k=1/4,p_i=t, the minimum is t−1/4 for
t∈[1/3,1/2]. The frontier ranges continuously from 1/12 to 1/4.

- [Model, proofs, failed attacks and sharp error bound](math/RESULTS.md)
- [Sources and matching-assumption implications](sources/NOTES.md)
- [Exact checks](experiments/check.py) and [execution receipt](experiments/receipt.json)

The old downward/log-support interface preserves the entire frontier. It remains
coarsest for all contextual fixed-order queries, using the inherited one-sender
separation theorem; optimized-only coarseness remains open. A single old binary
answer is insufficient. Equal coordinate ranges, vertex-only evaluation and
modelwise order choice each fail, with explicit exact counterexamples retained.

For directed discrepancy at most δ, the bound

    e*_P ≤ exp(δ)e*_Q + (exp(δ)−1)max_i k_i

holds for fixed and optimized orders, and is attained by a rational two-sender
example even after order optimization. Rational domination sandwiches give
rational multiplicative factors; independent compressed occurrences multiply
their factors, exact attachments contribute one, and finite labelled branches
retain the same common-order quantifier.

## Evidence and limits

The strategic formula is an exact cost-substitution corollary of R13, not a new
equilibrium concept or a historical-originality claim. Written proofs include
arbitrary mixed continuations and attained favorable ties. The checker translates
the explicit report-sanction payoff into R13's primitive full-state/path evaluator
and independently compares it with the new formula. It also asks Z3 for arbitrary
mixed equilibrium feasibility and full-polytope strict feasibility.

Those solver answers are trusted exact-backend evidence, not external proof
certificates. The primitive checker and belief assumptions are inherited from
R13; this is not an independent reimplementation of all game machinery. No new
R20 Lean declaration or independent human proof review is claimed. The required
LEAN YES/NO decisions follow each substantial result in the proof note.

The September 21 receipt records 94 arbitrary-mixed equilibrium queries and
94 primitive backward assessments, 912 terminal-payoff translation checks,
98 exhaustively enumerated pure profiles and 64 full-polytope feasibility queries.
Normal and `python -O` execution produced identical receipts, using Python 3.9.6
and Z3 4.15.3. The receipt hashes the checker and inherited primitive dependencies.

Run with Python and the pinned dependency in `experiments/requirements.txt`:

```sh
python experiments/check.py > /tmp/r20-normal.json
python -O experiments/check.py > /tmp/r20-optimized.json
cmp /tmp/r20-normal.json /tmp/r20-optimized.json
```

The next bounded mathematical attack may change the observability of the sanction
trigger. That is a separate model, not included in this theorem. No interface
enrichment is justified by the present test.
