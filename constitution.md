# Constitution — eggnita-skills

Project invariants in **EARS** form (Easy Approach to Requirements Syntax). These starter rules
mirror the harness guardrails; edit and extend them — they are yours. Keep them true.

- The system SHALL NOT commit secrets, API keys, tokens, or credentials to version control.
- WHEN a change adds or modifies behavior, the system SHALL include a test that exercises it.
- WHILE a test suite exists, the suite SHALL pass before a commit is made.
- IF a change would reduce test coverage, THEN it SHALL NOT be committed without explicit approval.
- The system SHALL keep `AGENTS.md` and `README.md` consistent with what actually ships.
- WHEN a skill is added, it SHALL be a plugin named `egg-{name}` (lowercase, hyphenated) with its own `plugin.json` and `README.md` under `plugins/`.
- WHEN a skill is added, renamed, or changed, the same change SHALL update `.claude-plugin/marketplace.json` and the "What's inside" table in the root `README.md`.
- The system SHALL NOT include internal Eggnita specifics (internal policies, client or partner names, private URLs, infrastructure details, or credentials) in any skill's text, examples, or prompts.
