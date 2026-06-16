---
name: source-notion-page
description: Adapter for reading Notion pages and databases via Notion MCP
---

# Source Adapter: notion-page

**Requires:** MCP `notion` with command `retrieve_page`
**Feeds into:** `reference.md` (wikis, docs), `project.md` (active project pages)

## Config fields

```yaml
- id: team-wiki
  type: notion-page
  mcp: notion
  requires: [notion.retrieve_page]
  config:
    page_id: "abc123..."       # Notion page ID (from URL)
    include_children: true     # recursively include child pages
    max_depth: 2               # child page depth limit
  feeds_into: reference.md
```

## Query steps

1. Call `notion.retrieve_page` with `page_id`
2. If `include_children: true`: recursively fetch child pages up to `max_depth`
3. Extract: headings, summaries, decisions, action items, linked resources
4. For databases: extract recent entries if relevant

## Output format

```
## Notion: {page title}

### Key sections:
- [{section heading}]: [summary]

### Decisions / action items:
- [item + context]

### Child pages referenced:
- [{child title}]: [one-line summary]
```

## Degradation

If MCP unavailable: log "Skipped notion-page '{id}': notion MCP not available". Continue.
