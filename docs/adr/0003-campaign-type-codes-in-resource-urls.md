# 0003. Map campaign types to Amazon's URL codes in one table; Sponsored Display has no `/v2` prefix

- **Status:** Proposed — owner to confirm
- **Date:** 2026-10-06

## Context

`Blurb::Profile` (`lib/blurb/profile.rb`) picks campaign types by the keys `:sp`, `:sb` and `:sd`, but Amazon's URLs use `sp`, `hsa` (the legacy name for Sponsored Brands, "headline search ads") and `sd`. Sponsored Products and Brands live under `/v2/<type>/<resource>`, while Sponsored Display lives at `/sd/<resource>` with no version segment. Report list calls for Sponsored Display drop the `sd/` segment entirely.

## Decision

- `Blurb::BaseClass::CAMPAIGN_TYPE_CODES` (`lib/blurb/base_class.rb`) is the single map from caller names to URL codes; `sb` maps to `hsa`.
- `RequestCollectionWithCampaignType` (`lib/blurb/request_collection_with_campaign_type.rb`) builds `"#{base_url}/v2/#{type}/#{resource}"`, except for `sd`, which gets `"#{base_url}/sd/#{resource}"`.
- `RequestCollection#execute_request` removes `/sd/` from un-parameterised `GET` calls on `sd/reports` URLs.

## Consequences

- Don't "normalise" `hsa` to `sb` or add `/v2` for `sd`: both would send requests to URLs Amazon doesn't serve.
- New campaign types are added to `CAMPAIGN_TYPE_CODES` and, if their URL shape differs, to `RequestCollectionWithCampaignType`.
- `spec/unit/request_collection_spec.rb` pins the URL shapes.
