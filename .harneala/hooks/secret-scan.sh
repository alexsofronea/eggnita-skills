#!/usr/bin/env bash
# harness secret-scan — block obvious committed secrets. Self-contained: depends
# only on grep + git, so it works in a git pre-commit even with no plugin loaded.
#
# Usage:
#   secret-scan.sh            scan the added lines of the staged diff (git diff --cached)
#   secret-scan.sh FILE...    scan the given files (used by tests)
#
# Exit 0 = clean; exit 1 = a likely secret was found (printed, redacted).
set -uo pipefail

# High-signal patterns chosen to minimise false positives. Extend in your repo.
# Eggnita extensions: ASIA (AWS temp keys), sk-ant- (Anthropic), sk- (OpenAI), JWTs.
PATTERNS='AKIA[0-9A-Z]{16}|ASIA[0-9A-Z]{16}|sk-ant-[A-Za-z0-9_-]{20,}|sk-[A-Za-z0-9]{20,}|eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.|-----BEGIN [A-Z ]*PRIVATE KEY-----|ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{20,}|xox[baprs]-[A-Za-z0-9-]{10,}|AIza[0-9A-Za-z_-]{35}|(password|passwd|secret|api[_-]?key|access[_-]?key|auth[_-]?token|token)["'"'"']?[[:space:]]*[:=][[:space:]]*["'"'"'][^"'"'"' ]{12,}["'"'"']'

main() {
  local found=0 text
  if [ "$#" -gt 0 ]; then
    text="$(cat "$@" 2>/dev/null)"
  else
    # Added ('+') lines of the staged diff (minus the '+'), excluding the harness's
    # own hook scripts, whose pattern strings would otherwise self-match.
    text="$(git diff --cached --no-color -U0 -- . ':(exclude).harneala/hooks' 2>/dev/null | grep '^+' | grep -v '^+++' | sed 's/^+//')"
  fi
  local hits
  hits="$(printf '%s\n' "$text" | grep -nEi "$PATTERNS" || true)"
  if [ -n "$hits" ]; then
    found=1
    echo "harness: blocked — possible secret(s) detected:" >&2
    # redact: show the line but mask the long run of secret-looking characters
    printf '%s\n' "$hits" | sed -E 's/[A-Za-z0-9_/+-]{12,}/***REDACTED***/g' >&2
  fi
  return "$found"
}

main "$@"
