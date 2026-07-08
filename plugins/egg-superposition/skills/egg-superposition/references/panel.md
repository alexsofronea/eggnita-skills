# Panel — adversarial pressure-test

Positioning only its author has read is untested. The panel attacks it before it ships: a rules critic checks it against the library; ICP personas react as the customers it's meant to reach. Their findings feed a revision.

The panel is a **deliberate pass the user asks for**, scaled to the stakes — not run on every edit. A one-line tagline tweak doesn't need three sub-agents; a homepage rewrite that's about to go live does.

Its sharpest use is **choosing between positioning options** ([templates.md](templates.md#3-the-anchor--value-options-map)): since positioning can't be A/B tested ([frameworks.md](frameworks.md#17)), you decide on thesis and risk — so the critic attacks each option's **thesis** and the ICP personas react to each option's **hero**. That's how a direction gets chosen with evidence instead of a hunch.

## Scaling — pick the depth with the user

Offer the level, recommend one, let the user choose (interaction contract):

- **Quick — one critic** *(default)*. A single critic sub-agent reads the positioning against [patterns.md](patterns.md) and returns concrete rule failures. Fast, cheap, catches the obvious misses.
- **Deep — critic + ICP personas.** The critic *plus* target-customer personas who react as humans. For high-stakes work (homepage going live, repositioning a company).
- **Full — critic + several personas.** Multiple distinct personas when the buyer set is genuinely mixed (e.g. a technical champion and an economic buyer who read completely differently).

## The roles

**Rules critic.** Dispatched a sub-agent with the positioning and the pattern rules. Returns: which dimensions fail, quoting the offending line and naming the rule. Adversarial by instruction — its job is to find what's wrong, not to reassure.

**ICP personas** (each a separate sub-agent, given the target-customer profile from discovery, told to react *as that person*, not as a marketer):

- **The skeptic** — "I don't believe this / this could be anyone / what does this even do?" Surfaces vagueness and unearned claims.
- **The champion** — the ideal buyer. "Do I see my exact problem here? Do I feel understood?" Surfaces whether the positioning lands for the person it's for.
- **The wrong-fit buyer** — someone it's *not* for. "Would I mistakenly think this is for me?" Tests whether self-qualification actually filters.

Each persona returns its honest first-read reaction and the one thing that would make it click or bounce — in the customer's voice, not scored jargon.

## How it runs

1. **Confirm the depth** with the user.
2. **Dispatch the roles as parallel sub-agents** — one prompt each, given the positioning artifact plus (for the critic) the rules and (for personas) the ICP profile. Independent, so run them concurrently.
3. **Synthesize** — collect the findings, dedupe, rank by severity. Separate "the rules say" (critic) from "the customer felt" (personas); both matter, they're different signals.
4. **Revise** — apply the findings to the positioning, showing what changed and why.
5. **Report** — present the panel's findings and the revision to the user. Offer another round only if the revision was substantial.

## Guardrails

- **Personas react, they don't rewrite.** Their value is the honest reaction; the main agent does the revising against the rules.
- **Adversarial by default.** Instruct critic and personas to look for what fails. A panel that says "looks great" did nothing.
- **Don't over-run it.** One good round beats three perfunctory ones. Escalate depth to stakes, not habit.
