# AGENTS.md

This repository is prepared as an automated programming workspace driven by OpenCode.

## Operating Rules

Follow this sequence for every non-trivial task:

1. Read the user brief, repository structure, README, tests, and relevant docs.
2. Identify ambiguity. Stop for confirmation only when the answer changes architecture, data contracts, security, payment, permissions, or destructive operations.
3. For minor ambiguity, make a conservative assumption and record it in the final response.
4. Implement within the smallest reasonable scope.
5. Run formatting, lint, type checks, tests, and build when the project provides those commands.
6. Fix failures caused by the change.
7. Report changed files, validation results, assumptions, and remaining risks.

## Engineering Rules

- Prefer existing frameworks, patterns, helpers, and naming conventions.
- Do not introduce new frameworks or services without a clear need.
- Do not perform unrelated refactors.
- Do not delete user work unless the task explicitly requires it.
- Keep public API and database changes documented.
- Add focused tests for core behavior, edge cases, and regressions.
- Treat generated code as production code: readable, maintainable, and reviewable.

## Open Source Research Rules

- When unsure how a library, framework, or API should be used, search official docs first with `context7`.
- When implementation examples are useful, use `gh_grep` to search public GitHub code snippets.
- Use GitHub examples as references, not as blind copy-paste sources.
- Check license compatibility before copying meaningful code from an open source project.
- Prefer adding mature package dependencies over vendoring code, unless the task explicitly requires vendoring.
- Never paste secrets, private repository content, or proprietary code into public GitHub searches.

## Question Rules

Ask the user before proceeding when:

- Requirements have multiple incompatible interpretations.
- Data model, API contract, authentication, authorization, payment, or security behavior is affected.
- The task requires deleting data, overwriting large code areas, or changing deployment assumptions.
- A decision will create significant downstream implementation cost.

Otherwise continue with a documented assumption.

## Parallel Work Rules

- Use one Git worktree per feature or module.
- Each OpenCode session owns one feature branch.
- Avoid editing shared foundation files from multiple worktrees at the same time unless the task plan explicitly assigns ownership.
- Before merging, run review and validation from the feature worktree.
