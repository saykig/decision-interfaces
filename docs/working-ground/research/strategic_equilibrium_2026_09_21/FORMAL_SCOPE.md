# Formal statement map and residual scope

## Assessment and equilibrium definitions

`RawAssessment` carries arbitrary behavioral sender and receiver strategies,
public beliefs at every public transcript, and private beliefs at every sender
information set/type. `RawAssessment.Consistent` requires a **single sequence** of
completely mixed feasible sender/receiver profiles converging to those strategies;
actual transcript and private-type Bayes probabilities must converge to those
belief fields simultaneously. The perturbations need not be equilibria.

`RawSequentialEquilibrium` adds sender feasibility and sequential rationality:
receiver expected payoff is computed by summing the explicit belief over Nature
states times the primitive defect payoff; sender expected payoff sums its explicit
private belief over states and then R14's full continuation-path expectation.
`SenderBestReply` and `BestReply` compare against every feasible mixed action.
Type zero has only its compulsory silent action. Each sender acts once, so there
is no omitted future decision by the same player or unproved one-shot-deviation
principle. No blocker, suffix inequality, or desired target is in this definition.

`raw_equilibrium_normalization` proves the belief fields of every such assessment
coincide with the uniquely derived R14 posterior system. `Assessment` and
`SequentialEquilibrium` are its canonical representation, used to simplify the
remaining proof. `raw_target_iff_canonical` proves equality of the unrestricted
and canonical target-existence questions; normal form is not a hidden restriction.

`SilentTarget` requires zero positive-type report probability at **each all-silent
prefix**, and zero receiver defection probability at the all-silent terminal
transcript. This is the behavioral on-path target stated in R13, under its full-
support prior. It allows arbitrary off-path behavior. A separate generic theorem
identifying this behavioral predicate with an externally encoded distributional
outcome event is not part of the source; no such external encoding is used here.

```yaml
LEAN: YES — Explicit assessment normalization prevents assumed posterior or cascade restrictions from entering the reusable equilibrium theorem.
```

## Backward argument and construction

| Declaration | Formally proved content |
|---|---|
| `equilibrium_chain_gain` | Derives the complete-prefix mixed incentive test from actual sequential rationality via R14's continuation theorem. |
| `no_mixed_rescue` | Reverse strong induction forces every report-chain positive type to report whenever every suffix test is strict. |
| `target_requires_blocker` | In particular the first positive type reports, contradicting its on-path silence; hence a target needs a weak blocker. |
| `last_blocker` | Any nonempty finite set of weak blockers has a final position, after which every test is strict. |
| `blocker_sender_rational` | Zero through the last blocker, one after it on the report chain, and zero at every broken prefix is rational at every sender history. |
| `blocker_target_equilibrium` | This sender strategy and the derived receiver rule have a common consistency sequence and satisfy the target. |
| `target_iff_blocker` | Both directions for canonical assessments and every sub-boundary nonnegative fine. |
| `raw_target_iff_blocker` | The same equivalence for arbitrary explicit-belief assessments. |
| `ordered_raw_target_iff_blocker` | The named-actor/permutation form with exactly the ordered suffix product. |

The product zero before the blocker, weak inequality at the blocker, and strict
inequalities after it are separate lemmas/cases. No pure-strategy restriction is
used in the necessity direction. Favorable sender ties appear only as a permitted
best reply with zero reporting at a nonpositive gain.

```yaml
LEAN: YES — The arbitrary-mixed backward argument and constructive converse are the thesis-bearing game-to-suffix bridge.
```

## Boundary and attained minimum

`receiver_silence_at_boundary` proves receiver cooperation at every history for
`e ≥ B`, using the primitive receiver payoff and posterior bounds. At complete
reports and `e=B`, the gain is zero, so cooperation is a favorable best reply.
`sender_gain_zero_receiver` derives a sender's gain as `-k` from the primitive
state/path sum, without a suffix assumption. `target_at_or_above_boundary` builds
the all-silent, always-cooperating consistent equilibrium.

`feasible_fines` characterizes every nonnegative fine. `minimumFine` is exactly
`if ∃ blocker then 0 else B`. `attained_minimum` proves an `IsLeast` statement for
the nonnegative target-feasible fines; `raw_attained_minimum` does so for the
unrestricted explicit-belief assessment. This is stronger than identifying an
infimum or merely giving a sufficient boundary fine.

```yaml
LEAN: YES — Attainment and favorable boundary ties are required for the exact zero-versus-full enforcement answer.
```

## Precise scope and assurance limits

- Finite `n > 0`, including the explicitly declared one-sender extension of R13's
  main `n ≥ 2` model. The empty sender case is not asserted by the equivalence.
- Independent private binary types, authenticated positive reports, full public
  transcript observation, no extra private signal or shared random device.
- Full-support priors below the strict receiver threshold, positive `A,B` and
  disclosure costs. The theorem itself accepts arbitrary real sender rewards;
  the original positive-reward domain is included without changing its primitives.
- One fixed order encoded by protocol position, no strategy shared across distinct
  actual prior models, and existential favorable tie selection.
- Every new theorem is Lean checked only after the associated receipt successfully
  compiles and audits the exact source hash. Allowed axioms are `propext`,
  `Classical.choice`, and `Quot.sound`; there is no custom axiom or admitted proof.
- No external kernel replay, independent human model review, generic game-framework
  embedding, public priority claim, or new empirical warrant is supplied.
- Robust quantification over uncertain families/common orders, log interfaces, and
  binary decoder correctness are separate downstream layers, not silently included.
