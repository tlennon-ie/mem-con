#!/usr/bin/env bash
# scaffold.sh — generate memory/ structure from team.yaml
# Run from repo root after editing team.yaml
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEAM_YAML="${REPO_ROOT}/team.yaml"
MEMORY_DIR="${REPO_ROOT}/memory"
TODAY=$(date +%Y-%m-%d)

if [ ! -f "$TEAM_YAML" ]; then
  echo "Error: team.yaml not found at ${TEAM_YAML}"
  echo "Copy team.yaml.example to team.yaml and customize it first."
  exit 1
fi

if ! command -v python3 &>/dev/null; then
  echo "Error: python3 is required for YAML parsing. Install Python 3 and retry."
  exit 1
fi

cd "$REPO_ROOT"

ENTRIES=$(python3 - <<'PYEOF'
import yaml, sys
with open("team.yaml") as f:
    config = yaml.safe_load(f)
for team in config.get("teams", []):
    ts = team["slug"]
    tn = team["name"]
    for area in team.get("areas", []):
        print(f"{ts}\t{tn}\t{area['slug']}\t{area.get('name', area['slug'])}")
PYEOF
)

create_area_files() {
  local team_slug="$1" team_name="$2" area_slug="$3" area_name="$4"
  local dir="${MEMORY_DIR}/${team_slug}/${area_slug}"
  mkdir -p "$dir"

  [ -f "${dir}/MEMORY.md" ] || cat > "${dir}/MEMORY.md" << EOF
---
name: ${area_slug}-memory-index
description: Memory index for ${area_name} — pointers to all typed context files
metadata:
  type: index
  area: ${area_slug}
  team: ${team_slug}
  last_updated: ${TODAY}
---

# ${area_name} — Memory Index

- [user.md](user.md) — Team member roles and preferences
- [project.md](project.md) — Active work, decisions, stakeholders
- [feedback.md](feedback.md) — Agent guidance, what worked/failed
- [reference.md](reference.md) — Tools, dashboards, integration configs

**Status:** Unseeded — run \`/populate-context ${area_slug}\` to fill with real content.
EOF

  [ -f "${dir}/user.md" ] || cat > "${dir}/user.md" << EOF
---
name: ${area_slug}-user
description: Team member roles, expertise, and working preferences for ${area_name}
metadata:
  type: user
  area: ${area_slug}
  team: ${team_slug}
  last_updated: ${TODAY}
  seeded: false
---

# ${area_name} — Team Context

**Primary contact:** TBD (update CODEOWNERS)

**Team roles:** [Unseeded — run /populate-context ${area_slug}]

**Domain expertise:** [Unseeded]

**Working preferences:** [Unseeded]
EOF

  [ -f "${dir}/project.md" ] || cat > "${dir}/project.md" << EOF
---
name: ${area_slug}-project
description: Active work, decisions, and stakeholder context for ${area_name}
metadata:
  type: project
  area: ${area_slug}
  team: ${team_slug}
  last_updated: ${TODAY}
  seeded: false
---

# ${area_name} — Project Context

**Active work:** [Unseeded — run /populate-context ${area_slug}]

**Recent decisions:** [Unseeded]

**Key stakeholders:** [Unseeded]

**Why:** [Unseeded]

**How to apply:** [Unseeded]
EOF

  [ -f "${dir}/feedback.md" ] || cat > "${dir}/feedback.md" << EOF
---
name: ${area_slug}-feedback
description: Agent guidance and what worked or failed for ${area_name}
metadata:
  type: feedback
  area: ${area_slug}
  team: ${team_slug}
  last_updated: ${TODAY}
  seeded: false
---

# ${area_name} — Feedback and Agent Guidance

[Unseeded — populated via post-session hook after each agent session]
EOF

  [ -f "${dir}/reference.md" ] || cat > "${dir}/reference.md" << EOF
---
name: ${area_slug}-reference
description: External systems, dashboards, and integration configs for ${area_name}
metadata:
  type: reference
  area: ${area_slug}
  team: ${team_slug}
  last_updated: ${TODAY}
  seeded: false
---

# ${area_name} — References

**Project tracking:** [Unseeded — run /populate-context ${area_slug}]

**Key dashboards:** [Unseeded]

**Shared docs:** [Unseeded]

**Communication channels:** [Unseeded]

## Integrations

\`\`\`yaml
# integrations — tool queries and links, populated by populate-context
# sources: slack | google-drive | jira | notion | github | custom
integrations: []
\`\`\`
EOF

  echo "  ✓ ${team_slug}/${area_slug}/"
}

create_team_readme() {
  local team_slug="$1" team_name="$2"
  local dir="${MEMORY_DIR}/${team_slug}"
  mkdir -p "$dir"
  [ -f "${dir}/README.md" ] && return
  cat > "${dir}/README.md" << EOF
# ${team_name}

Memory files for the ${team_name} team. Areas are defined in team.yaml.

Each area contains: MEMORY.md, user.md, project.md, feedback.md, reference.md.
EOF
}

generate_manifest() {
  local manifest="${REPO_ROOT}/manifest.yaml"
  echo "# mem-con manifest — area seeding status" > "$manifest"
  echo "# Updated by populate-context skill on approval" >> "$manifest"
  echo "" >> "$manifest"
  echo "areas:" >> "$manifest"
  while IFS=$'\t' read -r team_slug team_name area_slug area_name; do
    [ -z "$team_slug" ] && continue
    echo "  ${area_slug}: {seeded: false, team: ${team_slug}}" >> "$manifest"
  done <<< "$ENTRIES"
  echo "" >> "$manifest"
  echo "shared: {seeded: false}" >> "$manifest"
}

echo "Scaffolding memory/ from team.yaml..."
mkdir -p "${MEMORY_DIR}/shared"

while IFS=$'\t' read -r team_slug team_name area_slug area_name; do
  [ -z "$team_slug" ] && continue
  create_team_readme "$team_slug" "$team_name"
  create_area_files "$team_slug" "$team_name" "$area_slug" "$area_name"
done <<< "$ENTRIES"

generate_manifest

echo ""
echo "Done."
echo "Memory structure:"
find "${MEMORY_DIR}" -type d | sort | sed "s|${REPO_ROOT}/||"
echo ""
total=$(find "${MEMORY_DIR}" -name "*.md" | wc -l)
echo "Total files: ${total}"
echo ""
echo "Next steps:"
echo "  - Run /populate-context {area} to seed an area with real content"
echo "  - Update CODEOWNERS with team member GitHub usernames"
