---
name: source-zoom-transcripts
description: Adapter for reading Zoom meeting recordings/transcripts via Pipedream MCP
---

# Source Adapter: zoom-transcripts

**Requires:** MCP `pipedream` with Zoom app configured
**Feeds into:** `project.md` (meeting decisions), `feedback.md` (recurring topics)

## Config fields

```yaml
- id: sprint-recordings
  type: zoom-transcripts
  mcp: pipedream
  requires: [pipedream.zoom]
  config:
    topic_keywords: ["sprint", "backend", "review"]
    lookback_days: 14
    max_recordings: 5
  feeds_into: project.md
```

## Query steps

1. Call Pipedream Zoom tool to list recent recordings
2. Filter by `topic_keywords` in meeting title and `lookback_days` window
3. For each matching recording: fetch transcript or auto-generated summary
4. Extract: decisions, action items, participants

## Output format

```
## Zoom: {topic_keywords} (last {lookback_days} days)

### {meeting title} — {date}
- Decisions: [list]
- Action items: [list]
```

## Degradation

If Pipedream Zoom unavailable: log "Skipped zoom-transcripts '{id}': pipedream Zoom not configured". Continue.
