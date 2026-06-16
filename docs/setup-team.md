# Setting Up mem-con for Your Team

This guide is for the person setting up mem-con for a new org or team.

## Step 1: Fork or clone this repo

```bash
git clone https://github.com/your-org/mem-con.git
cd mem-con
```

Or fork it to your own GitHub/GHE org and use that URL as your `team_repo`.

## Step 2: Customize team.yaml

Edit `team.yaml`:

```yaml
organization:
  name: "Acme Corp"
  team_repo: "https://github.com/acme/mem-con.git"

tools:
  project_tracking: jira      # what your team actually uses
  communication: slack
  docs: notion
  code: github
  # set others to null if unused

teams:
  # Delete example teams you don't need
  # Add teams that match your actual org structure
  - slug: engineering
    name: Engineering
    areas:
      - { slug: backend, name: "Backend & API" }
      - { slug: infra,   name: Infrastructure }
```

## Step 3: Generate memory structure

```bash
bash scripts/scaffold.sh
```

This creates `memory/{team}/{area}/` for every team and area in team.yaml.

## Step 4: Add shared context

Edit `memory/shared/` files with your org's baseline:
- `user.md` — team norms, communication style
- `project.md` — current org-wide priorities
- `reference.md` — shared dashboards and tools

## Step 5: Update CODEOWNERS

Add GitHub usernames for each area contact so PRs route correctly.

## Step 6: Add shared source templates (optional)

In `team.yaml`, add `source_templates[]` for common sources your team all use:

```yaml
source_templates:
  - id: team-jira-sprint
    type: jira-jql
    mcp: jira
    config:
      jql: "project = ENG AND sprint in openSprints()"
    feeds_into: project.md
```

Team members can then reference `template: team-jira-sprint` in their user-profile.yaml.

## Step 7: Push and share install command

```bash
git push origin main
```

Share with your team:

```bash
git clone {team_repo} ~/.memcon && bash ~/.memcon/install.sh
```
