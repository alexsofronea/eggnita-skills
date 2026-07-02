# egg-plane

Manage [Plane](https://plane.so) projects and tasks through the Plane MCP, as a careful, helpful teammate rather than a blunt automation. egg-plane wraps the raw MCP in guardrails so an agent can't invent an ID, spawn a duplicate, wipe a label list, or claim success on a write that silently failed.

Built and tuned for the **Plane free tier**: it knows what's paywalled (epics, custom types, custom relations, initiatives, time tracking, views) and routes around each with a documented substitute.

## What it does

- **Create tickets that hold up**: an adaptive Context / Scope / Acceptance-criteria description sized to the task, resolved project/state/assignee, dependencies always shown, no bare one-liners. Big context overflows to a page attached to the item.
- **Search before creating**: surfaces likely duplicates by identifier before opening anything new.
- **Track dependencies**: the six built-in Plane relations (blocking, blocked_by, start/finish before/after), and a warning before you start an item whose blocker is still open.
- **Epic-simulation**: since epics are paywalled, it uses a `[epic] {name}` parent with `epic` label, children via `parent`, and PQL rollups (`childOf`).
- **Sprint & structure**: cycles, modules, milestones, and intake/triage.
- **Context**: comments and handoffs, external links (repo/PR/doc), attached pages, file attachments from a public URL, and a workload view before you assign more.
- **Bulk from a spec**: turn a plan or PRD into a set of linked items, plan-then-apply with one approval.
- **Onboard newcomers**: every new project it creates gets a public "Start here" page covering the Plane apps, the MCP, installing egg-plane, and how the team works.
- **Capture & suggest**: when work in Claude Code / Codex / Cursor surfaces a bug, follow-up, or blocker, it searches Plane, shows what exists, and helps you decide, link, add a child, create new, or set a relation. Proactive but gated and polite; it never auto-creates and never enforces.
- **Report without dumps**: `count_work_items` grouped by state or assignee for a project or cycle.

## Requirements

- The **Plane MCP** connected to your Plane workspace in your agent (Claude Code, Codex, Cursor, …).
- A Plane project to work in. The skill resolves projects by their identifier (e.g. `EGG`); it never assumes one exists. New projects it creates are private by default.

## Install

```bash
/plugin marketplace add alexsofronea/eggnita-skills
/plugin install egg-plane
```

## Use

Ask for anything Plane-shaped and the skill activates: "create a ticket for X", "what's blocking EGG-3?", "log this to Plane", "how's the EGG-1 epic doing?", "turn this plan into tickets". It resolves the project first, then follows its guardrails on every action.

## The guardrails (why this exists)

Resolve-never-guess-IDs · search-before-create · verify-after-write · echo-after-write-with-IDs · confirm-before-destroy/bulk · incremental-over-replace · adaptive-ticket · PQL-not-dumps-flag-truncation · real-relations-by-ID · free-tier-aware · gated-taxonomy · projects-stay-private · suggest-politely-never-enforce. The full set with examples lives in `skills/egg-plane/references/guardrails.md`.

## How it's organized

```
skills/egg-plane/
├── SKILL.md                        # router + always-on guardrails
└── references/
    ├── capability-map.md           # free-tier: what works, what's paywalled, substitutes
    ├── guardrails.md               # the rules, in full, with examples
    ├── pql-cookbook.md             # named queries (the "views" substitute)
    ├── ticket-template.md          # the adaptive ticket shape
    ├── workflows.md                # core: project, ticket, triage, dependencies, epic, report
    ├── structure-ops.md            # cycles, modules, milestones, intake/triage
    ├── context-ops.md              # comments, links, pages, attachments, workload
    ├── bulk-from-spec.md           # a plan/PRD into linked items
    ├── onboarding-page.md          # the public "Start here" page for new projects
    └── coding-session-nudge.md     # capturing tasks while coding, politely
```

## Free-tier notes

Paywalled and routed around: native Epics, custom work-item types, custom relation definitions, cross-project initiatives, time tracking, and view creation. Everything else the team needs day to day, tickets, sub-items, the six dependencies, cycles, modules, milestones, pages, estimates, comments, links, attachments, intake, PQL reporting, works on the free tier. See `skills/egg-plane/references/capability-map.md`.
