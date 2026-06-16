---
name: source-slack-channel
description: Adapter for reading Slack channel messages via Slack MCP
---

# Source Adapter: slack-channel

**Requires:** MCP `slack` with command `read_channel` (or `get_channel_history`)
**Feeds into:** `project.md` (active work signals), `feedback.md` (recurring patterns)

## Config fields

```yaml
- id: my-channel
  type: slack-channel
  mcp: slack
  requires: [slack.read_channel]
  config:
    channel: "#channel-name"   # channel name with # or channel ID (C0123456)
    lookback_days: 14          # default: 14
    max_messages: 100          # default: 100
    exclude_bots: true         # default: true
  feeds_into: project.md
```

## Query steps

1. Call `slack.read_channel` with `channel` and `lookback_days` from config
2. If channel-not-found error: search with `slack.search_channels`, retry with returned ID
3. Filter: if `exclude_bots: true`, remove messages with `subtype == bot_message`
4. Focus on: decisions ("decided", "approved", "going with"), blockers, announcements, open questions
5. Summarize by category

## Output format

```
## Slack: #{channel} (last {lookback_days} days)

### Decisions:
- [decision + approximate date]

### Active work / signals:
- [what people are working on]

### Open questions / blockers:
- [unresolved items]
```

## Degradation

If MCP call fails: log "Skipped slack-channel '{id}': {error}". Continue with other sources.
