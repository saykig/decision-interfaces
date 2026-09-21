"""Exact self-tests and separate SymPy raw-polynomial cross-checks."""
from collections import Counter
from fractions import Fraction as F
from itertools import permutations, combinations_with_replacement
from pathlib import Path
import hashlib
import json
import random
import sympy as s
from all_orders import cascade, optimize, check_sandwich

COUNTS = Counter()

def check(ok, category):
    if not ok:
        raise RuntimeError(category)
    COUNTS[category] += 1


def oracle(points, known, ratios, order):
    """No threshold aggregation: rebuild all original suffix polynomials."""
    t = s.Symbol('t', real=True)
    for a, b in combinations_with_replacement(points, 2):
        p = [s.Rational(a[i].numerator, a[i].denominator) + t*s.Rational((b[i]-a[i]).numerator, (b[i]-a[i]).denominator) for i in range(2)]
        p += [s.Rational(x.numerator, x.denominator) for x in known]
        terms = [t >= 0, t <= 1]
        for j, i in enumerate(order):
            q = s.prod(p[h] for h in order[j+1:]) - s.Rational(ratios[i].numerator, ratios[i].denominator)
            terms.append(q > 0)
        if s.reduce_inequalities(terms, t) is not s.false:
            return True
    return False


def direct_witness(w, known, ratios, order):
    p = tuple(w)+tuple(known)
    for j, i in enumerate(order):
        value = F(1)
        for h in order[j+1:]:
            value *= p[h]
        if value <= ratios[i]:
            return False
    return True


def main():
    rng = random.Random(210926)
    for n in range(2, 7):
        for _ in range(3):
            points = [(F(rng.randrange(1, 13), 20), F(rng.randrange(1, 13), 20))]
            known = [F(rng.randrange(1, 13), 20) for _ in range(n-2)]
            ratios = [F(rng.randrange(1, 31), 50) for _ in range(n)]
            for order in permutations(range(n)):
                got = cascade(points, known, ratios, order)
                check((got is not None) == direct_witness(points[0], known, ratios, order), 'all_order_singleton_checks')
    segment = [(F(1,4),F(1,2)),(F(1,2),F(1,4))]
    triangle = [(F(1,4),F(1,4)),(F(1,4),F(1,2)),(F(1,2),F(1,4))]
    for points, n in [(segment,3),(triangle,4),(segment,5)]:
        known = [F(1,2)]*(n-2)
        ratios = [F(1,10),F(1,10)]+[F(1,20)]*(n-2)
        for order in permutations(range(n)):
            got = cascade(points, known, ratios, order)
            check((got is not None) == oracle(points, known, ratios, order), 'raw_polynomial_crosschecks')
            if got is not None:
                check(direct_witness(got, known, ratios, order), 'original_suffix_witness_checks')
    fixtures = {}
    # Known sender 2 is not forced first: lexicographic prefix is tested too.
    for name, r2, expected in [('safe',F(1,5),'ZERO'),('unsafe',F(1,10),'FULL'),('exact_tie',F(9,64),'ZERO')]:
        answer = optimize(segment, segment, 1, [F(1,2)], [F(1,10),F(1,10),r2])
        check(answer['answer'] == expected, 'optimization_fixtures')
        fixtures[name] = answer
    lower = [(F(9,20),F(9,20))]
    source = [(F(1,2),F(1,2))]
    answer = optimize(source, lower, F(10,9), [F(1,2)], [F(1,10),F(1,10),F(23,100)])
    check(answer['answer']=='REFINE', 'honest_refinement')
    fixtures['refine'] = answer
    answer = optimize(source, source, 1, [F(1,2)], [F(1,10)]*3, max_orders=1)
    check(answer['answer']=='UNKNOWN', 'work_budget_is_not_refinement')
    fixtures['budget'] = answer
    check(not check_sandwich(source, [(F(1,10),F(1,10))], 1), 'wrong_source_sandwich')
    for pointlist, costs, order, expected in [
        (segment,[F(1,10),F(1,10),F(9,64)],(2,0,1),False),
        (segment,[F(1,10),F(1,10),F(9,64)-F(1,10**40)],(2,0,1),True),
        (segment,[F(1,2),F(1,10),F(1,100)],(2,0,1),False),
        (segment,[F(1,10),F(1),F(1,100)],(2,0,1),False)]:
        got=cascade(pointlist,[F(1,2)],costs,order)
        check((got is not None)==expected,'strict_and_narrow_boundaries')
    for _ in range(12):
        points=[(F(rng.randrange(5,11),20),F(rng.randrange(5,11),20)) for _ in range(3)]
        low=[(F(9,10)*x,F(9,10)*y) for x,y in points]
        known=[F(1,3),F(1,2)]
        costs=[F(rng.randrange(1,16),100) for _ in range(4)]
        answer=optimize(points,low,F(10,9),known,costs)
        if answer['answer']=='ZERO':
            check(cascade(points,known,costs,answer['order']) is None,'zero_soundness')
        elif answer['answer']=='FULL':
            check(all(cascade(points,known,costs,p) is not None for p in permutations(range(4))),'full_soundness')
        else:
            check(answer['answer']=='REFINE','allowed_refinement')
    bad_cases=[lambda: cascade(segment,[F(1,2)],[F(1,10)]*3,(0,0,2)),
               lambda: optimize(source,lower,1,[F(1,2)],[F(1,10)]*3),
               lambda: cascade([(0.5,0.5)],[],[F(1,10)]*2,(0,1)),
               lambda: optimize([(F(2,3),F(1,2))],source,2,[],[F(1,10)]*2)]
    for fn in bad_cases:
        try: fn()
        except ValueError: check(True,'invalid_input_rejections')
        else: raise RuntimeError('invalid input accepted')
    paths=['all_orders.py','check_all_orders.py']
    print(json.dumps({'status':'passed','counts':dict(COUNTS),'fixtures':fixtures,
        'source_sha256':{p:hashlib.sha256(Path(__file__).with_name(p).read_bytes()).hexdigest() for p in paths},
        'sympy_version':s.__version__,
        'scope':'One convex planar block, any finite number of known-probability senders; full permutations; finite tests; no Lean or general-attachment claim.'},sort_keys=True,indent=2))

if __name__=='__main__': main()
