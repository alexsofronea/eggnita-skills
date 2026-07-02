#!/usr/bin/env bash
# harness run-checks — the pre-commit entry point. Runs every guardrail and fails
# the commit if any blocks. Self-contained: invoked by .git/hooks/pre-commit (and
# usable in CI). Each check operates on the staged diff from the repo root.
set -uo pipefail

here="$(cd "$(dirname "$0")" && pwd)"
root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$root" || exit 1

rc=0
bash "$here/secret-scan.sh"      || rc=1   # block committed secrets
bash "$here/skip-guard.sh"       || rc=1   # block asserting -> skipped tests
bash "$here/coverage-ratchet.sh" || rc=1   # block coverage drops (opt-in)
exit "$rc"
