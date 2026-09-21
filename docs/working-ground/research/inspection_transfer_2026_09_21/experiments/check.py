"""Exact primitive lottery/payoff checks for the bounded inspection transfer."""
from collections import Counter
from fractions import Fraction as F
from hashlib import sha256
from itertools import product
from math import prod
from pathlib import Path
import json
import sys

ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'game_cascade_audit_2026_09_19/experiments'))
from game import Game
from mixed import solve
import z3

counts=Counter()
def check(ok,key):
    if not ok: raise RuntimeError(key)
    counts[key]+=1


def main():
    eta,k=F(1),F(1,2)
    for q in [F(j,16) for j in range(1,16)]:
        threshold=(eta-k)/q
        for e in [F(0),threshold/2,threshold,threshold+F(1,100),2*threshold]:
            # Enumerate audit's two terminal outcomes; after R receiver chooses D.
            report=sum(prob*(eta-k-e*detected) for detected,prob in [(0,1-q),(1,q)])
            silent=sum(prob*F(0) for detected,prob in [(0,1-q),(1,q)])
            check(report-silent==eta-k-e*q,'lottery_payoff_identity')
            game=Game(['1/2'],[k+e*q],eta=[eta])
            actual=solve(game,0)['exists']
            check(actual==(e>=threshold),'primitive_mixed_threshold')
            check(game.backward_candidate(0)[2]['target']==actual,'primitive_assessment')
    # Convex hull max/min in one coordinate are exact endpoint calculations.
    U=[F(1,2)]; V=[F(1,4),F(1,2)]
    check(max(U)==max(V),'equal_positive_support_endpoint')
    check((eta-k)/min(U)==1 and (eta-k)/min(V)==2,'same_interface_distinct_frontiers')
    for vertices in [U,V,[F(1,10),F(1,3),F(3,5)]]:
        a=min(vertices); e=(eta-k)/a
        check(all(eta-k-e*q<=0 for q in vertices),'robust_attained_threshold')
        # Gain is affine in q, so vertex bounds here extend to the full interval.
        check(eta-k-(e-F(1,100))*a>0,'strictly_below_fails')
    for families in [[U,V],[V,V],[U,V,[F(1,3),F(1,2)]]]:
        products=[prod(row) for row in product(*families)]
        check(min(products)==prod(min(s) for s in families),'independent_serial_composition')
    for count in range(1,9):
        exact,approx=F(1,3),F(1,4)
        check(((eta-k)/approx**count)/((eta-k)/exact**count)==(exact/approx)**count,'repeat_factor')
    # q labels are jointly constrained: independent lows invent an impossible model.
    allowed=[(F(1,4),F(1,2)),(F(1,2),F(1,4))]
    check(min(prod(row) for row in allowed)==F(1,8),'shared_mask_detection_floor')
    check(prod(min(row[i] for row in allowed) for i in range(2))==F(1,16),'erased_mask_wrong_floor')
    a_lo,a_hi=F(1,4),F(1,2)
    for a in [F(1,4),F(1,3),F(1,2)]:
        check((eta-k)/a_hi <= (eta-k)/a <= (eta-k)/a_lo,'certified_interval')
    deps=[Path(__file__),ROOT/'game_cascade_audit_2026_09_19/experiments/game.py',ROOT/'game_cascade_audit_2026_09_19/experiments/mixed.py']
    print(json.dumps({'status':'pass','checks':dict(sorted(counts.items())),'total':sum(counts.values()),
        'z3':z3.get_version_string(),'source_hashes':{str(p.relative_to(ROOT)):sha256(p.read_bytes()).hexdigest() for p in deps},
        'scope':'finite exact primitive checks plus written affine/endpoint proof; not Lean'},indent=2,sort_keys=True))

if __name__=='__main__':main()
