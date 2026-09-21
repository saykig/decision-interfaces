"""Fresh combined game/interface build and axiom audit; historical receipts untouched."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile

PHASE = Path(__file__).resolve().parents[1]
GAME_ROOT = PHASE.parent / 'lean_belief_bridge_2026_09_19' / 'lean'
INTERFACE_ROOT = PHASE / 'lean'
REVISION = '0df444a360eaa60ab8c11dca51a86af692955474'
TOOLCHAIN = 'leanprover/lean4:v4.33.1'
ALLOWED = {'propext', 'Classical.choice', 'Quot.sound'}
MODULES = ['Beliefs', 'Transcripts', 'Receiver', 'Continuation', 'Bridge', 'Kernel', 'Equilibrium', 'Interface', 'GameInterface']


def run(args, env=None):
    result = subprocess.run(args, env=env, text=True, capture_output=True, timeout=900)
    output = result.stdout + result.stderr
    if result.returncode:
        raise SystemExit(output or f'Command failed: {args}')
    return output


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--packages', type=Path, required=True)
    parser.add_argument('--lean', default='lean')
    parser.add_argument('--output', type=Path)
    args = parser.parse_args()
    if args.output and args.output.exists():
        raise SystemExit('Refusing to overwrite a historical receipt')
    packages = args.packages.resolve()
    revision = run(['git', '-C', str(packages / 'mathlib'), 'rev-parse', 'HEAD']).strip()
    if revision != REVISION:
        raise SystemExit('Wrong Mathlib revision')
    paths = sorted(str(p / '.lake/build/lib/lean') for p in packages.iterdir()
                   if (p / '.lake/build/lib/lean').is_dir())
    lean = [args.lean, '+' + TOOLCHAIN]
    version = run(lean + ['--version']).strip()
    sources, logs, declarations = {}, {}, []
    with tempfile.TemporaryDirectory(prefix='di-game-interface-proof-') as temp:
        build = Path(temp)
        env = dict(os.environ, LEAN_PATH=os.pathsep.join([str(build)] + paths))
        for module in MODULES:
            ROOT = INTERFACE_ROOT if module in ('Interface', 'GameInterface') else GAME_ROOT
            namespace = 'DecisionInterface.' if ROOT == INTERFACE_ROOT else 'Cooperation.'
            source = ROOT / (module + '.lean')
            content = source.read_text()
            names = re.findall(r'^(?:def|abbrev|lemma|theorem|structure)\s+([\w.]+)', content, re.M)
            if not names:
                raise SystemExit(f'No declarations in {module}')
            declarations.extend(namespace + name for name in names)
            sources[source.name] = hashlib.sha256(source.read_bytes()).hexdigest()
            logs[module] = run(lean + ['--root=' + str(ROOT), '-o', str(build / (module + '.olean')),
                                       str(source)], env).replace(str(ROOT) + os.sep, '')
            print('Compiled ' + module, flush=True)
        if len(declarations) != len(set(declarations)):
            raise SystemExit('Duplicate declaration names')
        audit = '\n'.join('import ' + m for m in MODULES) + '\n'
        audit += '\n'.join('#print axioms ' + d for d in declarations) + '\n'
        audit_path = build / 'AxiomAudit.lean'
        audit_path.write_text(audit)
        output = run(lean + ['--root=' + str(build), str(audit_path)], env)
        audited = {}
        pattern = r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)"
        for name, raw in re.findall(pattern, output):
            axioms = [s.strip() for s in raw.split(',') if s.strip()]
            if set(axioms) - ALLOWED:
                raise SystemExit(f'Unapproved dependencies for {name}: {axioms}')
            audited[name] = axioms
        if set(audited) != set(declarations):
            raise SystemExit('Incomplete audit:\n' + output)
        if 'sorryAx' in output or any('sorry' in log.lower() for log in logs.values()):
            raise SystemExit('An admitted proof appeared in compiler output')
    receipt = dict(status='Lean checked; formal scope only', toolchain=version,
                   mathlib_revision=revision, source_sha256=sources,
                   verifier_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
                   modules=MODULES, audited_declarations=audited,
                   audit_sha256=hashlib.sha256(audit.encode()).hexdigest(), compiler_output=logs)
    rendered = json.dumps(receipt, indent=2, sort_keys=True) + '\n'
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered)
    else:
        print(rendered, end='')


if __name__ == '__main__':
    main()
