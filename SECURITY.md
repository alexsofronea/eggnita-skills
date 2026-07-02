# Security

This repository is **public**. Everything in it, including full git history, is world-visible. Treat every commit accordingly.

## What never goes in this repo

- **Secrets:** API keys, tokens, passwords, private keys, certificates, `.env` files, service-account JSON, connection strings. The `.gitignore` blocks the common files and the pre-commit hook scans staged changes, but neither is a substitute for care.
- **Internal Eggnita specifics:** internal policies and processes, client or partner names, private URLs and endpoints, infrastructure details, org-chart or headcount specifics, anything that would tell an outsider how Eggnita runs internally.

Skills should be useful to anyone, with Eggnita's private context kept out. If a skill only makes sense with internal knowledge baked in, it doesn't belong here as-is; abstract it.

## Safety nets (not guarantees)

- **`.gitignore`** ignores common secret-bearing files.
- **`.harneala/hooks/secret-scan.sh`** blocks commits whose staged changes match known secret patterns. It runs as a git pre-commit hook installed by `/harneala:init feature` (once per clone). Extend its `PATTERNS` when you hit a secret shape it misses.

Both are backstops. The primary control is reviewing your own diffs before committing.

## If a secret gets committed

1. Treat it as compromised and rotate or revoke it at the source right away. Removing it from Git does **not** make it safe; assume it was seen.
2. Remove it from history (e.g. `git filter-repo` or BFG) if it was pushed, and force-push with the team's coordination.
3. Tell whoever owns the credential.

## Public-repo posture (applied)

The repo is public so any team member can install the skills without being added as a collaborator. What's in place:

- **`main` is protected** by an active ruleset (`protect-main`) that blocks force-pushes and branch deletion. Direct pushes to `main` still work; this is the light guard we chose. Outsiders have no write access, so their forks and PRs can never merge without a maintainer.
- **Issues stay enabled** for the team. On a public repo it's all-or-nothing (you can't restrict issue creation to the org), so leave them on and moderate rather than disabling.
- **Contributions are Eggnita-only.** README and CONTRIBUTING say so. GitHub can't stop an outsider from *opening* a PR or issue, so the plan is: close outside PRs unmerged, moderate outsider issues.

To re-apply the branch protection (e.g. on a fresh clone of the setup or after changes):

```bash
gh api -X POST repos/alexsofronea/eggnita-skills/rulesets \
  -H "Accept: application/vnd.github+json" \
  --input - <<'JSON'
{
  "name": "protect-main",
  "target": "branch",
  "enforcement": "active",
  "conditions": { "ref_name": { "include": ["~DEFAULT_BRANCH"], "exclude": [] } },
  "rules": [ { "type": "deletion" }, { "type": "non_fast_forward" } ]
}
JSON
```

Optional, if drive-by noise appears: temporarily limit interactions to collaborators (up to 6 months) with `gh api -X PUT repos/alexsofronea/eggnita-skills/interaction-limits -f limit=collaborators_only`.

Since history is now public, the "scrub before exposing" step already ran clean. Keep it in mind for anything that could accidentally add a secret later: the pre-commit scanner is the first line, your own diff review the second.

## Reporting

Found a leaked secret or a security concern in this repo? Contact the repo owner directly rather than opening a public issue.
