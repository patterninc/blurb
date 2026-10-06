# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow
[Semantic Versioning](https://semver.org/spec/v2.0.0.html). Conventional Commit
types map to sections: `feat` → Added, `fix` → Fixed, `refactor`/`perf` → Changed,
removals → Removed, `!`/`BREAKING CHANGE` → called out under Changed.

Entries before 0.5.9 were reconstructed from git tags and commit messages; older
releases (0.1.0–0.4.x) are summarised only by the upgrade note below.

## [Unreleased]

### Added

- Development tooling only (no change to the gem's runtime code): `AGENTS.md`, ADRs, RuboCop, pre-commit, hermetic unit specs with WebMock, SimpleCov gate, committed `Gemfile.lock`, `Makefile`, PR CI (`Static Checks`, `PR Hygiene`).

### Changed

- The default `rspec` run now executes only the hermetic specs in `spec/unit/`. The live Amazon Advertising API specs in `spec/blurb/` are tagged `:live` and run with `BLURB_LIVE=1` (`make test-live`).

## [0.5.9] - 2021-03-04

### Fixed

- `Blurb::Request#make_request` re-raises the original `RestClient` error when an error response has no body, instead of failing with `NoMethodError`.

## [0.5.8] - 2021-02-16

### Fixed

- Corrected the Faraday SSL version parameter passed by the OAuth client.

## [0.5.7] - 2021-02-11

### Fixed

- OAuth token requests specify the SSL version explicitly (`ssl: { version: :TLSv1 }` in `Blurb::Account`).

## [0.5.6] - 2021-01-05

### Added

- Request/response logging to stdout when `BLURB_LOGGING` is set.

## [0.5.5] - 2020-10-23

### Fixed

- Removed a stray `byebug` call.

## [0.5.4] - 2020-09-09

### Fixed

- Error classes load `blurb/errors/base_exception` (commit "fix: inherit base exeption"). Note: `FailedRequest`, `RequestThrottled` and `InvalidReportRequest` still subclass `StandardError`, not `Blurb::BaseException`.

## [0.5.2] - 2020-08-07

### Added

- Sponsored Brands search-term report.

## Upgrading to 0.2.0

0.2.0 moved the gem to v2.0 of the Amazon Advertising API. Request paths, payload
fields and responses follow the v2 API; code written against 0.1.x needs to be
checked against the v2 reference.

[Unreleased]: https://github.com/patterninc/blurb/compare/v0.5.9...HEAD
[0.5.9]: https://github.com/patterninc/blurb/compare/v0.5.8...v0.5.9
[0.5.8]: https://github.com/patterninc/blurb/compare/v0.5.7...v0.5.8
[0.5.7]: https://github.com/patterninc/blurb/compare/v0.5.6...v0.5.7
[0.5.6]: https://github.com/patterninc/blurb/compare/v0.5.5...v0.5.6
[0.5.5]: https://github.com/patterninc/blurb/compare/v0.5.4...v0.5.5
[0.5.4]: https://github.com/patterninc/blurb/compare/v0.5.3...v0.5.4
[0.5.2]: https://github.com/patterninc/blurb/compare/v0.5.1...v0.5.2
