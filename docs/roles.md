# Role Reference — mem-con

How mem-con adapts to different roles. The AI agent infers the right
output format from your `role` field in user-profile.yaml.

## Role → Build Artifact mapping

| Role | Primary artifact | Common sources |
|------|-----------------|---------------|
| Product Manager | Feature spec, user stories, prototype brief | Jira, Slack, Notion, meeting notes |
| Engineer | Design doc, task breakdown, ADR | GitHub, Jira, Slack, codebase scan |
| Tech Lead / Manager | Architecture decision, team update, capacity plan | GitHub, Jira, Slack, Google Docs |
| Designer / UX | Design brief, research plan, component spec | Figma, Notion, Slack, Google Drive |
| UX Researcher | Research plan, synthesis doc, insight report | Notion, Google Docs, meeting notes |
| Marketer | Campaign brief, copy draft, content calendar | Notion, Google Drive, Slack |
| Sales | Deal summary, objection map, proposal outline | Salesforce, Slack, email |
| Customer Success | Runbook, onboarding plan, escalation doc | Jira, Slack, email, Zendesk |
| Live Ops / Support | Incident runbook, on-call guide, post-mortem | Jira, Slack, PagerDuty, logs |
| Technical Writer | Doc outline, release notes, API reference | GitHub, Jira, Confluence, Google Docs |
| Executive | Decision memo, OKR update, strategy brief | Notion, Google Docs, Slack, email |
| HR | Job description, process doc, policy note | Google Docs, Notion, email, Slack |
| Finance | Budget update, variance analysis, forecast | Google Sheets, Slack, email |

## Setting your role

In `user-profile.yaml`, set the `role` field per context:

```yaml
contexts:
  - id: eng-backend
    role: "Senior Engineer"    # used to infer Build artifact format
  - id: project-alpha
    role: "Tech Lead"
```

## Multi-role contexts

If you wear multiple hats in one context (e.g., "Engineer + Tech Lead"),
set the primary role and note the secondary in user.md for that area.

## Custom roles

Any role string works — the agent uses it to infer the most useful artifact.
If your role isn't in the table above, the agent will ask what kind of output
would be most useful before starting the Build phase.
