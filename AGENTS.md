# eggnita-skills

Agent instructions for this repo. **You own this file — edit it freely.**
harneala scaffolded it at the **feature** tier and won't touch it again. Anything the harness
manages lives in its own `<!-- BEGIN harness:… -->` block below (added at feature/production) —
never in this preamble, so nothing here goes stale when you graduate.

**What this is.** A Claude Code plugin marketplace of shared Eggnita skills. Each skill is a
plugin named `egg-{name}` under `plugins/`, listed in `.claude-plugin/marketplace.json`. The team
installs with `/plugin install egg-{name}` and updates with `/plugin update`. Internal tooling:
public to read and install, no outside contributions.

**Repo policy lives in `CLAUDE.md`** (the hard rules: `egg-{name}` naming, docs-ship-with-the-change,
no secrets, opacity about internal Eggnita specifics) **and `CONTRIBUTING.md`** (the step-by-step for
adding a skill). Read both before adding or changing a skill. This file (`AGENTS.md`) covers the
build *workflow*; `CLAUDE.md` covers the *policy*.

**Per-clone setup.** Run `/harneala:init feature` once after cloning. It installs the git
pre-commit hook (secret-scan + guardrails) and wires the reflect loop. Nothing else is needed.

- Unsure of the current tier, what's set up, or what to do next? Run `/harneala:orient` for a
  read-only summary. It reads the live scope marker, so it always reflects the real guardrails.

<!-- BEGIN harness:feature -->
## Harness — feature tier

This repo runs the harneala **feature-tier** workflow. This block is harness-owned (re-synced by
`/harneala:init`); everything outside the BEGIN/END markers is yours.

Unsure where you are or what to do next? Run `/harneala:orient` for a read-only summary of the
current tier and the recommended next step. About to start a change and unsure how much process it
warrants? Run `/harneala:right-size` to size its blast radius and get the proportional workflow.
Working on something outside this chain? Don't tunnel-vision on harneala's own skills — run
`/harneala:toolcheck` to see the plugins, MCP servers, and skills you already have, and reach for
whichever fits the task best.

Build through the vendored skill chain, one vertical slice at a time:

1. **Align** — `/harneala:grill-with-docs` to stress-test the design (records ADRs + a glossary).
2. **Spec & slice** — `/harneala:to-prd`, then `/harneala:to-issues`. GitHub issues are the coding
   spine; when work needs colleagues outside the repo (a shared task board, a non-coding hand-off),
   `/harneala:toolcheck` routes to a project-management MCP like Plane to create tasks in the
   project's space — mirror coordination there, keep the code's source of truth on GitHub.
3. **Build** — `/harneala:tdd` (red → green → refactor), one slice per issue. When a slice
   touches the UI, `/harneala:make-interfaces-feel-better` applies the polish lens (motion,
   surfaces, typography, hit areas) — it fires on UI work, and `/orient` / `/right-size` surface it.
4. **Hand off** — `/harneala:handoff` when a session fills up.

Project invariants live in `constitution.md`. Lessons captured during work go to `learnings.md`.

**Reflect loop.** When something breaks, state the lesson on its own line as
`LEARNING: <what broke> -> <the rule that prevents it>`. A `Stop` hook appends each new
`LEARNING:` line to `learnings.md`, and a `SessionStart` hook loads `learnings.md` back at the
start of the next session — so the harness stops repeating mistakes. Promoting a recurring lesson
into `constitution.md` or the plugin itself stays a manual, human-gated step — run
`/harneala:promote` to cluster recurring learnings and review the proposed promotion diffs.
<!-- END harness:feature -->
