# First-paper statement review and continuation record

September 21, 2026 continuation. Companion to
[the integrated v0.1 manuscript](DECISION_INTERFACES.md).

## Status and authority

**Manuscript integration: executed.** The draft states the primitive model and
quantifiers before its seven numbered results, incorporates the detailed technical
proof dependencies by exact source edition, and includes theorem-level source
comparisons and evidence boundaries.

**Author-side statement audit: executed at the document level.** This is the same
assistant/session that assembled the draft. It is not an independent person, a
separate proof-kernel implementation or a second research team's review. We checked
the resulting exposition against R13's primitive audit, R15 RESULTS, the R16
foundation audit/bit model/planar proof, the first-paper package, active goals,
verification ledger and R16/R18 theorem-level source notes. We did not freshly
inspect every line of every Lean module, rederive every metric-entropy constant,
or independently repeat the external source readings recorded by the earlier audit.

**Independent statement/model-fidelity review: OPEN.** No reviewer has been
appointed or contacted by this task. This status may only change when a genuinely
separate reviewer supplies a dated report identifying the reviewed commit and
statements. Passing CI does not close it.

**Publication priority review: OPEN.** Existing candidate language stays provisional.
Some neighboring papers were inspected only at abstract or bibliographic-record
level. The source note retains those limits. No new CANDIDATE ORIGINAL THEOREM
label is assigned to the R22 transfer.

## 1. Theorem-to-proof audit table

Core edition: `1525f20c86f4e14f7fd8baf404f085b3e95ff427`.

| Draft statement | Exact proof dependency | Author-side check and surviving boundary |
|---|---|---|
| Theorem 1 and Corollary 1 | R13 `math/AUDIT.md` §§1–8; R19A `raw_target_iff_blocker`, `ordered_raw_target_iff_blocker`, `raw_attained_minimum` | Receiver fine remains on the receiver. Actual consistency and arbitrary mixed continuation reasoning precede the blocker formula. One order works across models; equilibria may vary. Existential favorable ties do not imply every equilibrium is silent. |
| Theorem 2 | R15 `math/RESULTS.md` §1 and Theorem A; R16 `math/FOUNDATION_AUDIT.md` | Nonempty compact convex positive families and one known contextual sender are retained. This is not optimized-only minimality or arbitrary nonconvex support sufficiency. Exact-interface coarseness is not advertised as a newly compiled Lean theorem. |
| Theorem 3 | R15 Theorem A; R16 foundation audit items 1–2; R19B interface/realization/rational-query and joined scope | Sion's convex/concave premises and the [0,1] weight box remain explicit. Rational queries preserve the supremum and strict separation; rational attainment is not claimed. |
| Theorem 4 | R15 Theorem B; R19B product/reuse scope | Directed errors add exactly. Symmetric errors only satisfy the stated bound. Independent repeats are not tied parameters or one reused lottery. |
| Theorem 5 | R15 §3; R16 planar proof §4; R18 contract | Every source/decoded vertex is covered; a convex hull is not a set of logged vertices. Beta is strictly below gamma for completeness. Incomplete computation is UNKNOWN, not REFINE. |
| Theorem 6 | R16 `PLANAR_RATE.md` §§1–4; `BIT_MODEL.md`; R15 packing and R16 foundation audit item 4 | Fixed positive box, deterministic uniform coding, all contextual queries, source-readable verification, source-storage exclusion and expanded memory are visible. The short draft proof incorporates, rather than replaces, the detailed technical construction. |
| Theorem 7 | R16 `BIT_MODEL.md`, composition contracts B/C; R19B reuse scope | Per-code storage is distinguished from k transmissions. The collision argument uses completeness on separated queries and no decoder source access. No generic new tensorization principle is claimed. |
| Transfer discussion | R20/R21 phase proofs; R22 at `221354c025861e58e7ba7667321aa305860d7bab` | Changed instruments are explicitly outside Theorems 1–7. R22's sender fine, audit lottery, joint uncertainty and positive-cost query domain are not imported silently into the core game. |

## 2. Adversarial scope controls retained in the draft

The integration deliberately rejects the following tempting but unsupported
strengthenings. These are safeguards, not newly discovered defects in the original
theorems.

1. “A blocker makes every equilibrium silent.” False at permitted favorable ties;
   R13 supplies a mixed-equilibrium counterexample. The draft says existence.
2. “Every model has some order, so one order works for every model.” Wrong
   quantifier interchange; the draft optimizes after the worst-model margin.
3. “All support summaries are interchangeable.” Nonconvex unions, revisions and
   new sanction observability may require discarded information. Masks and transfer
   boundaries remain visible.
4. “A rational query attains every real maximizing discrepancy.” The proved
   statement is equality of suprema with strict rational separation, not necessarily
   rational attainment. The draft preserves this distinction.
5. “More accurate means universally reusable.” Unlimited independent reuse amplifies
   any finite-code collision; reuse counts and final-margin contracts remain explicit.
6. “Zero extra certificate bits means a source-free certificate.” It does not.
   Source access and verification work are charged separately from the query payload.
7. “Small code means small decoded state and efficient general order search.” Neither
   follows. The expanded grid and factorial reference are stated separately.
8. “All seven old CI jobs plus R22 certify every manuscript claim.” They do not.
   The new transfer is not Lean-checked; entropy and adapter obligations persist.
9. “R22 vertex exactness repairs R18 by checking only vertices.” It does not.
   Linear-fractional projective geometry is objective-specific; R18's product/log
   queries can have essential interior witnesses.
10. “Stable cooperation is good cooperation.” The target's desirability and any
    application to war require separate empirical and normative arguments.

## 3. Independent review handoff

A reviewer should supply a report against the full manuscript commit, not merely
against a moving branch. The minimum report should resolve these four questions:

- Do the stated game, observability, timing, parameter knowledge, commitment and
  equilibrium quantifiers match the primitive and formal objects actually used?
- Do Theorems 2–5 use only the permitted contexts, retain their convexity/positivity
  premises and correctly interpret one-sided error, finite masks and incomplete work?
- Do Theorems 6–7 count all information and distinguish source access, extra witness
  bits, expanded computation and bounded versus unlimited reuse?
- Does the literature comparison contain a matching-assumption implication that
  makes a candidate theorem a known specialization, or does a specific mathematical
  connection remain to be established?

Requested outputs are an annotated theorem table, any counterexample or exact
missing premise, and a disposition for each finding: actual correction, clarification
of an existing premise, reviewer-proposed strengthening, or outside scope. A review
is useful even when it finds no new theorem or no publication novelty.

A separate formal review should identify the actual compiled statements and
axiom/dependency audits. Remote replay is not a different proof-kernel implementation.
No independent reviewer response is fabricated in this packet.

## 4. What this continuation executed

R22 supplies complete written arguments for the joint inspection frontier,
marginal-dependence collision, clipped operational curve, rational polytope
realization, sharp directed error bound, independent serial/finite-mask composition
and a second unsupported-reward-attachment collision. Its primitive oracle was
written separately from its query formula in this same session. It remains
same-session exact evidence, not independent human validation.

At research commit `221354c025861e58e7ba7667321aa305860d7bab`:

- [R22 run 35671492618](https://github.com/saykig/decision-interfaces/actions/runs/35671492618)
  passed its exact replay job, including receipt equality and normal/optimized runs.
- [Research run 35671492629](https://github.com/saykig/decision-interfaces/actions/runs/35671492629)
  passed all seven existing jobs, including the strategic/interface Lean rebuild.

These are eight successful jobs across two workflows at that source commit, not
eight new theorem proofs. R22's receipt records 33,205 individual exact checks over
156 source families with nine queries each. Historical R01–R21 source files and
receipts were not rewritten. The integrated manuscript and this packet are later
expository additions, not new Lean source.

Execution used the authenticated GitHub connector for repository reads and
non-forced commits to main. Local new-code tests ran in a partial workspace, not
a full clone. The shell could not resolve GitHub and public raw-download attempts
were unavailable. The user's macOS checkout was not accessed; no statement about
its current working-tree cleanliness is made. The application repository was not
modified.

## 5. Current next bounded goal

**Paper closure:** obtain independent statement/model-fidelity and source review of
this integrated draft. Integration is complete as v0.1; independent review remains
an unclosed gate, not a reason to claim publication readiness.

**Next implementable mathematical assurance:** formalize R22's T1/T3 bridge:
actual two-leaf audit payoff and mixed best reply -> attained robust fine ->
clipped joint profile -> finite rational V-input interpretation. Then check the
executable adapter against those declared formal objects. Acceptance requires
compiled statements without admitted/custom axioms, source/statement mapping,
exact threshold and negative-domain controls, and a source-pinned replay. No such
new Lean build has been performed in this continuation.

**Next prospective transfer:** only after choosing that separate task, test a
two-sender shared-parameter inspection model. Derive its continuation/blocker
condition from primitives before testing composability of the one-sender curve.
A failure should earn an enlarged interface; a success should earn a proof and
error law. No dynamic, bargaining or vector-instrument programme is precommitted.

See [R22's progress and D64–D67](../research/joint_inspection_2026_09_21/README.md#10-progress-decisions-and-next-bounded-work)
for the detailed mathematical continuation record. The August 13 and September 20
north-star statements and historical ledgers retain their original meaning.
