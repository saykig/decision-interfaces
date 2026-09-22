"""Fresh R22 build: compiled statements and transitive axiom audit, not model validation."""
import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parent
REVISION = "0df444a360eaa60ab8c11dca51a86af692955474"
TOOLCHAIN = "leanprover/lean4:v4.33.1"
ALLOWED = {"propext", "Classical.choice", "Quot.sound"}
MODULES = ["AuditGame", "RobustFine", "Profile"]


def run(args, env=None):
    result = subprocess.run(args, env=env, text=True, capture_output=True, timeout=900)
    output = result.stdout + result.stderr
    if result.returncode:
        raise SystemExit(output or f"Command failed: {args}")
    return output


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--packages", type=Path, required=True)
    parser.add_argument("--lean", default="lean")
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    if args.output and args.output.exists():
        raise SystemExit("Refusing to overwrite an existing receipt")
    packages = args.packages.resolve()
    revision = run(["git", "-C", str(packages / "mathlib"), "rev-parse", "HEAD"]).strip()
    if revision != REVISION:
        raise SystemExit("Wrong mathlib revision")
    paths = sorted(str(p / ".lake/build/lib/lean") for p in packages.iterdir()
                   if (p / ".lake/build/lib/lean").is_dir())
    lean = [args.lean, "+" + TOOLCHAIN]
    version = run(lean + ["--version"]).strip()
    sources, logs, declarations = {}, {}, []
    with tempfile.TemporaryDirectory(prefix="di-r22-proof-") as temp:
        build = Path(temp)
        env = dict(os.environ, LEAN_PATH=os.pathsep.join([str(build)] + paths))
        for module in MODULES:
            source = ROOT / (module + ".lean")
            content = source.read_text()
            stripped = re.sub(r"/-.*?-/", "", content, flags=re.S)
            stripped = re.sub(r"--[^\n]*", "", stripped)
            if re.search(r"\b(sorry|admit|axiom|native_decide|unsafe)\b", stripped):
                raise SystemExit("Unapproved proof token in " + source.name)
            names = re.findall(r"^(?:noncomputable\s+)?(?:def|abbrev|lemma|theorem|structure)\s+([\w.]+)",
                               content, re.M)
            if not names:
                raise SystemExit("No declarations in " + module)
            declarations.extend("JointInspection." + name for name in names)
            sources[source.name] = hashlib.sha256(source.read_bytes()).hexdigest()
            logs[module] = run(lean + ["--root=" + str(ROOT), "-o", str(build / (module + ".olean")),
                                       str(source)], env).replace(str(ROOT) + os.sep, "")
            print("Compiled " + module, flush=True)
        if len(declarations) != len(set(declarations)):
            raise SystemExit("Duplicate declaration names")
        audit = "\n".join("import " + m for m in MODULES) + "\n"
        audit += "\n".join("#print axioms " + d for d in declarations) + "\n"
        audit_path = build / "AxiomAudit.lean"
        audit_path.write_text(audit)
        output = run(lean + ["--root=" + str(build), str(audit_path)], env)
        audited = {}
        pattern = r"'([^']+)' (?:depends on axioms: \[([^\]]*)\]|does not depend on any axioms)"
        for name, raw in re.findall(pattern, output):
            axioms = [s.strip() for s in raw.split(',') if s.strip()]
            if set(axioms) - ALLOWED:
                raise SystemExit(f"Unapproved dependencies for {name}: {axioms}")
            audited[name] = axioms
        if set(audited) != set(declarations):
            raise SystemExit("Incomplete audit:\n" + output)
        if "sorryAx" in output or any("sorry" in log.lower() for log in logs.values()):
            raise SystemExit("An admitted proof appeared in compiler output")
    receipt = dict(status="Lean checked; declared formal scope only", toolchain=version,
                   mathlib_revision=revision, source_sha256=sources,
                   verifier_sha256=hashlib.sha256(Path(__file__).read_bytes()).hexdigest(),
                   source_commit=os.environ.get("GITHUB_SHA"),
                   modules=MODULES, audited_declarations=audited,
                   audit_sha256=hashlib.sha256(audit.encode()).hexdigest(), compiler_output=logs)
    rendered = json.dumps(receipt, indent=2, sort_keys=True) + "\n"
    if args.output:
        args.output.parent.mkdir(parents=True, exist_ok=True)
        args.output.write_text(rendered)
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
