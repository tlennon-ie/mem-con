---
name: source-gmail
description: Adapter for searching Gmail messages via Gmail or Google Workspace MCP
---

# Source Adapter: gmail

**Requires:** MCP `gmail` with commands `search`, `get_message`
**Feeds into:** `project.md` (active discussions), `reference.md` (important threads)

## Config fields

```yaml
- id: project-email
  type: gmail
  mcp: gmail
  requires: [gmail.search]
  config:
    query: "subject:(backend OR API) newer_than:14d"  # Gmail search syntax
    max_results: 20
    include_thread: true   # fetch full thread, not just subject
  feeds_into: project.md
```

## Query steps

1. Call `gmail.search` with the configured `query`
2. For each result (up to `max_results`): call `gmail.get_message` if `include_thread: true`
3. Extract: decisions made, action items, stakeholder context, links shared
4. Group by thread topic

## Output format

```
## Gmail: "{query}" (recent)

### Key threads:
- [subject]: [summary — who said what, decision or action if any]

### Action items from email:
- [item + sender + date]
```

## Degradation

If MCP unavailable: log "Skipped gmail '{id}': gmail MCP not available". Continue.
