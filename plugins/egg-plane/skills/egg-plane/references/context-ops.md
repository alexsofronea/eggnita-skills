# Context ops: comments, links, pages, attachments, workload

Ways to attach context and read the team's load. All verified on the free tier. Guardrails still apply, especially "real relations by ID, never prose" (guardrail 9) and "echo after write" (guardrail 4).

## Comments (status and handoffs)

- **Add:** `create_work_item_comment(project_id, work_item_id, comment_html, access="INTERNAL")`. Use for status updates, decisions, and session handoffs so the item carries its own history.
- **Read:** `list_work_item_comments(project_id, work_item_id)`.
- Keep comments factual and identifier-linked ("Blocked on EGG-2; picking back up when it's Done"). A comment is not a substitute for a real relation or a state change; use it alongside them.

## External links

- **Add:** `create_work_item_link(project_id, work_item_id, url)`. Attach the repo, a PR, a commit, or an external doc.
- **Read:** `list_work_item_links(project_id, work_item_id)`.
- Prefer a link over pasting a URL into the description; it renders as a first-class link on the item.

## Pages and attaching them

Pages hold the context a description shouldn't (specs, designs, research).

- **Create:** `create_page(project_id, name, description_html)` (project page), or omit `project_id` for a workspace page.
- **Attach to a work item:** `attach_page_to_work_item(project_id, work_item_id, page_id)`. Verified.
- **Read / list:** `retrieve_page`, `list_pages`.
- Pattern: when a ticket needs more than a short Context, create a page, attach it, and keep the description a summary with the pointer.

## File attachments

- **Attach from a public URL:** `upload_work_item_attachment_from_url(project_id, work_item_id, url, name)`. The URL must be publicly reachable (a raw GitHub URL, a public S3 link). Verified.
- **Read for analysis:** `read_work_item_attachment`.
- Don't attach anything sensitive, and remember the source URL must be public, so never point it at a private/internal address.

## Workload view (before assigning)

Before piling more on someone, look at their current load.

- `count_work_items(group_by="assignees__id", pql='stateGroup IN openStates()')` scoped to the project, then resolve the assignee UUIDs to names (filter bots).
- Report it plainly ("alex.sofronea: 6 open, 2 urgent") and let that inform the assignment. With a single human on the workspace today this is light, but it's the right habit as the team grows.
