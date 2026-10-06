# Release a new blurb gem version

Repo: `blurb`. Owner: `#sre-comm` on Slack

## When this is needed

A merged change on `master` has to reach consuming applications, which install `blurb` from RubyGems (`gem 'blurb'`).

## Before you start

- Access: push access to `patterninc/blurb` (tags) and owner rights on the `blurb` gem at rubygems.org (`gem signin`). No AWS access is involved.
- Impact: consumers with an unpinned or `~>` constraint pick the version up on their next `bundle update`. Breaking changes need a minor bump and a `CHANGELOG.md` note.
- New resources: none; this repo has no infrastructure.

## Steps

1. Open a PR that bumps `spec.version` in `blurb.gemspec` and moves the `## [Unreleased]` entries in `CHANGELOG.md` under `## [X.Y.Z] - YYYY-MM-DD`; merge it once `Static Checks` passes.
2. Optional, against a test/sandbox profile only: `make test-live` with a `.env` holding `BLURB_CLIENT_ID`, `BLURB_CLIENT_SECRET`, `BLURB_REFRESH_TOKEN`, `BLURB_REGION`, `BLURB_PROFILE_ID`.
3. `git checkout master && git pull`
4. `bundle exec rake release` (from `bundler/gem_tasks` in `Rakefile`): builds `pkg/blurb-X.Y.Z.gem`, creates and pushes tag `vX.Y.Z`, and pushes the gem to rubygems.org.

## Verify

- `gem list blurb --remote --exact` shows `blurb (X.Y.Z)`.
- `git ls-remote --tags origin vX.Y.Z` returns the tag.

## Rollback

- RubyGems versions can't be replaced. Yank a broken version with `gem yank blurb -v X.Y.Z`, then release a fixed `X.Y.Z+1`.
