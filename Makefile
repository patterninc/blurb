# One-command setup and checks (item 37). Added by closing-ai-readiness-gaps.
# `make all` is what CI runs. None of these targets touch AWS.

.PHONY: help bootstrap fmt lint typecheck validate test test-live all

help: ## List targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-12s\033[0m %s\n", $$1, $$2}'

bootstrap: ## Install gems and git hooks (Ruby version: .ruby-version / .tool-versions)
	bundle install
	@command -v pre-commit >/dev/null || pipx install pre-commit 2>/dev/null || python3 -m pip install --user pre-commit
	pre-commit install --install-hooks

fmt: ## Apply formatters to every file (RuboCop layout cops)
	bundle exec rubocop --autocorrect --only Layout

lint: ## Run every pre-commit hook on every file (format check, lint, validate)
	pre-commit run --all-files --show-diff-on-failure

typecheck: ## Type-check lib/ against sig/*.rbs with Steep (also a pre-commit hook)
	bundle exec steep check

test: ## Hermetic unit specs (WebMock, no credentials) with coverage gate; writes rspec-junit.xml
	bundle exec rspec --format progress --format RspecJunitFormatter --out rspec-junit.xml

test-live: ## Live Amazon Advertising API specs (needs .env credentials; creates real resources)
	BLURB_LIVE=1 bundle exec rspec

all: lint test ## Everything CI runs
