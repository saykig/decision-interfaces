# R22 reusable inspection library

The public import is `Inspection`. It joins the physical one-sender audit model,
actual Bayesian/tremble consistency, attained robust fine, positive-query profile,
Mathlib projective convex hulls, rational input specification and directed error
transport. `audit_target_from_approximation` is a downstream theorem that imports
and reuses these definitions and results.

See [formal scope, model map, evidence and remaining work](../FORMAL_SCOPE.md).
The original R22 README and earlier receipts retain their historical status;
this continuation records newly compiled formal coverage separately.

Run `verify.py --packages <existing pinned .lake/packages> --output <fresh.json>`.
It rebuilds the modules in dependency order, generates finite test theorems from
actual Python adapter outputs, and audits every discovered named declaration's
transitive axioms. Allowed dependencies are only `propext`, `Classical.choice`
and `Quot.sound`. Lean is `v4.33.1`; Mathlib is pinned at
`0df444a360eaa60ab8c11dca51a86af692955474`.

To extend the library, add a `.lean` file importing `Inspection`, then include
that module after `Inspection` in the verifier's `MODULES`, or use the same build
search paths. The fresh temporary build is removed after verification. This is
an importable source library using the repository's existing build convention,
not a newly published standalone Lake package or an executable policy engine.

T1 and the selected T3 bridges are covered. T4's directed inequality is covered,
but general sharpness and the interval-envelope algorithm remain written/tested.
T5 composition and masks remain written/tested, not newly Lean-formalized.
Python implementation correctness is supported by finite cross-language replay;
it is not proved for all inputs. Independent human model/statement review remains
separate. Nothing here establishes that the model fits a real institution.
