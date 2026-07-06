---
name: egg-plane
description: Use when managing projects, tasks, sprints, or dependencies in Plane through the Plane MCP, creating, updating, triaging, or searching work items; linking blockers; epic-style rollups; cycles, modules, milestones, or intake; comments, links, pages, and attachments; capturing a task from a coding session; or reporting on a project or cycle. Enforces ID resolution, search-before-create, verify-after-write, confirm-before-destroy, and a gated taxonomy. Tuned for the Plane free tier.
---

# egg-plane

Drive Plane through its MCP as a careful, helpful teammate, not a blunt automation. This skill exists because the raw MCP will happily let an agent invent an ID, create a duplicate, wipe a label list, or claim success on a write that silently failed. egg-plane makes those mistakes hard, and makes the agent genuinely useful about keeping work tracked.

## When to use

- Any create/update/triage/search of Plane work items, projects, cycles, modules, milestones, pages, states, labels, or estimates.
- Linking work items: parent/child (sub-items), the six built-in dependencies, external links, and attached pages/files.
- Grouping work: **modules** for standing product areas (the default), **epics** for finite convergent features (paywalled, simulated as `[epic] {name}` with `childOf` rollups).
- Intake/triage, comments and handoffs, workload checks, and status/sprint reports.
- Turning a plan or PRD into a set of linked items (see [references/bulk-from-spec.md](references/bulk-from-spec.md)).
- Capturing a task from a coding session, and politely suggesting Plane when tracking would help. See [references/coding-session-nudge.md](references/coding-session-nudge.md).
- Scaffolding a whole new product's setup checklist (domains, email, engineering, analytics, discoverability, ads, security, docs) as prioritized, module-grouped tasks: the scoped **egg-hatch** sub-skill (invoke by name, or accept when offered). See [../egg-hatch/SKILL.md](../egg-hatch/SKILL.md).

## The guardrails (always on)

Non-negotiable. Full version with examples in [references/guardrails.md](references/guardrails.md); the short form:

1. **Resolve, never guess IDs.** Projects, items, members, states, labels via their `list_*`/`retrieve_*` tools. Never a UUID from memory.
2. **Search before create.** `search_work_items` / `list_work_items` first; surface likely duplicates by identifier and ask.
3. **Verify after write.** A write can error yet persist (a project create returned 400 but existed). On any error, re-read before retrying; never blind-retry a create.
4. **Echo after write.** One line, full identifiers, old→new: `EGG-3: state Todo→In Progress, +label backend`. No silent mutations.
5. **Confirm before destroy or bulk.** `delete_*`, archive, `transfer_cycle_work_items`, multi-item ops: list affected identifiers, get an explicit yes.
6. **Incremental over replace.** Use `manage_work_item_label`/`_assignee`/`manage_cycle_work_items`/`manage_module_work_items`. Never a full `labels=[...]`/`assignees=[...]` to change one.
7. **Adaptive ticket, never a bare line.** Title, project, state, priority, assignee, and a description sized to the task: Context always, a **Done when** line (acceptance = the test) on anything substantive, and a **Steps** checklist when there are real sub-steps. Always present dependencies; overflow big context to an attached page. See [references/ticket-template.md](references/ticket-template.md).
8. **PQL, not dumps; flag truncation.** Filter server-side; `count_work_items` for totals; never present a paginated partial as the whole set.
9. **Real relations by ID, never prose.** Parent, dependency, label, link, or attached page, all resolvable in Plane. Never "as discussed in the doc."
10. **Free-tier aware, degrade gracefully.** Route around paywalls with the documented substitute. See [references/capability-map.md](references/capability-map.md).
11. **Taxonomy is gated, not locked.** States/labels/estimates can be created, but confirm first, map ambiguous requests to the nearest existing value, and warn on drift.
12. **New projects: set private, give a description.** A new project can come up public, so set `network: 0` explicitly and verify; never publish unasked. Always add a short project description at create.
13. **Suggest Plane, politely; never enforce.** Offer tracking warmly, respect the answer, keep the user's real work first.

## Free-tier reality (read once)

Full map in [references/capability-map.md](references/capability-map.md). The essentials:

- **Works:** work items (typeless), states, labels, assignees, parent/child, the six built-in dependencies (auto-bidirectional), PQL + `count_work_items`, cycles, modules, milestones, pages (+ attach to item), estimates, comments, external links, file attachments (from a public URL), intake/triage. New projects are private by default.
- **Paywalled, do not call (they 402/403):** `list_work_item_types` / `resolve_work_item_type` (custom types & epics), `list_work_item_relation_definitions` (custom relations "relates"/"duplicate"), `list_initiatives` (cross-project), worklogs / time tracking. That 402 on `list_work_item_relation_definitions` gates only *custom* relations — the six **built-in dependencies still work**, so call `create_work_item_relation(relation_type="blocked_by")` directly and never downgrade a dependency to a text-only line.
- **Absent:** view creation. Substitute: the named-query library in [references/pql-cookbook.md](references/pql-cookbook.md).
- **Members gotcha:** member lists include bots. Filter `is_bot = true` before suggesting an assignee.

## Workflows

- **Core** (create project, create ticket, triage/search, dependencies + start-warning, epic-simulation, status/report): [references/workflows.md](references/workflows.md). New projects also get a public newcomer "Start here" page: [references/onboarding-page.md](references/onboarding-page.md).
- **Structure** (cycles, modules, milestones, intake/triage): [references/structure-ops.md](references/structure-ops.md). **Module vs epic:** modules are the everyday "which product area?" bucket (a task's strong-default grouping); reserve epics for a finite feature that tasks converge into. They're independent axes; a task can have both.
- **Context** (comments, external links, pages + attach, file attachments, workload view, optional cycle-time note on Done): [references/context-ops.md](references/context-ops.md). Every HTML body (comments, descriptions, pages) must be **minified**; Plane turns whitespace between block tags into empty paragraphs/bullets and strips HTML comments.
- **Bulk** (a plan/PRD into linked items, plan-then-apply): [references/bulk-from-spec.md](references/bulk-from-spec.md).
- **Capture** (coding-session nudge, polite suggestion): [references/coding-session-nudge.md](references/coding-session-nudge.md).

## First move, every time

Before any Plane action: know the project. `list_projects`, match the `identifier` the user means (e.g. `EGG`), hold its UUID. If the project is ambiguous or absent, ask; don't assume a prefix exists.
