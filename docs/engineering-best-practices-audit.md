# Engineering Best Practices Audit — blurb

| | |
|---|---|
| **Audit date** | 2026-10-06 |
| **Auditor** | Claude — gauge-repo skill |
| **Rubric version** | `item-credit-v1` — 2026-09-04 (`references/best-practices.md`) |
| **Audited ref** | `chore/ai-readiness-common-gaps` (PR #29) |

## Changes since last audit (2026-09-10, 30.3%)

- **Moved to Met:** 1 Skills, 2 AGENTS.md, 3 ADRs, 7 Changelog, 9 CODEOWNERS, 10 Linters, 11 Formatters, 12 Type checking, 13 Pre-commit, 14 Commit conventions, 18 License scanning, 21 Complexity, 23 Unit tests, 24 Integration tests, 25 Golden files, 29 Coverage, 32 Flaky quarantine, 33 Structured CI output, 34 Deterministic fixtures, 36 Devcontainer, 48 Lockfiles.
- **Runbooks (4) moved from N/A to Met:** the release runbook the last audit called standard `bundler/gem_tasks` now exists (`docs/runbooks/release-gem.md`), so the item is scored rather than declined.
- **Gap → Partial:** 16 Required CI checks (PR checks exist and pass, not yet required), 49 Agent-dispatch manifest (present; `clickup_list_id` unset).
- **Still Gap:** 30 Mutation testing, 43 Structured logging.

## Repo profile

`blurb` is a Ruby gem (library/SDK, published to RubyGems, `0.5.9` per `blurb.gemspec`) wrapping the Amazon Advertising API v2. It has no deployed service, no database, no browser or terminal UI, and no AWS footprint of its own: the artifact is a distributed package consumed by other applications. The codebase is small (~17 files under `lib/`, one namespace). Ruby is pinned to 2.7.8 (`.ruby-version`, `.tool-versions`, `.devcontainer/`). Hermetic unit specs live in `spec/unit/` (WebMock, JSON fixtures, golden payload files); live-API specs in `spec/blurb/` are tagged `:live` and need credentials. PR CI is `Static Checks` (pre-commit incl. RuboCop and Steep, rspec with SimpleCov, Trivy license scan, JUnit upload) and `PR Hygiene` (Conventional Commit titles); the legacy push workflow `.github/workflows/ci.yml` still only installs gems. History shows ~10 contributors over time; the repo is in maintenance mode and owned by SRE (`backstage.yaml` Owner `sre-comm`). The GitHub owner was verified as `patterninc` (`gh repo view` → `patterninc/blurb`, public), so Pattern's inherited Wiz and Toolsmith controls apply. The org ruleset `require-pr-review` protects the default branch `master`.

## Scorecard

| Metric | Value |
|--------|-------|
| **Critical gates** | **RED** |
| **Adjusted compliance** | **91.2%** |

Critical gates are RED only because required CI checks (item 16) is Partial: `Static Checks` and `PR Hygiene` run and pass on PRs, but no ruleset marks them required on `master`. Every other applicable gate (2, 6, 15, 19, 20, 23, 24, 40, 48) is Met. Adjusted compliance is calculated independently:

`(30 Met + 0.5 × 2 Partial) / (49 total − 15 justified N/A) = 31 / 34 = 91.2%`

### Status totals

| Status | Items |
|--------|------:|
| Met | 30 |
| Partial | 2 |
| Gap | 2 |
| N/A | 15 |
| **Total** | **49** |

### Per-category breakdown

| Category | Met | Partial | Gap | N/A |
|----------|----:|--------:|----:|----:|
| Documentation & Context | 7 | 0 | 0 | 2 |
| Guardrails & Enforcement | 10 | 1 | 0 | 2 |
| Testing & Feedback Loops | 7 | 0 | 1 | 5 |
| Environment & Tooling | 6 | 0 | 1 | 6 |
| Agent dispatch | 0 | 1 | 0 | 0 |
| **Total** | **30** | **2** | **2** | **15** |

## Documentation & Context

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 1 | Skills / reusable prompt workflows | **Met** | `.claude/skills/change-and-verify/SKILL.md` (change, verify, release flow), `.claude/skills/change-github-workflows/SKILL.md` | — |
| 2 | AGENTS.md | **Met** | `AGENTS.md` (layout, commands, do-not-touch, agent tooling); `CLAUDE.md` is a symlink to it | — |
| 3 | Architecture decision records | **Met** | `docs/adr/0001`–`0003` (request path and key casing, campaign-type URL codes) with index `docs/adr/README.md` | ADRs 0002/0003 are `Proposed — owner to confirm`; the owner should accept or correct them. |
| 4 | Runbooks | **Met** | `docs/runbooks/release-gem.md` (release, verify, yank/rollback), indexed in `docs/runbooks/README.md` | — |
| 5 | API contract docs (OpenAPI / protobuf) | **Not applicable** | — | The repo consumes Amazon's third-party API; it owns no wire contract. Its public surface is Ruby classes, now typed in `sig/blurb.rbs`. |
| 6 | README with setup & run instructions | **Met** | `README.md` — installation, credential walkthrough, refresh-token flow, per-resource usage | The Travis badge, `iserve-products` links and `.env` variable names in "Development" are stale; fix them after PR #26 lands. |
| 7 | Changelog with migration notes | **Met** | `CHANGELOG.md` (Keep a Changelog, v0.5.2–v0.5.9 plus `Unreleased`, upgrade notes) | — |
| 8 | On-call playbooks | **Not applicable** | — | Library; nothing is paged. Incidents surface in consuming applications. |
| 9 | CODEOWNERS | **Met** | `.github/CODEOWNERS`: `* @patterninc/sre` (backstage Owner `sre-comm`) | — |

## Guardrails & Enforcement

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 10 | Linters | **Met** | `.rubocop.yml` (RuboCop 1.50, `NewCops: enable`), run by the `rubocop` pre-commit hook in `Static Checks`; existing offenses frozen per file in `.rubocop_todo.yml` | Pay the todo down in small PRs. |
| 11 | Formatters | **Met** | RuboCop layout cops (`make fmt`), `end-of-file-fixer` / `trailing-whitespace` hooks | — |
| 12 | Type checking | **Met** | `sig/blurb.rbs` (public API), `sig/vendor.rbs` (dependency stubs), `Steepfile`; `steep check` runs as a pre-commit hook in `Static Checks` and as `make typecheck` | Two diagnostics are downgraded to information for the known positional-hash call in `RequestCollection#execute_bulk_request`; restore them when that is fixed. |
| 13 | Pre-commit hooks | **Met** | `.pre-commit-config.yaml` (hygiene, RuboCop, Steep, Conventional Commits); `make bootstrap` installs them | — |
| 14 | Commit message conventions | **Met** | `conventional-pre-commit` on `commit-msg`; `.github/workflows/pr-hygiene.yml` checks PR titles | — |
| 15 | Branch protection rules | **Met** | Org ruleset `require-pr-review` on `~DEFAULT_BRANCH`: `pull_request`, `non_fast_forward`, `deletion` | — |
| 16 | Required CI checks before merge | **Partial** | `Static Checks` and `PR Hygiene` run on every PR and pass, but no ruleset has a `required_status_checks` rule for `master` | An admin applies a repo ruleset requiring `Static Checks` and `PR Hygiene` on `master` (`set-branch-rules.sh` dry run is ready). |
| 17 | Dependency allow-lists / deny-lists | **Not applicable** | — | Three runtime dependencies on a maintenance-mode gem; a package allow-list is ceremony beyond this repo's scale. |
| 18 | License compliance scanning | **Met** | Trivy `--scanners license` over `vendor/bundle` in `Static Checks`; one documented ignore in `.trivyignore.yaml` (diff-lcs, dev-only, also MIT) | — |
| 19 | Secret scanning | **Met** | Inherited Pattern Wiz policy (owner verified `patterninc`); `Wiz Secret Scanner` reports on PRs | — |
| 20 | SAST / static analysis gates | **Met** | Inherited Pattern Wiz policy (owner verified `patterninc`); `Wiz SAST Scanner` reports on PRs | — |
| 21 | Max complexity limits | **Met** | `Metrics/CyclomaticComplexity`, `PerceivedComplexity`, `MethodLength` enabled at defaults in `.rubocop.yml`; existing violators listed in `.rubocop_todo.yml` | — |
| 22 | Import boundary enforcement | **Not applicable** | — | Flat single-gem codebase (~17 files, one namespace); there are no layers to police. |

## Testing & Feedback Loops

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 23 | Unit tests | **Met** | `spec/unit/` (24 examples): request key casing, error mapping, 307 downloads, URL shapes, bulk splitting, account token flow; WebMock blocks real HTTP; run by `make test` in `Static Checks` | — |
| 24 | Integration tests | **Met** | Live-API specs in `spec/blurb/` tagged `:live`, run with `make test-live` (`BLURB_LIVE=1`); documented in `AGENTS.md` and `docs/runbooks/release-gem.md` as the pre-release check | Credential-gated by design; never run in PR CI. |
| 25 | Snapshot / golden-file tests | **Met** | `spec/unit/golden_payloads_spec.rb` compares the exact JSON sent for sp/hsa/sd report creates and history retrieve with `spec/fixtures/golden/*.json`; `UPDATE_GOLDEN=1` regenerates | — |
| 26 | Contract tests (Pact) | **Not applicable** | — | The wire contract is owned by Amazon; consumer-driven contract testing has no provider to verify against. Golden payloads (item 25) pin the observed contract. |
| 27 | End-to-end tests (Playwright) | **Not applicable** | — | No UI of any kind; headless client library. |
| 28 | Visual regression tests | **Not applicable** | — | No visual surface. |
| 29 | Test coverage thresholds | **Met** | SimpleCov `minimum_coverage 82` in `spec/spec_helper.rb` (current 82.66%), enforced by `make test` in CI | — |
| 30 | Mutation testing | **Gap** | None | Add `mutant-rspec` scoped to `Blurb::Request` after the Ruby 3 upgrade: current mutant needs Ruby >= 3.0, and the last 2.7-compatible release (0.11.25) needs `parser ~> 3.2.2`, which conflicts with RuboCop 1.50's `rubocop-ast`. |
| 31 | Load / performance benchmarks | **Not applicable** | — | Client for a rate-limited third-party API; throughput is bounded by Amazon throttling, not this code. |
| 32 | Flaky test quarantine | **Met** | Live, inherently flaky specs are tagged `:live` by path in `spec/spec_helper.rb` and excluded from the default and CI run | — |
| 33 | Structured CI output | **Met** | `make test` writes `rspec-junit.xml` (`RspecJunitFormatter`); `Static Checks` uploads `**/*-junit.xml` | — |
| 34 | Deterministic test fixtures | **Met** | `spec/fixtures/*.json` payloads and fixed dates/IDs in unit specs; no unit spec reads live state or unseeded Faker | — |
| 35 | Smoke tests for deploys | **Not applicable** | — | Nothing is deployed; the artifact is a published gem. |

## Environment & Tooling

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 36 | Devcontainer config | **Met** | `.devcontainer/devcontainer.json` (Ruby 2.7.8, Python, gh; `make bootstrap`); `.ruby-version`, `.tool-versions` | — |
| 37 | One-command setup | **Met** | `make bootstrap` (gems + hooks); `make all` runs everything CI runs; `bin/setup`, `bin/console` | — |
| 38 | Seed scripts for local databases | **Not applicable** | — | No database. |
| 39 | MCP servers for external tools | **Met** | Toolsmith-managed MCP access (owner verified `patterninc`) | — |
| 40 | Scoped secrets per environment | **Met** | Amazon credentials only via `BLURB_*` env vars / gitignored `.env`; PR workflows use no secrets beyond `GITHUB_TOKEN`; nothing is deployed | The legacy `ci.yml` passes unrelated `RUBY_GEM_BUNDLE_TOKEN` / `SIDEKIQ_ENTERPRISE_TOKEN`; drop them when that workflow is retired. |
| 41 | Preview environments per PR | **Not applicable** | — | Nothing to deploy. |
| 42 | Hot-reload / watch mode | **Not applicable** | — | Library with no runnable app; `bin/console` is the interactive loop for a gem this size. |
| 43 | Structured logging (JSON) | **Gap** | `lib/blurb/request.rb` `log` helper prints with `puts` when `BLURB_LOGGING` is set | Replace it with an injectable `Logger` so consuming apps control format and level. Runtime behaviour change: needs the owner. |
| 44 | Observable traces and metrics | **Not applicable** | — | Instrumentation belongs to consuming applications; the gem has no runtime of its own. |
| 45 | Feature flags with local overrides | **Not applicable** | — | Library; no runtime features to toggle. |
| 46 | Database migration tooling | **Not applicable** | — | No database. |
| 47 | Dependency update automation | **Met** | Org-wide Wiz for verified Pattern repos | — |
| 48 | Reproducible builds (lockfiles) | **Met** | `Gemfile.lock` committed for linux/darwin x86_64 and arm64; Ruby pinned in `.ruby-version`; CI installs from the lock (`bundler-cache`) | An upper bound on the runtime `activesupport` dependency would protect consumers; it changes their resolution, so it is an owner decision. |

## Agent dispatch

| # | Practice | Status | Evidence | Recommendation / rationale |
|---|----------|--------|----------|----------------------------|
| 49 | Agent-dispatch manifest | **Partial** | `.agents/pattern-agents.json` has `schema_version`, `github.repo`, `slack_channel`, `datadog`, `skills.plugins`; no `aws[]` needed (no AWS footprint). `clickup_list_id` is not set | The owner names the ClickUp list for this repo; add it as `clickup_list_id`. |

## Prioritized recommendations

1. **[S] Partial — required CI checks (16):** An admin adds a repo ruleset requiring `Static Checks` and `PR Hygiene` on `master` (both have reported on PR #29).
2. **[S] Gap — structured logging (43):** Replace the `puts`-based `log` in `lib/blurb/request.rb` with an injectable `Logger` (minor version bump, `CHANGELOG.md` note).
3. **[M] Gap — mutation testing (30):** After moving the gem to Ruby 3.x, add `mutant-rspec` scoped to `Blurb::Request` and run it incrementally (`--since master`) in CI.
4. **[S] Partial — agent-dispatch manifest (49):** Set `clickup_list_id` in `.agents/pattern-agents.json` once the owner names the list; confirm or drop the default `datadog` fields.

## Declined practices

| # | Practice | Rationale |
|---|----------|-----------|
| 5 | API contract docs | Consumes Amazon's third-party API; owns no wire contract. |
| 8 | On-call playbooks | Library — nothing is paged; incidents surface in consuming apps. |
| 17 | Dependency allow/deny lists | Three runtime dependencies on a maintenance-mode gem; policy ceremony beyond repo scale. |
| 22 | Import boundary enforcement | Flat ~17-file single namespace; no layers to police. |
| 26 | Contract tests | Contract is owned by a third party (Amazon); golden payload files pin the observed shape instead. |
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

- `backstage.yaml` registers the repo in the Backstage catalog with cost-center, environment and ownership labels.
- The RBS signatures in `sig/` ship with the gem, so consuming apps that use Steep get types for `Blurb` without a separate collection entry.
- `.rubocop_todo.yml` is exclude-only (no raised `Max`), so new code meets RuboCop defaults while old offenses are paid down file by file.
- `.trivyignore.yaml` records why its one license exception is acceptable, next to the rule.
- The unit specs found two real load-order bugs (ActiveSupport >= 7.1 and `present?` outside Rails), fixed by require-only changes in `lib/blurb/request.rb`.
