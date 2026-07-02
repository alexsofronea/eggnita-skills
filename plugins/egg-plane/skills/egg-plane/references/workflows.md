# egg-plane workflows

Step-by-step for the core tasks. Every step obeys the guardrails; they're not repeated here. Cycles, modules, milestones, and intake live in [structure-ops.md](structure-ops.md); comments, links, pages, attachments, and workload in [context-ops.md](context-ops.md); turning a plan into many linked items in [bulk-from-spec.md](bulk-from-spec.md).

## Create a project

New projects come up **private and fully featured**: enable every feature the free tier allows so nothing has to be turned on later.

1. **Create minimal:** `create_project(name, identifier)`. Adding `project_lead` or view flags at create can 400 while still creating the row, so keep it minimal.
2. **Enable all features:** `update_project(project_id, project_lead=..., module_view=true, cycle_view=true, issue_views_view=true, page_view=true, intake_view=true)`. Turn on cycles, modules, views, pages, and intake by default. (Work-item types stay off; they're paywalled.)
3. **Add the default estimate:** `create_project_estimate(project_id, name="Complexity", type="categories")`, then `create_project_estimate_points` with easy/medium/hard/very hard (see [structure-ops.md](structure-ops.md)).
4. **Verify private:** re-read with `retrieve_project`, confirm `network` is `0`. Never set `2` (public) unless the user asks (guardrail 12).
5. **Seed states if empty:** if `list_states` comes back empty (a half-created project), create the standard set (guardrail 11: confirm the set first).
6. **Echo:** the identifier, that it's private, and which features are on.

## Create a ticket

1. **Resolve the project.** `list_projects`, match the identifier. Hold its UUID.
2. **Search for duplicates.** `search_work_items` on the key words; if structured, a PQL `list_work_items`. Surface matches by identifier; ask before proceeding if any look close.
3. **Resolve state, assignee, labels.** `list_states`, `get_project_members` (filter bots), `list_labels`. No match for an assignee → unassigned, and say so.
4. **Fill the template.** Context, Scope, Acceptance criteria (see [ticket-template.md](ticket-template.md)).
5. **Create.** `create_work_item` with title, project, state, priority, assignees, labels, parent (if any), `description_html`.
6. **Verify.** If it errored, re-read by identifier before retrying. If it succeeded, confirm the fields you set are present.
7. **Echo.** One line with the new identifier and key fields.

## Triage / search

1. Resolve the project.
2. `search_work_items` for text, or `list_work_items` with a named query from [pql-cookbook.md](pql-cookbook.md).
3. For a specific item, `retrieve_work_item_by_identifier` (expand `assignees,labels,state`) and `list_work_item_relations` for its dependencies.
4. Report by identifier: state, assignee, blockers, children. Never dump raw JSON.

## Dependencies

**Set one:** resolve both items to UUIDs, then `create_work_item_relation(work_item_id=source, work_item_ids=[target], relation_type="blocked_by")` (or `blocking`, `start_before`, etc.). The inverse is created automatically. Echo: `EGG-3 blocked_by EGG-2`.

**Inspect:** `list_work_item_relations(work_item_id=...)` returns the six directions explicitly. Prefer this over guessing PQL direction.

**Warn before starting.** When the user is about to start or pick up an item:
1. `list_work_item_relations` on it.
2. For each item in `blocked_by`, read its state.
3. If any blocker is in an open state group (`backlog`/`unstarted`/`started`), warn: `EGG-3 is blocked_by EGG-2 (In Progress), start anyway?`
4. No open blockers → proceed quietly.

## Epic-simulation

Epics are paywalled; simulate them.

**Create an epic:** `create_work_item` with the title as `[epic] {name}`, then add the `epic` label (create it once with `create_label` if missing, confirming per guardrail 11). This item is the parent.

**Attach a child:** create the child with `parent=<epic UUID>`, or move an existing item with `update_work_item(parent=...)`.

**Roll up status:**
- List children: `list_work_items(pql='childOf("EGG-1")', expand="state,assignees")`.
- Progress by state: `count_work_items(group_by="state__group", pql='childOf("EGG-1")')`, then resolve state groups to a simple "3 done / 2 in progress / 1 todo" line.

## Status / report

1. Resolve the project (and cycle if relevant, `list_cycles`, or `activeCycle()` in PQL).
2. `count_work_items(group_by="state__group")` scoped by a project or cycle PQL for a burndown-style snapshot.
3. `count_work_items(group_by="assignees__id")` for load per person; resolve UUIDs to names before showing.
4. Present a short table, not a dump.

## Coding-session capture

See [coding-session-nudge.md](coding-session-nudge.md) for when to raise it and how to help the user decide. The create step reuses "Create a ticket" above, with Context/Scope mined from the session.
