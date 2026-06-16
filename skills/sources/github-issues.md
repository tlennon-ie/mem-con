---
name: source-github-issues
description: Adapter for reading GitHub issues and PRs via GitHub MCP
---

# Source Adapter: github-issues

**Requires:** MCP `github` with command `list_issues`
**Feeds into:** `project.md` (active work), `reference.md` (links)

## Config fields

```yaml
- id: my-prs
  type: github-issues
  mcp: github
  requires: [github.list_issues]
  config:
    repo: "owner/repo"          # GitHub repo in owner/repo format
    filter: assigned            # assigned | created | mentioned | all
    state: open                 # open | closed | all
    labels: []                  # optional label filters
    lookback_days: 14
  feeds_into: project.md
```

## Query steps

1. Call `github.list_issues` with repo, filter, state, and labels
2. Filter by `lookback_days` (updated_at field)
3. Separate issues from PRs (PRs have `pull_request` key)
4. Extract: titles, status, reviewers, blockers

## Output format

```
## GitHub: {repo} ({filter}, {state})

### Open PRs:
- [#{number}] {title} — {state}, {reviewer status}

### Open issues:
- [#{number}] {title} — {labels}
```

## Degradation

If MCP unavailable: log "Skipped github-issues '{id}': github MCP not available". Continue.
