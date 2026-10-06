# 0002. Route every API call through `Blurb::Request`, which owns key casing and error mapping

- **Status:** Proposed — owner to confirm
- **Date:** 2026-10-06

## Context

The Amazon Advertising API speaks camelCase JSON (`campaignId`, `startDate`) and signals throttling, report-not-ready and redirect-to-download through HTTP status codes. Ruby callers want snake_case symbols and typed exceptions. Without one place that does this, each collection would convert keys and rescue `RestClient` errors its own way, and consumers would see inconsistent hashes and exceptions.

## Decision

`lib/blurb/request.rb` is the only code that talks HTTP:

- Request payloads and query params are camel-cased (`camelcase_keys`), except keys that are already all upper case, which pass through. `Date`/`Time`/`ActiveSupport::TimeWithZone` values are formatted as `YYYYMMDD`.
- Responses are JSON-parsed and every key becomes a snake_case **symbol** (`underscore_keys`).
- `429` raises `Blurb::RequestThrottled`; `406` on a report URL raises `Blurb::InvalidReportRequest`; any other error response raises `Blurb::FailedRequest` with the parsed body. A `307` is followed with a plain `GET` and returned **unparsed** — that is how report and snapshot downloads work.
- `GET` requests set `max_redirects: 0` so the `307` reaches the rescue above.

`RequestCollection`, `Account` and the `*_requests.rb` classes only build URLs, headers and payloads and call `Request#make_request`.

## Consequences

- Consumers rely on symbol keys and on these exception classes; changing either is a breaking change (minor version bump plus a `CHANGELOG.md` note).
- Don't "simplify" by removing `max_redirects: 0` or the `TemporaryRedirect` rescue: report downloads would then be JSON-parsed and fail.
- Unit specs in `spec/unit/request_spec.rb` pin this behaviour with WebMock stubs.
