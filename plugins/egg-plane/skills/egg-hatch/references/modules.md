# egg-hatch module catalog

The full domain set. The survey (see [survey.md](survey.md)) trims it to what fits the product and adjusts the suggested priorities. One Plane module per domain; items tagged in.

Each item shows a **default priority** (the starting suggestion) and, where relevant, a **gate** (the survey signal that keeps, drops, or raises it). Provider names are **examples, never defaults** (provider-neutrality): if the survey pinned a provider, write the task against it; otherwise the task body carries the examples and leaves the choice open. Items marked *(security …)* are floored and enforced, and also belong in the always-on **Security** module below.

Many universal-core items live here in their home module with fuller detail; [universal-core.md](universal-core.md) is the always-offer cross-cutting view. Items marked *(security)* also belong in the **Security** module below; tag them into both.

---

## Security (always created, never skipped)

Every product is security-gated. egg-hatch **always** creates this module, whatever the survey says, and floors its items at high or urgent. Some controls also live embedded in a domain module (email integrity in Domains & email, access control in Engineering); tag those into Security as well so the whole security surface is visible and filterable in one place.

- **Security baseline & threat model**: decide the posture, threat-model the product, name an owner. Default: high.
- **Secret management + scanning**: secrets in a store (never plaintext), pre-commit + CI secret scanning, push protection. e.g. gitleaks + a secret store. Default: high.
- **Dependency + supply-chain scanning**: Dependabot / Renovate, code scanning (e.g. CodeQL), CI actions pinned to commit SHAs, lockfiles. Default: high.
- **WAF + rate limiting** on auth and API. e.g. Cloudflare WAF / AWS WAF. Default: high.
- **Access control**: authn/authz, least privilege, RBAC, SSO/SAML for B2B. Default: high.
- **Data protection**: encryption in transit and at rest, backups + tested restore, disaster recovery. Default: high.
- **Email integrity**: SPF + DKIM + DMARC (also in Domains & email). Default: high.
- **Agent-surface guardrails**: secrets never in git or MCP configs, scoped per-agent tokens, sandbox by default, repo/secret/budget allowlists, and the same scans and gates on agent commits as human commits. Default: high.
- **Product-type security**: PCI (e-commerce), KYC / trust-and-safety (marketplace), OWASP LLM Top 10 + guardrails (AI-native). Default: high. Gate: the type applies.
- **Pre-launch vulnerability review / pentest**. Default: medium.
- **Incident response + rollback plan**: who is paged, how you roll back. Default: medium.

The survey can raise these (PCI to urgent for e-commerce) but never drops the module or floors the core controls below high. If the user asks to skip security, warn and keep it.

## 1. Foundation & legal

- **Legal entity / EIN / bank account**: the base before taking money or hiring. Default: low (usually already true for an org; skip if so).
- **Terms of Service**: the contract (liability limits, IP ownership, termination). Default: high.
- **Privacy Policy**: legally required the moment you collect any personal data; CCPA/CPRA require a refresh every 12 months. Default: high; **urgent** with personal data / EU users.
- **Cookie consent (CMP)**: block non-essential cookies until granular opt-in, with easy withdrawal (e.g. OneTrust / Cookiebot / Usercentrics). Default: high when gated; skip if no non-essential cookies. Gate: EU visitors + any analytics/marketing cookie.
- **DPA**: obtain from each vendor/subprocessor, and offer one to B2B customers (GDPR Art. 28). Default: medium. Gate: EU business customers.
- **Public subprocessors list**: EDPB-recommended, with a change-notification path. Default: low. Gate: B2B + EU.

## 2. Domains & email

- **Register domain + managed DNS**: anchors everything (e.g. Cloudflare / AWS Route 53 / Google Cloud DNS / Namecheap). Default: urgent.
- **Subdomain plan**: app., api., transactional (send./mail.), marketing (news./hello.), status., docs.; a separate domain for cold outreach. Default: high.
- **Transactional email** on its subdomain with SPF + DKIM + custom Return-Path (e.g. Resend / Postmark / Amazon SES / SendGrid). Default: high. *(security overlay: email integrity)*
- **DMARC** staged none → quarantine → reject, watching rua reports at each stage. Default: high. *(security overlay)*
- **Bounce/complaint webhooks + own suppression table**: protect reputation and never re-send to a hard-bounced or complained address. Default: high.
- **Marketing/lifecycle email** on the marketing subdomain, product events piped in async (e.g. Customer.io / Loops / Klaviyo / Mailchimp). Default: medium. Gate: doing lifecycle/newsletter.
- **Cold-outreach setup** on a SEPARATE domain with warmup (e.g. Instantly / Smartlead). Default: low; skip if not. Gate: running sales outreach.
- **Root-domain lockdown** (SPF `-all`, DMARC reject): stop spoofing of unused addresses. Default: medium. *(security overlay)*

## 3. Engineering foundation

- **Repo hygiene**: README, LICENSE, .gitignore (env files), Conventional Commits. Default: high.
- **Branch protection on main**: required review + required status checks. Default: high.
- **Pre-commit secret scan + host push protection** (e.g. gitleaks + GitHub push protection). Default: high. *(security overlay: supply chain)*
- **CI**: lint → typecheck → test → build, each a required check; pin third-party actions to commit SHAs (e.g. GitHub Actions / GitLab CI). Default: high. *(SHA pinning: security overlay)*
- **Environments**: per-PR preview + a stable staging with seeded data (e.g. Vercel / Cloudflare Pages / Netlify previews). Default: high.
- **Secrets in a platform secret store** + least-privilege scoped deploy tokens (e.g. Cloudflare / Vercel / Doppler / AWS Secrets Manager). Default: high. *(security overlay: infrastructure)*
- **Infrastructure-as-code**: e.g. Terraform / Pulumi / Wrangler for infra config. Default: low.
- **Error tracking** client + server: e.g. Sentry / Rollbar / Bugsnag. Default: high.
- **Structured logging + uptime/status monitoring + alerting**: e.g. Better Stack / UptimeRobot / Grafana. Default: high.
- **Testing**: static + integration first, a few e2e on critical journeys against staging (e.g. Vitest / Playwright). Default: medium.
- **Dependency updates + code scanning**: e.g. Dependabot / Renovate + CodeQL. Default: medium. *(security overlay: supply chain)*
- **WAF + rate limiting** on auth/API: e.g. Cloudflare WAF / AWS WAF. Default: medium. *(security overlay: infrastructure)*
- **Backups + tested restore** with a written RPO/RTO. Default: high. *(security overlay: data)*

## 4. Product analytics & feedback

- **Pick one product-analytics tool**: e.g. PostHog / GA4 / Amplitude. Default: high.
- **Event-naming convention doc** before any tracking code. Default: high.
- **Instrument signup / activation / core-conversion**, front + back. Default: high.
- **Feature flags** for safe rollouts: e.g. PostHog / LaunchDarkly / Flagsmith. Default: medium.
- **Session replay**. Default: low.
- **Define the activation metric** empirically from retention data. Default: low (post-launch).
- **In-product feedback + NPS**: e.g. Featurebase / Canny. Default: low. Gate: active users.
- **Separate GA4 for acquisition**. Default: low. Gate: running paid/organic.

## 5. Billing & payments

Gate: the product charges money. Skip the whole module if it never will.

- **Choose the model**: direct (e.g. Stripe) vs merchant-of-record (e.g. Paddle / Lemon Squeezy), by international-tax appetite. Default: high.
- **Products + Prices; hosted Checkout + Payment Element**. Default: high.
- **Customer Portal** (self-serve invoices, plan changes, cancellation). Default: medium.
- **Webhooks** for subscription/invoice events → sync access state. Default: high.
- **Dunning** (retries + failed-payment emails). Default: medium.
- **Tax**: Stripe Tax or a merchant-of-record. Default: high. Gate: selling into taxed jurisdictions.
- **Disclose the processor** in the privacy policy. Default: medium.
- **PCI**: use a hosted/tokenized gateway; never touch raw card data. Default: high. *(security overlay: product-type)*

## 6. Design system & brand

- **Logo + brand marks; favicon set; OG image template**. Default: medium.
- **Design tokens** in W3C DTCG format (Figma Variables → e.g. Style Dictionary / Terrazzo). Default: medium.
- **Minimal component library** (5–10 core components). Default: medium.
- **Figma Code Connect mappings**: design→code fidelity for agents. Default: low. Gate: Figma Org/Enterprise + design-heavy product.

## 7. SEO / AEO / GEO / LLM discoverability

Gate: the product has a public marketing site. Skip for purely internal tools with no public site.

**Foundational (do unconditionally):**

- **Google Search Console** register + verify (DNS TXT). Default: high.
- **Bing Webmaster Tools** register + verify (feeds Copilot, very likely ChatGPT search). Default: high.
- **IndexNow** for near-real-time crawl notice. Default: medium.
- **XML sitemap**: framework-native, or audit with e.g. Screaming Frog / Ahrefs / Sitebulb; 50k-URL / 50MB per file, index for larger. Default: high.
- **lastmod hygiene**: update only on real content change. Default: medium.
- **Sitemap in robots.txt + submit via console/API** (anonymous ping endpoints are dead). Default: medium.
- **Core Web Vitals (INP ≤200ms) + HTTPS + mobile + canonical + hreflang**. Default: high.
- **OpenGraph + X cards, favicon, OG image**. Default: medium.
- **Server-render or statically render primary content**: AI crawlers (GPTBot, ClaudeBot, PerplexityBot) do NOT run JavaScript. Default: high for AI visibility.

**Structured data (Schema.org JSON-LD):**

- **Core types**: Organization + sameAs, WebSite, BreadcrumbList, Product/Offer, Article, SoftwareApplication, Review/AggregateRating, Event, LocalBusiness (still earn rich results). Default: medium.
- **Don't expect rich results from FAQPage (retired 2026-05-07) or HowTo**: keep markup only as a cheap maybe-AI hint. Default: low.

**AI-crawler control (robots.txt):**

- **Deliberate per-crawler policy**: training bots (GPTBot, Google-Extended, Applebot-Extended, CCBot) are separate from retrieval/citation bots (OAI-SearchBot, ChatGPT-User, Claude-User, Claude-SearchBot, PerplexityBot). Allow the retrieval bots for AI visibility; default-disallow Bytespider (documented non-compliance). Default: medium.

**AEO / GEO (emerging; experiment, don't bet the roadmap):**

- **Structure content for extraction**: answer-first, clear headings, visible dates, factual density (~44% of LLM citations come from the first 30% of a page). Default: medium.
- **Add citations, statistics, quotations**: the one tactic with academic backing (+30–40% generative visibility). Default: medium.
- **Genuine brand consistency + earned mentions** (not astroturf). Default: low, rising to medium.
- **llms.txt**: near-zero real value today; add only as a near-free hedge / for AI coding-agent docs. Default: low.
- **Validate**: Rich Results Test + schema.org validator. Default: low.

## 8. Paid ads & acquisition

Gate: running paid ads. Skip if not. Create only the platforms that fit the product type.

**Shared measurement layer (build once, before any platform):**

- **Consent Management Platform**: e.g. OneTrust / Cookiebot / Usercentrics. Default: high.
- **Google Consent Mode v2** (EEA traffic); note the 2026-06-15 change making it the sole control for ad-cookie collection from linked GA4. Default: high.
- **Server-side collection point**: e.g. self-hosted server GTM / Stape / Meta CAPI Gateway, fanning out to each platform's server API. Default: high.
- **Shared event taxonomy + per-platform mapping**. Default: high.
- **Single UTM taxonomy** (source/medium/campaign required; lowercase, consistent). Default: high.
- **GA4 as the neutral cross-platform attribution ledger**. Default: high.
- **Shared event_id** threaded pixel ↔ server for dedup. Default: high.

**Per platform** (each: business account → ad account + billing → pixel/tag → server-side conversions API → verify a conversion → ready-to-spend gate). Create those that fit; default medium each:

- **Meta** (Pixel + Conversions API), **Google Ads** (tag + Enhanced Conversions; migrate uploads to Data Manager API before 2026-06-15), **LinkedIn** (Insight Tag + Conversions API), **Reddit** (Pixel + CAPI), **TikTok** (Pixel + Events API), **X** (Pixel/CAPI, test cautiously). Secondary: **Microsoft/Bing Ads**, **Pinterest**.

**Platforms by product type:** B2B → LinkedIn + Google Search; consumer → Meta + TikTok + Google/YouTube; developer/technical → Reddit + X + Google Search; e-commerce → Meta + Google PMax/Shopping + TikTok Shop; local → Google (local + Business Profile) + Meta.

Rationale note for task bodies: justify server-side tracking by iOS ATT / ITP / ad-blocker signal loss, **not** third-party-cookie deprecation (Chrome reversed that).

## 9. Support & comms

- **Support inbox/helpdesk**: e.g. Plain / Intercom / Front, by audience. Default: medium.
- **Public status page**: e.g. Instatus / Better Stack. Default: low, rising to medium. Gate: paying/dependent customers.
- **Changelog / release notes**. Default: low (post-launch).

## 10. Team & process

- **Board setup**: states, labels, cycles, issue/PR templates (egg-plane and egg-hatch do much of this already). Default: high.
- **Definition of Done**, team-authored. Default: medium.

## 11. Working instructions (human + agent)

- **README (setup-from-cold), CONTRIBUTING, onboarding doc**. Default: high.
- **Runbooks (command-first), ADR log** (e.g. MADR minimal). Default: medium.
- **AGENTS.md at root; CLAUDE.md as a thin `@AGENTS.md` import; .cursor/rules/*.mdc**. Default: high.
- **Project-scoped MCP config** with secrets externalised (commit an example, gitignore the real one). Default: medium. *(security overlay: agent surface)*
- **Agent guardrails**: repo/secret/budget allowlists per agent; sandbox by default; agent commits get the same scans and gates as human commits. Default: medium. *(security overlay: agent surface)*
