# Structure ops: cycles, modules, milestones, intake

Sprint and grouping structures. All verified on the free tier. Every step obeys the guardrails; they're not repeated here.

## Module vs epic: choose the right axis

They answer different questions and are **independent** (a task can be in a module *and* under an epic):

- **Module = a standing bucket.** "Which part of the product is this?" A viewing/filtering lens (CLI, API, billing, docs…). It never really *completes*; that area of work is ongoing. Modules have their own progress bars and can be dropped into cycles. This is the everyday categorization.
- **Epic = a finite, convergent feature.** "These N tasks add up to one thing, and here's the order they unlock in." It has a *done* state and earns the parent-child + `blocked_by` machinery.

The rule of thumb: **default to a module** for grouping. **Reserve epics** for the handful of cases where smaller tasks genuinely roll up into one feature that will finish. Don't use an epic as a workstream bucket (it never converges) and don't use a module for a finite feature (it can't express the unlock order).

## Cycles (sprints)

One active cycle at a time (parallel cycles are paywalled). A cycle whose `end_date` is in the past is treated as **completed** and locks.

- **Create:** `create_cycle(project_id, name, owned_by=<member UUID>, start_date, end_date)`. Owner is required; resolve a member first.
- **Add / remove items:** `manage_cycle_work_items(cycle_id, add_ids=[...], remove_ids=[...])`. Incremental, per guardrail 6. Only works on an **active or upcoming** cycle; a completed one 400s ("no new issues can be added").
- **List / scope:** `list_cycles`, or PQL `cycle IN activeCycle()`. `list_cycle_work_items(cycle_id)` lists a cycle's items.
- **Complete:** `complete_cycle(cycle_id)` sets `end_date` to today. Only on a not-yet-completed cycle; calling it on an already-completed one 400s.
- **Carryover:** `transfer_cycle_work_items(cycle_id, new_cycle_id)` moves **all** items from the source to the target. The **source must already be completed** ("the old cycle is not completed yet" otherwise). This is a bulk op: confirm first and name the target (guardrail 5).
- **Health snapshot:** `count_work_items(group_by="state__group", pql='cycle IN activeCycle()')`, plus an unassigned count (`hasNoAssignee()`).

**Sprint lifecycle order (verified):** create → add items while active/upcoming → `complete_cycle` → `transfer_cycle_work_items` to carry leftovers into the next cycle. You cannot add to or transfer from a cycle in the wrong state.

## Modules (standing product areas)

Modules are the everyday categorization: the product's workstreams/areas. Treat them like a controlled set, similar to labels (guardrail 11): assign to an existing one, and create a new module only with the user's confirmation.

- **Create:** `create_module(project_id, name, description, status, lead)`. Status: `backlog`/`planned`/`in-progress`/`paused`/`completed`/`cancelled`.
- **Add / remove items:** `manage_module_work_items(module_id, add_ids, remove_ids)`.
- **List / scope:** `list_modules`, or PQL `module = "<uuid>"`.
- **Progress:** `count_work_items(group_by="state__group", pql='module = "<uuid>"')`.

**Assign a module to most tasks (strong default, not required).** When a task clearly belongs to an existing module, put it there so the board stays browsable by area. If none fits, leave it module-less rather than forcing a bad fit or spawning a module without asking.

**Seed modules at project setup.** When creating a project, offer to define its initial modules (the product's workstreams/areas) so tasks have buckets from day one. Skippable; see the project-creation workflow.

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

The intake queue is the "not yet accepted into the backlog" list. Enabled on the free tier, verified end to end. New intake items land in a **Triage** state with status `-2` (pending).

- **List the queue:** `list_intake_work_items(project_id)`.
- **Add to intake:** `create_intake_work_item(project_id, data={"issue": {"name": "...", "priority": "...", "description_html": "..."}})`. The work item fields go **inside an `issue` object** (a bare `data` without `issue` 400s). The response's `issue` field is the work item UUID you use for the triage calls below.
- **Read / remove:** `retrieve_intake_work_item(work_item_id=<issue UUID>)`, `delete_intake_work_item(work_item_id=<issue UUID>)` (destructive, confirm).
- **Triage** with `update_intake_work_item(work_item_id=<issue UUID>, status=...)`:
  - `1` **accepted** → converts it to an active work item (moves Triage → Backlog). Verified.
  - `-1` **declined** → stays in Triage as declined. Verified.
  - `0` **snoozed** (requires `snoozed_till` date), `2` **duplicate** (requires `duplicate_to` work item UUID), `-2` pending.

Triage flow: list the queue, summarize each item by identifier, and for each recommend accept (with a follow-up state/assignee) or decline (with a one-line reason). Act only on the user's call.
