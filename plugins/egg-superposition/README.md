# egg-superposition

Audit and create positioning and messaging for a product, company, or person — then attack it to prove it holds.

Positioning is what you say and to whom: who a thing is for, the problem it kills, why it wins over the alternatives, and the homepage that carries all of that in five seconds. egg-superposition runs two modes over one library of positioning patterns, with an adversarial panel that pressure-tests the output.

## What it does

- **Audit** — hand it a URL, pasted copy, or a screenshot. It scores the positioning against the pattern library (clarity, customer-centricity, differentiation, self-qualification, proof, jargon, and more), ranks the findings by impact, and rewrites the worst offenders.
- **Create** — for net-new or repositioning work: discovery → a **positioning brief** (customer, problem, alternatives, wedge, value, proof, messaging hierarchy) → **section-by-section homepage copy** → a **wireframe spec** a designer or frontend skill can build. Stop at any stage.
- **Panel** — a deliberate pressure-test: a rules critic, and optionally target-customer personas (the skeptic, the champion, the wrong-fit buyer) who react as humans. Scaled to the stakes — one critic for a quick check, a full panel before a homepage goes live.

Under the hood it runs a real, named method — a **positioning-anchors grammar** (what you *are*: category / use case / alternative) plus fill-in **templates** it can produce whole: a Positioning & Messaging Canvas, a 6-slide alignment deck, and an options map for choosing a direction on thesis-and-risk. The patterns and frameworks are distilled from real before/after teardowns and messaging principles, rewritten as the skill's own rules — customer-centric, problem-led, jargon-allergic. It teaches the principles; it never lifts anyone's brand or copy.

## When it triggers

Claude reaches for it when you ask to audit, fix, write, or pressure-test positioning or messaging — a confusing homepage, a feature-led tagline, a from-scratch value proposition, or "would a customer actually get this?" Invoke it by name any time.

Not for general marketing content, SEO articles, or ads — it's about positioning and the homepage that carries it.

## How to use

Just describe the situation:

- "This homepage is confusing — audit it." → audit mode
- "Help me position this new tool." → create mode
- "Attack this positioning like a skeptical buyer." → straight to the panel

The skill guides you from there. Every question with options is presented as selectable choices with a "suggest your own / talk it through" escape — it recommends and guides, you steer.

## How it behaves

It's built to be **candid, not a cheerleader** — if your positioning is broad, your wedge is imaginary, or your problem has no owner, it tells you plainly and early so you can act, instead of praising a draft you can't ship. Concise over comprehensive.

## Requirements

- **Claude Code.** Sub-agent dispatch (used by the panel) is built in.
- **The `stop-slop` skill** (recommended). New positioning and messaging copy the skill writes passes through `stop-slop` to strip AI writing tells before you see it. This applies when it *creates* copy, not when it audits (audits run without the gate). If it isn't installed, the skill does the manual pass instead. Available in the standard skill set; add it if your environment doesn't already have it.
