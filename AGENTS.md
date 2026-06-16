# mem-con — Agent Instructions

This repo is a generic team context service. It stores structured memory for any team,
role, or project. Any AI coding agent should read this file at session start.

---

## What This Repo Is

`mem-con` stores typed memory files organized by team and area (`memory/{team}/{area}/`).
Used as a git submodule (at `.context/`) or standalone clone (`~/.memcon`).
Agents load this context to assist any role with work grounded in real project history.

---

## Session Start — Always Do This First

### 1. Read user-profile.yaml
Located in repo root or `~/.memcon/user-profile.yaml`.
If missing: tell the user to run `/configure-sources` or `bash scripts/init-user.sh`.

### 2. Read .memcon-context
Contains one context id (e.g., `eng-backend`). Match to `user-profile.yaml contexts[]`.
If missing: list available contexts, ask user to pick, write file.

### 3. Load memory in order
1. `memory/shared/` — all 5 files (MEMORY.md, user.md, project.md, feedback.md, reference.md)
2. `memory/{path}/` — all 5 files for the active context path

### 4. Check environment capabilities
Read `environment.mcps`, `environment.agents`, `environment.client` from user-profile.yaml.
Never attempt an MCP call or agent dispatch not listed in the environment block.

---

## The 5 Memory File Types

| File | Contents |
|------|----------|
| `MEMORY.md` | Index — one-line summaries of the other 4 files |
| `user.md` | Team member roles, expertise, working preferences |
| `project.md` | Active work, decisions, deadlines, priorities |
| `feedback.md` | What worked/failed in past sessions, agent guidance |
| `reference.md` | Tools, dashboards, integrations, links |

---

## The Workflow — Discover → Define → Build → Review → Capture

### Phase 1 — Discover

1. Review `feedback.md` and `project.md` for the active context
2. For each source in `user-profile.yaml contexts[active].sources[]`:
   - Check `requires[]` against `environment.mcps` — skip if MCP not available
   - Load adapter from `skills/sources/{type}.md`
   - Execute query via specified MCP
   - Tag results with `feeds_into` target
3. Produce Signal Summary:

```
## Signal Summary — {context name} — {date}

### Active work / signals:
- [what's happening, from memory + sources]

### Recent decisions:
- [decisions from memory files or source queries]

### Flagged items:
- [anything time-sensitive or unresolved]

### Sources skipped:
- [any sources that were unavailable and why]
```

Gate: Show Signal Summary. Ask: "Does this capture the key signals? Anything missing?"

---

### Phase 2 — Define

Frame the goal or problem:

```
## Goal / Problem Definition

**What:** [one sentence]
**Who is affected:** [team, users, stakeholders]
**Evidence:** [cite source: memory file, Slack message, Jira ticket, meeting note]
**Impact:** [what happens if not addressed]
```

Gate: Get explicit approval before Phase 3.

---

### Phase 3 — Build

Produce the work artifact. Infer format from user's `role`:

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

Gate: Show artifact. Ask: "Does this look right? Should I proceed?"

---

### Phase 4 — Review

Explicit user approval. Never advance to Capture without "yes."

---

### Phase 5 — Capture

At session end:
1. Summarize what was decided
2. Draft proposed updates:
   - `project.md`: new decisions, status changes
   - `feedback.md`: what approach worked or failed
   - `reference.md`: new tool links, queries, dashboards discovered
3. Show proposed changes. Ask: "Should I update context memory with these learnings?"
4. **Write only after explicit approval.**

---

## Populating Unseeded Areas

If an area's memory files are mostly empty (show "Unseeded"):
1. Check `user-profile.yaml` for configured sources for this context
2. Query each source following its adapter in `skills/sources/`
3. Draft all 4 typed files
4. Show drafts: "DRAFT — please review before committing"
5. Write only after approval

---

## Critical Rules

- **Never write to memory files** without explicit user approval
- **Always load `memory/shared/`** before area-specific memory
- **Always show proposed changes** before writing
- **Degrade gracefully** — skip unavailable sources, note what was skipped
- **Gate at every phase** — do not advance without user acknowledgment
