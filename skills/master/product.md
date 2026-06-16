---
name: product
description: >
  Load Product team context and run the Discover → Define → Build → Review → Capture
  workflow. Trigger: /product, "Product context", "load product"
---

# Product Team Skill

1. Identify the relevant area within the Product team (areas: discovery, delivery, analytics)
2. Write the context id to `.memcon-context`
3. Load `memory/shared/` then `memory/product/{area}/`
4. Run the Discover → Define → Build → Review → Capture workflow
5. Build artifact format adapts to user role within Product context
