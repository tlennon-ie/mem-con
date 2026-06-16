---
name: team-challenge
description: >
  Pressure-test a decision, spec, or plan with hard questions calibrated to the user's role.
  Trigger: /team-challenge, "challenge this", "poke holes in this", "what am I missing"
---

# team-challenge

Challenges a decision, plan, or artifact. Asks hard questions. Never validates without interrogating.

---

## Step 1 — Identify what to challenge

Ask or infer: what artifact or decision is being challenged?
Read user's `role` from user-profile.yaml.

---

## Step 2 — Ask role-calibrated questions

**Product Manager:**
- Who specifically asked for this, and how many customers?
- What's the cost of NOT doing this?
- What does the data say? What's the counter-signal?
- What's explicitly out of scope, and will stakeholders agree?
- Who owns success measurement after launch?

**Engineer:**
- What's the failure mode and behavior under load?
- What's the rollback plan if this breaks in production?
- Who depends on this interface — have they been consulted?
- What existing abstraction does this duplicate or undermine?
- What's the simplest version that solves the actual problem?

**Designer:**
- Who did you test this with, and what was their biggest hesitation?
- What does the worst-case user path look like?
- How does this degrade on mobile / low bandwidth / assistive tech?
- What existing pattern does this break — is that intentional?

**Marketer:**
- What's the specific audience and what do they actually care about?
- What's the measurable success criterion?
- What's the counter-narrative a skeptic would use?
- What channels are you not using, and why?

**Sales:**
- What's the objection you're most likely to hear? How do you handle it?
- Why would a prospect choose a competitor?
- What's the minimum info needed to move this deal forward?

**Customer Success:**
- What does the customer actually want vs. what they're asking for?
- What's the escalation path if this runbook doesn't resolve it?
- What leading indicator shows this customer is at risk?

**Executive:**
- What's the opportunity cost of this decision?
- Who is accountable for the outcome — are they in the room?
- What would you need to see in 90 days to know this was right?

**Tech Writer:**
- Who is the reader, and what do they already know?
- What's the one thing a reader must not misunderstand?
- What breaks if this doc is wrong for 6 months?

**HR:**
- How does this align with how people actually behave vs. how they should?
- What's the legal or compliance exposure?
- How will this land with people who disagree?

**Live Ops / Support:**
- What's the blast radius if this runbook is followed incorrectly?
- What information is missing that an on-call engineer would need at 2am?
- What's the signal that says "escalate now"?

---

## Step 3 — Synthesize

After challenging, summarize:
- The strongest objections raised
- What would need to be true for this to succeed
- Suggested next step: revise, validate, or proceed with eyes open
