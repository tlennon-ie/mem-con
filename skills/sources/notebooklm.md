---
name: source-notebooklm
description: Adapter for querying NotebookLM notebooks via NotebookLM MCP
---

# Source Adapter: notebooklm

**Requires:** MCP `notebooklm` with command `notebook_query`
**Feeds into:** `project.md`, `reference.md` (synthesized research context)

## Config fields

```yaml
- id: team-research
  type: notebooklm
  mcp: notebooklm
  requires: [notebooklm.notebook_query]
  config:
    notebook_id: "abc123..."    # NotebookLM notebook ID
    query: "current state of backend architecture decisions"
  feeds_into: reference.md
```

## Query steps

1. Call `notebooklm.notebook_query` with `notebook_id` and `query`
2. Extract synthesized answer and source citations
3. Note which sources the notebook drew from

## Output format

```
## NotebookLM: {notebook_id}
Query: "{query}"

### Synthesized answer:
[notebook response]

### Sources cited:
- [source name/type]
```

## Degradation

If MCP unavailable: log "Skipped notebooklm '{id}': notebooklm MCP not available". Continue.
