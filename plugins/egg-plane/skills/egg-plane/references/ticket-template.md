# Ticket template

Every work item this skill creates turns a vague ask into something a teammate can pick up cold. The shape adapts to the task: a chore is short, a feature is fuller. No bare one-line tickets, and no three-header ceremony on a two-minute fix either.

## Required fields (always)

- **Title**: specific and outcome-oriented. "Block secrets in pre-commit for AWS temp keys", not "fix hook". For an epic-like parent, prefix it: `[epic] {name}`.
- **Project**: resolved UUID.
- **State**: resolved UUID; default to the project's backlog or todo unless told otherwise.
- **Priority**: `urgent` / `high` / `medium` / `low` / `none`, chosen on purpose.
- **Assignee**: a resolved member, or explicitly "unassigned" (stated to the user).
- **Description**: sized to the task (below), passed as `description_html`.

Add when they apply: a **module** (the product area it belongs to; strong default, assign after create with `manage_module_work_items`), `parent` (sub-item / epic child), `labels`, `start_date`/`target_date`, `estimate_point`.

## Description: adaptive, not a fixed form

- **Always Context.** One or two lines: why this exists, the trigger, what a newcomer needs.
- **A "Done when" line on anything substantive.** State the observable end-state that means the task is finished; it doubles as the test ("Done when: a test email passes DMARC"). Near-mandatory: only a trivial chore ("bump the label color") may skip it. This is the machine-meaningful contract, so it matters more than the checklist below.
- **Steps, when the task has real sub-steps.** A short checklist of the quick to-dos as a task-list (renders as interactive checkboxes in Plane; see the syntax below). Optional and for the human's benefit; skip it for a one-move chore.
- **Scope when in/out isn't obvious.** Name what's explicitly out and the areas touched.
- **Always present dependencies.** If the item blocks or is blocked by others, name them by identifier in the description *and* set the real relation (guardrail 9). The reader should see what stands in the way.
- **Overflow to a page.** When the real context is bigger than a description should hold (a spec, a design, research notes), create a page (`create_page`) and attach it (`attach_page_to_work_item`). Keep the description a summary with a pointer, not a wall.

Keep it tight. Real context beats filler. Mine a coding-session context for Context/Scope rather than making the user retype it.

## Description body (full form, for a feature)

```html
<p><strong>Context:</strong> why this exists, the problem, the trigger, the background a newcomer needs.</p>
<p><strong>Scope:</strong> what's in and what's explicitly out. Name the files/areas/systems touched if known.</p>
<p><strong>Dependencies:</strong> blocked by EGG-2; blocks EGG-9.</p>
<p><strong>Steps</strong></p>
<ul data-type="taskList">
  <li data-type="taskItem" data-checked="false">a quick to-do</li>
  <li data-type="taskItem" data-checked="false">the next one</li>
</ul>
<p><strong>Done when:</strong></p>
<ul>
  <li>a concrete, checkable condition that also serves as the test</li>
  <li>another one</li>
</ul>
```

For a small chore, a `<p>Context:</p>` line plus a one-line `<p><strong>Done when:</strong> …</p>` is enough; skip Scope and Steps.

The **Steps** list uses Plane's task-list markup (`<ul data-type="taskList"><li data-type="taskItem" data-checked="false">…</li></ul>`), which Plane preserves and renders as interactive checkboxes (verified). Ordinary `<ul>` is fine for Done-when conditions. The agent creates steps unchecked and can't tick them later, so they're a human aid, not a status signal.

The HTML blocks here are indented for reading. **Minify before sending** (no whitespace between block tags), or Plane renders empty paragraphs and phantom bullets. See the "Writing HTML" note in [context-ops.md](context-ops.md).

## Worked example (feature)

Title: `egg-plane: warn before starting a blocked item`
Project: `EGG` · State: `Todo` · Priority: `high` · Assignee: `alex.sofronea` · Parent: `EGG-1` · Labels: `backend`

```html
<p><strong>Context:</strong> Starting work on an item whose blocker is still open wastes effort. The MCP exposes dependencies but won't warn on its own.</p>
<p><strong>Scope:</strong> On a "start this" action, check the item's blockers via list_work_item_relations and warn if any blocker is in an open state. Out of scope: auto-reordering the backlog.</p>
<p><strong>Dependencies:</strong> blocked by EGG-2 (dependency-inspection helper).</p>
<p><strong>Steps</strong></p>
<ul data-type="taskList">
  <li data-type="taskItem" data-checked="false">Read blockers via list_work_item_relations on the start action</li>
  <li data-type="taskItem" data-checked="false">Warn if any blocker is in an open state group</li>
</ul>
<p><strong>Done when:</strong></p>
<ul>
  <li>Starting EGG-3 while EGG-2 is open prints a warning naming EGG-2 and its state</li>
  <li>No warning when all blockers are Done or Cancelled</li>
</ul>
```

## Epic-like parent

Titled `[epic] {name}`, labeled `epic`. Its description states the goal and lists the children as they're created. Children link via `parent`, roll up via `childOf`. See [workflows.md](workflows.md).

## After creating

Echo with the identifier and key fields, per guardrail 4:

```
EGG-7: created (Todo, high, alex.sofronea) under epic EGG-1, +label backend, blocked_by EGG-2
```
