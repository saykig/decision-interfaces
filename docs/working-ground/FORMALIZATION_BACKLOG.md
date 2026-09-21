# Formalization and independent-check backlog

The goal is not to formalize every exploratory calculation. Formal verification
should attack the assumptions on which later results depend and the claims most
likely to enter the thesis.

## September 21 execution status

[R19A](research/strategic_equilibrium_2026_09_21/README.md) closes Priority 0.1:
actual explicit-belief assessments, mixed no-rescue, constructive sufficiency,
arbitrary permutations and the attained minimum now have a fresh 163-declaration
Lean audit. The older detailed entries below preserve the previous backlog state.
Gate B2's interface bridge is the current assurance target; the binary encoder
and classical entropy proofs remain outside the immediate formal scope.

## Priority 0 — thesis-bearing chain

### 1. R08 game-to-cascade theorem

Formalize the finite sequential hard-evidence game far enough to prove the bridge

```
no all-silent target sequential equilibrium exists at 0 <= e < B
iff
k_{pi_j} < eta_{pi_j} * product_{l>j} p_{pi_l}
for every position j
```

including favorable ties and the claim that the minimum fine is 0 or B in the
declared benchmark. This is the highest-value target because R09 and R10 inherit
this characterization.

**Current status:** R13 independently rederived the game from its primitives and
completed the written audit. R14 now Lean-checks the primitive belief, receiver
and full mixed continuation bridge, with 119 audited declarations and a normalized
behavioral tree. Full assessment/sequential-equilibrium existence, both backward
arguments and the 0-or-B theorem remain unformalized. The original R08 executable
is still unavailable. The exact existence predicate above avoids falsely claiming
that a weak blocker makes every equilibrium silent.

Suggested formalization order, now grounded in
[R13's proof](research/game_cascade_audit_2026_09_19/math/AUDIT.md):

1. Product prior and transcript likelihood factorization; unique consistent
   beliefs from completely mixed limits with positive denominators.
2. Incomplete-transcript receiver strictness and complete-transcript fine boundary.
3. Full mixed continuation payoff from the extensive game, retaining endogenous
   report probabilities before any backward substitution.
4. Both directions of target existence and the attained minimum at 0 or B.

R14 closes steps 1–3 from the primitive game, including off-path limits and full
state/path payoffs. Step 4 is now the first open formalization step; it requires
the assessment predicate and backward construction, not additional suffix algebra.
See [R14's precise scope](research/lean_belief_bridge_2026_09_19/math/FORMAL_SCOPE.md).

### 2. R15 enforcement-interface metric and certified sandwich

After completing the R08/R14 target-existence formalization, formalize the R15
bridge from a certified interface approximation to enforcement-margin guarantees:

- the rational domination sandwich implies the weighted-log support bound;
- the directed discrepancy bounds every permitted contextual margin query;
- one added sender attains the discrepancy;
- independent-product discrepancies add exactly;
- a certified interval crossing zero yields `refine`, not a false exact fine.

The planar encoder implementation itself does not need to be formalized before
these mathematical statements. The storage upper/lower bounds may remain written
until the operational metric is stable.

**Current status:** written proof plus exact executed verifiers; no Lean proof for
R15. The originating executable package is also not yet repository-CI replayable.

### 3. R10 move-to-front and short-prefix theorem

Formalize:

- suffix-product monotonicity under moving selected senders earlier;
- the move-to-front lemma;
- the finite Helly reduction to at most `min(n,d+1)` selected constraints;
- the segment corollary that a successful order exists iff a successful ordered
  prefix of length at most two exists.

Use an existing Mathlib Helly theorem if its hypotheses match exactly; otherwise
formalize the finite convex-family argument stated in `math/THEOREM.md`.
Do not formalize the software implementation as if that proved the game theorem.

**Current status:** written proof + exact selector checks; no Lean proof.

### 4. R10 exact algorithm statement

After the structural theorem is formalized, formalize only the mathematical
correctness specification of the certificate classes (constant blocker, strict
rational witness, complete sign cover). The Python implementation can remain a
program tested against that specification.

**Current status:** exact executable certificates, not a proof assistant.

## Priority 1 — independent implementation

### Rust certificate verifier for R10

Write a small independent verifier using arbitrary-precision integers/rationals.
It should parse the committed JSON certificate, reconstruct the pair polynomials,
check rational witnesses and independently implement Sturm-count/sign-cover
validation.

Do **not** share code or generated polynomial routines with the Python selector.
The point is implementation diversity, not speed.

**Current status:** not implemented.

### R12 polygon certificate boundary

R12 now supplies a different-backend, different-encoding exact replay (Z3 intrinsic
coordinates versus cvc5 original convex weights), plus independent Sturm checks
on segment slices. General success bundles still trust exact algebraic backends;
the CPC skeletons are not externally kernel-checked. Three special weighted-AM–GM
certificates are checked with rational arithmetic and a short written proof.

A general solver-free polygon emptiness checker is not implemented. Formalizing
the small AM-GM sufficiency statement would be tractable, but would certify only
that certificate format and would not close the more consequential R08 strategic
gap. Keep the priority order above. See
[R12's certificate statement](research/fixed_dimension_selection_2026_09_19/math/CERTIFICATES.md).

## Priority 2 — useful but not currently thesis-critical

- R09: formalize the weighted-certificate **sufficiency** and projection
  counterexamples before attempting the full Sion/minimax derivation.
- R07: formalize the model-specific optimized-jump counterexample only if it
  remains in the final paper. The abstract recovery theorem is established
  parametric optimization and is lower priority.
- R03–R05: extend existing Lean files only when the corresponding theorem survives
  into the final thesis. Existing formalizations already check the most
  error-prone algebraic bridges.

## External replay / Palomar

No result is currently recorded here as Palomar-registered.

A Palomar submission should be considered only when all of the following hold:

1. the theorem is stable enough to appear in the paper;
2. a small human-auditable Lean statement matches the informal theorem;
3. the Lean proof is complete and axiom-audited;
4. the game/model fidelity has been reviewed separately;
5. the exact public commit is frozen for external replay.

External registration would strengthen confidence in the formal proof artifact.
It would still not establish novelty, empirical relevance, or that the strategic
model is the right representation of a real institution.


## R16 update — September 21: preserve the thesis-bearing priority order

The planar storage gap is closed by a written rational multiscale argument;
fixed-d entropy is classical. Do not prioritize coding identities merely because
they are easy to formalize. After R08/R14 assessment existence, target:

1. Rational domination sandwich -> weighted-log support -> contextual interval.
2. Rational-query continuity plus one-sender attainment.
3. Exact directed product addition -> finite-repeat budget and collision
   impossibility under unlimited reuse.
4. Finite branch max/min interval transport, compatibility masks and tree
   max-sum error-budget induction.

The [R16 candidate theorem and plan](research/optimal_bits_2026_09_21/sources/NOTES.md)
states assumptions, closest literature and priority uncertainty. No R16 Lean
formalization has been started. Fast certificate/query complexity remains open.


## R19A/R19B resolution — September 21, 2026

The earlier assessment-existence and seven interface bridge priorities above are
now checked in [R19A](research/strategic_equilibrium_2026_09_21/README.md) and
[R19B](research/interface_bridge_2026_09_21/README.md). The latter also derives Sion
for the actual margin, proves rational-query separation, and joins that result
to raw equilibrium assessments with explicit common-order quantifiers. Fresh
receipts audit 163 (R19A), 126 (interface), and 237 (joined) declarations; these
scopes overlap and are not additive. Historical entries retain their dated scope.

Next bounded assurance priorities: independent theorem-statement/model review;
external replay of the frozen sources; executable R16/R18 table/query adapters.
The tree proof covers binary full recursion and an arbitrary finite-child node
contract, not byte-level equivalence to arbitrary-arity Python tables. Borrowed
entropy remains outside Lean; exact-interface coarseness is still a written proof.
