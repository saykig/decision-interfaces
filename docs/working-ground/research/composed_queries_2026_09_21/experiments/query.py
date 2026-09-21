"""Source-bound exact reference for finite unions of independent V-polytope products.

No convexification across labels; repeated occurrences have fresh convex weights.
QF_NRA UNSAT retains Z3 trust. SAT witnesses are independently rationally checked.
The strategic interpretation inherits R13, not a newly formalized game theorem.
"""
from collections import Counter
from fractions import Fraction as F
from hashlib import sha256
from importlib.util import spec_from_file_location, module_from_spec
from itertools import permutations, product
from math import factorial, prod
from pathlib import Path
import argparse
import json
import z3

ROOT = Path(__file__).resolve().parents[2]


def load(name, path):
    spec = spec_from_file_location(name, path)
    module = module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


codec = load('r16_codec', ROOT/'optimal_bits_2026_09_21/experiments/codec.py')
verifier = load('r16_verifier', ROOT/'optimal_bits_2026_09_21/experiments/verify.py')


def rational(x):
    if isinstance(x, bool) or not isinstance(x, (str, int, F)):
        raise ValueError('exact rational input required')
    return F(x)


def hull(raw, tau):
    points = tuple(dict.fromkeys(tuple(rational(x) for x in p) for p in raw))
    if not points or not points[0] or any(len(p) != len(points[0]) for p in points):
        raise ValueError('nonempty consistent vertex dimensions required')
    if any(not 0 < x < tau for p in points for x in p):
        raise ValueError('source/lower probabilities must lie strictly in (0,tau)')
    return points


def compatible_assignments(label_sets, masks):
    """Enumerate exact finite constraints, including edge masks on a label tree.

    Each mask is (occurrence_indices, allowed_label_tuples). No geometric hull.
    Empty output denotes an incompatible assembly, rejected by prepare().
    """
    for indices, allowed in masks:
        if len(set(indices)) != len(indices) or any(type(i) is not int or not 0 <= i < len(label_sets) for i in indices):
            raise ValueError('invalid mask indices')
        if any(len(row) != len(indices) for row in allowed):
            raise ValueError('invalid mask row')
    return [list(labels) for labels in product(*label_sets)
            if all(tuple(labels[i] for i in indices) in set(map(tuple, allowed))
                   for indices, allowed in masks)]


def prepare(data):
    tau = rational(data.get('tau', '2/3'))
    if not 0 < tau < 1 or data.get('reuse') != 'independent':
        raise ValueError('declare tau in (0,1) and independent occurrence reuse')
    occurrences = data['occurrences']
    if not occurrences or any(not isinstance(key, str) for key in occurrences):
        raise ValueError('nonempty named occurrence list required')
    counts, components, bindings = Counter(occurrences), {}, {}
    for key in counts:
        raw = data['components'][key]
        alternatives, dimensions = {}, set()
        if not raw['labels'] or any(not isinstance(label, str) for label in raw['labels']):
            raise ValueError('nonempty string label set required')
        for label, item in raw['labels'].items():
            kind = item['kind']
            if kind == 'exact':
                lower = hull(item['vertices'], tau)
                source, scale, payload_hash = lower, F(1), None
            elif kind == 'codec':
                source = hull(item['source'], tau)
                payload = bytes.fromhex(item['payload_hex'])
                b, decoded = codec.decode(payload)
                epsilon = F(1, 1 << b)
                if not verifier.verify(source, decoded, epsilon):
                    raise ValueError('R16 source-relative sandwich failed')
                # Exactly preserve the downward hull; remove redundant decoded knots.
                lower = hull(codec.frontier(decoded), tau)
                scale = 1 + epsilon/(F(1,8)-epsilon)
                payload_hash = sha256(payload).hexdigest()
                limit = raw.get('max_uses')
                if type(limit) is not int or limit < counts[key]:
                    raise ValueError('compressed reuse exceeds declared max_uses')
            else:
                raise ValueError('unsupported component kind')
            dimensions.add(len(lower[0]))
            alternatives[label] = (lower, tuple(tuple(scale*x for x in p) for p in lower), scale)
            bindings[key+':'+label] = {
                'source_sha256': sha256(json.dumps([[str(x) for x in p] for p in source], separators=(',', ':')).encode()).hexdigest(),
                'payload_sha256': payload_hash, 'scale': str(scale), 'dimension': len(lower[0])}
        if len(dimensions) != 1:
            raise ValueError('labels must preserve sender dimensions')
        components[key] = alternatives
    labels = data['allowed']
    if not labels:
        raise ValueError('empty compatible family is not a strategic query')
    scenarios = []
    for row in labels:
        if len(row) != len(occurrences) or any(label not in components[key] for key, label in zip(occurrences, row)):
            raise ValueError('unknown/incompatible label tuple')
        scenarios.append(tuple(row))
    scenarios = tuple(dict.fromkeys(scenarios))
    n = sum(len(next(iter(components[key].values()))[0][0]) for key in occurrences)
    ratios = tuple(rational(r) for r in data['ratios'])
    if len(ratios) != n or any(r <= 0 for r in ratios):
        raise ValueError('one positive cost ratio per sender required')
    return {'components': components, 'occurrences': occurrences, 'scenarios': scenarios,
            'ratios': ratios, 'n': n, 'bindings': bindings,
            'error_factors': [str(prod(components[key][label][2] ** len(components[key][label][0][0])
                                      for key, label in zip(occurrences, row))) for row in scenarios]}


def witness_valid(blocks, ratios, order, weights):
    if len(weights) != len(blocks):
        return False
    points = []
    for vertices, ws in zip(blocks, weights):
        if len(ws) != len(vertices) or any(w < 0 for w in ws) or sum(ws) != 1:
            return False
        points.extend(sum(w*v[j] for w, v in zip(ws, vertices)) for j in range(len(vertices[0])))
    suffix = F(1)
    for i in reversed(order):
        if suffix <= ratios[i]:
            return False
        suffix *= points[i]
    return True


def feasible(blocks, ratios, order, timeout_ms=10000, witness_steps=16):
    """Closed barycentric domains + strict product constraints, arbitrary dimension."""
    solver = z3.SolverFor('QF_NRA')
    solver.set(timeout=timeout_ms)
    all_weights, coordinates = [], []
    for k, vertices in enumerate(blocks):
        # Eliminate the sum equality. Includes points, segments, redundant vertices.
        free = [z3.Real(f'w_{k}_{j}') for j in range(len(vertices)-1)]
        ws = free + [z3.RealVal(1)-sum(free)]
        solver.add(*(w >= 0 for w in ws))
        all_weights.append(ws)
        coordinates.extend(sum(z3.RealVal(str(v[j]))*w for v, w in zip(vertices, ws))
                           for j in range(len(vertices[0])))
    suffix = z3.RealVal(1)
    for i in reversed(order):
        solver.add(suffix > z3.RealVal(str(ratios[i])))
        suffix *= coordinates[i]
    decision = solver.check()
    if decision == z3.unknown:
        return {'status': 'UNKNOWN', 'reason': solver.reason_unknown()}
    if decision == z3.unsat:
        return {'status': 'UNSAT'}
    model = solver.model()
    for step in range(witness_steps):
        weights = []
        for ws in all_weights:
            row = []
            for w in ws:
                value = model.eval(w, model_completion=True)
                if z3.is_algebraic_value(value):
                    value = value.approx(8*(2**step))
                row.append(max(F(0), F(value.numerator_as_long(), value.denominator_as_long())))
            total = sum(row)
            weights.append([w/total for w in row] if total else [F(1)]+[F(0)]*(len(row)-1))
        if witness_valid(blocks, ratios, order, weights):
            return {'status': 'SAT', 'weights': [[str(w) for w in row] for row in weights]}
    return {'status': 'UNKNOWN', 'reason': 'rational_witness_budget'}


def family_feasible(problem, order, side, timeout_ms, witness_steps):
    unknown = []
    for labels in problem['scenarios']:
        blocks = [problem['components'][key][label][side]
                  for key, label in zip(problem['occurrences'], labels)]
        result = feasible(blocks, problem['ratios'], order, timeout_ms, witness_steps)
        if result['status'] == 'SAT':
            return dict(result, labels=list(labels))
        if result['status'] == 'UNKNOWN':
            unknown.append(dict(result, labels=list(labels)))
    return {'status': 'UNKNOWN', 'incomplete': unknown} if unknown else {'status': 'UNSAT'}


def optimize(data, max_orders=100000, timeout_ms=10000, witness_steps=16):
    if max_orders is not None and (type(max_orders) is not int or max_orders < 0):
        raise ValueError('invalid order budget')
    if type(timeout_ms) is not int or timeout_ms < 0 or type(witness_steps) is not int or witness_steps < 0:
        raise ValueError('invalid solver/witness budget')
    problem = prepare(data)
    rows = []
    base = {'total_orders': factorial(problem['n']), 'bindings': problem['bindings'],
            'scenario_error_factors': problem['error_factors'],
            'error_units': 'log(factor), directed source-minus-lower support bound',
            'backend': 'Z3 '+z3.get_version_string(), 'unsat_trust': 'Z3 QF_NRA'}
    def result(answer, **kwargs):
        return dict(base, answer=answer, checked_orders=len(rows), rows=rows, **kwargs)
    for order in permutations(range(problem['n'])):
        if max_orders is not None and len(rows) >= max_orders:
            return result('UNKNOWN', reason='order_budget')
        low = family_feasible(problem, order, 0, timeout_ms, witness_steps)
        # Monotonicity supplies outer feasibility when a lower witness exists.
        high = {'status': 'SAT', 'reason': 'lower_witness'} if low['status'] == 'SAT' else family_feasible(problem, order, 1, timeout_ms, witness_steps)
        rows.append({'order': list(order), 'lower': low, 'outer': high})
        if high['status'] == 'UNSAT':
            return result('ZERO', order=list(order))
    if all(row['lower']['status'] == 'SAT' for row in rows):
        return result('FULL')
    if any(row['lower']['status'] == 'UNKNOWN' or row['outer']['status'] == 'UNKNOWN' for row in rows):
        return result('UNKNOWN', reason='incomplete_feasibility')
    return result('REFINE')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('input', type=Path)
    parser.add_argument('--max-orders', type=int, default=100000)
    parser.add_argument('--timeout-ms', type=int, default=10000)
    args = parser.parse_args()
    print(json.dumps(optimize(json.loads(args.input.read_text()), args.max_orders, args.timeout_ms), indent=2, sort_keys=True))


if __name__ == '__main__':
    main()
