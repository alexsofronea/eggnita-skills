# Security

This repository may become public. Treat everything in it as if it already is.

## What never goes in this repo

- **Secrets:** API keys, tokens, passwords, private keys, certificates, `.env` files, service-account JSON, connection strings. The `.gitignore` blocks the common files and the pre-commit hook scans staged changes, but neither is a substitute for care.
- **Internal Eggnita specifics:** internal policies and processes, client or partner names, private URLs and endpoints, infrastructure details, org-chart or headcount specifics, anything that would tell an outsider how Eggnita runs internally.

Skills should be useful to anyone, with Eggnita's private context kept out. If a skill only makes sense with internal knowledge baked in, it doesn't belong here as-is; abstract it.

## Safety nets (not guarantees)

- **`.gitignore`** ignores common secret-bearing files.
- **`.githooks/pre-commit`** blocks commits whose staged changes match known secret patterns. Enable it with `git config core.hooksPath .githooks` (once per clone).

Both are backstops. The primary control is reviewing your own diffs before committing.

## If a secret gets committed

1. Treat it as compromised and rotate or revoke it at the source right away. Removing it from Git does **not** make it safe; assume it was seen.
2. Remove it from history (e.g. `git filter-repo` or BFG) if it was pushed, and force-push with the team's coordination.
3. Tell whoever owns the credential.

## Reporting

Found a leaked secret or a security concern in this repo? Contact the repo owner directly rather than opening a public issue.
