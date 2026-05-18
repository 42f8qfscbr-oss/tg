# Automated Programming Workflow

## Standard Flow

1. Write a task brief from `templates/task-brief.md`.
2. Ask the `architect` agent to produce a design, task split, risks, and confirmation questions.
3. Confirm architecture and high-impact decisions manually.
4. Create one worktree per feature with `scripts/new-worktree.ps1`.
5. Start OpenCode in each worktree with `scripts/start-opencode.ps1`.
6. Assign each worktree one bounded implementation task.
7. Run the `reviewer` agent against each feature branch.
8. Fix review findings and run validation.
9. Merge only after validation passes.

## Recommended Agent Prompts

Architecture:

```text
Use @architect. Read the repository and this task brief. Produce architecture, task split, risks, and questions that require confirmation before implementation.
```

Implementation:

```text
Use the builder agent. Implement only this assigned task. Follow AGENTS.md. Run relevant validation and report changed files, commands, results, assumptions, and remaining risks.
```

Review:

```text
Use @reviewer. Review this branch relative to main. Focus on bugs, security, data consistency, edge cases, missing tests, and architecture drift. Do not make code changes.
```
