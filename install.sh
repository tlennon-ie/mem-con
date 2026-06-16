#!/usr/bin/env bash
# install.sh — mem-con one-command setup
set -euo pipefail

MEMCON_HOME="${HOME}/.memcon"
TEAM_YAML="${MEMCON_HOME}/team.yaml"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  mem-con install"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# ── Detect setup path ────────────────────────────────────────────────────────
EXISTING_PROFILE="${MEMCON_HOME}/user-profile.yaml"

if [ -f "$EXISTING_PROFILE" ]; then
  SETUP_PATH="add-context"
elif [ -f "$TEAM_YAML" ] && grep -q "your-org" "$TEAM_YAML" 2>/dev/null; then
  SETUP_PATH="team-setup"
elif [ -f "$TEAM_YAML" ]; then
  SETUP_PATH="member-setup"
else
  SETUP_PATH="fresh"
fi

# ── Clone or update mem-con ──────────────────────────────────────────────────
if [ -d "${MEMCON_HOME}/.git" ]; then
  echo "→ Updating existing mem-con at ${MEMCON_HOME}..."
  git -C "$MEMCON_HOME" pull --ff-only
else
  TEAM_REPO="${1:-}"
  if [ -z "$TEAM_REPO" ]; then
    echo ""
    echo "What is your team repo URL? (from team.yaml organization.team_repo)"
    read -r TEAM_REPO
  fi
  echo "→ Cloning ${TEAM_REPO} to ${MEMCON_HOME}..."
  git clone "$TEAM_REPO" "$MEMCON_HOME"
fi

# ── Install git hooks into current repo ─────────────────────────────────────
echo ""
echo "→ Installing git hooks..."
CURRENT_REPO_GIT=$(git rev-parse --git-dir 2>/dev/null || echo "")
if [ -z "$CURRENT_REPO_GIT" ]; then
  echo "  Not in a git repo — skipping hook install."
  echo "  Run install.sh from inside your working git repo to install hooks."
else
  cp "${MEMCON_HOME}/hooks/post-session.sh" "${CURRENT_REPO_GIT}/hooks/post-commit"
  chmod +x "${CURRENT_REPO_GIT}/hooks/post-commit"
  echo "  ✓ post-commit hook installed"

  cp "${MEMCON_HOME}/hooks/pre-commit.sh" "${CURRENT_REPO_GIT}/hooks/pre-commit"
  chmod +x "${CURRENT_REPO_GIT}/hooks/pre-commit"
  echo "  ✓ pre-commit hook installed"
fi

# ── Path-specific setup ──────────────────────────────────────────────────────
if [ "$SETUP_PATH" = "fresh" ] || [ "$SETUP_PATH" = "team-setup" ]; then
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  Next: customize team.yaml, then run scaffold"
  echo ""
  echo "  1. Edit ${MEMCON_HOME}/team.yaml"
  echo "     - Set organization.name and organization.team_repo"
  echo "     - Set tools you use (slack, jira, notion, etc.)"
  echo "     - Customize teams and areas to match your org"
  echo ""
  echo "  2. bash ${MEMCON_HOME}/scripts/scaffold.sh"
  echo "     Generates memory/ structure from team.yaml"
  echo ""
  echo "  3. bash ${MEMCON_HOME}/scripts/init-user.sh"
  echo "     Sets up your personal user-profile.yaml"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
else
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  Next: set up your personal context"
  echo ""
  echo "  bash ${MEMCON_HOME}/scripts/init-user.sh"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

echo ""
