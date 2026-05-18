# OpenCode Automated Programming Workspace

This directory contains a reusable OpenCode setup for DeepSeek V4 Pro based automated programming.

## First-Time Setup

Open this directory in PowerShell and run:

```powershell
opencode
```

Inside OpenCode:

```text
/connect
```

Choose `deepseek`, enter your DeepSeek API key, then run:

```text
/models
```

Select `DeepSeek-V4-Pro`. If the displayed model id differs from `deepseek/DeepSeek-V4-Pro`, update `opencode.jsonc`.

Detailed connection notes are in `docs/deepseek-setup.md`.

To check the local setup:

```powershell
.\scripts\check-opencode-env.ps1
```

## Daily Flow

1. Create a task brief from `templates/task-brief.md`.
2. Ask `@architect` to split the work.
3. Confirm architecture decisions.
4. Create worktrees with `scripts/new-worktree.ps1`.
5. Run OpenCode in each worktree and assign one task to the `builder` agent.
6. Ask `@reviewer` to review branch changes before merging.

## Example Worktree Command

```powershell
.\scripts\new-worktree.ps1 -Branch feature/auth -Path ..\my-app-auth -Base main
```

Then:

```powershell
cd ..\my-app-auth
opencode
```
