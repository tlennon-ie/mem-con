---
name: source-slack-canvas
description: Adapter for reading Slack canvas documents via Slack MCP
---

# Source Adapter: slack-canvas

**Requires:** MCP `slack` with command `read_canvas`
**Feeds into:** `reference.md` (runbooks, docs), `project.md` (current state docs)

## Config fields

```yaml
- id: my-canvas
  type: slack-canvas
  mcp: slack
  requires: [slack.read_canvas]
  config:
    canvas_id: "F0123456789"   # Canvas file ID (from Slack URL)
    channel: "#channel-name"   # optional: channel context
  feeds_into: reference.md
```

## Query steps

1. Call `slack.read_canvas` with `canvas_id`
2. Extract structured content: headings, bullet points, tables, links
3. Summarize key sections relevant to project or reference context

## Output format

```
## Slack Canvas: {canvas title}

### Key content:
- [section heading]: [summary of content]

### Links and references:
- [any URLs or cross-references found]
```

## Degradation

If MCP call fails: log "Skipped slack-canvas '{id}': {error}". Continue with other sources.
