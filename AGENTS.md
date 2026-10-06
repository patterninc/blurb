# blurb

Ruby gem (`blurb`, version in `blurb.gemspec`, currently 0.5.9) that wraps the Amazon Advertising API v2 (Sponsored Products, Sponsored Brands, Sponsored Display). It deploys nothing and has no AWS footprint; the artifact is the published gem, consumed by other Pattern Ruby applications that pass it Amazon Advertising credentials. Owner: SRE (`sre-comm` in `backstage.yaml`).

## Layout

- `lib/blurb.rb` — entry point. `Blurb.new(client_id:, client_secret:, refresh_token:, region:, profile_id:)`; every argument defaults to a `BLURB_*` env var.
- `lib/blurb/account.rb` — OAuth refresh-token exchange (`retrieve_token`, refreshed after 1 hour) and the region → API host map (`API_URLS`: `TEST`, `NA`, `EU`, `FE`).
- `lib/blurb/profile.rb` — one advertising profile; builds the `RequestCollection*` objects for campaigns, ad groups, keywords, reports, snapshots, etc.
- `lib/blurb/request.rb` — the single HTTP path (`rest-client`). Camel-cases request keys, snake-cases response keys, maps HTTP errors to `lib/blurb/errors/*`. See `docs/adr/0002-*`.
- `lib/blurb/request_collection*.rb` — generic list/retrieve/create/update/delete over a resource URL; `RequestCollectionWithCampaignType` adds the `sp`/`hsa`/`sd` path segment. See `docs/adr/0003-*`.
- `lib/blurb/*_requests.rb` — endpoint-specific collections (reports, snapshots, history, suggested keywords).
- `lib/blurb/errors/` — `FailedRequest`, `RequestThrottled`, `InvalidReportRequest` (all inherit `BaseException`).
- `spec/unit/` — hermetic unit specs; HTTP stubbed with WebMock, payloads in `spec/fixtures/`. Run by `make test` and CI.
- `spec/blurb/` — live-API integration specs (tagged `:live`); they call the real Amazon Advertising API and are excluded unless `BLURB_LIVE=1`.
- `bin/setup`, `bin/console` — `bundle install`; an IRB session with the gem loaded.
- `backstage.yaml` — Backstage catalog entry (owner, cost center).
- `.travis.yml` — stale, Travis no longer runs; `.github/workflows/ci.yml` is the legacy push workflow (installs gems only).

## Commands

| Command | What it does |
|---|---|
| `make bootstrap` | `bundle install` plus git hooks (Ruby version in `.ruby-version` / `.tool-versions`) |
| `make lint` | Every pre-commit hook on every file, including RuboCop — what CI runs |
| `make test` | Hermetic unit specs and golden payload files (`spec/fixtures/golden/`, regenerate with `UPDATE_GOLDEN=1 make test`) with coverage gate; writes `rspec-junit.xml` |
| `make test-live` | Live-API specs; needs a `.env` with `BLURB_CLIENT_ID`, `BLURB_CLIENT_SECRET`, `BLURB_REFRESH_TOKEN`, `BLURB_REGION`, `BLURB_PROFILE_ID` |
| `make all` | Everything CI runs |

## Do not touch

- Never commit `.env` or any Amazon Advertising credential, refresh token or profile ID. `.env` is gitignored.
- Don't run `make test-live` against a production advertising profile: the live specs create campaigns, keywords and reports. Use the `TEST` region or a sandbox profile.
- The public API (`Blurb`, `Blurb::Profile` collections, error classes) is consumed by other apps. Renaming a method, changing key casing or an exception class is a breaking change: bump the minor version and note it in `CHANGELOG.md`.
- `bundle exec rake release` publishes to RubyGems; only run it when asked.
- RuboCop offenses that predate the linter are listed in `.rubocop_todo.yml`; fix them in their own PR, don't regenerate the file to hide new ones.

## Agent tooling

- Decisions that must not be "simplified away" are in `docs/adr/`. Read them before refactoring.
- Repo skills live in `.claude/skills/`; dispatch metadata in `.agents/pattern-agents.json`.
- Commits and PR titles follow Conventional Commits (hook + `PR Hygiene` check).
- Owner: `#sre-comm` on Slack.
