#!/usr/bin/env bash
# harness skip-guard — half of the test-ratchet. Block a commit that turns an
# asserting test into a skipped/disabled one. Deterministic and diff-based:
# it fires when the staged diff introduces MORE skip markers than it removes, so
# it()->it.skip() blocks while a pure reformat of an already-skipped test does not.
# Self-contained: only grep + git. Conservative by design — a brand-new skipped
# test also trips it (a no-op test should get a human's sign-off too).
#
# Usage: skip-guard.sh    (operates on git diff --cached in the current repo)
# Exit 0 = ok; exit 1 = a test was weakened to skipped.
set -uo pipefail

# Skip/disable markers across common test frameworks.
SKIP='\.skip\b|\.todo\b|\bxit\b|\bxdescribe\b|\bxtest\b|@pytest\.mark\.skip|@unittest\.skip|unittest\.skip|pytest\.skip\(|raise SkipTest|t\.Skip\(|@Disabled|@Ignore\b'

main() {
  local diff added removed
  # Exclude the harness's own hook scripts — their skip-marker patterns are
  # definitions, not skipped tests. Real test files live elsewhere and are scanned.
  diff="$(git diff --cached --no-color -U0 -- . ':(exclude).harneala/hooks' 2>/dev/null)"
  added="$(printf '%s\n' "$diff" | grep '^+' | grep -v '^+++' | grep -cE "$SKIP" || true)"
  removed="$(printf '%s\n' "$diff" | grep '^-' | grep -v '^---' | grep -cE "$SKIP" || true)"
  added=${added:-0}; removed=${removed:-0}
  if [ "$added" -gt "$removed" ]; then
    echo "harness: blocked — a test was changed to skipped/disabled (skip markers $removed -> $added)." >&2
    echo "         tests ratchet up, never down. Get explicit sign-off to skip a test." >&2
    return 1
  fi
  return 0
}

main "$@"
