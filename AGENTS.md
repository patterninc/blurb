# blurb

TODO(readiness): one paragraph — what this repo does (code and scripts), what it deploys or produces, and who depends on it.

## Layout

- `CODE_OF_CONDUCT.md` — TODO(readiness): purpose
- `Gemfile` — TODO(readiness): purpose
- `LICENSE.txt` — TODO(readiness): purpose
- `README.md` — TODO(readiness): purpose
- `Rakefile` — TODO(readiness): purpose
- `backstage.yaml` — TODO(readiness): purpose
- `bin/` — TODO(readiness): purpose
- `blurb.gemspec` — TODO(readiness): purpose
- `lib/` — TODO(readiness): purpose
- `spec/` — TODO(readiness): purpose

## Commands

| Command | What it does |
|---|---|
| `make bootstrap` | Install git hooks and linter plugins (versions in `.tool-versions`) |
| `make lint` | Every pre-commit hook on every file — what CI runs |
| `make test` | Unit tests |
| `make all` | Everything CI runs |

## Do not touch

- TODO(readiness): state backend, resources that must never be replaced, anything applied by hand.

## Agent tooling

- Decisions that must not be "simplified away" are in `docs/adr/`. Read them before refactoring.
- Repo skills live in `.claude/skills/`; dispatch metadata in `.agents/pattern-agents.json`.
- Commits and PR titles follow Conventional Commits (hook + `PR Hygiene` check).
- Owner: `#sre-comm` on Slack.
