---
name: change-and-verify
description: Use when changing Ruby code in blurb (lib/blurb/**) and deciding how to verify the change before a PR, or when cutting a gem release.
---

# Changing code in blurb

1. Read `AGENTS.md` (layout, what must not change) and `docs/adr/` before touching `lib/blurb/request.rb`, `lib/blurb/base_class.rb` or `lib/blurb/request_collection*.rb`.
2. Make the change. Every HTTP call goes through `Blurb::Request` (ADR 0002); don't call `RestClient` elsewhere.
3. Add or update a hermetic spec in `spec/unit/` for the behaviour you changed. Stub HTTP with WebMock (`stub_request`) and keep payloads in `spec/fixtures/`. Never put real credentials, profile IDs or refresh tokens in fixtures.
4. `make all` must pass: RuboCop, every pre-commit hook, unit specs and the SimpleCov gate — exactly what CI runs. If coverage rises, raise `minimum_coverage` in `spec/spec_helper.rb`.
5. If the change alters the public API (method names, key casing, exception classes), it is breaking: say so in the PR and in `CHANGELOG.md`.
6. Open the PR with a Conventional Commit title (`feat: …`, `fix: …`) and add a line under `## [Unreleased]` in `CHANGELOG.md`.

## Live API check (optional, before a release)

`make test-live` runs `spec/blurb/` against the real Amazon Advertising API. It needs a `.env` with `BLURB_CLIENT_ID`, `BLURB_CLIENT_SECRET`, `BLURB_REFRESH_TOKEN`, `BLURB_REGION` and `BLURB_PROFILE_ID`, and it creates campaigns, keywords and reports. Only run it when the user asks, against a test/sandbox profile.

## Releasing a version (only when asked)

1. Bump `spec.version` in `blurb.gemspec` (semver; breaking → minor while < 1.0).
2. Move the `[Unreleased]` entries in `CHANGELOG.md` under the new version and date; update the compare links.
3. Merge via PR. Then, from an up-to-date default branch, `bundle exec rake release` tags `vX.Y.Z`, pushes the tag and publishes to RubyGems. It needs the owner's RubyGems credentials; don't run it without the user.
