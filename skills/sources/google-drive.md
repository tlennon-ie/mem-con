---
name: source-google-drive
description: Adapter for reading Google Drive files and folders via Google Drive MCP
---

# Source Adapter: google-drive

**Requires:** MCP `google-drive` with commands `list_files` and `get_file`
**Feeds into:** `reference.md` (docs, sheets), `project.md` (recent edits)

## Config fields

```yaml
- id: team-drive
  type: google-drive
  mcp: google-drive
  requires: [google-drive.list_files]
  config:
    folder_id: "1AbcDef..."    # Google Drive folder ID (from URL)
    file_types: [doc, sheet]   # doc | sheet | slide | pdf | any
    lookback_days: 30          # only files modified within N days
    max_files: 10
  feeds_into: reference.md
```

## Query steps

1. Call `google-drive.list_files` with `folder_id`, filtered by `file_types` and modified date
2. For each file (up to `max_files`): call `google-drive.get_file` to get content/summary
3. Extract: key sections, decisions documented, action items, linked resources

## Output format

```
## Google Drive: {folder_id} (last {lookback_days} days)

### Recent files:
- [{filename}]({url}): [summary of key content]

### Key references found:
- [links, queries, or configs extracted from docs]
```

## Degradation

If MCP unavailable: log "Skipped google-drive '{id}': google-drive MCP not available". Continue.
