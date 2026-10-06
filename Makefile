# One-command setup and checks (item 37). Added by closing-ai-readiness-gaps.
# `make all` is what CI runs. None of these targets touch AWS.

.PHONY: help bootstrap fmt lint validate test all

help: ## List targets
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-12s\033[0m %s\n", $$1, $$2}'

bootstrap: ## Install git hooks and linter plugins (toolchain versions: .tool-versions)
	@command -v pre-commit >/dev/null || pipx install pre-commit 2>/dev/null || python3 -m pip install --user pre-commit
	pre-commit install --install-hooks

fmt: ## Apply formatters to every file

lint: ## Run every pre-commit hook on every file (format check, lint, validate)
	pre-commit run --all-files --show-diff-on-failure

test: ## Unit tests

all: lint test ## Everything CI runs
