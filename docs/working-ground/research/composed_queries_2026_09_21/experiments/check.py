"""Exact end-to-end regression and independent algorithm/game comparisons."""
from collections import Counter
from copy import deepcopy
from fractions import Fraction as F
from hashlib import sha256
from itertools import permutations, product
from pathlib import Path
import json
import sys
import query as q

counts = Counter()

def check(condition, category):
    if not condition:
        raise RuntimeError(category)
    counts[category] += 1


def rejects(fn):
    try:
        fn()
    except (ValueError, KeyError):
        counts['invalid_inputs_rejected'] += 1
    else:
        raise RuntimeError('invalid input accepted')


def exact(vertices):
    return {'kind': 'exact', 'vertices': vertices}


def instance(vertices, ratios, tau='2/3'):
    return {'reuse': 'independent', 'tau': tau, 'components': {'P': {'labels': {'a': exact(vertices)}}},
            'occurrences': ['P'], 'allowed': [['a']], 'ratios': list(map(str, ratios))}


def encoded(source, b=6):
    payload, _ = q.codec.encode(source, b)
    return {'kind': 'codec', 'source': [[str(x) for x in p] for p in source], 'payload_hex': payload.hex()}


def source_data(data):
    out = deepcopy(data)
    for component in out['components'].values():
        for label, item in list(component['labels'].items()):
            if item['kind'] == 'codec':
                component['labels'][label] = exact(item['source'])
    return out


def verify_rows(data, result):
    prepared = q.prepare(data)
    for row in result['rows']:
        low = row['lower']
        if low['status'] == 'SAT':
            blocks = [prepared['components'][key][label][0] for key, label in zip(prepared['occurrences'], low['labels'])]
            ws = [[F(w) for w in weights] for weights in low['weights']]
            check(q.witness_valid(blocks, prepared['ratios'], row['order'], ws), 'rational_witness_replay')
    if result['answer'] == 'FULL':
        check(len(result['rows']) == result['total_orders'] and all(r['lower']['status'] == 'SAT' for r in result['rows']), 'full_evidence_complete')


def main():
    # Existing optimized R12 selector and independent cvc5 full-order oracle.
    path12 = q.ROOT/'fixed_dimension_selection_2026_09_19/experiments'
    sys.path.insert(0, str(path12))
    r12 = q.load('r12_selector', path12/'selector.py')
    independent = q.load('r12_independent', path12/'independent.py')
    fixtures = q.load('r12_fixtures', path12/'fixtures.py')
    r10 = q.load('r10_selector', q.ROOT/'two_prefix_selection_2026_09_19/experiments/selector.py')
    for name, (raw, expected, _) in fixtures.cases().items():
        data = instance(raw['vertices'], raw['r'], raw['tau'])
        answer = q.optimize(data)
        optimized = r12.select(raw, timeout=30000)
        check(answer['answer'] == ('ZERO' if expected == 'zero' else 'FULL'), 'r12_fixture_answer')
        check((answer['answer'] == 'ZERO') == (optimized['status'] == 'zero'), 'r12_optimized_comparison')
        verify_rows(data, answer)
        blocks = [q.hull(raw['vertices'], F(raw['tau']))]
        for order in permutations(range(len(raw['r']))):
            actual = q.feasible(blocks, tuple(map(F, raw['r'])), order)
            check((actual['status'] == 'SAT') == independent.feasible(raw, order, timeout=30000), 'independent_cvc5_full_order')
        if len(raw['vertices']) <= 2:
            segment = {'a': raw['vertices'][0], 'b': raw['vertices'][-1], 'r': raw['r'], 'tau': raw['tau']}
            optimized10 = r10.select(segment)
            check((answer['answer'] == 'ZERO') == (optimized10['status'] == 'success'), 'r10_optimized_comparison')
    # General affine dimension three, then factored products against one expanded hull.
    tetra = [['1/4']*3, ['1/2','1/4','1/4'], ['1/4','1/2','1/4'], ['1/4','1/4','1/2']]
    check(q.optimize(instance(tetra,['1/100']*3))['answer'] == 'FULL', 'dimension_three_all_orders')
    factors = [q.hull([['1/4','1/2'],['1/2','1/4']], F(2,3)), q.hull([['1/3'],['1/2']], F(2,3))]
    expanded = [list(a+b) for a,b in product(*factors)]
    expanded_input = {'vertices': [[str(x) for x in p] for p in expanded], 'r': ['1/10','1/10','1/10'], 'tau':'2/3'}
    for order in permutations(range(3)):
        result = q.feasible(factors, (F(1,10),)*3, order)
        check((result['status'] == 'SAT') == independent.feasible(expanded_input,order,timeout=30000), 'product_vs_expanded_cvc5')
    # Primitive game from full state/path gains, including arbitrary mixed variables.
    path13 = q.ROOT/'game_cascade_audit_2026_09_19/experiments'
    sys.path.insert(0, str(path13))
    game = q.load('r13_game', path13/'game.py')
    mixed = q.load('r13_mixed', path13/'mixed.py')
    for probabilities, ratios in [(['1/2','1/2'], ['1/4','1']), (['1/2','2/5'], ['1/10','1/10']),
                                 (['1/2','2/5','1/3'], ['2/15','1/10','1/10'])]:
        blocks = [tuple([tuple(map(F, probabilities))])]
        for order in permutations(range(len(ratios))):
            cascade = q.feasible(blocks, tuple(map(F, ratios)), order)['status'] == 'SAT'
            g = game.Game(probabilities, ratios, order=order)
            for fine in [F(0), F(1,2), F(1)]:
                answer = mixed.solve(g, fine)['exists']
                check(answer == (not cascade or fine == 1), 'primitive_mixed_game_comparison')
                check(g.backward_candidate(fine)[2]['target'] == answer, 'primitive_backward_comparison')
    # Interior witness and sub-10^-30 feasible window: no vertex/grid decision.
    eps = F(1,10**35)
    blocks = [((F(1,2),F(1,5),F(3,5)), (F(1,2),F(3,5),F(1,5)))]
    ratios = (F(4,25)-eps**2, F(2,5), F(1,10))
    witness = q.feasible(blocks, ratios, (0,1,2))
    check(witness['status'] == 'SAT', 'narrow_interior_witness')
    check(q.feasible(blocks, (F(4,25),F(1,10),F(1,10)), (0,1,2))['status'] == 'UNSAT', 'exact_product_tie')
    # Modelwise success does not imply a common order.
    labels = {'L': exact([['1/10']]), 'H': exact([['3/5']])}
    distinct = {'reuse': 'independent', 'components': {'P': {'labels': labels}}, 'occurrences': ['P','P'],
                'allowed': [['L','H'],['H','L']], 'ratios': ['2/5','2/5']}
    check(q.optimize(distinct)['answer'] == 'FULL', 'no_common_order')
    for row in distinct['allowed']:
        one = deepcopy(distinct); one['allowed'] = [row]
        check(q.optimize(one)['answer'] == 'ZERO', 'modelwise_success')
    # Shared mask stops invented high/high combinations; convexification also fails.
    masked = deepcopy(distinct)
    masked['components']['K'] = {'labels': {'a': exact([['1/2']])}}
    masked['occurrences'] = ['K','P','P']; masked['ratios'] = ['1/10','1/100','1/100']
    masked['allowed'] = [['a','L','H'],['a','H','L']]
    check(q.optimize(masked)['answer'] == 'ZERO', 'mask_preserved')
    erased = deepcopy(masked); erased['allowed'] = [['a', x, y] for x,y in product(labels, repeat=2)]
    check(q.optimize(erased)['answer'] == 'FULL', 'erased_mask_counterexample')
    convexified = instance([['1/2','1/10','3/5'],['1/2','3/5','1/10']], masked['ratios'])
    check(q.optimize(convexified)['answer'] == 'FULL', 'convexification_counterexample')
    check(q.compatible_assignments([['L','H']]*3, [([0,1],[['L','H'],['H','L']]),([1,2],[['L','L'],['H','H']])]) == [['L','H','H'],['H','L','L']], 'tree_masks')
    # Binary payload -> source verification -> arbitrary order / multi-block query.
    sources = [[(F(1,3),F(1,3))], [(F(1,4),F(1,2)),(F(1,2),F(1,4))]]
    fixtures_out = []
    for source in sources:
        coded = encoded(source)
        for r in ['1/100', '1/9', '1']:
            data = {'reuse': 'independent', 'components': {'P': {'labels': {'a': coded}, 'max_uses': 2},
                    'K': {'labels': {'a': exact([['1/2']])}}},
                    'occurrences': ['K','P'], 'allowed': [['a','a']], 'ratios': [r,'1/100','1/100']}
            result = q.optimize(data); truth = q.optimize(source_data(data))
            check(result['answer'] == 'REFINE' or result['answer'] == truth['answer'], 'codec_source_soundness')
            verify_rows(data, result)
            fixtures_out.append({'answer': result['answer'], 'source_answer': truth['answer']})
            if source == sources[0] and r == '1/9':
                check(result['answer'] == 'REFINE', 'representation_refine')
        repeated = deepcopy(data); repeated['occurrences'] = ['P','P']; repeated['allowed'] = [['a','a']]
        repeated['ratios'] = ['1/1000']*4
        result = q.optimize(repeated)
        check(result['answer'] == q.optimize(source_data(repeated))['answer'] == 'FULL', 'repeated_compressed_occurrences')
        verify_rows(repeated, result)
        prepared = q.prepare(repeated)
        check(len(result['rows'][0]['lower']['weights']) == 2, 'fresh_occurrence_weights')
        check(F(prepared['error_factors'][0]) == prepared['components']['P']['a'][2]**4, 'reuse_error_accounting')
    # Different compressed components plus arbitrary 3D V attachment.
    many = deepcopy(repeated)
    many['components']['Q'] = {'labels': {'a': encoded(sources[0])}, 'max_uses': 1}
    many['components']['V'] = {'labels': {'a': exact([['1/4']*3, ['1/2','1/4','1/4'], ['1/4','1/2','1/4'], ['1/4','1/4','1/2']])}}
    many['occurrences'] = ['P','Q','V']; many['allowed'] = [['a']*3]; many['ratios'] = ['1']+['1/100']*6
    check(q.optimize(many)['answer'] == 'ZERO', 'general_attachment_multiple_codecs')
    many['ratios'] = ['1/100000']*7
    p = q.prepare(many)
    blocks = [p['components'][k]['a'][0] for k in p['occurrences']]
    check(q.feasible(blocks, p['ratios'], tuple(range(7)))['status'] == 'SAT', 'general_attachment_strict_cascade')
    # Finite masks with actual compressed alternatives.
    cm = deepcopy(masked)
    cm['components']['P'] = {'labels': {'L': encoded([(F(1,4),F(1,4))]), 'H': encoded([(F(1,2),F(1,2))])}, 'max_uses': 2}
    cm['ratios'] = ['1/40']+['1/1000']*4
    cr = q.optimize(cm)
    check(cr['answer'] in ('REFINE',q.optimize(source_data(cm))['answer']), 'compressed_label_masks')
    verify_rows(cm, cr)
    check(q.optimize(repeated,max_orders=0)['answer'] == 'UNKNOWN', 'order_unknown')
    check(q.optimize(repeated,max_orders=1)['answer'] == 'UNKNOWN', 'partial_full_is_unknown')
    check(q.optimize(repeated,witness_steps=0)['answer'] == 'UNKNOWN', 'witness_unknown')
    bad = deepcopy(repeated); bad['components']['P']['max_uses'] = 1
    rejects(lambda: q.optimize(bad))
    bad = deepcopy(repeated); bad['components']['P']['labels']['a']['source'] = [['1/8','1/8']]
    rejects(lambda: q.optimize(bad))
    bad = deepcopy(repeated); bad['components']['P']['labels']['a']['payload_hex'] = '00'
    rejects(lambda: q.optimize(bad))
    bad = deepcopy(masked); bad['allowed'] = []
    rejects(lambda: q.optimize(bad))
    bad = deepcopy(masked); bad['allowed'] = [['a','L','missing']]
    rejects(lambda: q.optimize(bad))
    bad = deepcopy(masked); bad['ratios'][0] = 0.1
    rejects(lambda: q.optimize(bad))
    bad = deepcopy(masked); bad['reuse'] = 'same_parameter'
    rejects(lambda: q.optimize(bad))
    rejects(lambda: q.optimize(masked, timeout_ms=-1))
    check(not q.witness_valid([((F(1,2),),)], (F(1,2),), (0,), [[F(2)]]), 'bad_witness_rejected')
    here = Path(__file__).parent
    print(json.dumps({'status':'pass', 'checks':dict(sorted(counts.items())), 'total':sum(counts.values()),
                      'codec_answers':fixtures_out, 'z3':q.z3.get_version_string(),
                      'source_hashes':{str(p.relative_to(q.ROOT)):sha256(p.read_bytes()).hexdigest() for p in [here/'query.py',here/'check.py',q.ROOT/'optimal_bits_2026_09_21/experiments/codec.py',q.ROOT/'optimal_bits_2026_09_21/experiments/verify.py']},
                      'scope':'exact backends and rational witnesses; no new Lean/game proof'}, indent=2, sort_keys=True))

if __name__ == '__main__':
    main()
