# egg-hatch build flow

The steps egg-hatch runs. Every write obeys egg-plane's guardrails (see [../../egg-plane/SKILL.md](../../egg-plane/SKILL.md)); they are not repeated here.

## 0. Resolve the project

egg-plane's first move: `list_projects`, match the identifier, hold the UUID. If ambiguous or absent, ask. If the project has no description, offer a one-line one (egg-plane sets it at create; add it here if it is missing).

## 1. Survey

Run the interview in [survey.md](survey.md). Keep it short: the few questions that actually change the checklist, not fifteen. Record the answers; they drive every later decision (which modules, which items, skip vs keep, suggested priority, which providers).

## 2. Propose the module set (confirm)

From the answers, derive the module set (full set minus the truly irrelevant). The **Security module is always in the set and cannot be cut**; if the user tries to drop it, warn and keep it. Present the rest as a list for the user to confirm, extend, or cut. Do not create modules yet. This is the gated-taxonomy confirm (guardrail 11) plus the module-creation confirm.

## 3. Create the modules

For each confirmed domain, `create_module(project_id, name, description)`. Echo each. Modules are the standing product areas (egg-plane's module-vs-epic guidance): the everyday grouping, not epics.

## 4. Plan the items (confirm the batch)

Assemble the item list from the kept modules' catalogs. The universal-core items are **part of those modules, not a separate set** (the domain item lives in Domains & email, backups in Engineering, and so on), so include each once in its home module; don't create a core item and a module item for the same thing. Add the product-type overlay and any security-overlay items, each with a suggested priority (the catalog's default, adjusted by the survey). Present the plan grouped by module, with a count and the suggested priority per item, for one approval. This is egg-plane's plan-then-apply (see egg-plane's bulk-from-spec). Let the user reprioritize or drop before anything is written.

## 5. Create the items

For each approved item:

- Search first (guardrail 2) in case it already exists.
- `create_work_item` with title, project, state (backlog or todo), the suggested priority, and `description_html`: minified, adaptive ticket shape (Context, a **Done when** line, and a **Steps** checklist where there are real sub-steps, per egg-plane's ticket-template), provider-neutral wording (examples or the pinned provider).
- Assign the module with `manage_module_work_items(module_id, add_ids=[...])` (modules are set after create).
- Verify and echo per item or per small batch.

## 6. Set dependencies

Where one item blocks another (domain before email before marketing email; analytics before the activation metric; CI before preview envs), set the real relation with `create_work_item_relation(relation_type="blocked_by")`, and name the blocker by identifier in the description too (guardrail 9).

## 7. Echo the summary

One block: the project, the modules created, item counts per module, how many at each priority, and which items are flagged security-enforced. No silent writes.

## Notes

- **Provider-neutral wording.** If the survey pinned a provider, write tasks against it. Otherwise the task body names two or three examples (see the catalog) and leaves the choice to the reader. Never invent a default vendor.
- **Security overlay.** Security items are tagged into their home module and marked enforced. Floor them at high/urgent and flag loudly if the user tries to drop one (see [overlays.md](overlays.md)).
- **Minified HTML.** Every `description_html` is minified (no whitespace between block tags), per egg-plane's context-ops rule, or Plane renders empty paragraphs and phantom bullets.
- **Scale sensibly.** A lean product may be twenty items; a full-fat B2B SaaS may be sixty. Confirm the batch so the user sees the size before it lands.
