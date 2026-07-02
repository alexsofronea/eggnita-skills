# Working in eggnita-skills

Rules for any agent working in this repo. These are not optional.

## What this repo is

A Claude Code **plugin marketplace** of shared Eggnita skills. Each skill is a plugin named `egg-{name}` under `plugins/egg-{name}/`, registered in `.claude-plugin/marketplace.json`. It may become public for read/install, but it's an internal Eggnita project — no outside contributions.

## Hard rules

1. **Naming:** every skill/plugin is `egg-{name}` (lowercase, hyphens). Folder name, `plugin.json` name, and marketplace entry all match.
2. **Docs ship with the change.** When you add, rename, or meaningfully change a skill, update these in the same change: the plugin's own `README.md`, `.claude-plugin/marketplace.json`, and the "What's inside" table in the root `README.md`. Consider the task unfinished until these match reality.
3. **No secrets.** Never write API keys, tokens, passwords, private keys, `.env` values, or credentials into any file. See `SECURITY.md`.
4. **Opacity about internal Eggnita specifics.** Write skills as if a stranger will read them. No internal policies, client names, private URLs, infra details, or credentials in skill text, examples, or prompts.
5. **Don't commit or push on your own.** Make changes and propose them; the repo owner commits.

## Where things live

- `.claude-plugin/marketplace.json`: the marketplace manifest (list of plugins).
- `plugins/egg-{name}/`: one plugin per skill, each with its own `README.md`.
- `.githooks/pre-commit`: secret scanner. Enable per clone with `git config core.hooksPath .githooks`.
- `CONTRIBUTING.md`: the full how-to for adding a skill. Follow it.

## Before you finish

Re-read hard rule #2. If you added or changed a skill, confirm the marketplace manifest and both READMEs reflect it.
