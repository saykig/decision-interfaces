# R22 reusable inspection formalization — September 21, 2026

Work in progress. These new Lean sources require a successful source-bound build
and axiom audit before any formal-coverage claim is made. The historical R22
README and finite-check receipt remain unchanged.

The first modules separate primitive receiver/sender best replies, compact
worst-case attainment, and the operational profile. The source record is R22
README T1/T3 at base commit 5ea1f5059d155b0d6fdcd62768f7fa46bd75fd6d.

Run verify.py with --packages pointing to the existing pinned mathlib package
cache. The workflow joint-inspection-lean.yml records raw compiler output and,
only on success, a source-hashed axiom receipt. It uses the existing Lean v4.33.1
and mathlib 0df444a360eaa60ab8c11dca51a86af692955474, not a new dependency edition.

Important scope boundary: Consistent currently exposes algebraic Bayes equations
and authenticated report beliefs. A continuous posterior is proved, but a full
explicit tremble-witness connection is still to be supplied before claiming the
complete sequential-equilibrium consistency bridge. Projective convex hulls,
rational adapter fidelity, and boundary controls are also unfinished here.
No first-paper closure, new strategic model, novelty or empirical validity is claimed.
