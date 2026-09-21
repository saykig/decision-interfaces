# Decision Interfaces

[![Research verification](https://github.com/saykig/decision-interfaces/actions/workflows/research-verification.yml/badge.svg)](https://github.com/saykig/decision-interfaces/actions/workflows/research-verification.yml)

The canonical mathematical-foundation repository for reusable decision interfaces
under uncertainty, strategic interaction and composition. It owns future theorem
development, proofs, counterexamples, verification, source notes and mathematical
provenance, including the research trail that led to the current results.

The first foundation paper asks:

> What must a representation retain to preserve a declared family of strategic
> decisions, and how do accuracy, composition and reuse constrain its size?

The mathematics has a publication path independent of the CEES degree requirement.
The current enforcement benchmark supplies precise objects and test cases;
broader applicability must follow from explicit assumptions and results.

## Two repositories, distinct responsibilities

| Repository | Responsibility |
|---|---|
| **decision-interfaces** | Mathematical foundations, theorem statements and proofs, verification and formalization, literature comparison, corrections and full mathematical provenance. |
| [cooperation-enforcement](https://github.com/saykig/cooperation-enforcement) | Application and proving ground for the Ukraine-focused CEES paper: empirical evidence, operational interpretation, application-specific modelling and evaluation. NATO/coalition context belongs there when it supports that European focus. |

Applications cite a full foundation commit, exact result/path, assumptions and
verification status. A mathematical theorem establishes a conditional result;
it does not establish an empirical hypothesis about Ukraine without separate
evidence. See the [research programme and citation contract](RESEARCH_PROGRAMME.md).

## Start here

- [Working ground and research phases](docs/working-ground/README.md)
- [Research progress](docs/working-ground/PROGRESS.md) and [decisions/corrections](docs/working-ground/DECISIONS.md)
- [North star](docs/working-ground/research/foundations/NORTH_STAR.md), preserving the August 13 statement and September 20 clarification
- [Verification ledger](docs/working-ground/VERIFICATION.md) and [formalization backlog](docs/working-ground/FORMALIZATION_BACKLOG.md)
- [R15 enforcement-sufficient interfaces](docs/working-ground/research/enforcement_codec_2026_09_20/README.md)
- [R16 optimal bits and composition/reuse contract](docs/working-ground/research/optimal_bits_2026_09_21/README.md)
- [Import provenance and recovery](docs/working-ground/FOUNDATION_HANDOFF.md)

R16 records matching planar storage rates and a bounded-versus-unlimited reuse
boundary, with written proofs and exact executable evidence. R14 has scoped Lean
coverage of beliefs, receiver choices and continuation gains. Full target-existence
and the attained minimum-fine theorem remain written proofs; R15/R16 have no new
Lean proofs. Historical missing executables and unrun experiments remain explicitly
recorded. A green CI run covers only the suites and formal statements it executes.

## Current executable coverage

[R18 composed queries](docs/working-ground/research/composed_queries_2026_09_21/README.md)
connects R16 binary payloads to arbitrary rational V-polytope attachments, multiple
compressed components, bounded repeated independent occurrences, and exact finite
label/tree masks. It preserves ZERO/FULL/REFINE/UNKNOWN, with rational witnesses,
trusted exact backends and comparisons to R10/R12 and the primitive R13 game.
This closes the declared reference-query integration gate; the two Lean bridges
and continuous-enforcement research remain separate obligations.

## Provenance

Established on September 21, 2026 from cooperation-enforcement commit
[`7dfd6ae183ce8a1e68648993661be2e39b31f16a`](https://github.com/saykig/cooperation-enforcement/commit/7dfd6ae183ce8a1e68648993661be2e39b31f16a).
All 43 commits reachable from that source tip and all 273 tracked files were
inherited without rewriting history. Mathematical research files retain their
original paths and bytes. New guidance and appended handoff entries establish the
new ownership boundary. The source repository retains its complete mathematics
and history for later user-directed cleanup.
