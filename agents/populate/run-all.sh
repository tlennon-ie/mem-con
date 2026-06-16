#!/usr/bin/env bash
# agents/populate/run-all.sh
# Dispatches populate-area agents for all unseeded areas
set -euo pipefail

MANIFEST="manifest.yaml"

echo "mem-con: Running population agents for unseeded areas"
echo ""

# Read unseeded areas from manifest
UNSEEDED_AREAS=$(python3 - "$MANIFEST" << 'EOF'
import yaml, sys

with open(sys.argv[1]) as f:
  manifest = yaml.safe_load(f)

areas = manifest.get("areas", {})
for area, state in areas.items():
  if not state.get("seeded", False):
    print(area)
EOF
)

if [ -z "$UNSEEDED_AREAS" ]; then
  echo "All areas are seeded. Nothing to do."
  exit 0
fi

COUNT=$(echo "$UNSEEDED_AREAS" | wc -l | tr -d ' ')
echo "Found ${COUNT} unseeded areas:"
echo "$UNSEEDED_AREAS" | sed 's/^/  - /'
echo ""

read -r -p "Populate all ${COUNT} areas? This will run Claude agents. [y/N] " response
if [[ ! "$response" =~ ^[Yy]$ ]]; then
  echo "Aborted."
  exit 0
fi

# Check claude CLI is available
if ! command -v claude &>/dev/null; then
  echo "ERROR: claude CLI not found. Install Claude Code to run population agents."
  exit 1
fi

SUCCESS=0
FAILED=0

while IFS= read -r area; do
  echo "→ Populating: ${area}..."

  AREA="$area" claude --print \
    "$(cat agents/populate/populate-area.md | sed "s/{AREA}/${area}/g")" \
    "Populate the ${area} area in mem-con. Use configured sources from user-profile.yaml." \
    2>&1 | tail -5

  if [ $? -eq 0 ]; then
    echo "  ✓ ${area} populated"
    SUCCESS=$((SUCCESS + 1))
  else
    echo "  ✗ ${area} failed"
    FAILED=$((FAILED + 1))
  fi

  sleep 2
done <<< "$UNSEEDED_AREAS"

echo ""
echo "Population complete: ${SUCCESS} succeeded, ${FAILED} failed"
echo "Review drafted files before committing. Run /populate-context {area} to review each one."
