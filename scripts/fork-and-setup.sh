#!/usr/bin/env bash
# scripts/fork-and-setup.sh
#
# First-time bootstrap: fork mem-con to your own GitHub account or org,
# re-point the local remote to your fork, update team.yaml, and run setup.
#
# Usage (from inside a cloned copy of the template repo):
#   bash scripts/fork-and-setup.sh
#
# Requirements: git, gh CLI (https://cli.github.com), python3

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEAM_YAML="${REPO_ROOT}/team.yaml"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  mem-con — Fork & Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Preflight checks ────────────────────────────────────────────────────────
if ! command -v gh &>/dev/null; then
  echo "✗ gh CLI not found."
  echo "  Install it from https://cli.github.com then re-run this script."
  exit 1
fi

if ! command -v python3 &>/dev/null; then
  echo "✗ python3 not found. Required for YAML patching."
  exit 1
fi

if ! gh auth status &>/dev/null; then
  echo "✗ Not logged in to gh CLI."
  echo "  Run:  gh auth login"
  echo "  Then re-run this script."
  exit 1
fi

# ── Detect source repo ──────────────────────────────────────────────────────
SOURCE_REMOTE=$(git -C "$REPO_ROOT" remote get-url origin 2>/dev/null || echo "")
if [ -z "$SOURCE_REMOTE" ]; then
  echo "✗ Could not detect origin remote. Are you inside a cloned git repo?"
  exit 1
fi

# Extract host, owner/repo from remote URL (handles https and ssh)
if [[ "$SOURCE_REMOTE" =~ ^git@([^:]+):(.+)\.git$ ]]; then
  GH_HOST="${BASH_REMATCH[1]}"
  SOURCE_REPO="${BASH_REMATCH[2]}"
elif [[ "$SOURCE_REMOTE" =~ ^https://([^/]+)/(.+)\.git$ ]]; then
  GH_HOST="${BASH_REMATCH[1]}"
  SOURCE_REPO="${BASH_REMATCH[2]}"
elif [[ "$SOURCE_REMOTE" =~ ^https://([^/]+)/(.+)$ ]]; then
  GH_HOST="${BASH_REMATCH[1]}"
  SOURCE_REPO="${BASH_REMATCH[2]}"
else
  echo "✗ Could not parse remote URL: ${SOURCE_REMOTE}"
  echo "  Expected: https://host/owner/repo.git or git@host:owner/repo.git"
  exit 1
fi

IS_GHE=false
GH_HOST_FLAG=""
if [ "$GH_HOST" != "github.com" ]; then
  IS_GHE=true
  GH_HOST_FLAG="--hostname ${GH_HOST}"
fi

echo "  Template repo : ${SOURCE_REMOTE}"
echo "  GitHub host   : ${GH_HOST}"
echo ""

# ── Where to fork ────────────────────────────────────────────────────────────
echo "Where do you want to fork mem-con?"
echo "  1) My personal GitHub account"
echo "  2) A GitHub org or team account"
echo ""
read -rp "Choice [1/2]: " FORK_CHOICE

FORK_ORG_FLAG=""
FORK_OWNER=""
if [ "$FORK_CHOICE" = "2" ]; then
  echo ""
  if [ "$IS_GHE" = true ]; then
    echo "Available orgs on ${GH_HOST}:"
    gh org list $GH_HOST_FLAG 2>/dev/null | head -10 || echo "  (could not list orgs — type the name manually)"
  else
    echo "Available orgs:"
    gh org list 2>/dev/null | head -10 || echo "  (could not list orgs — type the name manually)"
  fi
  echo ""
  read -rp "Org name: " FORK_ORG
  FORK_ORG_FLAG="--org ${FORK_ORG}"
  FORK_OWNER="$FORK_ORG"
else
  FORK_OWNER=$(gh api user $GH_HOST_FLAG --jq '.login' 2>/dev/null || echo "")
  if [ -z "$FORK_OWNER" ]; then
    read -rp "Your GitHub username: " FORK_OWNER
  fi
fi

# ── Repo name for the fork ───────────────────────────────────────────────────
DEFAULT_FORK_NAME="mem-con"
echo ""
read -rp "Fork repo name [${DEFAULT_FORK_NAME}]: " FORK_NAME
FORK_NAME="${FORK_NAME:-$DEFAULT_FORK_NAME}"

# ── Create the fork ──────────────────────────────────────────────────────────
echo ""
echo "  Forking ${SOURCE_REPO} → ${FORK_OWNER}/${FORK_NAME} ..."

# gh repo fork creates the fork; --clone=false since we're already cloned
FORK_FLAGS="$GH_HOST_FLAG $FORK_ORG_FLAG --fork-name ${FORK_NAME} --clone=false"

if ! gh repo fork "${SOURCE_REPO}" $FORK_FLAGS 2>/dev/null; then
  # gh fork exits non-zero if the fork already exists — check if it does
  EXISTING=$(gh repo view "${FORK_OWNER}/${FORK_NAME}" $GH_HOST_FLAG --json url --jq '.url' 2>/dev/null || echo "")
  if [ -n "$EXISTING" ]; then
    echo "  Fork already exists at ${EXISTING} — continuing."
  else
    echo "✗ Fork failed. Check your permissions and try again."
    exit 1
  fi
fi

# Build the fork URL
if [ "$IS_GHE" = true ]; then
  FORK_URL="https://${GH_HOST}/${FORK_OWNER}/${FORK_NAME}.git"
else
  FORK_URL="https://github.com/${FORK_OWNER}/${FORK_NAME}.git"
fi

echo "  ✓ Fork ready: ${FORK_URL}"

# ── Re-point origin to the fork ──────────────────────────────────────────────
echo ""
echo "  Updating git remote origin → ${FORK_URL}"
git -C "$REPO_ROOT" remote set-url origin "$FORK_URL"

# Keep a pointer to the template for future upstream pulls
if git -C "$REPO_ROOT" remote | grep -q "^template$"; then
  git -C "$REPO_ROOT" remote set-url template "$SOURCE_REMOTE"
else
  git -C "$REPO_ROOT" remote add template "$SOURCE_REMOTE"
fi

echo "  ✓ origin  → your fork"
echo "  ✓ template → original template (for future upstream pulls)"

# ── Patch team.yaml ──────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Configure your team"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -rp "Organization name (e.g. Acme Corp): " ORG_NAME

python3 - <<PYEOF
import re

with open("${TEAM_YAML}") as f:
    content = f.read()

content = re.sub(
    r'name:\s*"Your Organization"',
    'name: "${ORG_NAME}"',
    content
)
content = re.sub(
    r'team_repo:\s*"https://github\.com/your-org/mem-con\.git"',
    'team_repo: "${FORK_URL}"',
    content
)

with open("${TEAM_YAML}", "w") as f:
    f.write(content)

print("  ✓ team.yaml updated")
PYEOF

# ── Run scaffold to generate memory/ structure ───────────────────────────────
echo ""
echo "  Generating memory/ structure from team.yaml ..."
bash "${REPO_ROOT}/scripts/scaffold.sh" 2>/dev/null | tail -5

# ── Commit and push to fork ──────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Push initial config to your fork"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

cd "$REPO_ROOT"
git add team.yaml memory/ manifest.yaml 2>/dev/null || true
git commit -m "chore: configure for ${ORG_NAME} — fork of mem-con template" 2>/dev/null || echo "  (nothing new to commit)"
git push -u origin main

echo "  ✓ Pushed to ${FORK_URL}"

# ── Personal setup ────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Set up your personal context"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
read -rp "Set up your user-profile.yaml now? [Y/n]: " DO_INIT
if [[ ! "$DO_INIT" =~ ^[Nn]$ ]]; then
  bash "${REPO_ROOT}/scripts/init-user.sh"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Done. Share this install command with your team:"
echo ""
echo "  git clone ${FORK_URL} ~/.memcon && bash ~/.memcon/install.sh"
echo ""
echo "  To pull future updates from the template:"
echo "  git fetch template && git merge template/main"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
