---
name: source-confluence-page
description: Adapter for reading Confluence pages via Confluence MCP or Atlassian MCP
---

# Source Adapter: confluence-page

**Requires:** MCP `confluence` or `atlassian` with command `get_page`
**Feeds into:** `reference.md` (docs, runbooks), `project.md` (project pages)

## Config fields

```yaml
- id: team-confluence
  type: confluence-page
  mcp: confluence
  requires: [confluence.get_page]
  config:
    page_id: "123456"          # Confluence page ID
    include_children: false
    space_key: "ENG"           # optional space filter
  feeds_into: reference.md
```

## Query steps

1. Call `confluence.get_page` with `page_id`
2. Extract page content: headings, body text, tables, links
3. If `include_children: true`: fetch child pages
4. Summarize key sections relevant to the context

## Output format

```
## Confluence: {page title} ({space_key})

### Key sections:
- [{heading}]: [summary]

### Links referenced:
- [url]: [description]
```

## Degradation

If MCP unavailable: log "Skipped confluence-page '{id}': confluence MCP not available". Continue.
