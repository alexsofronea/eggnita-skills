---
name: egg-hatch
description: Use when scaffolding a new product or SaaS setup checklist into Plane, standing up the domains/DNS, email, engineering, analytics, billing, discoverability (SEO/AEO/GEO), ads, support, team, and working-instructions tasks a new product needs. Surveys the product's context, then creates prioritized, module-grouped work items. Invoke only when asked for it by name or when the agent offered it and the user accepted; it does not run on every project. Extends egg-plane and obeys its guardrails.
---

# egg-hatch

Scaffold the setup checklist for a brand-new product as real, prioritized, module-grouped Plane work items. egg-hatch surveys the product's context, then creates only the relevant tasks (skipping what doesn't apply), so a new project starts with a browsable, honest to-do board instead of a blank one. It creates the tracking tasks; it never builds the artifacts themselves (it won't write your DNS records or your README, it files the tasks to do that).

Built on [egg-plane](../egg-plane/SKILL.md): every write obeys egg-plane's guardrails (resolve IDs, search before create, verify after write, echo, gated taxonomy, minified HTML, confirm before bulk). This skill adds the survey, the checklist catalog, and the priority logic on top.

## When to use (scoped)

egg-hatch is opt-in, not automatic. Trigger it only when:

- the user names it ("hatch this project", "run the new-product checklist", "scaffold the setup tasks"), or
- the agent offered it (for example just after creating a project) and the user accepted.

Never run it unprompted on every `create_project`. The egg-plane create-project flow stays lean; egg-hatch is a deliberate follow-on.

## How it works

Survey the product's context, propose the module set (confirm), create the modules, create the relevant items with suggested priorities (confirm the batch), tag items into modules, set real dependencies, echo a summary. Full step list in [references/build-flow.md](references/build-flow.md).

## Principles (on top of egg-plane's guardrails)

1. **Survey first, generic never.** Read the product's context before creating anything, through a short adaptive dialogue (not a fixed questionnaire): infer from what the user gave, surface only the real gaps — as selectable recommended answers, not open prompts, always with a talk-it-through escape — and let each answer decide the follow-ups. The coverage map and how to run it are in [references/survey.md](references/survey.md).
2. **Full set by default, survey-trimmed.** Start from the complete module set; skip what the survey shows is truly irrelevant. Everything kept is created.
3. **Priority carries relevance, not omission.** Use Plane's real values none / low / medium / high / urgent. The skill suggests; the user confirms. Minor-but-kept items sit at none or low.
4. **Modules are the grouping.** One module per checklist domain (survey-derived), items tagged in. Gated creation, confirm the set (egg-plane guardrail 11).
5. **Provider-neutral, always.** Never hard-default a vendor. A task names two or three top-player examples, or the survey pins the user's choice. Do not push a house stack onto a client's product.
6. **Security is a mandatory module.** egg-hatch always creates a Security module, whatever the survey says, floored at high/urgent and resisting skipping; it covers application, supply-chain, infrastructure, data, email, product-type, and the agent surface. See [references/modules.md](references/modules.md).

## The catalog

- **Universal core** (always offered, any product): [references/universal-core.md](references/universal-core.md).
- **Modules** (the full domain set, with items, default priority, and the survey gate that keeps or drops each): [references/modules.md](references/modules.md).
- **Overlays** (product-type additions, and the security enforced overlay): [references/overlays.md](references/overlays.md).

## First move

Confirm the target project (egg-plane's rule: resolve it first). Then run the survey. Never create modules or items before the survey and the confirm step.
