---
name: source-slack-search
description: Adapter for searching Slack messages and mentions via Slack MCP
---

# Source Adapter: slack-search

**Requires:** MCP `slack` with command `search`
**Feeds into:** `project.md` (mentions, discussions), `feedback.md` (recurring themes)

## Config fields

```yaml
- id: my-mentions
  type: slack-search
  mcp: slack
  requires: [slack.search]
  config:
    query: "in:#channel mentions:me"  # Slack search query syntax
    lookback_days: 14
    max_results: 50
  feeds_into: project.md
```

## Query steps

1. Call `slack.search` with the configured `query`
2. Filter results to `lookback_days` window
3. Group by channel or topic
4. Extract: decisions made about the user, action items assigned, open questions

## Output format

```
## Slack Search: "{query}" (last {lookback_days} days)

### Relevant discussions:
- [channel]: [summary of thread/message]

### Action items mentioning you:
- [item + context]
```

## Degradation

If MCP call fails: log "Skipped slack-search '{id}': {error}". Continue.
