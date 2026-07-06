# egg-plane guardrails

The rules in full, each with the concrete tool calls and an example. When any conflict arises, these win over speed or convenience.

## 1. Resolve, never guess IDs

Every UUID comes from a live lookup in the same session, never from memory or a previous conversation.

- **Project:** `list_projects`, match the `identifier` the user named (e.g. `EGG`). Hold the `id`.
- **Work item:** `retrieve_work_item_by_identifier("EGG-3")`. Never reuse a UUID you saw earlier without re-resolving.
- **Member:** `get_workspace_members` or `get_project_members`, filter out `is_bot = true`, match on `email` or `display_name`. No invented emails or member IDs. No match, leave unassigned and say so.
- **State / label:** `list_states(project_id)` / `list_labels(project_id)`, match by name.
- **Type:** do not resolve, types are paywalled, `type_id` stays null.

## 2. Search before create

Before opening any work item:

1. `search_work_items(query=...)` on the key words (matches name, sequence id, project identifier).
2. If the intent is structured (a state, an assignee, an epic's children), `list_work_items` with a PQL filter.
3. Show likely duplicates as `EGG-12 "…" (In Progress)` and ask whether to link/update one instead of creating.

Only create once the user confirms it's genuinely new.

## 3. Verify after write

Plane can return an error on a write that still persisted, and can return success with fields you didn't set.

- On any write **error**, re-read the target before deciding it failed. If it persisted, adopt the created object; do not retry.
- Never blind-retry a `create_*`; retrying a create that actually succeeded makes a duplicate.
- On success, trust the returned object, but confirm the specific field you cared about is present (sparse responses return null for unrequested fields).

## 4. Echo after write

After every mutation, state what changed in one line with full identifiers and old→new values:

```
EGG-3: state Todo→In Progress, +label backend, assignee→alex.sofronea
EGG-7: created (Todo, high, unassigned) under epic EGG-1
```

No silent mutations. If nothing changed, say that too.

## 5. Confirm before destroy or bulk

These need an explicit yes, with the affected identifiers listed first:

- `delete_work_item`, `delete_*`
- `manage_work_item_archive`, `manage_module_archive`, `manage_cycle_archive`, `manage_project_archive`
- `transfer_cycle_work_items`
- any operation that will touch more than one item in a loop

Format: "This will delete EGG-4, EGG-9, EGG-11. Confirm?" Wait for the answer.

## 6. Incremental over replace

To change one label/assignee/membership, use the incremental tool:

- `manage_work_item_label(add_label_id=... / remove_label_id=...)`
- `manage_work_item_assignee(add_user_id=... / remove_user_id=...)`
- `manage_cycle_work_items` / `manage_module_work_items(add_ids / remove_ids)`

Never call `update_work_item(labels=[...])` or `update_work_item(assignees=[...])` to add one; those replace the entire list and silently drop everything not included.

## 7. Adaptive ticket, never a bare line

Every `create_work_item` carries, at minimum: **title**, **project**, **state** (default backlog/todo), **priority** (chosen deliberately), and **assignee** (a resolved member or an explicit "unassigned").

The **description adapts to the task**, it is not a rigid form:

- Always include **Context**. Anything substantive also gets a **Done when** line (acceptance criteria: the observable end-state that doubles as the test); only a trivial chore may skip it. Add **Scope** when in/out isn't obvious, and a **Steps** checklist (task-list checkboxes) when the task has real sub-steps. A tiny chore stays Context + one "Done when" line.
- **Always present dependencies.** If the item blocks or is blocked by others, state them by identifier in the ticket and set the real relation (guardrail 9).
- When a task needs **more context than a description should hold** (a spec, a design, research), create a **page** (`create_page`) and **attach it** (`attach_page_to_work_item`) rather than bloating the description. Link, don't dump.

Full guidance and examples: [ticket-template.md](ticket-template.md). No one-line tickets.

## 8. PQL, not dumps; flag truncation

Filter server-side. Don't fetch a whole project and reason over the JSON.

- Use the named queries in [pql-cookbook.md](pql-cookbook.md). For anything non-trivial, call `get_pql_reference` first (5-condition cap, no date arithmetic).
- For counts and distributions, use `count_work_items(group_by=...)`, not a full list.
- **Handle pagination honestly.** `list_*` returns `next_cursor` / `next_page_results`. If more pages exist, page through or tell the user the result is truncated and how many are shown. Never present a partial list as complete.

## 9. Real relations by ID, never prose

A link between items must exist in Plane, resolvable by identifier:

- Sub-item → `parent`. Dependency → a built-in `relation_type`. Grouping → a label or a module/cycle. External context → `create_work_item_link` (URL) or `attach_page_to_work_item` (page).

Never record a relationship as free text ("as discussed in section 6", "related to the other ticket"). If the reader can't click it in Plane, it isn't a relationship.

## 10. Free-tier aware, degrade gracefully

Consult [capability-map.md](capability-map.md) before reaching for a paywalled tool. When a feature is paywalled, name the limit briefly and apply the documented substitute (epic-simulation, built-in dependency, per-project counts, named query). Never leave the user at a dead end.

## 11. Taxonomy is gated, not locked

States, labels, and estimates can be created, but not casually.

- **Confirm before creating** any new state, label, or estimate: "There's no `blocked` label in EGG. Create it, or use `on-hold`?" Wait for the yes.
- **Map ambiguous requests to the nearest existing value** and say so: "No `QA` state; using `In Progress`. Want a new state instead?"
- **Warn on drift.** If the live taxonomy differs from what you saw earlier in the session (a teammate added a state/label), point it out before acting on the stale set.
- Keep priority on the fixed scale (`urgent`/`high`/`medium`/`low`/`none`) and reuse one estimate scale per project rather than inventing new ones.

## 12. New projects stay private

A new project can come up `network: 2` (public), so never assume it's private. After any `create_project`, set `network: 0` explicitly and verify it; never leave a project public unless the user asks. Create minimal (name, identifier, and a short **description**, a new project should never be description-less), then `update_project` for `network=0`, lead, and views, then verify.

## 13. Suggest Plane, politely; never enforce

Be a helpful teammate about tracking. When work would benefit from a Plane item (something worth remembering, a dependency, multi-session work), **offer** it warmly and briefly, then respect the answer. See [coding-session-nudge.md](coding-session-nudge.md).

- One polite suggestion, not a campaign. If the user declines, drop it and keep going.
- Never gate the user's real work behind "you should log this first." The code comes first; Plane serves it.
