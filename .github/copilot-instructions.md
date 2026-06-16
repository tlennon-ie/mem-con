# Copilot Instructions — mem-con

This repo is a team context store for any org or project.
It contains structured memory organized by team and area.

## Active Context

Read `.memcon-context` at session start. It contains the active context id (e.g., `eng-backend`).
Read `user-profile.yaml` to find the matching context entry — it has the `path` for memory loading.
If `.memcon-context` is absent, ask the user which context they are working in.

## Memory Loading

Always load in this order:
1. `memory/shared/` — org-wide baseline (user.md, project.md, feedback.md, reference.md)
2. `memory/{path}/` — the active context area (same 4 files)

## Memory File Types

| File | Contents |
|------|----------|
| `MEMORY.md` | Index and one-line summaries |
| `user.md` | Team member roles, expertise, preferences |
| `project.md` | Active work, decisions, deadlines |
| `feedback.md` | What worked/failed in past sessions |
| `reference.md` | Tools, dashboards, integrations, links |

## Workflow

When assisting with work, follow this sequence:
1. **Discover** — review memory, surface signals, present Signal Summary
2. **Define** — frame goal/problem (what, who, evidence, impact), get approval
3. **Build** — produce artifact for user's role (spec/design doc/brief/runbook/etc.)
4. **Review** — explicit approval only
5. **Capture** — propose memory updates, show changes, write only after "yes"

**Never write to memory files without explicit user approval.**
Gate at each phase. Degrade gracefully when tools are unavailable.
