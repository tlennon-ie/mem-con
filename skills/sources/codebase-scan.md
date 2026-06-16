---
name: source-codebase-scan
description: Adapter for scanning a codebase using the Explore agent to extract project context
---

# Source Adapter: codebase-scan

**Requires:** Agent type `Explore` (available in claude-code, cursor, vscode)
**Feeds into:** `project.md` (architecture, active files), `reference.md` (file paths, patterns)

## Config fields

```yaml
- id: my-codebase
  type: codebase-scan
  mcp: null
  requires_client: [claude-code, cursor, vscode]
  requires_agent: [Explore]
  config:
    repo_path: "."             # path to repo root (relative or absolute)
    focus_areas:               # optional: limit scan to specific directories
      - src/
      - lib/
    questions:                 # what to extract
      - "What are the main modules and their responsibilities?"
      - "What are the key files changed recently?"
      - "What patterns or conventions are used?"
  feeds_into: project.md
```

## Query steps

1. Verify `Explore` agent is listed in `environment.agents`
2. Verify `environment.client` is in `requires_client` list
3. Dispatch Explore agent to `repo_path` with the configured `questions`
4. For each question: collect findings, file paths, and patterns observed
5. Summarize architecture, recent activity, and key conventions

## Output format

```
## Codebase Scan: {repo_path}

### Architecture / modules:
- [module]: [responsibility]

### Key files / recent activity:
- [path]: [what it does / why it's notable]

### Conventions observed:
- [pattern or convention]
```

## Degradation

If Explore agent unavailable or client not supported:
log "Skipped codebase-scan '{id}': Explore agent not available in this client". Continue.
