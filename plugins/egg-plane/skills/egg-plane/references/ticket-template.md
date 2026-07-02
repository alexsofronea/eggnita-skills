# Ticket template

Every work item this skill creates turns a vague ask into something a teammate can pick up cold. The shape adapts to the task: a chore is short, a feature is fuller. No bare one-line tickets, and no three-header ceremony on a two-minute fix either.

## Required fields (always)

- **Title**: specific and outcome-oriented. "Block secrets in pre-commit for AWS temp keys", not "fix hook". For an epic-like parent, prefix it: `[epic] {name}`.
- **Project**: resolved UUID.
- **State**: resolved UUID; default to the project's backlog or todo unless told otherwise.
- **Priority**: `urgent` / `high` / `medium` / `low` / `none`, chosen on purpose.
- **Assignee**: a resolved member, or explicitly "unassigned" (stated to the user).
- **Description**: sized to the task (below), passed as `description_html`.

Add when they apply: `parent` (sub-item / epic child), `labels`, `start_date`/`target_date`, `estimate_point`.

## Description: adaptive, not a fixed form

- **Always Context.** One or two lines: why this exists, the trigger, what a newcomer needs.
- **Scope and Acceptance criteria when they earn their place.** A real feature or fix gets them. A tiny chore ("bump the label color") does not. Add acceptance criteria whenever "done" is otherwise ambiguous.
- **Always present dependencies.** If the item blocks or is blocked by others, name them by identifier in the description *and* set the real relation (guardrail 9). The reader should see what stands in the way.
- **Overflow to a page.** When the real context is bigger than a description should hold (a spec, a design, research notes), create a page (`create_page`) and attach it (`attach_page_to_work_item`). Keep the description a summary with a pointer, not a wall.

Keep it tight. Real context beats filler. Mine a coding-session context for Context/Scope rather than making the user retype it.

## Description body (full form, for a feature)

```html
<p><strong>Context:</strong> why this exists, the problem, the trigger, the background a newcomer needs.</p>
<p><strong>Scope:</strong> what's in and what's explicitly out. Name the files/areas/systems touched if known.</p>
<p><strong>Dependencies:</strong> blocked by EGG-2; blocks EGG-9.</p>
<p><strong>Acceptance criteria:</strong></p>
<ul>
  <li>a concrete, checkable condition</li>
  <li>another one</li>
</ul>
```

For a small chore, one `<p>Context:</p>` line is enough.

## Worked example (feature)

Title: `egg-plane: warn before starting a blocked item`
Project: `EGG` · State: `Todo` · Priority: `high` · Assignee: `alex.sofronea` · Parent: `EGG-1` · Labels: `backend`

```html
<p><strong>Context:</strong> Starting work on an item whose blocker is still open wastes effort. The MCP exposes dependencies but won't warn on its own.</p>
<p><strong>Scope:</strong> On a "start this" action, check the item's blockers via list_work_item_relations and warn if any blocker is in an open state. Out of scope: auto-reordering the backlog.</p>
<p><strong>Dependencies:</strong> blocked by EGG-2 (dependency-inspection helper).</p>
<p><strong>Acceptance criteria:</strong></p>
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
