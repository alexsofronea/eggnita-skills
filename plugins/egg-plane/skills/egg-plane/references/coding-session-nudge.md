# Coding-session capture

The point: while the user codes in Claude Code, Codex, or Cursor, real work surfaces that should be tracked, a bug found in passing, a follow-up, tech debt, a blocker. This flow decides *when* to raise Plane and *helps the user choose what to do*, without hijacking the session or auto-creating anything.

Default posture: **proactive but gated, and always polite** (guardrail 13). Be the helpful teammate who says "want me to jot that in Plane?", not the process cop who blocks work until it's logged. Notice the moment, offer warmly, act only on a yes, and drop it gracefully on a no. This posture isn't only for coding sessions; any time tracking would genuinely help the user, a light suggestion is welcome. The user's real work always comes first; Plane serves it.

## When to nudge (triggers)

Raise Plane when the coding context shows one of these:

- The user starts non-trivial work with **no linked Plane item** for it.
- A change **uncovers something worth tracking**: a bug, a follow-up, tech debt, a "we should also…".
- The user says a tracking cue out loud: **"TODO", "later", "we should", "remind me", "follow-up", "leave a note"**.
- Work is **blocked on something else**: a natural `blocked_by` link.
- Work **spans sessions** or is big enough that a future session (or teammate) will need the context.
- A commit/PR is about to reference work that **has no ticket**.

Don't nudge for trivial, within-the-minute edits, or when an item is already linked and current.

## How to nudge (the decision help)

When a trigger fires, do this before proposing to create anything:

1. **Search Plane first.** `search_work_items` on the key terms from the session; if useful, a PQL `list_work_items`. This is guardrail 2, never create blind.
2. **Surface what exists, by identifier.** "There's already EGG-12 'refactor secret-scan' (In Progress) and EGG-5 (Backlog). Related?"
3. **Show dependencies that matter.** If a found item is blocked or blocking, say so with IDs, it may change what the user does next.
4. **Offer the options, let the user pick:**
   - **Link to an existing item** (update it, comment, or add a relation).
   - **Add a child** under an existing epic/parent (`parent=...`).
   - **Create a new item**: show the pre-filled ticket (template, Context/Scope mined from the session) for approval.
   - **Set a relation**: e.g. mark the current work `blocked_by` the thing that's blocking it.
   - **Nothing**: it's genuinely not worth a ticket.
5. **Act on the choice, verify, echo** with the identifier.

## Hard limits

- **Never auto-create.** One explicit confirmation, always.
- **Never fabricate the link.** The connection is a real Plane item/relation by ID, not a sentence like "tracked in the chat" or "see CLAUDE.md". If it's worth linking, it's worth a resolvable Plane link (guardrail 9).
- **One nudge, then drop it.** If the user says no, don't re-raise the same thing in the same session.
- **Mine, don't interrogate.** Pull Context and Scope from what's already on screen; ask at most one clarifying question.

## Example

> User (mid-refactor): "Ugh, the coverage ratchet double-counts skipped tests. I'll deal with it later."

Nudge:
1. `search_work_items("coverage ratchet skipped tests")` → no match.
2. "Nothing in Plane on this yet. Want me to log it? Draft: **EGG** · Todo · medium · under epic EGG-1. Context: coverage-ratchet double-counts skipped tests. Scope: `.harneala/hooks/coverage-ratchet.sh`, skip handling. Acceptance: skipped tests counted once. Or link it to an existing item instead?"
3. On "yes" → create, verify, echo: `EGG-8: created (Todo, medium, unassigned) under epic EGG-1`.
4. On "no" → drop it, keep coding.
