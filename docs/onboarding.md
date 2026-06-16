# mem-con — Onboarding Guide

Welcome to mem-con. This guide covers how to contribute memory updates,
configure your personal context, and use context in your AI sessions.

## What Goes in Memory Files

Each area has 4 typed files:

| File | What to put here |
|------|-----------------|
| `user.md` | Your role, expertise, working preferences, communication style |
| `project.md` | Active work, recent decisions, stakeholders, priorities |
| `feedback.md` | What approaches worked or failed, guidance for future sessions |
| `reference.md` | Tool links, dashboards, JQL filters, integration configs |

## Contributing Memory Updates

1. Work in your AI client — the agent will propose memory updates at session end
2. Review and approve each proposed change
3. The post-commit hook automatically opens a PR to the team repo
4. Your team's CODEOWNERS will review and merge

Or contribute manually:

```bash
# Edit the files for your area
vim memory/{team}/{area}/project.md
# Commit — the hook will prompt you to open a PR
git add memory/{team}/{area}/project.md
git commit -m "context: update {area} active projects"
```

## Setting Up Your Personal Context

```bash
bash scripts/init-user.sh
```

Or run `/configure-sources` in your AI client for an interactive guided setup.

## Seeding an Area

```bash
# In your AI client:
/populate-context {area-slug}
```

The skill queries your configured sources, drafts all 4 files, and asks for review before writing.

## Switching Contexts

```bash
echo "eng-backend" > .memcon-context
```

Or let your AI client ask at session start.

## Adding a New Team or Area

1. Edit `team.yaml` — add to `teams[]`
2. Run `bash scripts/scaffold.sh`
3. Update `CODEOWNERS` with the area contact
4. Commit and push

## Contribution Workflow

See `skills/shared/contribute.md` for the `/contribute` skill that
guides you through the full review and PR process.
