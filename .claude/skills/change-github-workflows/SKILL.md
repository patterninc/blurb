---
name: change-github-workflows
description: Use when adding or changing a GitHub Actions workflow in blurb (.github/workflows/*.yml), for example CI, terraform plan/apply, Docker build, ECS or Lambda deploy.
---

# Changing GitHub workflows in blurb

1. Load the `terraform:github-reusable-workflows` skill before you edit anything under `.github/workflows/`.
2. Check whether a reusable workflow in `patterninc/pattern-reusable-workflow` already covers the change: `terraform-ci-cd`, `ecs-deployment`, `docker-build-and-push`, `lambda-deploy`, `db-migrate`, `amplify-deployment` or `frontend-ci-checks`. If one does, call it rather than writing the steps inline.
3. Pin `uses:` to the latest release tag (`gh api repos/patterninc/pattern-reusable-workflow/tags --jq '.[0].name'`), never `@main`. Check the inputs and secrets at that tag, and pass secrets in an explicit `secrets:` block, never `secrets: inherit`.
4. AWS access goes through OIDC (`use-oidc: true` and the account's `aws-account-id`), not static keys.
5. If no reusable workflow fits, say so in the PR body and name the one you checked.
6. `make all` must pass. Its `check-yaml` hook validates the YAML.
