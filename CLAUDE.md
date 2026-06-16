# mem-con — Shared Context Service

This repo is a generic team context service for any role, team, or project.
It stores structured memory in typed markdown files organized by team and area.

---

## Step 1 — Read user-profile.yaml

At session start, read `user-profile.yaml` (in repo root or `~/.memcon/`).
If missing: run `/configure-sources` to set it up interactively.

Key fields to extract:
- `name`, `role` — who this person is
- `environment.client` — which AI client (claude-code, cursor, vscode, etc.)
- `environment.mcps` — what MCP servers are available with their commands
- `environment.skills` — what slash commands are installed
- `environment.agents` — what agent types are available
- `contexts[]` — all named contexts (id, name, role, repo, path, sources)
- `default_context` — which context to use if `.memcon-context` is absent

---

## Step 2 — Read .memcon-context

Read `.memcon-context` in the repo root. It contains a single context id (e.g., `eng-backend`).
Match it to a context entry in `user-profile.yaml`.

If `.memcon-context` is missing or the id doesn't match any context:
1. List all context ids and names from `user-profile.yaml`
2. Ask: "Which context are you working in today?"
3. Write the chosen id to `.memcon-context`

---

## Step 3 — Load memory

From the active context's `repo` and `path` fields, load in this order:
1. `memory/shared/MEMORY.md` — org-wide index
2. `memory/shared/` — all 4 shared files
3. `memory/{path}/MEMORY.md` — area index
4. `memory/{path}/` — all 4 area files

---

## Step 4 — Check environment capabilities

Before querying any source or dispatching any agent:
- Only attempt MCP calls for servers listed in `environment.mcps`
- Only dispatch agents listed in `environment.agents`
- Check `requires_client` on sources — skip if current client isn't listed
- If a required capability is missing: skip that source, log what was skipped

---

## Step 5 — Run Discover → Define → Build → Review → Capture

### Discover
Review memory files for active context. Query configured sources (check `requires`
against `environment.mcps` for each). Produce a Signal Summary.
Gate: show summary, ask "Does this capture the key signals?"

### Define
Frame the goal or problem: what, who, evidence, impact.
Gate: get explicit approval before Build.

### Build
Produce work artifact — format adapts to user's `role`:

| Role | Artifact |
|------|----------|
| Product Manager | Feature spec, user stories, prototype brief |
| Engineer | Design doc, task breakdown, ADR |
| Designer | Design brief, research plan, component spec |
| Marketer | Campaign brief, copy draft, content plan |
| Sales | Deal summary, objection map, proposal outline |
| Customer Success | Runbook, escalation doc, onboarding plan |
| Executive | Decision memo, OKR update, strategy brief |
| Tech Writer | Doc outline, release notes draft |
| HR | Job description, process doc, policy note |
| Live Ops | Incident runbook, on-call guide, playbook |

Gate: show artifact, get explicit approval.

### Review
Explicit user approval. Never advance without "yes."

### Capture
Propose memory updates. Show proposed changes. Write only after confirmation.

---

## Critical Rules

- **Never write to memory files** without explicit user approval
- **Always load `memory/shared/`** before area-specific memory
- **Always show proposed changes** before writing, no matter how small
- **Degrade gracefully** — skip unavailable sources, note what was skipped
- **Gate at every phase** — do not advance without acknowledgment
