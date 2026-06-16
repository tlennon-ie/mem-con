---
name: source-outlook
description: Adapter for reading Outlook email via Pipedream MCP
---

# Source Adapter: outlook

**Requires:** MCP `pipedream` with Outlook app configured
**Feeds into:** `project.md`, `reference.md`

## Config fields

```yaml
- id: project-outlook
  type: outlook
  mcp: pipedream
  requires: [pipedream.outlook]
  config:
    folder: "Inbox"             # mailbox folder to search
    query: "project OR team"    # keyword filter
    lookback_days: 14
    max_results: 20
  feeds_into: project.md
```

## Query steps

1. Call Pipedream Outlook tool to list/search messages in the configured folder
2. Filter by `query` keywords and `lookback_days` window
3. Extract decisions, action items, stakeholder context

## Output format

```
## Outlook: {folder} — "{query}" (last {lookback_days} days)

### Key messages:
- [subject] from [sender]: [summary]

### Action items:
- [item + context]
```

## Degradation

If Pipedream Outlook unavailable: log "Skipped outlook '{id}': pipedream Outlook not configured". Continue.
