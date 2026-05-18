# Coding Rules

## General

- Keep changes focused on the assigned task.
- Prefer explicit types and clear data boundaries.
- Keep domain logic out of UI handlers and route glue where possible.
- Validate external input at system boundaries.
- Make failure modes visible and testable.

## Tests

- Add or update tests for new core behavior.
- Prefer small, deterministic tests.
- Cover important negative paths, not only happy paths.
- If tests cannot be run locally, explain the blocker.

## Validation Commands

When a project defines these commands, run the relevant set before finishing:

```powershell
npm run lint
npm run typecheck
npm test
npm run build
```

For non-Node projects, use the equivalent commands documented by that project.
