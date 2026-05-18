# Hermes Local Control Workflow

Hermes is the local controller for this workspace. GitHub is not the development executor. WSL2 Ubuntu 24.04 is the primary development environment; Windows is only a launcher and file bridge.

## Roles

- Hermes: strategy, planning, task decomposition, approval checkpoints, and coordination.
- DeepSeek V4 Pro: primary reasoning, coding, architecture, review, and debugging model used by local OpenCode.
- DeepSeek V4 Flash: lightweight model for simple non-coding operations such as downloads, installs, environment checks, file listings, and short operational replies.
- GitHub: repository hosting, open source research, issue/PR reference, and backup.
- `gh_grep`: public GitHub code examples for inspiration.
- `context7`: official library/framework documentation.

## Model Routing

- Use `deepseek/deepseek-v4-flash` for ordinary operational work: downloading tools, installing packages, checking versions, listing files, running simple commands, and replying to short status questions.
- Use `deepseek/deepseek-v4-pro` for code generation, code edits, architecture, task splitting, debugging, code review, security-sensitive decisions, and dependency/API design.
- If a simple operation reveals code changes, complex failures, ambiguous requirements, or architectural impact, Hermes must escalate back to DeepSeek V4 Pro before continuing.

## Environment Policy

- Run development, dependency installation, validation, Git commands, and OpenCode sessions inside WSL2 Ubuntu 24.04.
- Use ~/codex/Coding-framework as the canonical workspace.
- Do not develop from the Windows repository path unless the user explicitly asks for Windows-specific maintenance.

## Standard Flow

1. Start Hermes in WSL2 Ubuntu:

```bash
cd ~/codex/Coding-framework
./scripts/linux/start-hermes.sh
```

Use the Windows PowerShell launcher only for bootstrap or Windows-specific maintenance:

```powershell
.\scripts\start-hermes.ps1
```

2. Ask Hermes for a plan:

```text
Use Hermes. I want to build <goal>. Research open source inspiration if useful, then report the plan and task split. Do not execute until I approve.
```

3. Review Hermes' plan and approve or revise.

4. Create independent task folders in WSL2 Ubuntu:

```bash
./scripts/linux/new-python-task-project.sh task-a
./scripts/linux/new-python-task-project.sh task-b
```

Use the Windows PowerShell project script only for Windows-specific maintenance.

5. Start one local OpenCode session per task folder in WSL2 Ubuntu:

```bash
cd ~/codex/Coding-framework/projects/task-a
opencode
```

6. Give each task folder a bounded implementation prompt from Hermes' plan.

7. Run validation inside each task folder:

```powershell
.\scripts\python-validate.ps1
```

On WSL2 Ubuntu:

```bash
./scripts/linux/python-validate.sh
```

8. Hermes reviews results and decides whether to push to GitHub.

## GitHub Policy

GitHub Actions based `/opencode` execution is disabled by default.

Use GitHub for:

- hosting repository state
- reading open source examples
- saving branches and pull requests
- issue/PR references

Do not use GitHub issue comments as the primary development execution path.

## Recommended Hermes Prompt

```text
Use Hermes.
Goal: <describe goal>
Constraints: Python, one independent folder per task, local DeepSeek V4 Pro execution.
Use GitHub only for open source inspiration and repository backup.
First produce plan, architecture, task split, risks, and questions. Do not execute until I approve.
```
