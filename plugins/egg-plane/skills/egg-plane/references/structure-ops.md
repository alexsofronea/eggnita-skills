# Structure ops: cycles, modules, milestones, intake

Sprint and grouping structures. All verified on the free tier. Every step obeys the guardrails; they're not repeated here.

## Cycles (sprints)

One active cycle at a time (parallel cycles are paywalled).

- **Create:** `create_cycle(project_id, name, owned_by=<member UUID>, start_date, end_date)`. Owner is required; resolve a member first.
- **Add / remove items:** `manage_cycle_work_items(cycle_id, add_ids=[...], remove_ids=[...])`. Incremental, per guardrail 6.
- **List / scope:** `list_cycles`, or PQL `cycle IN activeCycle()`.
- **Complete:** `complete_cycle(cycle_id)`.
- **Carryover:** `transfer_cycle_work_items` moves unfinished items to another cycle. This is a **bulk op, confirm first** and list the identifiers being moved (guardrail 5).
- **Health snapshot:** `count_work_items(group_by="state__group", pql='cycle IN activeCycle()')`, plus an unassigned count (`hasNoAssignee()`).

## Modules (feature groupings)

- **Create:** `create_module(project_id, name, description, status, lead)`. Status: `backlog`/`planned`/`in-progress`/`paused`/`completed`/`cancelled`.
- **Add / remove items:** `manage_module_work_items(module_id, add_ids, remove_ids)`.
- **List / scope:** `list_modules`, or PQL `module = "<uuid>"`.
- **Progress:** `count_work_items(group_by="state__group", pql='module = "<uuid>"')`.

## Milestones

Verified: create and list work on the free tier.

- **Create:** `create_milestone(project_id, title, target_date)`.
- **List:** `list_milestones(project_id)`.
- Use for a dated target the team is driving toward. Keep the title outcome-shaped ("Beta live", not "milestone 1").

## Estimates

The standard estimate is **categories: easy / medium / hard / very hard**, not story points. One estimate per project (Plane 409s on a second), so set it up once and reuse it (guardrail 11). Verified end to end on the free tier.

1. **Create the estimate (once):** `create_project_estimate(project_id, name="Complexity", type="categories")`. `last_used=true` makes it active. A project can hold only one estimate; to switch scales, `delete_project_estimate` first (destructive, confirm), then recreate.
2. **Define the categories:** `create_project_estimate_points(project_id, estimate_id, points=[{"value":"easy","key":0}, {"value":"medium","key":1}, {"value":"hard","key":2}, {"value":"very hard","key":3}])`.
3. **Attach to an item:** resolve the category UUID with `get_project_estimate` then `list_project_estimate_points`, then `update_work_item(estimate_point=<category UUID>)`. Echo it: `EGG-6: estimate→hard`.

Worked example: EGG's "Complexity" estimate with easy/medium/hard/very hard; EGG-6 is set to `hard`. Don't invent a second scale for the same project; map a request to the nearest category.

## Intake / triage

The intake queue is the "not yet accepted into the backlog" list. The feature is enabled on the free tier.

- **List the queue:** `list_intake_work_items(project_id)`.
- **Add to intake:** `create_intake_work_item(project_id, data={...})`. `data` carries the work item fields.
- **Read / update / remove:** `retrieve_intake_work_item`, `update_intake_work_item`, `delete_intake_work_item` (delete is destructive, confirm).
- **Accept:** promote an intake item into the backlog by updating it into a normal state / project item, then echo the new identifier.
- **Reject:** decline it, and say why in one line so the record is clear.

Triage flow: list the queue, summarize each item by identifier, and for each recommend accept (with a state/assignee) or reject (with a reason). Act only on the user's call.
