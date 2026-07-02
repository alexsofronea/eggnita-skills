# Security

This repository may become public. Treat everything in it as if it already is.

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

## Going public: the checklist

While the repo is **private**, contributions are locked down by visibility alone: no outsider can see, fork, open issues, or open PRs. Branch protection also isn't available on a private repo under the free GitHub plan. So there's nothing to enforce until the day it flips public. Run this checklist at that moment.

1. **Scrub first.** Before flipping, re-read "What never goes in this repo" and skim the history for anything that shouldn't be seen once public: `git log -p | grep -iE 'secret|token|password|api[_-]?key'`. History is visible the instant the repo is public.

2. **Flip to public.**

   ```bash
   gh repo edit alexsofronea/eggnita-skills --visibility public --accept-visibility-change-consequences
   ```

3. **Protect `main` immediately.** This blocks force-pushes and branch deletion (it becomes free once public). Direct pushes to `main` still work; this is the light guard we chose.

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

4. **Set expectations on contributions.** These are internal tools; outside PRs and issues won't be merged or actioned. The README and CONTRIBUTING already say so. GitHub can't stop outsiders from *opening* PRs/issues on a public repo, so plan to triage:
   - Close outside PRs unmerged. `main` protection guarantees nothing lands without a maintainer.
   - Moderate outsider issues. To dampen drive-by noise, temporarily limit interactions (up to 6 months): `gh api -X PUT repos/alexsofronea/eggnita-skills/interaction-limits -f limit=collaborators_only`.

5. **Keep issues enabled** so the Eggnita team keeps using them. On a public repo it's all-or-nothing (can't restrict issue creation to the org), so leave them on and moderate rather than disabling.

## Reporting

Found a leaked secret or a security concern in this repo? Contact the repo owner directly rather than opening a public issue.
