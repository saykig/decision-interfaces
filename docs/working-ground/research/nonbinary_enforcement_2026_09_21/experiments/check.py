"""R20 exact report-sanction frontier checks against the R13 primitive game.

The game side expands states, histories and behavioral continuations. The
suffix formula occurs only on the prediction side. Z3 answers are trusted
exact-backend evidence, not independently checked proof certificates.
"""
from fractions import Fraction as F
from itertools import permutations, product
from pathlib import Path
import hashlib
import json
import math
import platform
import sys

HERE = Path(__file__).resolve().parent
PRIMITIVES = HERE.parents[1] / 'game_cascade_audit_2026_09_19' / 'experiments'
sys.path.insert(0, str(PRIMITIVES))
import z3
from game import Game, require
from mixed import solve


def frontier(p, k, eta, order):
    return max(F(0), min(eta[i] * math.prod(p[h] for h in order[j + 1:]) - k[i]
                         for j, i in enumerate(order)))


def robust_finite(points, k, eta):
    return min(max(frontier(p, k, eta, order) for p in points)
               for order in permutations(range(len(k))))


def poly_cascade(vertices, k, eta, order, e):
    """Exact strict feasibility on an entire rational convex hull, never a grid."""
    rv = lambda x: z3.RealVal(str(x))
    weights = [z3.Real('w_' + str(i)) for i in range(len(vertices))]
    solver = z3.SolverFor('QF_NRA')
    solver.set(timeout=30000)
    solver.add(z3.Sum(weights) == 1, *(w >= 0 for w in weights))
    p = [z3.Sum([w * rv(v[i]) for w, v in zip(weights, vertices)])
         for i in range(len(k))]
    for j, i in enumerate(order):
        suffix = math.prod(p[h] for h in order[j + 1:])
        solver.add(rv(eta[i]) * suffix > rv(k[i] + e))
    answer = solver.check()
    require(answer != z3.unknown, 'Incomplete polytope check: ' + solver.reason_unknown())
    return answer == z3.sat


def run():
    fixtures = [
        ('one', [F(1,3)], [F(1,4)], [F(1)]),
        ('two_low', [F(1,3)] * 2, [F(1,4)] * 2, [F(1)] * 2),
        ('two_high', [F(1,2)] * 2, [F(1,4)] * 2, [F(1)] * 2),
        ('zero', [F(1,3), F(1,2)], [F(3,4), F(1,8)], [F(1)] * 2),
        ('sharp_q', [F(1,2), F(1,3)], [F(1,4), F(1,8)], [F(1), F(2)]),
        ('sharp_p', [F(1,2)] * 2, [F(1,4), F(1,8)], [F(1), F(2)]),
        ('three', [F(1,3), F(2,5), F(1,2)], [F(1,32)] * 3, [F(1)] * 3),
        ('heterogeneous', [F(1,4), F(1,3), F(1,2)],
         [F(1,40), F(1,10), F(1,8)], [F(3,2), F(2), F(1)]),
        ('large_denominator', [F(1,2) - F(1,10**24), F(1,3)],
         [F(1,4), F(1,8)], [F(1)] * 2),
    ]
    primitive_rows = []
    payoff_checks = pure_profiles = 0
    for name, p, k, eta in fixtures:
        for order in permutations(range(len(p))):
            threshold = frontier(p, k, eta, order)
            probes = {F(0), threshold, threshold + F(1,10**25)}
            if threshold > 0:
                probes.add(threshold - min(threshold / 2, F(1,10**25)))
            for e in sorted(probes):
                # Explicit primitive payoff translation at every terminal action
                # and report flag, before invoking the inherited game evaluator.
                for i, d, report in product(range(len(p)), (0,1), (0,1)):
                    direct = eta[i]*d - k[i]*report - e*report
                    translated = eta[i]*d - (k[i]+e)*report
                    require(direct == translated, 'Incorrect sanction translation')
                    payoff_checks += 1
                g = Game(p, [cost+e for cost in k], eta, order=order)
                _, _, assessment = g.backward_candidate(F(0))
                answer = solve(g, F(0))
                expected = e >= threshold
                require(assessment['target'] == answer['exists'] == expected,
                        'Primitive frontier mismatch: ' + name)
                if len(p) <= 2 and e == threshold:
                    equilibria, count = g.pure_equilibria(F(0))
                    pure_profiles += count
                    require(any(a['target'] for _, _, a in equilibria),
                            'Attained endpoint missing from exhaustive pure plans')
                primitive_rows.append({'name': name, 'order': list(order),
                                       'sanction': str(e), 'minimum': str(threshold),
                                       'target': expected})

    # Whole rational interval formula; exact evaluated members are illustrations,
    # while the interval-wide derivation is in math/RESULTS.md.
    interval = []
    for t in (F(1,3), F(3,8), F(2,5), F(1,2)):
        value = robust_finite([(t,t)], [F(1,4)]*2, [F(1)]*2)
        require(value == t-F(1,4), 'Nonbinary interval mismatch')
        interval.append({'t': str(t), 'minimum': str(value)})

    k2, eta2 = [F(1,4)]*2, [F(1)]*2
    models = [(F(1,2),F(1,4)), (F(1,4),F(1,2))]
    common = robust_finite(models, k2, eta2)
    modelwise = max(robust_finite([p], k2, eta2) for p in models)
    require(common == F(1,4) and modelwise == 0, 'Common-order counterexample lost')

    # Anti-correlated source, interior maximum, and dominated-point collision attack.
    q = [(F(1,2),F(1,4),F(1,2)), (F(1,2),F(1,2),F(1,4))]
    same_downward = q + [(F(1,2),F(1,4),F(1,4))]
    rectangle = q + [(F(1,2),F(1,4),F(1,4)), (F(1,2),F(1,2),F(1,2))]
    k3, eta3 = [F(1,16)]*3, [F(1)]*3
    interior = (F(1,2),F(3,8),F(3,8))
    interior_threshold = F(5,64)
    require(frontier(interior,k3,eta3,(0,1,2)) == interior_threshold, 'Interior value')
    require(max(frontier(v,k3,eta3,(0,1,2)) for v in q) == F(1,16), 'Vertex value')
    poly_checks = 0
    for vertices, threshold in [(q,interior_threshold), (rectangle,F(3,16))]:
        require(not poly_cascade(vertices,k3,eta3,(0,1,2),threshold), 'Boundary unsafe')
        require(poly_cascade(vertices,k3,eta3,(0,1,2),threshold-F(1,10**25)),
                'Below boundary incorrectly safe')
        poly_checks += 2
    for order in permutations(range(3)):
        for e in (F(0),F(1,16),F(5,64),F(1,8),F(3,16)):
            require(poly_cascade(q,k3,eta3,order,e) ==
                    poly_cascade(same_downward,k3,eta3,order,e),
                    'Equal downward interface changed frontier answer')
            poly_checks += 2

    # Sharp directed error bound, including optimization over all common orders.
    sharp_k, sharp_eta = [F(1,4),F(1,8)], [F(1),F(2)]
    eq = robust_finite([(F(1,2),F(1,3))],sharp_k,sharp_eta)
    ep = robust_finite([(F(1,2),F(1,2))],sharp_k,sharp_eta)
    a, cost_max = F(3,2), F(1,4)
    require(eq == F(1,12) and ep == F(1,4), 'Sharp example minima')
    require(ep == a*eq+(a-1)*cost_max, 'Sharp bound not attained')

    files = [Path(__file__), PRIMITIVES/'game.py', PRIMITIVES/'mixed.py']
    return {
        'phase': 'R20', 'research_date': '2026-09-21',
        'evidence': 'exact rational primitive state/path checks and trusted Z3 arbitrary-mixed/polytope feasibility; no new Lean proof',
        'python': platform.python_version(), 'z3': z3.get_version_string(),
        'primitive_mixed_queries': len(primitive_rows),
        'primitive_backward_assessments': len(primitive_rows),
        'terminal_payoff_translation_checks': payoff_checks,
        'exhaustive_pure_profiles': pure_profiles,
        'polytope_solver_queries': poly_checks,
        'nonbinary_values': interval,
        'common_order_counterexample': {'modelwise': str(modelwise), 'common': str(common)},
        'interior_counterexample': {'interior': '5/64', 'vertices': '1/16'},
        'sharp_error': {'e_q': str(eq), 'e_p': str(ep), 'exp_delta': str(a), 'max_cost': str(cost_max)},
        'primitive_cases': primitive_rows,
        'dependencies_sha256': {str(p.relative_to(HERE.parents[1])):
                                hashlib.sha256(p.read_bytes()).hexdigest() for p in files},
    }


if __name__ == '__main__':
    print(json.dumps(run(), indent=2, sort_keys=True))
