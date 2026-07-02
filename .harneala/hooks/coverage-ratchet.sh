#!/usr/bin/env bash
# harness coverage-ratchet — half of the test-ratchet. Block a commit that lowers
# coverage below a committed baseline. Opt-in and language-agnostic:
#
#   .harneala/coverage-cmd        a script that prints the current coverage number
#   .harneala/coverage-baseline   the floor, a number (e.g. 85 or 85.3)
#
# If no coverage-cmd exists the check no-ops (the rest of the ratchet still runs);
# if no baseline exists it no-ops with a hint to record one. Self-contained: only
# awk + the repo's own coverage command.
#
# Usage: coverage-ratchet.sh   (run from the repo root)
# Exit 0 = ok / not configured; exit 1 = coverage dropped below the baseline.
set -uo pipefail

CMD=".harneala/coverage-cmd"
BASE=".harneala/coverage-baseline"

num() { printf '%s' "$1" | tr -dc '0-9.'; }   # keep digits + dot

main() {
  # Unconfigured is the common default — stay silent so it isn't noise on every commit.
  [ -f "$CMD" ] || return 0
  if [ ! -f "$BASE" ]; then
    echo "harness: coverage-ratchet skipped — no $BASE; record one to start ratcheting." >&2
    return 0
  fi
  local current baseline
  current="$(num "$(bash "$CMD" 2>/dev/null)")"
  baseline="$(num "$(cat "$BASE")")"
  if [ -z "$current" ]; then
    echo "harness: coverage-ratchet — coverage command produced no number; not blocking." >&2
    return 0
  fi
  if awk "BEGIN { exit !($current < $baseline) }"; then
    echo "harness: blocked — coverage $current% is below the baseline $baseline%." >&2
    echo "         tests ratchet up, never down. Raise coverage or update $BASE with sign-off." >&2
    return 1
  fi
  return 0
}

main "$@"
