# Context ops: comments, links, pages, attachments, workload

Ways to attach context and read the team's load. All verified on the free tier. Guardrails still apply, especially "real relations by ID, never prose" (guardrail 9) and "echo after write" (guardrail 4).

## Writing HTML (comments, descriptions, pages): minify it

Every HTML body the skill sends (`comment_html`, a work item's `description_html`, a page's `description_html`) must be **minified: no whitespace between block tags**. Plane's editor turns any newline or space between `</p>` and `<p>`, or between `<li>` items, into an **empty paragraph or an empty bullet**, so a nicely-indented template renders with big gaps and phantom bullets (verified live). Butt the block tags together: `<ul><li>one</li><li>two</li></ul>`, never one tag per line. The HTML snippets shown in these references are spaced out for reading; strip the gaps before sending.

Two related facts, same sanitizer: HTML comments (`<!-- ... -->`) are **stripped**, so there is no hidden-metadata channel in a comment; anything that must persist has to be visible text or a real field. Plain `@name` is also inert (see mentions below).

## Comments (status and handoffs)

- **Add:** `create_work_item_comment(project_id, work_item_id, comment_html, access="INTERNAL")`. Use for status updates, decisions, and session handoffs so the item carries its own history.
- **Read:** `list_work_item_comments(project_id, work_item_id)`. **Remove:** `delete_work_item_comment(project_id, work_item_id, comment_id)`.
- Keep comments factual and identifier-linked ("Blocked on EGG-2; picking back up when it's Done"). A comment is not a substitute for a real relation or a state change; use it alongside them.

### Mentioning people (@)

Plain `@name` text does **nothing**; it's stored as literal characters and notifies no one (verified). To actually tag someone, resolve their member UUID (`get_project_members`, filter bots) and emit a mention **node** in `comment_html`:

```html
<mention-component entity_identifier="<MEMBER-UUID>" entity_name="user_mention"></mention-component>
```

Verified live: this renders as a real highlighted `@display_name` mention and notifies the person; plain `@display_name` does not. So the rule is guardrail 1 again: resolve the UUID, never type a raw handle. This works in comments and in `description_html`.

### Optional cycle-time note on Done

When you move an item to **Done**, you may post a short "how long it was in flight" note. Native time tracking is paywalled, so this reads the free substitute: the activity log, which is ground truth, never a guess.

- **Source:** `list_work_item_activities(project_id, work_item_id)`. Find the last `state` change into **In Progress** and the one into **Done**; the span between their timestamps is the time in progress.
- **Post it as a new comment** (don't edit an existing one), a **single line only, no timestamps or epoch numbers**:

  `🤖 Auto-logged by egg-plane · In Progress → Done in 1m 35s (cycle time, not effort).`

- **Mark it as machine-generated.** MCP comments are attributed to the acting user, so without a marker a teammate reads it as hand-written. Lead with the bot marker (`🤖 Auto-logged by egg-plane`) so it's plainly the skill talking, not the person.
- **Be honest about the number.** It's wall-clock between the two state changes, so it over-counts if the item sat open across a break; label it "cycle time, not effort." It only means anything if In Progress was set when work actually started, so tie it to the "warn before starting" step (see [workflows.md](workflows.md)).
- **Optional and gated.** Offer it; don't spam every Done with it unless the team asked to track this.

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
