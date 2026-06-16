#!/usr/bin/env bash
# init-user.sh — interactive setup for user-profile.yaml
set -euo pipefail

MEMCON_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE="${MEMCON_HOME}/user-profile.yaml"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  mem-con — Personal Context Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ -f "$PROFILE" ]; then
  echo "user-profile.yaml already exists at ${PROFILE}"
  echo "Edit it directly or delete it and re-run this script."
  exit 0
fi

echo "This script creates your personal user-profile.yaml."
echo "It will NOT be committed to the shared repo."
echo ""

read -rp "Your name: " USER_NAME
read -rp "Your email: " USER_EMAIL
read -rp "Your primary role (e.g. Engineer, PM, Designer): " USER_ROLE

echo ""
echo "Available teams (from team.yaml):"
python3 -c "
import yaml
with open('${MEMCON_HOME}/team.yaml') as f:
    cfg = yaml.safe_load(f)
for t in cfg.get('teams', []):
    print(f\"  {t['slug']} — {t['name']}\")
    for a in t.get('areas', []):
        print(f\"    {t['slug']}/{a['slug']} — {a['name']}\")
"

echo ""
read -rp "Your primary team/area path (e.g. engineering/backend): " CONTEXT_PATH
read -rp "Context label (e.g. 'Engineering / Backend'): " CONTEXT_LABEL
read -rp "Team repo URL: " TEAM_REPO

CONTEXT_ID=$(echo "$CONTEXT_PATH" | tr '/' '-')

cp "${MEMCON_HOME}/user-profile.yaml.example" "$PROFILE"

python3 - <<PYEOF
with open("${PROFILE}") as f:
    content = f.read()

content = content.replace('"Your Name"', '"${USER_NAME}"')
content = content.replace('"you@company.com"', '"${USER_EMAIL}"')
content = content.replace('"Senior Engineer"', '"${USER_ROLE}"')
content = content.replace('"my-primary"', '"${CONTEXT_ID}"')
content = content.replace('"Engineering / Backend"', '"${CONTEXT_LABEL}"')
content = content.replace('"https://github.com/your-org/mem-con.git"', '"${TEAM_REPO}"')
content = content.replace('"engineering/backend"', '"${CONTEXT_PATH}"')
content = content.replace('default_context: my-primary', 'default_context: ${CONTEXT_ID}')

with open("${PROFILE}", "w") as f:
    f.write(content)
print("user-profile.yaml written to ${PROFILE}")
PYEOF

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Setup complete."
echo "  Next: open ${PROFILE} and add your sources"
echo "  Then run: /populate-context ${CONTEXT_ID}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
