# Reusable enforcement interface — contract, not a universal API

21 September 2026. The operational target is reusability across explicitly declared
mathematical contexts. No empirical transfer is required in this repository.

A future serialized interface must identify the exact result/version, supported
queries, domains, shared labels, equilibrium/observation rules, error direction and
budget, source-binding audit, reuse budget and unsupported operations. R17 provides
a source-backed planar reference evaluator, not that full serialized system.

| Obligation | Existing basis | Current executable boundary / next work |
|---|---|---|
| Accuracy | R15/R16: `D(Q) <= D(P) <= s D(Q)` gives directed profile error at most `2 log(s)` for one planar block | R17 checks the rational sandwich; it returns sign brackets, not a numerical margin or a new bit-rate proof |
| Strategic questions | All-order/cost mathematical guarantee in the inherited benchmark | R17 enumerates all orders with one planar block and known-probability senders; general uncertain attachments remain next |
| Allowed reuse | Directed errors add for independent occurrences; up to k repeats needs a k-aware local budget | R17 does not accept multiple uncertain blocks or enforce a serialized reuse token; those need explicit integration |
| Shared dependencies | Labelled conditional products retain the exact compatibility mask; tree recursion computes the worst permitted error sum | Do not convexify the union or treat a scalar error message as the whole strategic interface |
| Refinement | A certified bracket crossing zero can require more source information | R17 `REFINE` is honest but exact ties may remain unresolved at every finite accuracy; no guaranteed refinement termination there |
| Computation | Finite exact search and complexity are separate | `UNKNOWN` on budget exhaustion; never infer no order from an incomplete search |
| Source trust | Verification refers to the actually supplied source | No source-free authentication or empirical truth follows from a successful inclusion check |
| Scope changes | New evidence can distinguish families sharing the same current interface | Recover the source/restate the interface for unsupported revisions; do not silently reuse a stale guarantee |

## Lean decisions

Formalize the strategic existence bridge now because it checks that the inequality
actually describes rational behavior in the encoded game. Formalize the sandwich
and margin bridge because it checks that compression preserves that behavior-related
conclusion. These are heavily reused premises, not decorative identities.

A passing Lean build must report exact statements, imports, toolchain and all axiom
dependencies. Do not use a custom axiom or `sorry` to assume the theorem being
advertised. A conditional theorem is useful, but label any unformalized premise.
See Lean's [validation instructions](https://lean-lang.org/doc/reference/latest/ValidatingProofs/).

Do not prioritize a complete binary-codec formalization yet: it leaves the more
important strategic interpretation unchecked. Do not formalize a rapidly changing
continuous-fine conjecture as though its definitions were settled. No new Lean
execution occurred in R17.
