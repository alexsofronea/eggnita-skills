# Eggnita Skills

Shared [Claude Code](https://claude.com/claude-code) skills for the Eggnita team, packaged so anyone can install them in a couple of commands and pull the latest with one more.

This repo is a **Claude Code plugin marketplace**. Each skill ships as its own plugin named `egg-{name}`, lives in its own folder under `plugins/`, and carries its own documentation.

## What's inside

| Plugin | What it does |
|--------|--------------|
| _(none yet)_ | The first skill is on its way. This table updates as skills land. |

## Requirements

- [Claude Code](https://claude.com/claude-code) installed and working.
- Git.
- Whatever a given skill needs. Each plugin's own README lists its extra requirements, if any.

## Install

Add this marketplace once, then install the skills you want by name.

```bash
# 1. Register the marketplace (one time)
/plugin marketplace add alexsofronea/eggnita-skills

# 2. Install a skill
/plugin install egg-<name>
```

Run these inside Claude Code. After installing, the skill is available in your sessions.

## Update

Skills here track the latest on `main`; there's no version number to manage. To pull the newest skills and updates:

```bash
# Refresh the marketplace listing
/plugin marketplace update eggnita-skills

# Update an installed skill to the latest
/plugin update egg-<name>
```

## Use

Once a plugin is installed, its skill activates the way any Claude Code skill does. Claude picks it up when your request matches what the skill is for, or you invoke it by name. Each plugin's README explains what it's for and how to trigger it.

## Contributing

These are Eggnita's internal tools. The repo may be public so anyone can read and install the skills, but **contributions are Eggnita-only**; outside pull requests and issues won't be accepted.

If you're on the Eggnita team, read [CONTRIBUTING.md](CONTRIBUTING.md) first. It covers the `egg-{name}` convention, the folder layout, how to register a new plugin in the marketplace, and the rule that documentation ships in the same change as the code.

## Security

This repo may become public. Never commit secrets, and keep internal Eggnita specifics out of skills. A pre-commit hook scans for secrets as a safety net. See [SECURITY.md](SECURITY.md).
