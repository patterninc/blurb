---
name: change-and-verify
description: Use when changing code or scripts in blurb and deciding how to verify the change before a PR.
---

# Changing code in blurb

1. Read `AGENTS.md` for what the code touches (accounts, secrets, schedules) and what must not change.
2. Make the change. Keep side effects (API calls, AWS, file writes) behind a `main()` or function, so tests can import the module without running it.
3. Add or update a test in `tests/` for the function you changed. Mock network and AWS calls.
4. `make all` must pass: formatter, linter and tests, exactly what CI runs.
5. Open the PR with a Conventional Commit title (`feat: …`, `fix: …`).
