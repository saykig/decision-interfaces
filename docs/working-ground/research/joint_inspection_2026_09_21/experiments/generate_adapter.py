"""Generate finite Lean replay statements from the actual Python adapter outputs.

This is a finite cross-language check, not verification of arbitrary Python code.
The generated Lean statements use the separately formalized rational specification.
Only integer numerator/denominator literals can enter the generated proof text.
"""
from fractions import Fraction as F
from pathlib import Path
import argparse
import hashlib
import json

import joint


def literal(value):
    q=F(value)
    return f'({q.numerator}/{q.denominator})'


def source_literal(points):
    return '['+','.join('('+literal(r)+','+literal(q)+')' for r,q in points)+']'


def generate():
    families=[
        [(1,F(1,2))],[(2,F(1,4))],
        [(1,F(1,4)),(2,F(1,2))],[(1,F(1,2)),(2,F(1,4))],
        [(2,F(1,2)),(F(1,4),F(1,8))],
        [(2,F(1,2)),(F(5,2),F(3,4))],
        [(1,F(1,3)),(2,F(2,3)),(1,F(1,3))],
        [(F(1,7),F(1,2**16)),(F(9,7),F(2**16-1,2**16)),(2,F(1,2))],
    ]
    lines=['import RationalInput','','namespace JointInspection','noncomputable section','']
    n=0
    for ps in families:
        for a in [F(1,3),F(1),F(7,2)]:
            for k in [F(1,7),F(1,2),F(2),F(11)]:
                expected=joint.frontier(ps,a,k)
                lines += [f'theorem adapter_valid_{n:03d} :',
                    f'    checkedFine {source_literal(ps)} {literal(a)} {literal(k)} = .ok {literal(expected)} := by',
                    '  norm_num [checkedFine,ValidInput,rationalFine] <;> intro h <;> cases h','']
                n+=1
    invalid=[([],1,1),([(1,0)],1,1),([(1,1)],1,1),([(0,F(1,2))],1,1),
             ([(-1,F(1,2))],1,1),([(1,-1)],1,1),([(1,2)],1,1),
             ([(1,F(1,2))],0,1),([(1,F(1,2))],-1,1),
             ([(1,F(1,2))],1,0),([(1,F(1,2))],1,-1),
             ([(1,F(1,2)),(1,0)],1,1)]
    for i,(ps,a,k) in enumerate(invalid):
        try:
            joint.frontier(ps,a,k)
        except (TypeError,ValueError):
            pass
        else:
            raise RuntimeError('The Python adapter unexpectedly accepted invalid input')
        lines += [f'theorem adapter_invalid_{i:03d} :',
            f'    checkedFine {source_literal(ps)} {literal(a)} {literal(k)} = .error "outside R22 input domain" := by',
            '  apply invalid_rejected','  norm_num [ValidInput]','']
    lines += ['end','end JointInspection','']
    return '\n'.join(lines),n,len(invalid)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check',action='store_true')
    args=parser.parse_args()
    text,valid,invalid=generate()
    here=Path(__file__).resolve().parent
    target=here.parent/'lean'/'AdapterFixtures.lean'
    if args.check:
        if not target.exists() or target.read_text()!=text:
            raise SystemExit('Adapter fixtures differ from current Python outputs')
        print(json.dumps({'status':'fixture bytes match current Python outputs; Lean compilation is separate',
            'valid_cases':valid,'invalid_cases':invalid,
            'source_sha256':{
                'joint.py':hashlib.sha256((here/'joint.py').read_bytes()).hexdigest(),
                'generate_adapter.py':hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
                'AdapterFixtures.lean':hashlib.sha256(text.encode()).hexdigest()}},sort_keys=True,indent=2))
    else:
        print(text,end='')


if __name__=='__main__':
    main()
