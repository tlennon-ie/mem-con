---
name: contribute
description: >
  Guide a team member through contributing memory updates to mem-con.
  Validates structure, runs the team-challenge, and opens a PR.
  Trigger phrases: "contribute", "update memory for X", "/contribute".
---

# contribute

Guides a team member through making a well-formed memory contribution.
Runs structural validation and team-challenge before opening a PR.

---

## Step 1 — Identify the area

Ask: "Which team area are you updating memory for?" (e.g. `backend`, `approvals`)

Map the slug to its team using the table in manifest.yaml.
Confirm AREA_DIR = `memory/{team-slug}/{area}/`

**If the team member says `shared` or `memory/shared/`:**
> "Shared memory (`memory/shared/`) applies to every team member and is not
> auto-submitted. Changes here require explicit team review. Continue only if
> you intend to propose a team-wide update. When ready, use `/sync-memory`
> to open a PR — it will **not** be opened automatically after your commit."

Proceed only if the team member confirms. Do not write `.memcon-context = shared` — shared
sessions must be submitted manually.

For all other areas, write the active area:
```
echo "{area}" > .memcon-context
```

---

## Step 2 — Show current state

Read all 4 typed files for the area. Summarize:
- What is currently captured
- The last_updated date on each file
- Obvious gaps (empty files, placeholder text, missing Why/How lines)

---

## Step 3 — Gather new content from the team member

Ask each of the following, one at a time:
- "What changed since the last update? Any new decisions or shipped features?"
- "Any changed priorities, timelines, or stakeholder shifts?"
- "Any new feedback — what worked, what failed, what should agents do differently?"
- "Any new dashboards, filters, queries, or tool links to add to reference.md?"

Listen and synthesize into draft changes.

---

## Step 4 — Draft the update

Write proposed changes to the relevant typed files.
Label clearly at the top: `<!-- DRAFT — not yet committed -->`

Show the team member a clean before/after for each changed file.

---

## Step 5 — Run /team-challenge

Invoke the `team-challenge` skill on the proposed draft.
The team member must address or explicitly dismiss each question before proceeding to Step 6.

---

## Step 6 — Validate structure

Check all of the following. Block on errors; warn on style issues.

**Frontmatter (every .md file):**
- [ ] `name:` matches the filename (without .md)
- [ ] `description:` is present and specific (not generic placeholder)
- [ ] `metadata.type:` is one of: user, project, feedback, reference, index
- [ ] `metadata.area:` matches the active area slug
- [ ] `metadata.last_updated:` is set to today's date

**feedback.md and project.md:**
- [ ] Every entry has a `**Why:**` line
- [ ] Every entry has a `**How to apply:**` line

**MEMORY.md:**
- [ ] Every new memory file has a pointer entry
- [ ] Total line count is under 200

**reference.md:**
- [ ] All `visualization:` YAML blocks are valid (correct indentation, no tabs)

---

## Step 7 — Commit and open PR

Once user approves:
1. Remove the `<!-- DRAFT -->` labels
2. Stage changed files: `git add memory/{team-slug}/{area}/`
3. Commit: `context({area}): {one-line description of what changed}`
4. The post-commit hook will offer to open a PR automatically.
   If it doesn't fire, run `/sync-memory` to open one manually.
