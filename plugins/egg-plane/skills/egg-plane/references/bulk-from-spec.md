# Bulk create from a spec

Turn a PRD, plan, or design doc into a set of linked Plane items in one guided pass. This is where egg-plane earns its keep on planning, not just single tickets. It pairs naturally with harneala's `to-prd` / `to-issues`: those shape the plan, this lands it in Plane.

The risk with bulk creation is exactly what the guardrails guard against, magnified: duplicates, guessed IDs, silent partial failures. So bulk work is **plan-then-apply**, never a blind loop.

## Flow

1. **Resolve the project** and its states/labels/members once, up front.
2. **Parse the spec into a proposed tree.** For each item: title, a sized description (Context, plus Scope/Acceptance when warranted), priority, proposed state, proposed parent (the epic-like root), and proposed dependencies (`blocked_by` / `blocking`) by *position in the plan* (not IDs yet, they don't exist).
3. **Search for duplicates** across the titles (`search_work_items` per key phrase) and flag any that already exist. Offer to link/update instead of re-creating.
4. **Show the whole plan for approval** as a tree with the parent, children, priorities, and the dependency edges. One confirmation for the batch. This is the gate.
5. **Apply in dependency order:**
   - Create the epic-like parent first (`[epic] {name}`, `epic` label).
   - Create children with `parent=<parent UUID>`. Capture each returned identifier.
   - Only after items exist, wire dependencies with `create_work_item_relation` using the now-real UUIDs. Never reference an item before it exists.
6. **Verify and echo the batch.** Re-read the parent's children (`childOf`) and report the created identifiers as a tree, with the dependency edges. If any single create errored, re-read before retrying that one (guardrail 3), and report exactly which items landed and which didn't. No silent partial success.

## Limits and honesty

- **Cap the batch** at a reviewable size. If a plan implies 40 items, create the epic + first slice, land it, then continue, rather than firing 40 writes behind one "yes".
- **Report anything skipped.** If a duplicate was found and not created, or an item failed, say so with identifiers. A bulk op that quietly drops items is worse than no bulk op.
- **Dependencies are by ID, always.** The plan's "step 3 depends on step 2" becomes `EGG-9 blocked_by EGG-8`, never a note in a description.

## Example shape (approval view)

```
[epic] Ship egg-plane v1.1                         high
 ├─ Cycles workflow + worked example               medium
 ├─ Modules workflow + worked example              medium   blocked_by: Cycles workflow
 ├─ Estimates workflow (categories setup + attach) medium
 └─ Pages workflow (create + attach)               low
Create these 5 items under a new epic in EGG? (y/n)
```
