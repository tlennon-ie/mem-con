---
name: customer-success
description: >
  Load Customer Success team context and run the Discover → Define → Build → Review → Capture
  workflow. Trigger: /customer-success, "Customer Success context", "load customer-success"
---

# Customer Success Team Skill

1. Identify the relevant area within the Customer Success team (areas: onboarding, support, renewals)
2. Write the context id to `.memcon-context`
3. Load `memory/shared/` then `memory/customer-success/{area}/`
4. Run the Discover → Define → Build → Review → Capture workflow
5. Build artifact format adapts to user role within Customer Success context
