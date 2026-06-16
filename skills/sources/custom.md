---
name: source-custom
description: Escape hatch adapter for any MCP or tool not covered by built-in adapters
---

# Source Adapter: custom

Handles user-defined sources using any available MCP with a free-form query instruction.

**Requires:** The MCP specified in the source config's `mcp` field
**Feeds into:** Whatever the user specifies in `feeds_into`

## Config fields

```yaml
- id: my-custom-source
  type: custom
  mcp: linear              # any MCP id from environment.mcps
  requires: [linear.list_issues]  # specific command needed
  description: "My Linear board — in-progress issues"
  query: "list issues assigned to me with status In Progress, updated last 14 days"
  feeds_into: project.md
```

## Query steps

1. Verify the specified `mcp` is in `environment.mcps`
2. Verify the specified command in `requires[]` is in that MCP's commands list
3. Interpret the `query` field as a natural language instruction
4. Call the appropriate MCP command with parameters inferred from `query` and `description`
5. Extract and summarize the result

## Output format

```
## Custom Source: {description}
MCP: {mcp} | Query: "{query}"

### Results:
[extracted and summarized content]
```

## Degradation

If specified MCP or command unavailable:
log "Skipped custom '{id}': {mcp}.{command} not found in environment.mcps". Continue.

## Note on adding new built-in adapters

If you use the same custom source configuration repeatedly, consider adding a proper
adapter file to skills/sources/ and registering it in CATALOG.md. This makes the
config shorter and more discoverable for teammates.
