# OpenCode Automated Programming Workspace

This directory contains a reusable OpenCode setup for DeepSeek V4 Pro based automated programming.

WSL2 Ubuntu 24.04 is the primary development environment. Use ~/codex/Coding-framework as the canonical workspace; Windows is only a launcher and file bridge unless Windows-specific maintenance is explicitly required.

## First-Time Setup

Open the WSL2 Ubuntu workspace and run:

```bash
cd ~/codex/Coding-framework
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

Select `DeepSeek-V4-Pro`. If the displayed model id differs from `deepseek/deepseek-v4-pro`, update `opencode.jsonc`.

Detailed connection notes are in `docs/deepseek-setup.md`.

To check the WSL2 Ubuntu setup:

```bash
cd ~/codex/Coding-framework
./scripts/linux/check-env.sh
```

Use Windows PowerShell checks only for Windows-specific maintenance.

## GitHub Setup

GitHub CLI has been prepared for local repository, PR, issue, and Actions workflows.

Login:

```powershell
.\scripts\github-login.ps1
```

Check status:

```powershell
.\scripts\github-check.ps1
```

Open source research inside local OpenCode can use:

- `context7` for current official docs.
- `gh_grep` for public GitHub code examples.

See `docs/github-integration.md`.

## Hermes Control

Hermes is the local controller. Run it from WSL2 Ubuntu to plan, split tasks, and report strategy before execution:

```bash
cd ~/codex/Coding-framework
./scripts/linux/start-hermes.sh
```

Recommended first prompt:

```text
Use Hermes. I want to build <goal>. Use GitHub only for open source inspiration. First report plan, task split, risks, and questions. Do not execute until I approve.
```

See `docs/hermes-control.md`.

## Python Parallel Development

Bootstrap the Python environment:

```powershell
.\scripts\python-bootstrap.ps1
```

Create a Python feature worktree:

```powershell
.\scripts\new-python-worktree.ps1 -Branch feature/example -Path ..\example-worktree -Base main
```

Create one independent Python project folder per task:

```powershell
.\scripts\new-python-task-project.ps1 -Name task-a
.\scripts\new-python-task-project.ps1 -Name task-b
.\scripts\new-python-task-project.ps1 -Name task-c
```

On WSL2 Ubuntu:

```bash
./scripts/linux/new-python-task-project.sh task-a
./scripts/linux/new-python-task-project.sh task-b
./scripts/linux/new-python-task-project.sh task-c
```

Start one OpenCode session per folder:

```powershell
cd projects\task-a
opencode
```

Validate:

```powershell
.\scripts\python-validate.ps1
```

## Local DeepSeek V4 Pro

The default OpenCode model remains the DeepSeek cloud provider. A local OpenAI-compatible provider is also configured:

```text
local-deepseek-v4/deepseek-ai/DeepSeek-V4-Pro
```

Start a vLLM or SGLang server first, then run:

```powershell
.\scripts\start-opencode-local-deepseek.ps1
```

See `docs/local-deepseek-v4.md`.

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
