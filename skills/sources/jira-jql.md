---
name: source-jira-jql
description: Adapter for querying Jira issues via JQL and Jira MCP
---

# Source Adapter: jira-jql

**Requires:** MCP `jira` with command `search_issues`
**Feeds into:** `project.md` (active tickets, decisions), `reference.md` (filter links)

## Config fields

```yaml
- id: my-sprint
  type: jira-jql
  mcp: jira
  requires: [jira.search_issues]
  config:
    jql: "assignee = currentUser() AND sprint in openSprints()"
    max_results: 20
    fields: [summary, status, priority, assignee, updated]
  feeds_into: project.md
```

## Query steps

1. Call `jira.search_issues` with the configured `jql` and `fields`
2. Group results by status (In Progress, Review, Blocked, Done)
3. Extract: issue summaries, blocked items, recently completed, upcoming

## Output format

```
## Jira JQL: "{jql}"

### In Progress:
- [{key}] {summary} — {assignee}

### Blocked:
- [{key}] {summary} — blocker: {reason if available}

### Recently completed:
- [{key}] {summary}

### Upcoming:
- [{key}] {summary}
```

## Degradation

If MCP unavailable: log "Skipped jira-jql '{id}': jira MCP not available". Continue.
