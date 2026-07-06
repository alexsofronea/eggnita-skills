# Plane free-tier capability map

What the Plane MCP can and can't do on the free tier, verified by probing a live workspace. Trust this before calling a tool that might be paywalled: it saves a wasted round trip and a confusing error.

## Works (verified)

| Area | Tools | Notes |
|---|---|---|
| Work items | `create_work_item`, `update_work_item`, `retrieve_work_item`, `retrieve_work_item_by_identifier`, `delete_work_item` | Create with `type_id` null. Title, state, priority, assignees, labels, parent, dates, `description_html` all set in one call. |
| States | `list_states`, `create_state` | Groups: `backlog`, `unstarted`, `started`, `completed`, `cancelled`. Creating is gated by the taxonomy rule (confirm first). |
| Labels | `list_labels`, `create_label`, `manage_work_item_label` | `manage_work_item_label` adds/removes one. Creating is gated (confirm first). |
| Assignees | `manage_work_item_assignee` | Incremental add/remove. |
| Sub-items | `create_work_item(parent=...)`, `update_work_item(parent=...)` | Roll up with PQL `childOf("EGG-1")`. |
| Dependencies | `create_work_item_relation`, `list_work_item_relations` | Only the six built-ins (below). Auto-bidirectional. |
| Search & filter | `search_work_items`, `list_work_items` (PQL), `count_work_items` | `get_pql_reference` for syntax. |
| Cycles | `create_cycle` (needs `owned_by`), `list_cycles`, `list_cycle_work_items`, `manage_cycle_work_items`, `complete_cycle`, `transfer_cycle_work_items` | One active cycle at a time. Lifecycle order: add while active/upcoming → `complete_cycle` → `transfer` leftovers. `transfer` needs the source completed and moves all items (bulk, confirm). |
| Modules | `create_module`, `list_modules`, `manage_module_work_items` | |
| Pages | `create_page`, `retrieve_page`, `list_pages`, `attach_page_to_work_item`, `detach_page_from_work_item` | Create + read only: **no `update_page`, `delete_page`, or unlock tool**. `access=0` = public, `is_locked=true` = read-only, both settable **only at creation**. Edits/deletes are manual in the Plane UI. |
| Estimates | `create_project_estimate`, `create_project_estimate_points`, `list_project_estimate_points`, `update_work_item(estimate_point=...)`, `delete_project_estimate` | Standard is **categories: easy/medium/hard/very hard**. One estimate per project (409 on a second); switch scales by deleting first. |
| Milestones | `list_milestones`, `create_milestone` | Verified: create + list work. |
| Comments | `list_work_item_comments`, `create_work_item_comment`, `delete_work_item_comment` | HTML body; `access` INTERNAL/EXTERNAL. Mention a person with a `<mention-component entity_identifier="UUID" entity_name="user_mention">` node, not plain `@text` (verified). |
| External links | `create_work_item_link`, `list_work_item_links` | Attach a URL (repo, PR, doc) to an item. |
| Attachments | `upload_work_item_attachment_from_url`, `read_work_item_attachment` | Source URL must be public. Verified: uploaded a file from a raw GitHub URL. |
| Intake | `list_intake_work_items`, `create_intake_work_item`, `update_intake_work_item`, `retrieve_intake_work_item`, `delete_intake_work_item` | Triage queue. Create with `data={"issue": {...fields}}`. Triage via `update_intake_work_item(status=...)`: `1` accept (→ Backlog), `-1` decline, `0` snooze, `2` duplicate. |
| Activity log | `list_work_item_activities` | Every change (state, assignee, field) with a timestamp and `epoch`. Free. It's the source for cycle-time worklogs, since native time tracking is paywalled. |
| Members | `get_workspace_members`, `get_project_members` | **Returns bots.** Filter `is_bot = true`. |
| Projects | `create_project`, `update_project`, `retrieve_project` | A new project can come up `network: 2` (public) despite older assumptions, so **always set `network: 0` explicitly and verify** (don't assume private). Give it a short `description` at create. Enable all features on setup (cycles, modules, views, pages, intake + a categories estimate). |

### The six built-in dependency `relation_type` values

`blocking`, `blocked_by`, `start_before`, `start_after`, `finish_before`, `finish_after`. Pass one to `create_work_item_relation`. The inverse is maintained automatically.

## Paywalled, do not call (they return 402 / 403 / 400)

| Tool / feature | Error | Consequence |
|---|---|---|
| `list_work_item_types`, `resolve_work_item_type` | 402 / "upgrade" | No custom types, no native Epics. Work items stay typeless. |
| `list_work_item_relation_definitions` | 402 | Can't create custom relations (`relates to`, `duplicate`, `implements`). Only the six built-ins. |
| `list_initiatives` and initiative ops | 403 / "upgrade" | No cross-project initiatives / rollups. |
| `get_project_worklog_summary`, work logs | 402 | No time tracking. `is_time_tracking_enabled` is off. |

Also off (feature flags): `workflows` (state-transition rules), `parallel_cycles`, `manually_start_end_cycles`.

## Absent from the MCP

- **View creation.** No `create_view` tool. Substitute: the named-query library in [pql-cookbook.md](pql-cookbook.md), optionally mirrored into a page.

## Substitutes for paywalled features

- **Epic, epic-simulation.** A normal item titled `[epic] {name}`, labeled `epic`, is the parent. Children link via `parent`. Roll up with `childOf` + `count_work_items(group_by="state__group")`. See [workflows.md](workflows.md).
- **Custom relation, built-in dependency.** Map intent to one of the six. If they need "relates"/"duplicate" specifically, say it's paywalled and offer a built-in or a comment/link by ID.
- **Initiative rollup, per-project counts.** Run `count_work_items` per project and total them yourself.
- **View, named PQL query.**

## Behavioral gotchas (source of the guardrails)

1. **A write can error yet persist.** A `create_project` returned HTTP 400 but the project existed, with default states/labels not seeded. Verify by re-reading after any write error. Never blind-retry a create.
2. **`create_project` with extras can partially fail.** Creating with `project_lead` + view flags triggered the 400. Create minimal (name, identifier, a short description), then `update_project` for lead/views, then verify. **Privacy is not reliably default:** a new project can come up `network: 2` (public), so set `network: 0` explicitly and confirm it; never assume private.
3. **Members include bots.** Filter `is_bot`.
4. **Sparse fields return null when not requested.** Null means "not requested," not "empty." Name `description_html`, `type_id`, `state`, `assignees`, `labels` explicitly when you need them.
5. **Paginated responses truncate.** `list_*` returns `next_cursor` / `next_page_results`. When more pages exist, either page through or tell the user the result is truncated. Never imply a partial list is the whole set.
6. **Cycle state gates its operations.** A past-`end_date` cycle is "completed" and locked: you can't add items to it, and you can't `complete_cycle` it again. `transfer_cycle_work_items` needs the source completed first. So the only valid order is add → complete → transfer.
7. **HTML bodies must be minified; HTML comments are stripped.** Whitespace between block tags becomes empty paragraphs/bullets in Plane's editor, and `<!-- ... -->` nodes are removed by the sanitizer (so no hidden metadata in a comment). Minify every `comment_html`/`description_html`. See [context-ops.md](context-ops.md).
