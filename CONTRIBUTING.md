# Contributing

**Eggnita team only.** These are internal tools. The repo may be public so others can read and install the skills, but we don't accept outside contributions; external pull requests and issues will be closed unmerged. This guide is for people inside Eggnita.

How to add and maintain skills in this repo. Read this before you touch anything.

## Golden rules

1. **Name every skill `egg-{name}`.** The plugin folder, the plugin name in `plugin.json`, and the entry in the marketplace all use the same `egg-{name}`. Use lowercase and hyphens (`egg-changelog`, not `egg_Changelog`).
2. **One skill, one folder, its own docs.** Each plugin lives in `plugins/egg-{name}/` and has its own `README.md`.
3. **Docs ship with the change.** Any change that adds, renames, or meaningfully alters a skill updates, in the *same* change: the plugin's own `README.md`, the marketplace manifest, and the "What's inside" table in the root `README.md`. No "docs later."
4. **Never commit secrets.** See [SECURITY.md](SECURITY.md).
5. **Stay opaque about internal Eggnita specifics.** Write every skill as if a stranger will read it, because one might. No internal policies, client names, private URLs, infra details, or credentials in skill text, examples, or prompts.

## First-time setup

This repo runs the [harneala](.) feature-tier harness. Run its init once per clone:

```bash
/harneala:init feature
```

That installs the git pre-commit hook (secret-scan + guardrails) and wires the reflect loop. It's idempotent, so running it again is safe. See `AGENTS.md` for the build workflow and `constitution.md` for the project invariants.

## Adding a new skill

1. **Create the plugin folder:**

   ```
   plugins/egg-<name>/
   ├── .claude-plugin/
   │   └── plugin.json
   ├── skills/
   │   └── egg-<name>/
   │       └── SKILL.md
   └── README.md
   ```

2. **Write `plugin.json`:**

   ```json
   {
     "name": "egg-<name>",
     "description": "One clear sentence: what this skill does and when to reach for it.",
     "version": "0.1.0"
   }
   ```

3. **Write the skill** in `skills/egg-<name>/SKILL.md` with YAML frontmatter (`name`, `description`). The `description` is what Claude uses to decide when to load the skill, so make it specific about *when* to use it.

4. **Write the plugin `README.md`** for humans: what the skill does, when it triggers, how to use it, any extra requirements.

5. **Register it in the marketplace.** Add an entry to `.claude-plugin/marketplace.json`:

   ```json
   {
     "name": "egg-<name>",
     "source": "./plugins/egg-<name>",
     "description": "Same one-liner as plugin.json."
   }
   ```

6. **Update the root `README.md`** "What's inside" table.

7. **Test the install locally** before pushing:

   ```bash
   /plugin marketplace add /path/to/eggnita-skills
   /plugin install egg-<name>
   ```

## Documentation upkeep

The root `README.md` is the shop window; it must reflect what's actually installable. If you're an agent working in this repo, treat updating `README.md` and `marketplace.json` as part of "done," not a follow-up task. The root `CLAUDE.md` states this rule for agents.

## Commits

- Commits are made by the repo owner. Don't auto-commit or push on someone's behalf.
- The pre-commit hook will block a commit that looks like it contains a secret. If it's a genuine false positive, `git commit --no-verify`, but look twice first.
