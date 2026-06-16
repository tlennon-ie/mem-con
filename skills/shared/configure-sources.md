---
name: configure-sources
description: >
  Interactive setup for user-profile.yaml. Auto-detects AI client and MCPs,
  then walks through context and source configuration.
  Trigger: /configure-sources, "set up my context", "configure my sources"
---

# configure-sources

Sets up or updates `user-profile.yaml` by auto-detecting your environment
and walking through context and source configuration interactively.

---

## Step 1 — Detect client and available MCPs

Detect AI client from execution context:

**Claude Code:** Read `~/.claude/settings.json` and `.claude/settings.json` (project).
Look for `mcpServers` key. Extract each server name and its exposed tools/commands.

**Cursor:** Read `.cursor/mcp.json` or `~/.cursor/mcp.json`. Same `mcpServers` structure.

**VSCode:** Read `.vscode/settings.json`. Look for MCP server config keys.

**Claude Desktop:**
- macOS: `~/Library/Application Support/Claude/claude_desktop_config.json`
- Windows: `%APPDATA%\Claude\claude_desktop_config.json`
- Linux: `~/.config/Claude/claude_desktop_config.json`

**Other clients:** Ask: "Which MCPs do you have available? List their names."

Present findings: "I found these MCP servers: [list]. Which are you actively using?"

---

## Step 2 — Detect available skills and agents

Check client config for installed skills/slash commands and available agent types.
Ask if auto-detection isn't possible: "Which skills or slash commands do you use?"

---

## Step 3 — Build environment block

Construct from detected + confirmed values:
```yaml
environment:
  client: {detected}
  mcps:
    - id: {mcp-name}
      commands: [{tool-list}]
  skills: [{skill-names}]
  agents: [{agent-names}]
  ide_extensions: []
```

---

## Step 4 — Configure contexts

Ask: "What contexts do you work in? (e.g., a team area, a cross-functional project, multiple repos)"

For each context, gather in sequence (one question at a time):
1. **Name:** What do you call this context?
2. **Role:** What's your role in this context?
3. **Repo:** What's the git URL of the shared context repo?
4. **Path:** What team/area path? (Show available paths from team.yaml if present)
5. **Sources:** Which of your detected MCPs are relevant to this context?

For each selected MCP source, ask for config details:
- **slack-channel:** Which channels? (e.g., #backend, #eng-team)
- **google-drive:** Which folder ID or shared drive?
- **jira-jql:** Project key? Filter by assignee/sprint/label?
- **notion-page:** Which page ID or workspace?
- **gmail:** Labels, search terms, or senders to focus on?
- **sana:** Keywords to find relevant meeting notes?
- **pipedream:** Which app and what to pull?
- **custom:** MCP name, what to query, what it feeds into?

For each source ask: what does it feed into? (project.md / reference.md / feedback.md)

---

## Step 5 — Write user-profile.yaml

Generate complete file. If one already exists, ask: "Append new context or overwrite?"
Write file. Verify `user-profile.yaml` is in `.gitignore`.

---

## Step 6 — Optional immediate test

Ask: "Want to test your configuration by running populate-context now? [y/N]"
If yes: invoke populate-context for the default context.
