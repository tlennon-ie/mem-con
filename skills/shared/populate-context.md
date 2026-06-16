---
name: populate-context
description: >
  Seed a mem-con area with real content by querying configured sources from user-profile.yaml.
  Use when an area shows seeded:false, or to refresh context.
  Trigger: "populate context for X", "seed the X area", "/populate-context X"
---

# populate-context

Seeds a mem-con area with real content from sources configured in user-profile.yaml.
Produces drafts of all 4 typed memory files for user review before committing.

---

## Step 1 — Identify the target area

User invokes: `/populate-context {area-slug}` or `/populate-context {context-id}`

If no argument provided:
1. Read `.memcon-context` to get active context id
2. Look up context in `user-profile.yaml` to get `path`
3. Use the area portion of the path (e.g., `engineering/backend` → area is `backend`)

Resolve `AREA_DIR` = `memory/{team-slug}/{area-slug}/`

---

## Step 2 — Load source configuration

Read `user-profile.yaml`:
1. Find the active context (matching id from `.memcon-context`)
2. Get `sources[]` for this context
3. Check `environment.mcps`, `environment.agents`, `environment.client`, `environment.skills`

If a source has `template:` key: look up that id in `team.yaml` `source_templates[]`,
then apply any `config:` overrides from the user source definition.

---

## Step 3 — Query each source

For each source in `sources[]`:

1. Look up `type` in `skills/sources/CATALOG.md`
2. Check `requires[]` against `environment.mcps`:
   - MCP id must be listed in environment.mcps AND the required command must be in its commands list
   - If not: skip, log "Skipped {id}: {mcp}.{command} not available"
3. Check `requires_client[]` if present:
   - If `environment.client` not in list: skip, log reason
4. Load adapter from `skills/sources/{type}.md`
5. Execute query following the adapter's instructions
6. Tag results with `feeds_into` value

If all sources fail or skip: continue with available information, note all gaps.

---

## Step 4 — Aggregate by feeds_into

Group extracted content:
- `project.md`: decisions, active work, recent signals, open questions
- `reference.md`: tool links, dashboards, queries, integration configs
- `user.md`: team member info, roles, preferences (if gathered)
- `feedback.md`: patterns and guidance (often sparse on first seed)

---

## Step 5 — Draft all 4 typed files

Using aggregated content, draft each file. Preserve frontmatter structure from existing files.
Set `seeded: false` — only set to `true` after user approves.

Label each draft: "DRAFT — please review before committing."

---

## Step 6 — User review gate

Present each draft file. Ask:
- "Does this look accurate for your {area} context?"
- "Anything missing or incorrect?"
- "Any sensitive information to remove before sharing with the team?"

Revise based on feedback. Repeat for each file.

---

## Step 7 — Write approved files and update manifest

After user approves each file:
1. Write to `AREA_DIR/` — set `seeded: true`, set `last_updated` to today
2. Update `manifest.yaml`: set `areas.{area-slug}.seeded: true`
3. Write active context id to `.memcon-context` if not already set

Tell user: "Files written. The post-session hook will offer to open a PR at your next commit."
