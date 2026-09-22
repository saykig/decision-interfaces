"""R22 adversarial boundaries and adapter replay; exact finite evidence, not a proof.

The evaluator enumerates physical audit leaves. It does not call the threshold
formula inside that payoff evaluator. The API under test is the retained joint.py.
Every check is explicit (not assert), so Python -O cannot remove it.
"""
from collections import Counter
from fractions import Fraction as F
from hashlib import sha256
from itertools import combinations, product
import json
from pathlib import Path

import joint as api

COUNTS = Counter()
WITNESSES = {}


def check(category, condition):
    COUNTS[category] += 1
    if not condition:
        raise RuntimeError(f"Boundary check failed: {category}")


def rejects(category, thunk, exception=(ValueError, TypeError, ZeroDivisionError)):
    try:
        thunk()
    except exception:
        check(category, True)
        return
    raise RuntimeError(f"Expected rejection: {category}")


def report_leaves(r, q, a, k, fine, receiver_action=F(1)):
    detected = a*r*receiver_action-k-fine
    missed = a*r*receiver_action-k
    return q*detected + (1-q)*missed


def posterior(s):
    # Prior is 1/2; type zero cannot report.
    psilent = F(1,2) + F(1,2)*(1-s)
    return F(1,2)*(1-s)/psilent


def blend(points, weights):
    return tuple(sum(w*p[i] for p,w in zip(points,weights)) for i in range(2))


def transform(point):
    r,q = point
    return r/q,1/q


def main():
    points = tuple(product(map(F,['1/4','1','2','3']), map(F,['1/8','1/4','1/2','3/4'])))
    sources = [ps for n in (1,2,3) for ps in combinations(points,n)]
    queries = tuple(product(map(F,['1/2','1','2']), map(F,['1/4','1/2','1','3','6'])))
    mixes = tuple(F(n,6) for n in range(7))
    for s in mixes:
        b = posterior(s)
        check('receiver_silent_strict', F(0) <= b <= F(1,2) and 3*b-2 < 0)
        check('receiver_report_strict', 3*F(1)-2 > 0)
    for ps in sources:
        pieces = api.envelope(ps)
        cuts = sorted({piece.left for piece in pieces})
        tests = cuts + [(x+y)/2 for x,y in zip(cuts,cuts[1:])] + [cuts[-1]+1]
        for t in tests:
            check('exact_envelope_breakpoints', api.envelope_value(pieces,t) == api.profile(ps,t))
        weights = tuple(F(i+1,sum(range(1,len(ps)+1))) for i in range(len(ps)))
        p = blend(ps,weights)
        mu = tuple(w*z[1]/p[1] for w,z in zip(weights,ps))
        tp = transform(p)
        check('projective_forward', sum(mu)==1 and min(mu)>=0 and blend(tuple(map(transform,ps)),mu)==tp)
        denom = sum(u/z[1] for u,z in zip(mu,ps))
        back = tuple((u/z[1])/denom for u,z in zip(mu,ps))
        check('projective_inverse', back==weights and blend(ps,back)==p)
        for a,k in queries:
            fine = api.frontier(ps,a,k)
            check('profile_query_identity', fine==a*api.profile(ps,k/a))
            check('primitive_target_attainment', all(report_leaves(r,q,a,k,fine)<=0 for r,q in ps))
            check('convex_interior_at_threshold', report_leaves(*p,a,k,fine)<=0)
            check('safe_api_fidelity', api.safe(ps,a,k,fine))
            if fine>0:
                below = fine-F(1,2**80)*fine
                check('exact_below_threshold_failure', any(report_leaves(r,q,a,k,below)>0 for r,q in ps))
                check('safe_below_threshold_fidelity', not api.safe(ps,a,k,below))
                r,q=max(ps,key=lambda z: report_leaves(*z,a,k,below))
                payoff = report_leaves(r,q,a,k,fine)
                check('binding_model_exact_tie', payoff==0)
                for s in mixes:
                    check('tie_all_mixtures_allowed', s*payoff==0)
            else:
                check('zero_fine_feasible', api.safe(ps,a,k,0))
            r,q=ps[0]
            for e in (F(0),fine,fine+1):
                gain=report_leaves(r,q,a,k,e)
                for s in mixes:
                    value=s*gain
                    check('mixed_no_rescue', (gain<=0 and value<=0) or (gain>0 and gain>=value))

    A=api.source([(1,'1/4'),(2,'1/2')])
    B=api.source([(1,'1/2'),(2,'1/4')])
    check('equal_marginals', sorted(r for r,q in A)==sorted(r for r,q in B)
          and sorted(q for r,q in A)==sorted(q for r,q in B))
    ea,eb=api.frontier(A,1,'1/2'),api.frontier(B,1,'1/2')
    check('joint_dependence_counterexample', (ea,eb)==(F(3),F(6)))
    WITNESSES['equal_marginals_different_fines']=[str(ea),str(eb)]

    K=api.source([(2,'1/2')])
    L=api.source([(2,'1/2'),('1/4','1/8')])
    check('reward_shift_same_base_profile', api.envelope(K)==api.envelope(L))
    shifted=[max(F(0),max((r+4-1)/q for r,q in ps)) for ps in (K,L)]
    check('reward_shift_boundary', shifted==[F(10),F(26)])
    WITNESSES['unsupported_reward_shift']=list(map(str,shifted))
    rejects('negative_profile_rejected',lambda: api.profile(K,-3))
    rejects('negative_envelope_rejected',lambda: api.envelope_value(api.envelope(K),-3))

    for e in (F(0),F(1),F(100),F(10**20)):
        q=1/(2*e+2)
        check('no_finite_fine_without_floor', 0<q<1 and report_leaves(1,q,1,F(1,2),e)>0)
    for m in (4,16,256,65536):
        p=((F(1),F(1,m)),)
        q=((F(1),F(2,m)),)
        diff=api.frontier(p,1,'1/2')-api.frontier(q,1,'1/2')
        check('vanishing_detection_sensitivity', diff==F(m,4))
    for er,eq in product(map(F,['0','1/4','1/2']),repeat=2):
        p=((F(2)+er,F(1,4)),)
        q=((F(2),F(1,4)+eq),)
        eQ=api.frontier(q,1,'1/2')
        bound=eQ+(er+eQ*eq)/F(1,4)
        check('directed_error_sharpness', api.frontier(p,1,'1/2')==bound)

    singleton=api.source([(1,'1/2')])
    ind=api.serial(singleton,['1/2'],1,'1/2')
    shared=max(F(0),(1-F(1,2))/F(1,2))
    either=max(F(0),(1-F(1,2))/F(3,4))
    check('independent_AND_vs_shared_coin', (ind,shared)==(F(2),F(1)))
    check('AND_vs_OR_boundary', (ind,either)==(F(2),F(2,3)))
    WITNESSES['audit_semantics']={'independent_AND':str(ind),'same_coin':str(shared),'independent_OR':str(either)}
    for count in range(5):
        check('fresh_repeat_charged_each_time', api.serial(singleton,[F(1,2)]*count,1,'1/2')==2**count)

    components={'low':api.source([(1,'1/2')]),'high':api.source([(2,'1/2')])}
    floors={'low':F(1,4),'high':F(3,4)}
    exact=api.masked_serial(components,floors,[('low','low'),('high','high')],1,'1/2')
    relaxed=api.masked_serial(components,floors,product(components,floors),1,'1/2')
    check('mask_dependence', (exact,relaxed)==(F(4),F(12)))
    empty=api.masked_serial(components,floors,[],1,'1/2')
    zero=api.masked_serial(components,floors,[('low','low')],1,4)
    check('infeasible_not_zero', empty is None and zero==0 and empty!=zero)
    WITNESSES['mask_boundary']={'valid':'4','forbidden_pair_admitted':'12','empty':None,'feasible_zero':'0'}

    for bad in ([],[(0,'1/2')],[(-1,'1/2')],[(1,0)],[(1,1)],[(1,-1)],[(1,2)],[(True,'1/2')],[(1,0.5)]):
        rejects('source_domain_rejection',lambda bad=bad:api.source(bad))
    for a,k in [(0,1),(-1,1),(1,0),(1,-1),(True,1),(1,0.5)]:
        rejects('query_domain_rejection',lambda a=a,k=k:api.frontier(K,a,k))
    for floor in (0,1,-1,2,0.5,True):
        rejects('serial_domain_rejection',lambda floor=floor:api.serial(K,[floor],1,1))
    rejects('negative_fine_rejection',lambda:api.safe(K,1,1,-1))
    rejects('invalid_even_when_mask_empty',lambda:api.masked_serial({'x':[]},floors,[],1,1))
    rejects('invalid_even_when_mask_empty',lambda:api.masked_serial(components,{'x':0},[],1,1))
    rejects('invalid_even_when_mask_empty',lambda:api.masked_serial(components,floors,[],0,1))
    rejects('unknown_label_rejection',lambda:api.masked_serial(components,floors,[('missing','low')],1,1))

    longer=api.source([(2,'1/2'),('5/2','3/4')])
    check('finite_interval_extrapolation_boundary',api.discrepancy(K,longer,0,1)==0 and api.profile(K,2)!=api.profile(longer,2))
    mutants={
        'discard_joint_pairing': (max(r for r,q in A)-F(1,2))/min(q for r,q in A)!=ea,
        'remove_zero_clipping': (F(1)-F(3))/F(1,2)!=api.frontier(singleton,1,3),
        'collapse_empty_to_zero': F(0)!=empty,
        'reuse_same_coin_as_independent': ind!=shared,
        'replace_AND_by_OR': ind!=either,
        'transform_convex_weights_without_reweighting':
            transform(blend(A,(F(1,2),F(1,2))))!=blend(tuple(map(transform,A)),(F(1,2),F(1,2))),
        'apply_ratio_vertex_rule_to_other_objectives': F(1,10)*F(9,10)<F(1,2)*F(1,2),
        'infer_global_profile_from_finite_interval':
            api.discrepancy(K,longer,0,1)==0 and api.profile(K,2)!=api.profile(longer,2),
    }
    for name,killed in mutants.items():
        check('semantic_mutant_killed',killed)
    root=Path(__file__).resolve().parent
    result={
        'status':'PASS: exact finite adversarial and adapter replay; not universal formal proof',
        'source_families':len(sources),'queries_per_family':len(queries),
        'checks':dict(sorted(COUNTS.items())), 'total_checks':sum(COUNTS.values()),
        'semantic_mutants_killed':sorted(mutants), 'witnesses':WITNESSES,
        'source_sha256':{name:sha256((root/name).read_bytes()).hexdigest() for name in ('joint.py','boundary_checks.py')},
        'formal_boundary':'Python parser/envelope code not verified by Lean; compare to formal specification separately',
    }
    print(json.dumps(result,indent=2,sort_keys=True))


if __name__=='__main__':
    main()
