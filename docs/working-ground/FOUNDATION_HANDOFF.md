# September 21, 2026 foundation handoff

## Source and scope

- Source: `https://github.com/saykig/cooperation-enforcement`.
- Source branch: `main`.
- Source commit: `7dfd6ae183ce8a1e68648993661be2e39b31f16a`.
- Destination: `https://github.com/saykig/decision-interfaces`, `main`.
- Inherited history: all 43 commits reachable from the source tip, with original
  commit IDs, parentage, authors and timestamps; no filtering, squashing or rewriting.
- Inherited snapshot: all 273 tracked files, including research, ledgers, source
  notes, experiments, receipts, Lean files and the existing CI workflow.
- Research subtree: 263 tracked files; Git tree `bf280846f6c7d0cc0df52fb97d3c51bba2f311e9`.

The entire source snapshot is small and research-focused, so it was copied as a
whole to avoid losing mathematical context or breaking relative imports and links.
The new repository is public, matching the source. No licence was added.
No extra development branch was created.

All files under `docs/working-ground/research/` and the verification workflow are
unchanged at the handoff. Root README and agent guidance are replaced here; the
working-ground entry point and progress/decision ledgers gain dated handoff notes.
`RESEARCH_PROGRAMME.md` supplies the current publication and citation contract.

The source repository receives only agent boundary guidance and dated ledger entries.
Both source README files remain untouched at the user's request.
Its mathematical artifacts, verification files and historical commits remain intact.
Later source cleanup has not been performed.

## Recovery and limitations

Inherited records remain at their original paths. Use `git show <commit>:<path>`
to recover an earlier edition. Existing references to cooperation-enforcement,
Bellman, old repository defaults or temporary instructions inside research notes
retain their historical meaning; current routing is in the root guidance.
`TRANSFER_SCOPE.md` records an earlier transfer and is not this handoff's inventory.

A full Git clone preserves the history reachable from the selected main tip, not
GitHub issues, pull-request discussions, Actions logs, unreachable objects or
external files. The source advertised only `main` and no tags at inspection.
Externally hashed files and missing R08/R15 executables have not been recovered;
R02's larger experiment remains unrun. Retaining their descriptions does not imply
new execution, formal verification, independent review or empirical validation.

## Check the copy

From the destination repository:

```sh
git merge-base --is-ancestor 7dfd6ae183ce8a1e68648993661be2e39b31f16a HEAD
git diff --exit-code 7dfd6ae183ce8a1e68648993661be2e39b31f16a HEAD -- docs/working-ground/research .github/workflows/research-verification.yml
git rev-parse HEAD:docs/working-ground/research
```

The ancestor check should succeed, the diff should be empty and the tree should
match the ID above. These are provenance/integrity checks, not theorem proofs.
For computational and Lean replay use the inherited research-verification workflow
and the phase-specific instructions; preserve their exact coverage boundaries.
