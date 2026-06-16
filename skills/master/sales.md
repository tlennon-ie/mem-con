---
name: sales
description: >
  Load Sales team context and run the Discover → Define → Build → Review → Capture
  workflow. Trigger: /sales, "Sales context", "load sales"
---

# Sales Team Skill

1. Identify the relevant area within the Sales team (areas: enterprise, smb)
2. Write the context id to `.memcon-context`
3. Load `memory/shared/` then `memory/sales/{area}/`
4. Run the Discover → Define → Build → Review → Capture workflow
5. Build artifact format adapts to user role within Sales context
