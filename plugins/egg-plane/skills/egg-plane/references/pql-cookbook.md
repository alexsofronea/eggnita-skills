# PQL cookbook (the "views" substitute)

Plane views can't be created from the MCP, so this library of named queries stands in. Recognize the name the user says, run the query with `list_work_items` or `count_work_items`. For anything outside this list, call `get_pql_reference` and compose carefully.

## PQL rules that bite

- **Max 5 conditions.** Each comparison, each `IN(...)`, each `BETWEEN`, and each predicate/relation function counts as one.
- **No date arithmetic.** Never `today() - 7`. Use `daysAgo(7)`, `startOfWeek()`, etc.
- **UUID fields need UUIDs** (assignee, state, label, cycle, module, project, type). Resolve them first with the matching `list_*` tool. Exceptions that need no UUID: `currentUser()`, `activeCycle()`, `completedCycles()`, `openStates()`, `closedStates()`, `activeStates()`.
- **Relation/predicate functions take an identifier or UUID**, never a title: `childOf("EGG-1")`, `blocks("EGG-3")`.

## Named queries

| Name | PQL | Use |
|---|---|---|
| My open work | `assignee = currentUser() AND stateGroup IN openStates()` | What I should be doing |
| My work in this cycle | `assignee = currentUser() AND cycle IN activeCycle()` | Sprint focus |
| Blocked items | `stateGroup IN openStates() AND blocks("EGG-N") ` *(per blocker)*, or list relations per item | What's stuck. For "everything blocked", inspect relations item by item, PQL has no generic "isBlocked". |
| Overdue | `isOverdue()` | Past due date and still open |
| Unassigned urgent | `hasNoAssignee() AND priority = "urgent"` | Triage gaps |
| Stale open | `stateGroup IN openStates() AND updatedAt < daysAgo(30)` | Rot |
| Top-level (project spine) | `isTopLevel()` | Items with no parent |
| Epic children | `childOf("EGG-1")` | Roll up one epic |
| Epic children by state | `childOf("EGG-1")` + `count_work_items(group_by="state__group")` | Epic progress |
| Created this week | `createdAt >= startOfWeek()` | Recent additions |
| High/urgent backlog | `priority IN ("high","urgent") AND stateGroup = "backlog"` | Prioritization |
| Unestimated open | `stateGroup IN openStates() AND ` *(no estimate predicate, read `estimate_point` from results and filter client-side)* | Estimation gaps |

## Dependency direction (read carefully)

The relation functions are directional. To answer "what is blocking EGG-3 right now":

- `blocks("EGG-3")` → items that block EGG-3. These are its blockers.
- `blockedBy("EGG-2")` → items that EGG-2 blocks (i.e. things waiting on EGG-2).
- `linkedTo("EGG-5")` → related in either direction.
- `parentOf("EGG-9")` / `childOf("EGG-1")` → hierarchy.

When in doubt, `list_work_item_relations(work_item_id=...)` returns the six directions explicitly and is unambiguous.

## Counts and reports

Use `count_work_items` for distributions instead of listing:

- By state for a project: `count_work_items(group_by="state__group")` scoped by a project PQL.
- By assignee: `count_work_items(group_by="assignees__id")`.
- Epic progress: `count_work_items(group_by="state__group", pql='childOf("EGG-1")')`.

`group_by` keys come back as UUIDs for FK fields (state, assignee), resolve them to names with the matching `list_*` before showing the user.

## Mirroring to the UI (optional)

Since the team can't see these as Plane views, offer to write the ones they use often into a Plane **page** (`create_page`) titled e.g. "Saved queries" so they're visible alongside the boards. Keep the page in sync when queries change.
