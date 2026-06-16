---
name: review-contribution
description: >
  Pre-PR review of memory changes. Checks structure, content quality, and
  cross-file consistency before pushing. Faster than waiting for CI.
  Trigger phrases: "/review-contribution", "review my memory changes", "check before PR".
---

# review-contribution

Runs a full pre-PR quality check on memory changes before you push.
Flags structural errors, content quality issues, and consistency problems.
Think of it as running CI locally.

---

## Step 1 — Identify changed files

Run: `git diff --staged --name-only` (staged) or `git diff HEAD --name-only` (committed).
Filter to `memory/**/*.md` files.

If nothing is staged/committed, check the full area directory from `.memcon-context`.
If `.memcon-context` doesn't exist, ask: "Which area are you reviewing?"

---

## Step 2 — Structural checks (blocking)

For every changed `.md` file in `memory/`:

- [ ] Frontmatter block exists (opens and closes with `---`)
- [ ] `name:` field present and matches the filename without the `.md` extension
- [ ] `description:` present, non-empty, not a placeholder like "TODO" or "..."
- [ ] `metadata.type:` is one of: `user`, `project`, `feedback`, `reference`, `index`
- [ ] `metadata.area:` matches the active area slug
- [ ] `metadata.last_updated:` is set to today's date in `YYYY-MM-DD` format

If `MEMORY.md` was changed:
- [ ] Total line count is under 200 (it loads into every session context window)
- [ ] Every changed file has a corresponding pointer entry

These are **blocking**: do not proceed until all pass.

---

## Step 3 — Content quality checks (warnings)

**project.md:** Every initiative entry must have:
- A `**Why:**` line explaining motivation or constraint
- A `**How to apply:**` line explaining when this context matters

**feedback.md:** Every rule entry must have:
- A `**Why:**` line (the incident or principle behind the rule)
- A `**How to apply:**` line (when the rule kicks in; edge cases where it doesn't)

**user.md:** Check that:
- Entries describe specific, concrete preferences — not generic ("prefers clear communication")
- Profile reflects current role and context, not past state

**reference.md:** Check that:
- Any `visualization:` YAML block uses consistent indentation (2 spaces, no tabs)
- Date ranges and filters look reasonable (not hard-coded stale dates)

---

## Step 4 — Consistency checks

- Area slug in `metadata.area:` matches the directory name and `.memcon-context`
- Any `[[linked-memory-name]]` cross-references resolve to an existing file in the same area
- If an area is newly seeded: `manifest.yaml` has `seeded: true` for that area

---

## Step 5 — Report

Print:
```
review-contribution report  ({area})
──────────────────────────────────────
✓ Structural:   N/N checks passed
⚠ Warnings:     [list each, one per line]
✗ Errors:       [list each, one per line]
```

**If errors**: "Fix N blocking error(s) before pushing."
**If warnings only**: "Ready to push — review N warning(s) and decide if they need addressing."
**If all clear**: "All checks passed. Ready to push."
