"""Deterministic exact R22 checks. A finite replay is not a general proof.

The primitive oracle enumerates audit outcomes and checks both receiver actions;
it does not call frontier/profile/envelope. Assertions are not used, so -O runs
exactly the same checks. No dependencies beyond Python's standard library.
"""
from __future__ import annotations

from collections import Counter
from fractions import Fraction as F
from hashlib import sha256
from itertools import combinations, product
import json
from pathlib import Path

from joint import (discrepancy, envelope, envelope_value, frontier, masked_serial,
                   profile, safe, serial, source)

COUNTS: Counter[str] = Counter()


def check(condition: bool, category: str) -> None:
    if not condition:
        raise RuntimeError(f"failed {category}, prior counts={dict(COUNTS)}")
    COUNTS[category] += 1


def rejects(fn, category: str = "invalid_contract_rejection") -> None:
    try:
        fn()
    except (TypeError, ValueError):
        check(True, category)
    else:
        check(False, category)


def primitive(r: F, q: F, a: F, k: F, fine: F, mix: F) -> tuple[F, bool]:
    # Prior p=1/2, receiver payoffs A=2,B=1. Type zero can only be silent.
    posterior_s = F(1, 2) * (1 - mix) / (1 - F(1, 2) * mix)
    receiver_s_c = F(0)
    receiver_s_d = posterior_s - 2 * (1 - posterior_s)
    receiver_r_c, receiver_r_d = F(0), F(1)
    receiver_ok = receiver_s_c > receiver_s_d and receiver_r_d > receiver_r_c
    # Explicit detection/no-detection leaves, not the threshold formula.
    report = sum(prob * utility for prob, utility in
                 [(q, a * r - k - fine), (1 - q, a * r - k)])
    silent = F(0)
    # A linear mixture is a best reply iff it achieves the greater endpoint.
    best_reply = mix * report + (1 - mix) * silent == max(report, silent)
    return report, receiver_ok and best_reply


def run() -> dict:
    rewards = [F(1, 4), F(1, 2), F(1), F(2)]
    detections = [F(1, 8), F(1, 4), F(1, 2), F(3, 4)]
    atoms = list(product(rewards, detections))
    families = [source([p]) for p in atoms]
    families += [source(p) for p in combinations(atoms, 2)]
    # Twenty deterministic 2D/nondegenerate-or-degenerate triples.
    families += [source(p) for i, p in enumerate(combinations(atoms, 3)) if i % 28 == 0]
    queries = list(product([F(1, 2), F(1), F(2)], [F(1, 4), F(1), F(3)]))
    for points in families:
        pieces = envelope(points)
        check(pieces[0].left == 0 and pieces[-1].right is None, "envelope_coverage")
        check(all(p.right == n.left for p, n in zip(pieces, pieces[1:])), "envelope_coverage")
        for p in pieces:
            ts = [p.left, p.left + 1] if p.right is None else [p.left, (p.left + p.right) / 2, p.right]
            for t in ts:
                check(p.value(t) == profile(points, t), "exact_envelope_replay")
        for a, k in queries:
            e = frontier(points, a, k)
            check(e == a * envelope_value(pieces, k / a), "query_profile_identity")
            check(safe(points, a, k, e), "affine_feasibility_at_threshold")
            if e > 0:
                check(not safe(points, a, k, e / 2), "strict_lower_fine_failure")
            for fine in [e, e + F(1, 16)] + ([e / 2] if e else []):
                targets = []
                for r, q in points:
                    report, is_target = primitive(r, q, a, k, fine, F(0))
                    check(report == a * r - k - fine * q, "primitive_lottery_identity")
                    targets.append(is_target)
                    for mix in [F(1, 3), F(1)]:
                        gain, equilibrium = primitive(r, q, a, k, fine, mix)
                        check(equilibrium == (gain == 0 or (gain > 0 and mix == 1)),
                              "mixed_best_reply_replay")
                check(all(targets) == (fine >= e), "primitive_target_threshold")
            # Interior model replay and projective convex-combination identity.
            if len(points) > 1:
                weights = [F(i + 1, sum(range(1, len(points) + 1))) for i in range(len(points))]
                r = sum(w * p[0] for w, p in zip(weights, points))
                q = sum(w * p[1] for w, p in zip(weights, points))
                report, target = primitive(r, q, a, k, e, F(0))
                check(target and report <= 0, "interior_model_replay")
                mu = [w * p[1] / q for w, p in zip(weights, points)]
                check(sum(mu) == 1 and all(m >= 0 for m in mu), "projective_weights")
                check((r / q, 1 / q) ==
                      (sum(m * p[0] / p[1] for m, p in zip(mu, points)),
                       sum(m / p[1] for m, p in zip(mu, points))), "projective_identity")

    aligned = source([(1, "1/4"), (2, "1/2")])
    opposed = source([(1, "1/2"), (2, "1/4")])
    check({r for r, _ in aligned} == {r for r, _ in opposed} and
          {q for _, q in aligned} == {q for _, q in opposed}, "marginal_collision")
    check(frontier(aligned, 1, "1/2") == 3 and frontier(opposed, 1, "1/2") == 6,
          "marginal_collision")
    for a, k in queries:
        rectangle = source(product([1, 2], [F(1, 4), F(1, 2)]))
        check(frontier(aligned, a, k) <= frontier(rectangle, a, k), "rectangular_outer_bound")

    # Endpoint and ratio clipping, dominated points, and a true switch at t=1/2.
    switch = source([(1, "1/4"), (2, "1/2")])
    check(envelope(switch) == ((F(0), F(2), F(4), F(2)),
                               (F(2), None, F(0), F(0))), "dominated_line_removal")
    switch2 = source([(1, "1/4"), (2, "3/4")])
    check(any(p.left == F(1, 2) for p in envelope(switch2)), "nontrivial_breakpoint")
    dominant = source([(2, "1/4")])
    dominated = source([(2, "1/4"), (1, "1/2")])
    check(envelope(dominant) == envelope(dominated), "operational_not_full_hull_equality")
    for k in [2, 3, 10]:
        check(frontier(aligned, 1, k) == 0, "zero_clipping")
    check(discrepancy(dominant, dominated, 0, 10) == 0, "exact_discrepancy")
    check(discrepancy(aligned, opposed, 0, 2) == 4, "exact_discrepancy")
    for t in [F(i, 16) for i in range(33)]:
        check(abs(profile(aligned, t) - profile(opposed, t)) <=
              discrepancy(aligned, opposed, 0, 2), "discrepancy_interior_replay")

    # Bound e_P <= e_Q + (a*eps_r + e_Q*eps_q)/q_floor, with equality.
    for q0, dq, dr, a, k in product([F(1, 8), F(1, 4)], [F(0), F(1, 8)],
                                   [F(0), F(1, 3)], [F(1), F(2)], [F(1, 4), F(1, 2)]):
        p, q = source([(1 + dr, q0)]), source([(1, q0 + dq)])
        ep, eq = frontier(p, a, k), frontier(q, a, k)
        check(ep == eq + (a * dr + eq * dq) / q0, "sharp_error_bound")
    for m in [8, 16, 32, 64]:
        p, q = source([(1, F(1, m))]), source([(1, F(2, m))])
        check(frontier(p, 1, "1/2") - frontier(q, 1, "1/2") == F(m, 4),
              "detection_floor_necessity")

    for points in [aligned, opposed, switch2]:
        for a, k in queries:
            expanded = source([(r, q * F(1, 2) * F(1, 3)) for r, q in points])
            check(serial(points, [F(1, 2), F(1, 3)], a, k) == frontier(expanded, a, k),
                  "independent_serial_composition")
            check(serial(points, [F(1, 2)] * 3, a, k) == frontier(points, a, k) * 8,
                  "repeated_stage_accounting")
    components = {"low": source([(1, "1/2")]), "high": source([(2, "1/2")])}
    floors = {"low": F(1, 4), "high": F(3, 4)}
    masked = masked_serial(components, floors, [("low", "low"), ("high", "high")], 1, "1/2")
    rectangular = masked_serial(components, floors, product(components, floors), 1, "1/2")
    check(masked == 4 and rectangular == 12, "shared_mask_counterexample")
    check(masked_serial(components, floors, [], 1, "1/2") is None, "infeasible_not_zero")
    check(masked_serial(components, floors, [("low", "low")], 1, 3) == 0,
          "infeasible_not_zero")

    # Same ordinary profile, different answers after adding a background reward.
    # Zero reward is NOT accepted by the model, so use a positive dominated point.
    base = source([(2, "1/2")])
    extra = source([(2, "1/2"), (F(1, 4), "1/8")])
    check(envelope(base) == envelope(extra), "unsupported_reward_attachment_collision")
    # b=4,k=1 means effective cost -3, deliberately outside profile's t>=0 API.
    translated_base = source([(r + 4, q) for r, q in base])
    translated_extra = source([(r + 4, q) for r, q in extra])
    check(frontier(translated_base, 1, 1) == 10 and frontier(translated_extra, 1, 1) == 26,
          "unsupported_reward_attachment_collision")

    for points in [[], [(1, 0)], [(1, 1)], [(0, "1/2")], [(-1, "1/2")], [(1.0, "1/2")]]:
        rejects(lambda p=points: source(p))
    rejects(lambda: frontier(aligned, 0, 1))
    rejects(lambda: frontier(aligned, 1, 0))
    rejects(lambda: safe(aligned, 1, 1, -1))
    rejects(lambda: profile(aligned, -1))
    rejects(lambda: serial(aligned, [0], 1, 1))
    rejects(lambda: discrepancy(aligned, opposed, 2, 1))
    rejects(lambda: masked_serial(components, floors, [("missing", "low")], 1, 1))
    rejects(lambda: masked_serial(components, {"bad": 0}, [], 1, 1))

    here = Path(__file__).resolve().parent
    return {"phase": "R22", "evidence": "exact rational finite checks; not Lean or independent human review",
            "source_families": len(families), "queries_per_family": len(queries),
            "checks": dict(sorted(COUNTS.items())), "total_checks": sum(COUNTS.values()),
            "sha256": {p.name: sha256(p.read_bytes()).hexdigest()
                       for p in [here / "joint.py", here / "check.py"]}}


if __name__ == "__main__":
    print(json.dumps(run(), indent=2, sort_keys=True))
