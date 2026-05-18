# Hermes Local Control Workflow

Hermes is the local controller for this workspace. GitHub is not the development executor.

## Roles

- Hermes: strategy, planning, task decomposition, approval checkpoints, and coordination.
- DeepSeek V4 Pro: primary reasoning and coding model used by local OpenCode.
- GitHub: repository hosting, open source research, issue/PR reference, and backup.
- `gh_grep`: public GitHub code examples for inspiration.
- `context7`: official library/framework documentation.

## Standard Flow

1. Start Hermes locally:

```powershell
.\scripts\start-hermes.ps1
```

2. Ask Hermes for a plan:

```text
Use Hermes. I want to build <goal>. Research open source inspiration if useful, then report the plan and task split. Do not execute until I approve.
```

3. Review Hermes' plan and approve or revise.

4. Create independent task folders:

```powershell
.\scripts\new-python-task-project.ps1 -Name task-a
.\scripts\new-python-task-project.ps1 -Name task-b
```

5. Start one local OpenCode session per task folder:

```powershell
cd projects\task-a
opencode
```

6. Give each task folder a bounded implementation prompt from Hermes' plan.

7. Run validation inside each task folder:

```powershell
.\scripts\python-validate.ps1
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
