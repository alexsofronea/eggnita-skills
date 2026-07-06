# Newcomer onboarding page

Every project created through egg-plane gets a short, public "Start here" page so an invited teammate immediately knows what the project is and how to get the most out of Plane. Also create it on demand ("add an onboarding page to EGG").

## How

`create_page(project_id, name="Start here 👋", access=0, is_locked=true, description_html=<template below>)`.

- `access=0` is the project-visible (public) level, so every member sees it. Verified.
- `is_locked=true` makes it **read-only**. Members can read but not edit; unlocking (to edit) needs edit permission, so a project admin/owner does it in the Plane UI. Verified that the flag is set at creation.
- Fill the first line with a one-sentence description of *this* project, from the project's own description or what the user tells you. **Get it right the first time** (see the limitation below).
- Echo the page name, that it's public, and that it's locked.

### MCP limitation you must account for

The Plane MCP has **no `update_page`, `delete_page`, or unlock tool**; `create_page` is the only page write. Consequences:

- The lock can only be set **at creation**. There's no MCP unlock/relock.
- The agent can **never edit or delete a page** after creating it. All page edits are manual in the Plane UI. This matches "only admins edit it by hand," but it also means you can't fix a typo via the agent, so review the content before creating.
- If a project already has a wrong or unlocked "Start here" page, the agent can't remove it. Ask the user to delete it in the UI, then create the correct locked one.

## Why each setup item is on the page

- **Plane apps** (`plane.so/download`): mentions and updates reach people in real time, so work doesn't stall waiting on someone.
- **Plane MCP**: lets a teammate's coding agent read and write Plane from their editor.
- **egg-plane skill**: makes that agent follow the team's guardrails instead of raw API calls (no duplicates, real dependencies, clean tickets).

## Template

Replace the first `<em>` line with the project's own one-liner. Everything else is reusable.

```html
<p><em>{One sentence: what this project is and who it's for.}</em></p>
<h2>Get set up (about 5 minutes)</h2>
<ul>
<li><strong>Install the Plane apps</strong> (desktop &amp; mobile): <a href="https://plane.so/download">plane.so/download</a>. <em>Why: mentions and updates reach you in real time, so nothing waits on you.</em></li>
<li><strong>Connect the Plane MCP</strong> to your AI editor: <code>claude mcp add --transport http plane https://mcp.plane.so/http/mcp</code> (<a href="https://developers.plane.so/dev-tools/mcp-server">docs</a>). <em>Why: your coding agent reads and updates Plane without you leaving the editor.</em></li>
<li><strong>Install the egg-plane skill</strong>: <code>/plugin marketplace add alexsofronea/eggnita-skills</code>, then <code>/plugin install egg-plane</code>. <em>Why: the agent then follows the team's guardrails (no duplicate tickets, real dependencies, clean descriptions) instead of raw API calls. Ask a maintainer for repo access if the install fails.</em></li>
</ul>
<h2>Cycles, modules &amp; epics (the building blocks)</h2>
<ul>
<li><strong>Module</strong>: a standing bucket for a part of the product (CLI, billing, docs…). <em>Use it when: tagging which area a task belongs to. A task usually sits in one, and modules never "finish."</em></li>
<li><strong>Epic</strong>: one finite deliverable broken into sub-tasks, linked by parent/child and real <code>blocked_by</code> order. <em>Use it when: several tasks genuinely converge into one feature that will ship. Not for grouping a workstream; that's a module.</em></li>
<li><strong>Cycle</strong>: a time-boxed sprint, what the team commits to this period. <em>Use it when: planning the current stretch. Pull work from modules and epics into it.</em></li>
</ul>
<h2>How we work here</h2>
<ul>
<li><strong>Tickets carry context</strong>: a short Context, plus Scope/Acceptance when it matters. <em>Why: anyone can pick one up cold.</em></li>
<li><strong>Epics are <code>[epic] name</code> items</strong>; sub-tasks link to a parent; blockers are real <code>blocked_by</code> links, not notes. <em>Why: the board shows what truly depends on what.</em></li>
<li><strong>Estimates are easy / medium / hard / very hard.</strong> <em>Why: one shared sense of size.</em></li>
<li><strong>Half-formed ideas go to Intake.</strong> <em>Why: nothing is lost; it's triaged into the backlog or declined.</em></li>
<li><strong>Comments for handoffs, @mention to notify.</strong> <em>Why: decisions and pings live on the item, not in chat.</em></li>
</ul>
<h2>Just ask the agent</h2>
<p>With egg-plane installed, describe the outcome and it does the Plane work (resolves IDs, checks for duplicates, files it right):</p>
<ul>
<li>"Create a ticket for &lt;thing&gt;"</li>
<li>"What's blocking &lt;ITEM-ID&gt;?"</li>
<li>"Log this to Plane" (while coding)</li>
<li>"How's the &lt;epic&gt; doing?"</li>
<li>"Turn this plan into tickets"</li>
</ul>
<h2>Where to start</h2>
<p>Check <strong>your open work</strong> (assigned to you, still open) and the <strong>active cycle</strong> (current sprint). Ask the agent: "show my open work in this project."</p>
```
