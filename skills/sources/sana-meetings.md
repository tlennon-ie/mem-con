---
name: source-sana-meetings
description: Adapter for querying Sana meeting notes via Sana MCP
---

# Source Adapter: sana-meetings

**Requires:** MCP `sana` with commands `get_meeting`, `query`
**Feeds into:** `project.md` (decisions from meetings), `feedback.md` (recurring themes)

## Config fields

```yaml
- id: team-meetings
  type: sana-meetings
  mcp: sana
  requires: [sana.query]
  config:
    keywords: ["backend", "API", "sprint"]  # search terms
    lookback_days: 30
    max_meetings: 10
  feeds_into: project.md
```

## Query steps

1. Call `sana.query` with keyword list and date range (lookback_days from today)
2. For each result meeting: call `sana.get_meeting` for full summary/transcript
3. Extract: decisions made, action items, stakeholders mentioned, next steps

## Output format

```
## Sana Meetings: {keywords} (last {lookback_days} days)

### {meeting title} — {date}
- Decisions: [list]
- Action items: [list]
- Key participants: [list]
```

## Degradation

If MCP unavailable: log "Skipped sana-meetings '{id}': sana MCP not available". Continue.
