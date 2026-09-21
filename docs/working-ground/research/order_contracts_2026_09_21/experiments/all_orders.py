"""Exact all-order baseline: one convex planar block + exact known senders.

Senders 0,1 own the uncertain coordinates; sender i+2 has known[i].
The game-to-cascade theorem is inherited, not proved by this program.
No general-polytope, tree-order, efficient-selection, or Lean claim is made.
"""
from fractions import Fraction as F
from itertools import combinations_with_replacement, permutations
from math import factorial


def rational(x):
    if isinstance(x, bool) or not isinstance(x, (str, int, F)):
        raise ValueError('use exact rational strings, integers, or Fraction')
    return F(x)


def vertices(points):
    out = tuple(tuple(rational(x) for x in p) for p in points)
    if not out or any(len(p) != 2 or min(p) <= 0 for p in out):
        raise ValueError('a nonempty positive planar vertex list is required')
    return out


def determinant(o, a, b):
    return (a[0]-o[0])*(b[1]-o[1])-(a[1]-o[1])*(b[0]-o[0])


def down_hull(points):
    cloud = {(F(0), F(0))}
    for x, y in points:
        cloud.update(((x, y), (x, F(0)), (F(0), y)))
    ordered = sorted(cloud)
    def half(seq):
        ans = []
        for p in seq:
            while len(ans) > 1 and determinant(ans[-2], ans[-1], p) <= 0:
                ans.pop()
            ans.append(p)
        return ans
    return half(ordered)[:-1] + half(reversed(ordered))[:-1]


def contained(points, polygon):
    return all(determinant(a, b, p) >= 0 for p in points
               for a, b in zip(polygon, polygon[1:]+polygon[:1]))


def check_sandwich(source, lower, scale):
    source, lower, scale = vertices(source), vertices(lower), rational(scale)
    if scale < 1:
        raise ValueError('scale must be at least one')
    upper = tuple(tuple(scale*x for x in p) for p in lower)
    return contained(lower, down_hull(source)) and contained(source, down_hull(upper))


def strict_witness(points, tx, ty, txy):
    """Exists x>tx, y>ty, xy>txy in conv(points); returns rational point."""
    for a, b in combinations_with_replacement(points, 2):
        dx, dy = b[0]-a[0], b[1]-a[1]
        lo, hi = F(0), F(1)
        possible = True
        for start, slope, threshold in ((a[0], dx, tx), (a[1], dy, ty)):
            if slope > 0:
                lo = max(lo, (threshold-start)/slope)
            elif slope < 0:
                hi = min(hi, (threshold-start)/slope)
            elif start <= threshold:
                possible = False
        if not possible or lo > hi:
            continue
        def point(t):
            return a[0]+t*dx, a[1]+t*dy
        def strict(t):
            x, y = point(t)
            return x > tx and y > ty and x*y > txy
        if lo == hi:
            if strict(lo):
                return point(lo)
            continue
        mid = (lo+hi)/2
        x, y = point(mid)
        if x <= tx or y <= ty:
            continue
        candidates = [lo, hi]
        if dx*dy < 0:
            critical = -(dx*a[1]+dy*a[0])/(2*dx*dy)
            if lo < critical < hi:
                candidates.append(critical)
        best = max(candidates, key=lambda t: point(t)[0]*point(t)[1])
        if point(best)[0]*point(best)[1] <= txy:
            continue
        # Approach the strict-product maximizer from the strict linear interior.
        # Continuity ensures termination; no sampling tolerance decides the answer.
        t = best
        while not strict(t):
            mid = (best+mid)/2
            t = mid
        return point(t)
    return None


def _cascade(points, known, ratios, order):
    thresholds = {1: F(0), 2: F(0), 3: F(0)}
    mask, constant = 0, F(1)
    for i in reversed(order):
        if mask == 0:
            if constant <= ratios[i]:
                return None
        else:
            thresholds[mask] = max(thresholds[mask], ratios[i]/constant)
        if i < 2:
            mask |= 1 << i
        else:
            constant *= known[i-2]
    return strict_witness(points, thresholds[1], thresholds[2], thresholds[3])


def cascade(points, known, ratios, order):
    points = vertices(points)
    known = tuple(rational(x) for x in known)
    ratios = tuple(rational(x) for x in ratios)
    order = tuple(order)
    n = 2+len(known)
    if any(not 0 < x < 1 for x in known) or len(ratios) != n or min(ratios) <= 0:
        raise ValueError('invalid known probabilities or cost ratios')
    if any(type(i) is not int for i in order) or sorted(order) != list(range(n)):
        raise ValueError('order must be a complete permutation')
    return _cascade(points, known, ratios, order)


def optimize(source, lower, scale, known, ratios, tau='2/3', max_orders=100000):
    """Source-verified ZERO/FULL/REFINE bracket; UNKNOWN means work budget ended.

    ZERO returns one common order. FULL requires a strict lower witness for every
    order. REFINE is allowed only after complete enumeration finds neither.
    The original source is used for audit, not to bypass the compressed query.
    """
    source, lower = vertices(source), vertices(lower)
    scale, tau = rational(scale), rational(tau)
    known = tuple(rational(x) for x in known)
    ratios = tuple(rational(x) for x in ratios)
    n = 2+len(known)
    if not 0 < tau < 1 or any(x >= tau for p in source+lower for x in p):
        raise ValueError('source and decoded points must be strictly below tau')
    if any(not 0 < x < tau for x in known) or len(ratios) != n or min(ratios) <= 0:
        raise ValueError('invalid known probabilities or cost ratios')
    if max_orders is not None and (type(max_orders) is not int or max_orders < 0):
        raise ValueError('invalid work budget')
    if not check_sandwich(source, lower, scale):
        raise ValueError('source-relative sandwich failed')
    upper = tuple(tuple(scale*x for x in p) for p in lower)
    rows = []
    for order in permutations(range(n)):
        if max_orders is not None and len(rows) >= max_orders:
            return {'answer': 'UNKNOWN', 'reason': 'order_budget',
                    'checked_orders': len(rows), 'total_orders': factorial(n)}
        low = _cascade(lower, known, ratios, order)
        high = _cascade(upper, known, ratios, order)
        if low is not None and high is None:
            raise RuntimeError('monotone bracket invariant failed')
        rows.append({'order': list(order), 'lower_cascades': low is not None,
                     'outer_cascades': high is not None,
                     'lower_witness': None if low is None else [str(x) for x in low]})
        if high is None:
            return {'answer': 'ZERO', 'order': list(order), 'checked_orders': len(rows),
                    'total_orders': factorial(n), 'rows': rows}
    return {'answer': 'FULL' if all(r['lower_cascades'] for r in rows) else 'REFINE',
            'checked_orders': len(rows), 'total_orders': factorial(n), 'rows': rows}
