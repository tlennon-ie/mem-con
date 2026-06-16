---
name: sync-memory
description: >
  Manually force-push refined context for the active area to mem-con.
  Use when you want to share context immediately without waiting for a session commit.
  Trigger phrases: "sync memory", "push context", "/sync-memory", "share my context for X".
---

# sync-memory

Manually creates a PR to mem-con with the current state of the active area's
memory files. Use this when the post-session hook didn't fire or you want to push
context outside of a commit cycle.

---

## Step 1 — Identify active area

Read `.memcon-context` from the repo root. If it doesn't exist, ask the team member:
"Which area are you syncing context for?" Use the slug (e.g., `backend`).

Write the area slug to `.memcon-context`.

---

## Step 2 — Show current state

Display the contents of all 4 typed files for the active area:
`memory/{team-slug}/{area}/user.md`
`memory/{team-slug}/{area}/project.md`
`memory/{team-slug}/{area}/feedback.md`
`memory/{team-slug}/{area}/reference.md`

Ask: "Is this the context you want to share with the team?"

---

## Step 3 — Open PR

If user confirms, run:

```
bash hooks/post-session.sh
```

The hook will show the diff and prompt for PR creation.
If the hook can't find changes (nothing committed yet), stage and commit first:

```
git add memory/{team-slug}/{area}/
git commit -m "context({area}): manual context sync"
# Hook fires automatically after commit
```
