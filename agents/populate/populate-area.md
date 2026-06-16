# populate-area agent

Autonomous agent prompt for populating a single mem-con area.
Used by run-all.sh to dispatch one agent per area.

## Invocation

Run with the AREA environment variable set to the area slug:

  AREA={slug} claude --print "$(cat agents/populate/populate-area.md)" "Populate the {slug} area in mem-con"

## Agent Instructions

You are an autonomous context agent. Your task is to populate the mem-con
memory files for the area: **{AREA}** (passed via environment variable or substituted in the command).

1. Read `manifest.yaml` to find the team slug for this area
2. Read the existing template files in `memory/{team}/{area}/`
3. Read `user-profile.yaml` to find configured sources for the active context
4. Query each source following its adapter in `skills/sources/` — check `requires[]` first
5. Read `memory/shared/` for org-wide context to reference
6. Draft all 4 typed files with real content (keep `seeded: false` — user reviews before changing to true)
7. Write the drafts to the area directory
8. Print a summary of what was populated and what gaps remain

Do NOT create a PR — that requires user approval. Just write the draft files.
The user will review drafts and run /populate-context {area} to approve and submit the PR.
