# Research programme and repository boundary

Effective September 21, 2026. This document establishes current ownership and
publication guidance. The [north star](docs/working-ground/research/foundations/NORTH_STAR.md)
retains the intellectual purpose and its dated clarifications. Earlier notes that
say all research belongs in cooperation-enforcement describe the pre-handoff state.

## Mathematical foundation paper

Decision Interfaces owns the reusable mathematical argument independently of any
Ukraine application or CEES requirement. A working title is **Decision Interfaces:
Sufficient Representations for Strategic Decisions under Uncertainty and Composition**.
This is a research direction, not a claim of publication readiness or universality.

The candidate theorem chain is:

1. State the primitive strategic model and equilibrium concept, including information
   sets, beliefs, timing, ties and quantifiers (R08, audited in R13; scoped R14 Lean bridge).
2. Define the enforcement-sufficient interface and contextual discrepancy, and state
   exactly which queries it preserves (R15 and R16 foundation audit).
3. Present representation bounds with their probability domain, dimensionality,
   accuracy, source access and computational model (R16).
4. Prove composition and reuse guarantees under independent or explicitly labelled
   dependencies, including finite budgets, unlimited-repeat impossibility and
   refinement near decision boundaries (R15–R16).
5. Separate written proofs, exact certificates, numerical evidence, formal statements
   and external replay; retain the full development trail behind the paper.

R01–R12 remain reusable foundations, antecedents, alternate directions and
counterexamples. Inclusion in the first manuscript depends on actual dependencies,
not chronology. Existing neighbouring mathematics must be credited; novelty remains
a claim to investigate. Human–machine simulations, Ukraine analysis and a universal
decision architecture are not prerequisites for completing this foundation paper.

The immediate assurance priorities remain the R08/R14 target-existence and backward
construction formalization, followed by the R15 rational-sandwich/contextual-interval
bridge. See the existing [backlog](docs/working-ground/FORMALIZATION_BACKLOG.md).
This handoff does not execute those projects or promote their status.

## Ukraine-focused CEES application paper

Cooperation-enforcement owns the European-security research question, Ukraine case
selection, hypotheses, empirical sources, operationalization, application-specific
models, simulations and interpretation. NATO interoperability can supply relevant
context. It includes enough mathematics to explain and justify the application,
while citing reusable results and their full development in this repository.

A theorem proves what follows from its premises. Evidence must separately establish
whether those premises describe the case and whether the substantive hypothesis is
supported, contradicted or unresolved. Neither a simulation nor a mathematical
existence result alone proves a real-world claim about war.

Other domain applications may follow when their assumptions match the interfaces.
The foundation programme is not intellectually bounded by the CEES application.

## Stable dependency and citation contract

For each foundation result used by an application, record:

- Repository `saykig/decision-interfaces` and the **full 40-character commit SHA**.
- Exact file path, theorem/lemma/section identifier and a commit-pinned permalink.
- The statement actually used and the mapping from application quantities to its
  assumptions, including dependence, information, timing and equilibrium choices.
- Evidence status at that commit and known limitations or unresolved dependencies.
- For executable results: entry point, input/configuration, pinned dependencies and
  receipt. Identify separately any application data and empirical evidence.

Use URLs of the form `https://github.com/saykig/decision-interfaces/blob/<full-commit>/<path>`.
A branch URL or an unversioned label such as “R16” is insufficient. A commit pins an
edition; it does not certify the theorem. A tag/release may supplement the SHA.

The initial source edition is already addressable in this repository at
[`7dfd6ae183ce8a1e68648993661be2e39b31f16a`](https://github.com/saykig/decision-interfaces/commit/7dfd6ae183ce8a1e68648993661be2e39b31f16a).
For example, the [R16 planar-rate proof at that edition](https://github.com/saykig/decision-interfaces/blob/7dfd6ae183ce8a1e68648993661be2e39b31f16a/docs/working-ground/research/optimal_bits_2026_09_21/math/PLANAR_RATE.md)
is a written proof with the scoped computational evidence described in its phase;
this example does not assert that the CEES paper already uses that result.

Select and audit the required results before treating any foundation edition as an
application dependency. Upgrade a pin deliberately, recording affected claims and
rechecking the mapping. If a correction changes a premise or conclusion, preserve
the earlier edition, add a dated correction here and assess downstream consequences
in the application repository. Do not silently float applications to `main`.

## Working and provenance policy

- Develop reusable theorems, proofs, verification and mathematical source records
  here. Record application evidence and Ukraine interpretation in cooperation-enforcement.
- If an application reveals a general gap, resolve and document the mathematics here,
  then cite the resulting commit from the application. Application-specific derivations
  may remain with the application when their scope is explicit.
- Keep research directly under `docs/working-ground/`, with dated phases and ledgers.
  Preserve failed attempts, corrections and receipts; do not create a competing archive.
- Preserve the source mathematical history. Any later cleanup is a separate task;
  retained copies there are historical records, not a second active foundation track.
- No new mathematical claims, proof upgrades, external-source recovery or licence
  grants are implied by this migration. Original author dates and missing artifacts
  retain their recorded meaning.
