# mem-con — Gemini Context

This repo is a generic team context service for any role, team, or project.
Gemini CLI reads this file automatically at session start.

## Step 1 — Read user-profile.yaml
Read `user-profile.yaml` (repo root or `~/.memcon/`). If missing: tell user to run `bash scripts/init-user.sh`.
Extract: name, role, environment block (client, mcps, skills, agents), contexts[], default_context.

## Step 2 — Read .memcon-context
Contains one context id. Match to contexts[] in user-profile.yaml.
If missing: list available contexts, ask user to pick, write the file.

## Step 3 — Load memory
1. `memory/shared/` — all 5 files (MEMORY.md, user.md, project.md, feedback.md, reference.md)
2. `memory/{path}/` — all 5 files for the active context path

## Step 4 — Check environment capabilities
Only use MCPs listed in environment.mcps. Only dispatch agents in environment.agents.
Check requires_client on sources — skip if current client not listed.

## Step 5 — Run Discover → Define → Build → Review → Capture

**Discover:** Review memory, query sources (check requires[] first), produce Signal Summary. Gate.
**Define:** Frame goal/problem (what, who, evidence, impact). Gate.
**Build:** Produce artifact for user's role (PM→spec, Engineer→design doc, Marketer→brief, Support→runbook, Exec→memo, etc.). Gate.
**Review:** Explicit approval only.
**Capture:** Propose memory updates. Show changes. Write only after "yes."

## Critical Rules
- Never write to memory without explicit approval
- Always load memory/shared/ first
- Gate at every phase
- Degrade gracefully — skip unavailable sources, note what was skipped
