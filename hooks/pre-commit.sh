#!/usr/bin/env bash
# hooks/pre-commit.sh
# Installed by install.sh into <repo>/.git/hooks/pre-commit
# Validates staged memory files before every commit.

set -euo pipefail

STAGED_MEMORY=$(git diff --cached --name-only | grep "^memory/.*\.md$" | grep -v "README\.md" || true)
if [ -z "$STAGED_MEMORY" ]; then
  exit 0
fi

echo ""
echo "→ mem-con: validating staged memory files..."

export MEMCON_STAGED_FILES="$STAGED_MEMORY"

python3 << 'PYEOF'
import os, re, pathlib, sys
from datetime import date

errors   = []
warnings = []

staged_files = [f for f in os.environ.get("MEMCON_STAGED_FILES", "").strip().split("\n") if f.strip()]
TODAY = date.today().isoformat()

REQUIRED_FIELDS = ["name:", "description:"]
REQUIRED_META   = ["type:", "last_updated:"]
VALID_TYPES     = {"user", "project", "feedback", "reference", "index"}

for filepath in staged_files:
    f = pathlib.Path(filepath)
    if not f.exists():
        continue

    text = f.read_text(encoding="utf-8-sig")
    match = re.match(r'^---\n(.*?)\n---', text, re.DOTALL)

    if not match:
        errors.append(f"{f}: missing frontmatter block")
        continue

    fm = match.group(1)

    for field in REQUIRED_FIELDS:
        if field not in fm:
            errors.append(f"{f}: missing required field '{field}'")

    for mf in REQUIRED_META:
        if mf not in fm:
            errors.append(f"{f}: missing metadata sub-field '{mf}'")

    type_match = re.search(r'type:\s*(\S+)', fm)
    if type_match and type_match.group(1) not in VALID_TYPES:
        errors.append(f"{f}: invalid type '{type_match.group(1)}' — must be one of {VALID_TYPES}")

    date_match = re.search(r'last_updated:\s*(\S+)', fm)
    if date_match:
        recorded = date_match.group(1).strip('"\'')
        if recorded != TODAY:
            warnings.append(f"{f}: last_updated is '{recorded}', expected today ({TODAY})")

# Check MEMORY.md line count if staged
for filepath in staged_files:
    if pathlib.Path(filepath).name == "MEMORY.md":
        lines = pathlib.Path(filepath).read_text(encoding="utf-8-sig").splitlines()
        if len(lines) > 200:
            warnings.append(f"{filepath}: MEMORY.md has {len(lines)} lines — keep under 200 to avoid context truncation")

for w in warnings:
    print(f"  WARNING: {w}")

if errors:
    print("")
    for e in errors:
        print(f"  ERROR:   {e}")
    print("")
    print(f"  ✗ {len(errors)} error(s) — fix before committing.")
    sys.exit(1)

count = len(staged_files)
print(f"  ✓ {count} file(s) valid.")
PYEOF

echo ""
