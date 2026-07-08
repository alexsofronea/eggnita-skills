# Templates — the fill-in artifacts

Three concrete, reusable structures the skill can produce whole: the **Positioning & Messaging Canvas** (the master working doc), the **6-slide positioning deck** (the alignment artifact), and the **Anchor + Value options map** (the decision artifact). All three are built from the anchors grammar in [anchors.md](anchors.md). Reproduce them filled in for the user's product — that's the deliverable.

---

## 1. The Positioning & Messaging Canvas

The master document. Everything above the fold on a homepage traces to a cell here. Two halves: the **anchors + spine** (the core positioning) and the **argument columns** (the supporting proof).

### Structure

```
ANCHORS
  (S) Company Anchor        — the kind of company you sell to
  (S) Persona Anchor        — the buyer/user role
  (P) Use Case Anchor       — the job the product does ("helps you ___")
  (P) Alternative Anchor    — what you're an alternative to
  (P) Category Anchor       — the category the product is ("is a ___")

SPINE
  Problem Summary           — one sentence, linked to ONE chosen primary anchor
  … argument columns …
  Differentiation Summary   — the core way you solve the problem, tied to that anchor

ARGUMENT COLUMNS  (one per supporting argument, read top → bottom, each 1:1 linked)
  Sub-Problem        — one specific problem
  Differentiation Pillar — the shortest summary of the argument
  Capability         — the "how" of the differentiation
  Features           — the "what" behind the how (may be several)
  Benefit            — the "why" of the what + how
```

`(P)` = primary anchor, `(S)` = secondary. The vertical chain in each column is **strictly 1:1**: sub-problem #1 gets pillar #1, capability #1, features #1, benefit #1. Each argument answers one problem end to end.

### Build steps

1. **Choose primary anchors** (use case / alternative / category). Test each: does it *stand alone* as a sufficient definition of what the product is ([anchors.md](anchors.md))? Drop any primary anchor you don't actually lead with (Fletch drops "alternative" when they rarely position against one). Reject vague ones ("a service business," "grow your business").
2. **Choose secondary anchors** (company, persona) — descriptive context only. → Primary + secondary now reads as your one-sentence explanation.
3. **Link a problem to ONE primary anchor** → the Problem Summary. The anchor you pick changes the problem you tell. Write the Differentiation Summary as the core way you resolve it. → the four spine/anchor pieces stitched together = your **elevator pitch**.
4. **Build each argument column**: for each sub-problem, write its pillar → capability → features → benefit. These columns become the homepage's product sections.

The completed grid *is* the positioning brief. It's reused verbatim across the homepage and every GTM channel.

### Worked reference (abbreviated — BugHerd, website-feedback SaaS)

- Anchors: (S) Company = agencies · (S) Persona = PMs/devs/designers · (P) Use case = getting client feedback on website design & dev.
- Problem Summary: "Getting website feedback from clients is a big struggle that requires a lot of back-and-forth."
- Argument 1: *sub-problem* unclear which part of the page feedback refers to → *pillar* point-and-click feedback → *capability* comment in-context on a live component with an auto screenshot → *features* one-click commenting, automated screenshot → *benefit* always know where feedback points.
- Differentiation Summary: "Clients drop pins and comment on any website; we auto-capture a screenshot + technical details and turn each comment into a trackable task."
- Result after shipping: ~70% uplift in trial-to-paid, doubled monthly growth.

---

## 2. The 6-slide positioning deck

The lightweight alignment artifact (the "only positioning deck you'll ever need"). Gets the whole company saying the same thing. Built from the same anchors/value; think of it as the Canvas told as a narrative.

### The six slides

1. **Functional description** — one sentence: what you are + who you help. Backbone = your primary anchors (category / use case / alternative), plus secondary segmentation (company / persona).
   *"Oratory.co is a [category: website design agency] that helps [persona: marketers] in [company: early-stage B2B startups] [use case: refresh their brand and build a new website]."*
2. **Problem framing** — state the problem, linked to one primary anchor.
   *"Other [category: website design agencies] go beyond what an early-stage startup needs in process, price, and deliverables."*
3. **Value framing** — how you resolve that problem.
   *"Oratory is a website design agency built from the ground up for early-stage startups, without the baggage of agencies that focus on larger companies."*
4–6. **Supporting arguments 1, 2, 3** — each slide: a bolded **claim**, one sentence in the shape *"Unlike other [alternative] that [X], we [Y],"* and a short list of **features that make the argument believable.**
   *Arg: "Lightweight process — unlike agencies with long timelines and heavy discovery, Oratory runs fast sprints to get the core message live in 4 weeks." Features: fast sprints · 4-week go-live.*

Keep it to six. The point is a few themes everyone remembers, not exhaustive detail.

---

## 3. The Anchor + Value options map (the decision artifact)

Before committing to one positioning, map **2–3 whole options** and choose deliberately — because you can't A/B test positioning ([frameworks.md](frameworks.md#17)), you decide on thesis and risk instead. Each option is one panel:

```
OPTION N
  Anchors + Value   — the primary/secondary anchors + problem + differentiation for this direction
  Sample hero       — a real headline/subhead, each phrase color-coded to its anchor
  Thesis            — what you'd have to believe for this to be the right bet
  Risks             — the open questions / who it alienates / what could make it fail
```

### Worked reference (Freckle — CRM data enrichment)

- **Option 1 — head-to-head with Clay.** Anchors: category = GTM orchestration; alternative = Clay. Hero: "GTM orchestration made simple." *Thesis:* two players can coexist; be the simpler Clay. *Risks:* can we reach feature parity? too big a head start?
- **Option 2 — the GTM-engineer alternative.** Hero: "You don't need a GTM engineer. You just need Freckle." *Thesis:* bet against the need for GTM engineers. *Risks:* ready to take a bold stance and alienate GTM engineers as buyers?
- **Option 3 — easiest way to enrich CRM data.** Anchors: use case = enrich your CRM data; category = enrichment tools. Hero: "The easiest way to enrich your CRM data." *Thesis:* own enrichment, prove it's easier than incumbents. *Risk:* are these assumptions right? → **chosen** (underserved segment, white space as Clay moves away from CRM enrichment).

This map is what the **panel** ([panel.md](panel.md)) pressure-tests: the critic attacks each thesis, the ICP personas react to each hero.

---

## Governance: color-code the copy

When positioning becomes a live page, **tint each phrase of the copy to the anchor/value it encodes** and check the strategy survived the translation. If a homepage section has copy that maps to no cell in the Canvas, it's off-strategy. This is how you verify a shipped page still says what the strategy decided.
