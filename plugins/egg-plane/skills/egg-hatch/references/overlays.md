# egg-hatch overlays

Two things layer on top of the module catalog: **product-type overlays** (extra items added when the survey names a type) and the **security overlay** (a cross-cutting mark, not a module).

## Product-type overlays

Added on top of the universal core and the kept modules once question 1 names the type. Each item defaults to high unless noted; the survey adjusts.

- **Mobile app**: Apple ($99/yr) + Google ($25) developer accounts; store listing + ASO (screenshots, keywords); privacy manifest and current target-API-level compliance; push notifications + crash reporting; a working demo login for reviewers. Build in review-time buffer (Apple 24–48h, Google 3–7 days).
- **Marketplace**: identity / KYC for the supply side; a documented dispute-resolution process + payment holds/escrow; two-sided (blind) reviews; seller onboarding + payout and 1099 tooling. *(KYC and trust-and-safety: security overlay)*
- **Developer tool / API**: API keys + self-serve signup; rate-limit budgets + visible quota headers; a versioning and deprecation policy; quickstart + reference docs + SDKs + changelog + status page.
- **E-commerce / DTC**: PCI-compliant hosted gateway; inventory sync; shipping zones/rates tested across regions; multistate sales-tax nexus; fulfilment / 3PL; a real test order before going live. *(PCI: security overlay)*
- **AI-native**: offline evals before every release + online evals after; a layered guardrail architecture against the OWASP LLM Top 10 (prompt injection, sensitive-data disclosure, excessive agency, system-prompt leakage); token/cost monitoring; compliance mapping to the EU AI Act / NIST AI RMF. *(guardrails: security overlay)*
- **B2B SaaS**: SSO/SAML + RBAC + an admin console; SOC 2 (Type 1 early in the enterprise motion, Type 2 later); DPAs/MSAs for enterprise contracts. *(SOC 2, access control: security overlay)*

## Security (a mandatory module, not an overlay)

Security is realised as a **module that egg-hatch always creates**, whatever the survey says (see the Security module in [modules.md](modules.md)). Every product is security-gated. Its items are floored at high or urgent and resist skipping: if the user tries to drop the module or de-prioritise a core control below its floor, egg-hatch **warns and keeps it** rather than silently complying.

The module covers these dimensions (some also live embedded in a domain module; tag those into Security as well so the whole surface is filterable in one place):

- **Application**: OWASP Top 10, authn/authz, input validation, security headers, rate limiting.
- **Supply chain**: dependency scanning (Dependabot/Renovate), CI actions pinned to commit SHAs, lockfiles, provenance.
- **Infrastructure**: WAF + rate limiting, least-privilege scoped tokens, a real secret store, no plaintext secrets.
- **Data / compliance**: encryption in transit and at rest, backups + tested restore, GDPR/CCPA handling.
- **Email integrity**: SPF + DKIM + DMARC anti-spoofing (lives in Domains & email).
- **Product-type**: PCI (e-commerce), KYC / trust-and-safety (marketplace), OWASP LLM Top 10 + guardrails (AI-native).
- **Agent surface**: secrets never in git or MCP configs (commit an example, gitignore the real one); scoped per-agent tokens; sandbox by default; explicit repo/secret/budget allowlists per agent; agent commits get the same scanning and gates as human commits; enforce with linters and hooks, not agent self-policing.

How egg-hatch applies it:

1. The Security module is always in the proposed set and cannot be cut.
2. Its core controls are floored at ≥ high (≥ urgent for auth, secrets, and PCI/KYC where the product warrants).
3. A security-relevant item that also belongs to a domain module is tagged into both, so it shows on the domain board and in Security.
4. If the user asks to skip or lower one, restate the risk in one line and keep it at its floor unless they explicitly override with a reason (recorded in the item's description).

This generalises Eggnita's own posture (secret-scanning pre-commit, opacity rules, guardrails) to any product egg-hatch scaffolds, and treats the agent surface as first-class because these projects are built by agents as well as humans.
