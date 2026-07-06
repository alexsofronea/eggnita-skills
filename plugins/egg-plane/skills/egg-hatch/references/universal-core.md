# egg-hatch universal core

The items offered for essentially any product, regardless of distribution, access model, or complexity. egg-hatch always proposes these; it skips one only when an answer makes it genuinely inapplicable (transactional email or uptime for a fully offline local tool). Default priorities shown; the survey adjusts them. Provider examples are illustrative, never mandatory (provider-neutrality).

1. **Domain + DNS** on a managed DNS (e.g. Cloudflare / AWS Route 53 / Google Cloud DNS). **urgent**: anchors everything below.
2. **Authenticated transactional email** on its own subdomain with SPF + DKIM + DMARC (e.g. Resend / Postmark / Amazon SES). **high**: needed the moment the product sends signup, verify, reset, or receipt.
3. **Terms of Service + Privacy Policy** (plus cookie consent if any analytics/marketing cookie fires). **high**; **urgent** if collecting personal data or serving EU users.
4. **Auth + baseline security** (HTTPS, security headers, rate limiting on auth/API, sensible sessions and 2FA). **high**. *(security overlay)*
5. **Source control + branch protection + CI** (lint, typecheck, test, build as required checks on main). **high**.
6. **Secrets out of git + a secret store** (.gitignore, push protection / secret scan, e.g. Cloudflare / Vercel / Doppler secret store). **high**. *(security overlay)*
7. **A non-production environment** (per-PR preview and/or a stable staging with seeded data). **high**.
8. **Error tracking + uptime monitoring** with alerting (e.g. Sentry for errors, plus an uptime/status monitor). **high**.
9. **Product analytics with day-1 events**: signup, activation, core action; fix the event-naming convention first (e.g. PostHog / GA4 / Amplitude). **high**.
10. **A support channel** users can reach (a monitored inbox to start, e.g. Plain / Intercom later). **medium**.
11. **Backups with a tested restore** and a written RPO/RTO for the primary datastore. **high**. *(security overlay)*
12. **Working instructions, human + agent**: a README a stranger can set up from, and an AGENTS.md (with CLAUDE.md importing it) so coding agents share one source of truth. **high**.
13. **Task tracking + a Definition of Done**: the board and a shared "done" bar. **high**.

Items 2 and 8 flex: a purely offline or local product with no server and no sends can skip them. Items marked *(security overlay)* are floored and enforced (see [overlays.md](overlays.md)).
