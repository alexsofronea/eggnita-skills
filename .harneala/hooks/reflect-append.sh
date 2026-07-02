#!/usr/bin/env bash
# harneala home-2 reflect-append — a Stop hook scaffolded into a project at
# feature+ (ADR-0006/0009). When the agent finishes a run, this reads the session
# transcript for LEARNING markers — the convention the agent follows when
# something breaks ("LEARNING: <what broke> -> <rule to prevent it>") — and
# appends each new lesson to the project's learnings.md (the reflect loop's
# episodic memory). The home-1 loader reads it back next session.
#
# Advisory and best-effort (home-2, ADR-0006): it never creates learnings.md (so a
# never-/init'd or throwaway repo never gets a stray file), and any trouble —
# no python3, no transcript, no marker — is a clean no-op. Promotion of a lesson
# into a shared skill body stays a manual, human-gated step (ADR-0009).
set -uo pipefail

payload="$(cat 2>/dev/null || true)"
command -v python3 >/dev/null 2>&1 || exit 0   # no python3 → no-op (advisory)

# Resolve the project dir without the scope marker (ADR-0002): CLAUDE_PROJECT_DIR
# wins, else the Stop payload's cwd, else $PWD.
cwd="$(printf '%s' "$payload" | python3 -c '
import json, sys
try:
    print((json.load(sys.stdin).get("cwd") or ""))
except Exception:
    pass
' 2>/dev/null || true)"
project_dir="${CLAUDE_PROJECT_DIR:-${cwd:-$PWD}}"

learnings="$project_dir/learnings.md"
[ -f "$learnings" ] || exit 0   # never create — only append to an existing file

# Extract the transcript path from the Stop payload; bail cleanly if absent.
transcript="$(printf '%s' "$payload" | python3 -c '
import json, sys
try:
    print((json.load(sys.stdin).get("transcript_path") or ""))
except Exception:
    pass
' 2>/dev/null || true)"
[ -n "$transcript" ] && [ -f "$transcript" ] || exit 0

# Parse the JSONL transcript for assistant-emitted "LEARNING:" lines, dedupe
# against what learnings.md already records, and append the new lessons. Pure
# function of (transcript, learnings.md): re-running the same Stop is idempotent.
TRANSCRIPT="$transcript" LEARNINGS="$learnings" python3 <<'PY' 2>/dev/null || exit 0
import json, os, re

transcript = os.environ["TRANSCRIPT"]
learnings = os.environ["LEARNINGS"]
marker = re.compile(r"^\s*LEARNING:\s*(.+?)\s*$")

def texts_from(entry):
    msg = entry.get("message") or {}
    content = msg.get("content")
    if isinstance(content, str):
        yield content
    elif isinstance(content, list):
        for block in content:
            if isinstance(block, dict) and block.get("type") == "text":
                yield block.get("text", "") or ""

lessons = []
seen = set()
try:
    with open(transcript, "rb") as f:
        for raw in f:
            raw = raw.strip()
            if not raw:
                continue
            try:
                entry = json.loads(raw)
            except Exception:
                continue
            if entry.get("type") != "assistant":
                continue
            for text in texts_from(entry):
                for line in text.splitlines():
                    m = marker.match(line)
                    if m:
                        lesson = m.group(1).strip()
                        if lesson and lesson not in seen:
                            seen.add(lesson)
                            lessons.append(lesson)
except Exception:
    raise SystemExit(0)

if not lessons:
    raise SystemExit(0)

with open(learnings, "rb") as f:
    existing = f.read().decode("utf-8", "replace")

new = [l for l in lessons if l not in existing]
if not new:
    raise SystemExit(0)

with open(learnings, "a", encoding="utf-8") as f:
    if not existing.endswith("\n"):
        f.write("\n")
    for l in new:
        f.write("- " + l + "\n")
PY
exit 0
