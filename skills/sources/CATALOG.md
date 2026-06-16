# Source Adapter Catalog

Registry of all built-in source types for populate-context.
Each entry: source type, how it's invoked, required capability, supported clients.

| Source type       | via    | Required MCP + command               | Clients supported              |
|-------------------|--------|--------------------------------------|--------------------------------|
| slack-channel     | mcp    | slack.read_channel                   | all                            |
| slack-canvas      | mcp    | slack.read_canvas                    | all                            |
| slack-search      | mcp    | slack.search                         | all                            |
| gmail             | mcp    | gmail.search, gmail.get_message      | all                            |
| outlook           | mcp    | pipedream.outlook                    | all                            |
| google-drive      | mcp    | google-drive.list_files              | all                            |
| notion-page       | mcp    | notion.retrieve_page                 | all                            |
| jira-jql          | mcp    | jira.search_issues                   | all                            |
| github-issues     | mcp    | github.list_issues                   | all                            |
| sana-meetings     | mcp    | sana.get_meeting, sana.query         | all                            |
| zoom-transcripts  | mcp    | pipedream.zoom                       | all                            |
| notebooklm        | mcp    | notebooklm.notebook_query            | all                            |
| confluence-page   | mcp    | confluence.get_page                  | all                            |
| codebase-scan     | agent  | agent:Explore                        | claude-code, cursor, vscode    |
| custom            | any    | user-defined                         | all                            |

## Adapter file structure

Each adapter file in skills/sources/ contains:
1. Frontmatter (name, description)
2. Required capability declaration
3. Config fields (YAML block)
4. Query steps (how to call the MCP)
5. Output format (what to return to populate-context)
6. Degradation behavior (what to do on failure)
