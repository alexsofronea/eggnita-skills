---
name: egg-superposition
description: Use when auditing or creating positioning and messaging for a product, company, or person — scoring an existing homepage/landing page or positioning strategy, rewriting confusing or feature-led copy into customer-centric messaging, deciding who a thing is for and why it wins against the alternatives, or pressure-testing positioning against how a target customer would actually react. Audits against a distilled pattern library and generates a positioning brief → homepage copy → wireframe spec, with an adversarial critic + ICP-persona panel scaled to the stakes.
---

# egg-superposition

Position a product, company, or person so a stranger gets it in seconds — then prove the positioning holds by attacking it. egg-superposition runs two modes over one shared library of positioning patterns: **audit** an existing thing and score it against the rules, or **create** new positioning from a brief through to homepage copy and a wireframe spec. Either way, an adversarial **panel** (a rules critic, and target-customer personas) can pressure-test the output before it ships, so the agent earns the result instead of emitting plausible-sounding messaging.

The patterns are distilled from real before/after positioning teardowns and messaging principles, rewritten as our own rules — customer-centric, problem-led, jargon-allergic. The skill teaches the *principles*, never lifts anyone's brand or copy.

## When to use

- **Audit:** a homepage, landing page, tagline, pitch, or bio reads as confusing, feature-led, or generic and you want a scored teardown with prioritized fixes.
- **Create:** a net-new product/company/person needs positioning, or an existing one needs repositioning — from the strategic core out to page copy and layout.
- **Pressure-test:** you have positioning (yours or the agent's) and want it attacked by a rules critic and by simulated target customers before committing.

Not for: writing arbitrary marketing content, SEO articles, ads, or long-form copy unrelated to positioning. This skill is about *what you say and to whom*, and the homepage that carries it — not the whole content program.

## The two modes

- **Audit** — take a URL, pasted copy, or a screenshot. Identify the business type, score against the pattern library, return prioritized findings (what's confusing, feature-led not problem-led, missing self-qualification, weak or absent proof, unclear category, buried value), and rewrite the worst offenders. Flow and rubric: [references/audit.md](references/audit.md).
- **Create** — [discovery](references/discovery.md) → **positioning brief** (the Canvas: who it's for, the problem, the competitive alternatives, the wedge, the value, proof, messaging hierarchy) → **section-by-section homepage copy** → **wireframe spec** (section order and the job of each). Stops at a spec a designer or a frontend skill could build. Flow: [references/create.md](references/create.md).

Both modes score and generate against the same knowledge base:
- **[references/anchors.md](references/anchors.md)** — the grammar under everything: primary vs. secondary anchors, the clarity spectrum, and the Unique Value formula. Read this first.
- **[references/frameworks.md](references/frameworks.md)** — the 18 strategic decision models (maturity fork, real competition, demand-stage map, problem ownership, the real buyer, positioning-as-a-timeline, and more). Used at discovery/brief time and whenever a failure is strategic.
- **[references/patterns.md](references/patterns.md)** — the 15 failure modes, the scoring dimensions, and the homepage anatomy.
- **[references/templates.md](references/templates.md)** — the fill-in artifacts to produce whole: the Positioning & Messaging Canvas, the 6-slide deck, and the Anchor+Value options map.
- **[references/exemplars.md](references/exemplars.md)** — the copy technique library (hero formulas, problem-section structures, comparison tables, the consultancy build, teaching devices, named hero examples, and worked cases).

## The panel (adversarial pressure-test)

Positioning that only its author has read is untested. The panel attacks it:

- **Default — one critic.** A sub-agent reads the positioning against the pattern rules and returns concrete failures, not vibes.
- **Deep pass — critic + ICP personas.** The user can escalate to the critic *plus* target-customer personas (the skeptic, the champion, the wrong-fit buyer) who react as humans: "this is jargon," "I don't see my problem here," "I can't tell what it is." Their reactions feed a revision.

The panel is a deliberate step the user asks for, scaled to the stakes — not fired on every edit. How it dispatches and what each role returns: [references/panel.md](references/panel.md).

## Principles (always on)

1. **Customer-centric, not company-centric.** Lead with the customer's problem and world, not the product's features or the founder's cleverness. If a stranger can't tell what it is and whether it's for them, the positioning failed — no matter how polished.
2. **Distill, never photocopy.** The rules are principles in our own words. Never reproduce a specific company's copy, framework wording, or brand as if it were ours.
3. **Grounded in the library.** Every audit score and every generated section traces to a rule in [references/patterns.md](references/patterns.md). No freelancing positioning theory the library doesn't back.
4. **Earn the output.** For anything that matters, offer the panel before calling it done. Uncontested positioning is a draft, not a result.
5. **User steers, always.** Recommend and guide, never railroad. See the interaction contract below.
6. **Neutral about vendors and stacks.** Positioning serves the thing being positioned. Never bend it toward a house tool or a preferred category.
7. **Candid, not a cheerleader.** The user is paying for the truth, not applause. If the positioning is broad, the wedge is imaginary, the problem has no owner, or the product is too big to explain — say so plainly and early, so they can act on it. No praise-sandwiching, no softening a real problem into a "consideration," no agreeing to be agreeable. Name what's wrong, why it's wrong, and the fix. Concise over comprehensive: lead with the verdict, cut the throat-clearing, don't restate what they already know. The most useful thing this skill does is tell someone their positioning is confusing *before* the market does.

## Always run the slop check

Any prose this skill **generates or rewrites** — hero copy, problem sections, a positioning brief, an audit's rewrites, the written audit verdict — is passed through the **`stop-slop` skill** (invoke it via the Skill tool) before it's shown to the user. Positioning copy that reads like AI slop fails on its face. If `stop-slop` isn't installed, self-edit for the same tells and say you did the manual pass. This is not optional; it's the last gate before anything reaches the user.

## Interaction contract

Every question the skill asks with more than one sensible answer is presented as **selectable options plus an escape** — a recommended default marked as such, the real alternatives, and always a "let me suggest my own / talk it through" choice. The agent explains the trade-off, recommends, and tells the user the next step. The user picks; the user can always redirect. Guide firmly, decide nothing for them.

## First move

Figure out which mode. If the user handed you an existing page/tagline/bio to react to → **audit**. If they're starting or restarting positioning → **create**. If they already have positioning and want it attacked → straight to the **panel**. When it's ambiguous, ask — as selectable options with an escape. Then open the matching reference and run its flow.
