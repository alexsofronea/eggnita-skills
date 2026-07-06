# egg-hatch survey

A short, adaptive conversation, run before anything is created. This file lists **what the agent must learn**, not a script to read out. Conduct it as a branching dialogue: infer from what the user already gave, ask only the genuine gaps, and let each answer decide what to ask next.

## What to discover (a coverage map, not a script)

These are the facts the agent needs before it can build a good plan. Gather them however the conversation allows; the numbering is for internal completeness-checking, not an order to march through.

1. **Product type** (B2B SaaS / consumer web / mobile app / marketplace / developer tool or API / e-commerce / AI-native / internal tool). Selects the product-type overlay and drops clearly-irrelevant modules.
2. **Stage** (idea / pre-launch / launched / scaling). Shifts day-1 items up and post-launch items down.
3. **Distribution / access** (public signup / invite-only / waitlist / enterprise / app store / API). Keeps or drops auth, waitlist, store, and API-docs work.
4. **Personal data + EU users.** Raises Privacy Policy / cookie consent / DPA; drops them only if there is truly no personal data.
5. **Charging money + international.** Keeps or skips billing; international raises tax / merchant-of-record.
6. **Audience** (developers / consumers / businesses). Informs docs vs onboarding vs enterprise security, and ad-platform fit.
7. **Marketing channels** (SEO / content, marketing email, cold outreach, paid ads and which platforms). Keeps or drops the discoverability, marketing-email, outreach-domain, and ads modules.
8. **Public marketing site** (yes / no). Keeps or drops the SEO/AEO/GEO discoverability module.
9. **Stack / preferred providers** (hosting, email, analytics, payments, and so on, or "no preference"). Pins provider-specific wording, or leaves the example sets (provider-neutrality).
10. **Team + agents** (solo / team; using AI coding agents). Raises CONTRIBUTING / CODEOWNERS and the agent-instructions and agent-security items.
11. **Existing org infra** (entity, domains, analytics, design system already in place). Skip what already exists instead of recreating it.

## How to run it (adaptive, good UX)

- **Infer first, then confirm.** Mine any brief, one-liner, or coding-session context the user already gave. If they open with "a Stripe-billed B2B analytics tool for EU marketing teams," you already have type, billing, audience, and EU exposure. Reflect it back ("So: B2B SaaS, charging via Stripe, EU users, so privacy and a DPA are in scope, right?") and ask only the real gaps. Never re-ask what was implied.
- **Let answers branch, and drop whole lines of questioning.** Each answer rules items in or out, so ask follow-ups accordingly:
  - "Internal tool, no public site" → drop the entire discoverability and paid-ads branch; don't ask about robots.txt, sitemaps, or LinkedIn ads at all.
  - "Not charging yet" → skip the tax / merchant-of-record follow-ups.
  - "B2B SaaS with EU customers" → now DPA, SSO/SAML, and SOC 2 become worth surfacing; a consumer app wouldn't get them.
  - "AI-native" → open the evals / guardrails / token-cost follow-ups that don't apply otherwise.
  - "Runs paid ads" → then ask which platforms (and let product type suggest them: B2B leans LinkedIn + Google Search); skip the platform question entirely if there are no ads.
- **Ask few, well-timed questions.** Batch naturally related ones (data + EU together; charging + international together), don't fire eleven questions in a row, and let the user answer loosely.
- **Adapt to expertise.** A founder who clearly knows their stack needs fewer, sharper questions; someone vaguer needs a plain-language nudge with examples. Match the depth to the person.
- **Stop when the map is covered.** Once you can make every skip/keep and priority call with confidence, stop asking and move to proposing the module set. The eleven items are the completeness check you run against internally, not a form the user sits through.

## Mapping answers to the plan

- **Skip** a module only when an answer makes it truly inapplicable (no marketing site, skip discoverability; never charges, skip billing; not mobile, drop the app-store overlay). When unsure, keep it at low rather than dropping it.
- **Priority nudges:** legally-required or blocks-launch, high or urgent; standard hygiene, medium; deferrable-until-a-trigger, low. The **Security module is always created** and never skipped; its core controls are floored at high/urgent (see [modules.md](modules.md)).
- **Provider pinning:** if the stack answer named a provider, write tasks against it; otherwise keep the catalog's example sets.
- Always show the derived module set and the item plan for confirmation before creating (build-flow steps 2 and 4).
