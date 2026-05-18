# Python Parallel Development Workflow

This workspace uses standard Python virtual environments for each independent task project. The preferred operating model is one folder per independent task project.

## Setup

Run once from the workspace root:

```powershell
.\scripts\python-bootstrap.ps1
```

This creates `.venv`, installs development tools from `requirements-dev.txt`, and runs the validation suite.

## Validation

```powershell
.\scripts\python-validate.ps1
```

The script runs:

```powershell
.\.venv\Scripts\python.exe -m ruff check .
.\.venv\Scripts\python.exe -m mypy
.\.venv\Scripts\python.exe -m pytest
```

## Parallel Worktrees

Create one worktree per feature:

```powershell
.\scripts\new-python-worktree.ps1 -Branch feature/tg-client -Path ..\tg-client -Base main
```

Then start OpenCode in that worktree:

```powershell
cd ..\tg-client
opencode
```

Assign one bounded Python task to each worktree. Avoid editing shared files from multiple worktrees at the same time.

## One Folder Per Task

Create a fully independent Python task project:

```powershell
.\scripts\new-python-task-project.ps1 -Name tg-client
```

This creates:

- `projects/tg-client`
- independent Git repository
- independent `.venv`
- copied OpenCode config and agents
- copied GitHub/MCP docs
- Python validation scripts

Start it:

```powershell
cd projects\tg-client
opencode
```

## GitHub Research Prompt

Use this prompt inside OpenCode:

```text
Use GitHub and official docs to research mature Python implementations for this feature.
Use context7 for official docs and gh_grep for public GitHub examples.
Summarize implementation patterns, license risks, dependencies, and then implement the best fit in this worktree.
Run .\scripts\python-validate.ps1 before finishing.
```
