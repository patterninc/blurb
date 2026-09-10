# Engineering Best Practices Audit — blurb

| | |
|---|---|
| **Audit date** | 2026-09-10 |
| **Auditor** | Claude — gauge-repo skill |
| **Rubric version** | `item-credit-v1` — 2026-09-04 (`references/best-practices.md`) |

## Repo profile

`blurb` is a Ruby gem (library/SDK, published to RubyGems, currently `0.5.9` per `blurb.gemspec`) wrapping the Amazon Advertising API v2. It has no deployed service, no database, no browser or terminal UI, and no AWS footprint of its own — the artifact is a distributed package consumed by other applications. The codebase is small (~17 files under `lib/`) and flat, with an RSpec suite under `spec/` that exercises the **live** Amazon Advertising API using credentials supplied via `dotenv`/environment variables (`spec/spec_helper.rb` sleeps 1s between examples to avoid API throttling). CI is a single GitHub Actions workflow (`.github/workflows/ci.yml`) that checks out the repo and installs gems but contains **no test or lint step**; a stale `.travis.yml` also remains from the pre-Actions era. Local git history shows a single squashed commit by `patterninc-gha-runner`; the gemspec lists three historical authors and the repo is effectively dormant/maintenance-mode. A `backstage.yaml` catalog entry registers the repo in Backstage (CostCenter INFRA, owner `sre-comm`). The GitHub owner was verified as `patterninc` (`gh repo view` → `patterninc/blurb`), so Pattern's inherited Wiz and Toolsmith controls apply. An active org-level ruleset (`require-pr-review`) protects the default branch.

## Scorecard

| Metric | Value |
|--------|-------|
| **Critical gates** | **RED** |
| **Adjusted compliance** | **30.3%** |

Critical gates are RED: AGENTS.md (item 2) and required CI checks (item 16) are Gaps, and unit tests (23), integration tests (24), and reproducible builds (48) are Partial. Adjusted compliance is calculated independently:

`(8 Met + 0.5 × 4 Partial) / (49 total − 16 justified N/A) = 10 / 33 = 30.3%`

### Status totals

| Status | Items |
|--------|------:|
| Met | 8 |
| Partial | 4 |
| Gap | 21 |
| N/A | 16 |
| **Total** | **49** |

### Per-category breakdown

| Category | Met | Partial | Gap | N/A |
|----------|----:|--------:|----:|----:|
| Documentation & Context | 1 | 0 | 5 | 3 |
| Guardrails & Enforcement | 3 | 0 | 8 | 2 |
| Testing & Feedback Loops | 0 | 3 | 5 | 5 |
| Environment & Tooling | 4 | 1 | 2 | 6 |
| Agent dispatch | 0 | 0 | 1 | 0 |
| **Total** | **8** | **4** | **21** | **16** |

## Documentation & Context

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 1 | Skills / reusable prompt workflows | **Gap** | No `.claude/skills/`, `.claude/commands/`, or equivalent | Add a skill for the one recurring workflow this repo has (cutting and publishing a gem release). Low priority given dormancy. |
| 2 | AGENTS.md | **Gap** | No `AGENTS.md`, `CLAUDE.md`, or `.cursorrules` | Add `AGENTS.md` covering: Ruby version, `bin/setup`, how to run specs (and that they require live Amazon Advertising credentials via `.env`), release process, and code layout under `lib/blurb/`. |
| 3 | Architecture decision records | **Gap** | No `docs/adr/` or equivalent | Capture the few structural decisions (request/retry semantics in `lib/blurb/request.rb`, campaign-type code mapping in `lib/blurb/base_class.rb`) as short ADRs. Low priority. |
| 4 | Runbooks | **Not applicable** | — | Library with no operational surface; the only recurring task is gem release, which is standard `bundler/gem_tasks` (`Rakefile`). |
| 5 | API contract docs (OpenAPI / protobuf) | **Not applicable** | — | The repo consumes Amazon's third-party API; it owns no wire contract. Its public surface is Ruby classes documented in `README.md`. |
| 6 | README with setup & run instructions | **Met** | `README.md` — installation, credential acquisition walkthrough, refresh-token flow, and per-resource usage examples | — |
| 7 | Changelog with migration notes | **Gap** | No `CHANGELOG.md`; version history only visible in `blurb.gemspec` bumps | Published gem with breaking API-version changes (README notes the v2.0 migration) — add a changelog with upgrade notes per release. |
| 8 | On-call playbooks | **Not applicable** | — | Library; nothing is paged. Incidents surface in consuming applications. |
| 9 | CODEOWNERS | **Gap** | No `.github/CODEOWNERS`; `backstage.yaml` names owner `sre-comm` | The org ruleset already requires PR review; add a one-line CODEOWNERS pointing at the owning team so reviews auto-route. |

## Guardrails & Enforcement

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 10 | Linters | **Gap** | No `.rubocop.yml` or lint step anywhere | Add RuboCop with a minimal config and wire it into CI. |
| 11 | Formatters | **Gap** | No formatter config | Cover via RuboCop's layout cops (same change as item 10). |
| 12 | Type checking | **Gap** | No Sorbet/RBS | Optional RBS signatures for the public API (`Blurb`, `Client`, `Account`) would help agents and consumers; low priority for a dormant wrapper. |
| 13 | Pre-commit hooks | **Gap** | No `.pre-commit-config.yaml` or `.githooks/` | Add a pre-commit hook running RuboCop once it exists. Low priority. |
| 14 | Commit message conventions | **Gap** | No commitlint config; local history is a single squashed commit | Adopt Conventional Commits if changelog automation (item 7) is added; otherwise skip. Low priority. |
| 15 | Branch protection rules | **Met** | Org ruleset `require-pr-review` (active, `~DEFAULT_BRANCH`): `pull_request`, `non_fast_forward`, `deletion` rules | — |
| 16 | Required CI checks before merge | **Gap** | Ruleset has no `required_status_checks` rule, and `.github/workflows/ci.yml` installs gems but never runs the test suite | First make CI actually run tests (see items 23/25), then mark the job required on the default branch. |
| 17 | Dependency allow-lists / deny-lists | **Not applicable** | — | Three runtime dependencies (`rest-client`, `oauth2`, `activesupport`) on a dormant gem; a package allow-list is ceremony beyond this repo's scale. |
| 18 | License compliance scanning | **Gap** | No license-check job | Published MIT gem redistributing dependencies; a small CI license check is cheap insurance. Low priority. |
| 19 | Secret scanning | **Met** | Inherited Pattern Wiz policy (owner verified `patterninc`) | — |
| 20 | SAST / static analysis gates | **Met** | Inherited Pattern Wiz policy (owner verified `patterninc`) | — |
| 21 | Max complexity limits | **Gap** | No complexity enforcement | Enable RuboCop metrics cops with the same change as item 10. |
| 22 | Import boundary enforcement | **Not applicable** | — | Flat single-gem codebase (~17 files, one namespace); there are no architectural layers to police. |

## Testing & Feedback Loops

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 23 | Unit tests | **Partial** | 16 spec files under `spec/blurb/`, but every example calls the live Amazon API with real credentials (`spec/spec_helper.rb` sleeps 1s per example to dodge throttling) — there are no isolated unit tests, and nothing runs in CI | Stub HTTP with WebMock/VCR so the suite runs hermetically without credentials, then run it in CI. |
| 24 | Integration tests | **Partial** | The existing specs *are* integration tests against the real API, but they require a live advertising account/`.env` and are never executed in CI | Keep a credential-gated, tagged live-API suite for pre-release verification; document how to run it. |
| 25 | Snapshot / golden-file tests | **Gap** | No `testdata`/cassette fixtures | VCR cassettes double as golden files for request/response shapes — same work as item 23. |
| 26 | Contract tests (Pact) | **Not applicable** | — | The wire contract is owned by Amazon, a third party; consumer-driven contract testing has no counterpart to verify against. Recorded cassettes (item 25) pin the observed contract. |
| 27 | End-to-end tests (Playwright) | **Not applicable** | — | No UI of any kind; headless client library. |
| 28 | Visual regression tests | **Not applicable** | — | No visual surface. |
| 29 | Test coverage thresholds | **Gap** | No SimpleCov or CI coverage gate | Add SimpleCov with a modest threshold once the suite runs in CI. |
| 30 | Mutation testing | **Gap** | None | Only worthwhile after the suite is hermetic and CI-run; low priority. |
| 31 | Load / performance benchmarks | **Not applicable** | — | Client for a rate-limited third-party API; throughput is bounded by Amazon throttling, not this code. |
| 32 | Flaky test quarantine | **Gap** | No tagging/quarantine mechanism; live-API tests are inherently flaky | Tag live-API specs (e.g. `:live`) and exclude them from the default run — falls out of the item 23/24 split. |
| 33 | Structured CI output | **Partial** | `rspec_junit_formatter` is declared in `blurb.gemspec`, but CI has no test step so no JUnit output is ever produced | Emit JUnit XML from the CI rspec run once one exists. |
| 34 | Deterministic test fixtures | **Gap** | Specs depend on live account state and unseeded Faker data | VCR cassettes (item 23) make inputs and outputs fixed. |
| 35 | Smoke tests for deploys | **Not applicable** | — | Nothing is deployed; the artifact is a published gem. |

## Environment & Tooling

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 36 | Devcontainer config | **Gap** | No `.devcontainer/`; Ruby version disagrees across configs (CI 2.7.2, stale Travis 2.6.2, no `.ruby-version`) | Add a `.ruby-version` at minimum; a devcontainer is optional at this scale. |
| 37 | One-command setup | **Met** | `bin/setup` (bundle install); `bin/console` for an interactive session | — |
| 38 | Seed scripts for local databases | **Not applicable** | — | No database. |
| 39 | MCP servers for external tools | **Met** | Toolsmith-managed MCP access (owner verified `patterninc`) | — |
| 40 | Scoped secrets per environment | **Met** | Amazon credentials enter only via env vars/`dotenv` (`.env` gitignored per `.gitignore`); CI tokens held as GitHub Actions secrets (`ci.yml`); no deployment, so no per-environment split is needed | — |
| 41 | Preview environments per PR | **Not applicable** | — | Nothing to deploy. |
| 42 | Hot-reload / watch mode | **Not applicable** | — | Library with no runnable app; `bin/console` provides the interactive feedback loop appropriate to a gem this size. |
| 43 | Structured logging (JSON) | **Gap** | `lib/blurb/request.rb` logs via bare `puts` (`log` helper, lines 113–118) | Route through an injectable `Logger` so consuming apps control format/level; JSON structure is the consumer's concern, but `puts` pollutes consumers' stdout. |
| 44 | Observable traces and metrics | **Not applicable** | — | Instrumentation of production behavior belongs to consuming applications; the gem has no runtime of its own. |
| 45 | Feature flags with local overrides | **Not applicable** | — | Library; no runtime features to toggle. |
| 46 | Database migration tooling | **Not applicable** | — | No database. |
| 47 | Dependency update automation | **Met** | Org-wide Wiz for verified Pattern repos | — |
| 48 | Reproducible builds (lockfiles) | **Partial** | `Gemfile.lock` is gitignored; gemspec constraints are loose — `activesupport` is fully unpinned, so CI (`bundler-cache: true`) resolves a different graph over time | Commit `Gemfile.lock` (modern Bundler guidance, even for gems) and add an upper bound on `activesupport`. |

## Agent dispatch

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 49 | Agent-dispatch manifest | **Gap** | No `.agents/pattern-agents.json` | Add the manifest with `schema_version`, `github.repo` (`patterninc/blurb`), ClickUp list, Slack channel, and skills metadata. No `aws[]` needed — the repo has no AWS footprint. |

## Prioritized recommendations

1. **[M] Gap — required CI checks (16):** Add an `rspec` (and later RuboCop) step to `.github/workflows/ci.yml`, then make the job a required status check on the default branch via the ruleset. Blocked on recommendation 3 for the test step to be meaningful.
2. **[S] Gap — AGENTS.md (2):** Write `AGENTS.md` covering setup (`bin/setup`), the credential-dependent test suite and how to run it, Ruby version, release process, and layout of `lib/blurb/`.
3. **[M] Partial — unit tests (23):** Stub HTTP with WebMock/VCR so the spec suite runs hermetically without live Amazon credentials; remove the 1s inter-test sleep for stubbed runs.
4. **[M] Partial — integration tests (24):** Split live-API specs behind a `:live` tag gated on credentials; document the pre-release live run. (Also resolves flaky quarantine, item 32.)
5. **[S] Partial — reproducible builds (48):** Commit `Gemfile.lock`, add an upper bound to the `activesupport` dependency, and add a `.ruby-version` file (also narrows item 36).
6. **[S] Gap — agent-dispatch manifest (49):** Add `.agents/pattern-agents.json` with GitHub, ClickUp, Slack, and skills metadata.
7. **[S] Gap — changelog (7):** Add `CHANGELOG.md` with per-release upgrade notes, backfilling the v2.0 API migration note from the README.
8. **[M] Gap — linters/formatter/complexity (10, 11, 21):** Add RuboCop (lint + layout + metrics cops) and run it in CI.
9. **[S] Gap — CODEOWNERS (9):** Map the repo to `sre-comm` (per `backstage.yaml`) so the ruleset's required reviews auto-route.
10. **[S] Gap — coverage threshold (29):** Add SimpleCov with a starter threshold once CI runs the suite.
11. **[S] Gap — structured logging (43):** Replace the `puts`-based `log` helper in `lib/blurb/request.rb` with an injectable `Logger`.
12. **[S] Cleanup:** Delete the stale `.travis.yml` and the dead TravisCI badge/`iserve-products` homepage links in `README.md`/`blurb.gemspec`.

## Declined practices

| # | Practice | Rationale |
|---|----------|-----------|
| 4 | Runbooks | No operational surface; gem release is standard `bundler/gem_tasks`. |
| 5 | API contract docs | Consumes Amazon's third-party API; owns no wire contract. |
| 8 | On-call playbooks | Library — nothing is paged; incidents surface in consuming apps. |
| 17 | Dependency allow/deny lists | Three runtime dependencies on a dormant gem; policy ceremony beyond repo scale. |
| 22 | Import boundary enforcement | Flat ~17-file single namespace; no layers to police. |
| 26 | Contract tests | Contract is owned by a third party (Amazon); cassette fixtures pin the observed shape instead. |
| 27 | End-to-end tests | No UI; headless client library. |
| 28 | Visual regression tests | No visual surface. |
| 31 | Load/perf benchmarks | Throughput bounded by Amazon API throttling, not this code. |
| 35 | Smoke tests for deploys | Nothing deployed; artifact is a published gem. |
| 38 | Seed scripts | No database. |
| 41 | Preview environments | Nothing to deploy. |
| 42 | Hot-reload / watch mode | No runnable app; `bin/console` is the interactive loop for a gem this size. |
| 44 | Traces and metrics | No production runtime of its own; observability belongs to consumers. |
| 45 | Feature flags | Library; no runtime features to toggle. |
| 46 | Database migrations | No database. |

## Beyond the checklist

- `backstage.yaml` registers the repo in the Backstage catalog with cost-center, environment, and ownership labels — machine-readable ownership metadata most repos this size lack.
- Standard Bundler gem scaffold is intact and idiomatic: `bin/setup`, `bin/console`, `Rakefile` with `spec` as the default task, `.rspec` with documentation format.
- `rspec_junit_formatter` and `dotenv` are already declared as dev dependencies — the plumbing for structured CI output and credential hygiene exists even though CI doesn't use it yet.
- `.gitignore` proactively excludes `.env` and `.byebug_history`, keeping local credentials and debug artifacts out of history.
