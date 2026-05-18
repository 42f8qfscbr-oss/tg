---
name: ai-parallel-coding-bootstrap
description: Bootstrap and verify a portable WSL2 Ubuntu 24.04 or native Ubuntu AI automated parallel coding environment with Hermes/OpenCode, DeepSeek V4 Pro/Flash routing, GitHub research support, Python task-project scaffolding, and one-folder-per-task workflows. Use when setting up a new computer or agent host to match the user's AI parallel programming workspace for Codex, Hermes, OpenClaw, OpenCode, or similar coding agents.
---

# AI Parallel Coding Bootstrap

Use this skill to align a fresh WSL2 Ubuntu 24.04 or native Ubuntu machine to the user's AI automated parallel coding environment.

## Operating Model

- Treat WSL2 Ubuntu 24.04 or native Ubuntu as the only development environment.
- Use `~/codex/Coding-framework` as the canonical workspace.
- Use Hermes as the local controller for planning, strategy, task split, approval checkpoints, and command routing.
- Use OpenCode agents for implementation, review, validation, and lightweight operations.
- Use DeepSeek V4 Pro for planning, architecture, coding, debugging, and review.
- Use DeepSeek V4 Flash for simple downloads, installs, checks, status replies, and routine shell operations.
- Use GitHub for open-source inspiration, docs/examples, backup, branches, and PRs only.
- Use one independent folder under `projects/` for each unrelated development task.

For the exact expected final state, read `references/environment-contract.md` when validating a machine. For agent-specific usage patterns, read `references/agent-usage.md`.

## One-Command Bootstrap

From the skill folder on Ubuntu/WSL, run:

```bash
bash scripts/bootstrap-ubuntu.sh
```

Optional credentials can be provided before running:

```bash
export DEEPSEEK_API_KEY="..."
export GITHUB_TOKEN="..."
export CONTEXT7_API_KEY="..."
export LOCAL_DEEPSEEK_API_KEY="..."
```

If credentials are not provided, the script installs and verifies the base tooling, then prints the exact interactive login commands required. It never writes secrets to tracked files or the skill package.

Preview what bootstrap would do without changing the system:

```bash
bash scripts/bootstrap-ubuntu.sh --dry-run
```

To start Hermes automatically after verification:

```bash
START_HERMES=1 bash scripts/bootstrap-ubuntu.sh
# or
bash scripts/bootstrap-ubuntu.sh --start-hermes
```

## Verify Existing Machines

Run:

```bash
bash scripts/verify-env.sh
```

This checks system tools, OpenCode, configured agents, MCP servers, model routing files, GitHub auth state, DeepSeek auth state, and the canonical workspace path.

## After Bootstrap

Start the controller:

```bash
cd ~/codex/Coding-framework
./scripts/linux/start-hermes.sh
```

Recommended first prompt:

```text
Use Hermes.
Goal: <describe the development goal>
Constraints: Python, one independent folder per task, local WSL/Ubuntu execution.
Use GitHub only for open source inspiration and repository backup.
First produce plan, architecture, task split, risks, and questions. Do not execute until I approve.
```

## Safety Rules

- Do not paste secrets into prompts, GitHub searches, logs, commits, or zip packages.
- Do not run development from Windows paths or GitHub Actions issue comments.
- Do not copy open-source code without license review.
- Escalate from Flash to Pro before writing code, debugging complex failures, changing architecture, or making security/API/dependency decisions.
