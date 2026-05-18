# Environment Contract

A machine is aligned when the following conditions are true.

## Platform

- OS is WSL2 Ubuntu 24.04 or native Ubuntu.
- Development happens in Ubuntu, not Windows.
- Canonical workspace is `~/codex/Coding-framework`.

## Required Tools

- `git`
- `curl`
- `python3`
- `python3 -m venv`
- `node` 20 or newer
- `npm`
- `gh`
- `uv`
- `opencode`

## Repository

- Framework repo is cloned or updated from `42f8qfscbr-oss/tg`.
- Expected path: `~/codex/Coding-framework`.
- The repo provides Linux scripts under `scripts/linux/`.
- The repo provides OpenCode agents under `.opencode/agents/`.

## OpenCode Agents

Required agents:

- `hermes`: primary controller, DeepSeek V4 Pro.
- `operator`: lightweight operations, DeepSeek V4 Flash.
- `builder`: implementation, DeepSeek V4 Pro.
- `architect`: architecture/task split, DeepSeek V4 Pro.
- `reviewer`: code review, DeepSeek V4 Pro.
- `tester`: validation/failure investigation, DeepSeek V4 Pro.

## Model Routing

- `deepseek/deepseek-v4-pro` handles planning, coding, architecture, review, debugging, security, dependency/API decisions, and source-code changes.
- `deepseek/deepseek-v4-flash` handles downloads, installs, status checks, file listings, routine commands, and short operational replies.
- Any task that begins as simple but reveals code changes, complex failures, or architectural impact must escalate to Pro.

## MCP and Research

- `context7` is enabled for current official docs.
- `gh_grep` is enabled for public GitHub code examples.
- GitHub is used for inspiration, backup, branches, PRs, and repo sync, not primary development execution.

## Credentials

- DeepSeek auth is local to the machine and must not be committed.
- GitHub auth is local to `gh` and must not be committed.
- If environment variables are present, bootstrap may use them for local auth setup.
- If variables are absent, the agent must stop and tell the user the required interactive login commands.

## Work Model

- One unrelated development task equals one independent folder under `projects/`.
- Each task folder owns its own Python environment and validation cycle.
- Hermes reports plan, task folders, risks, and questions before execution unless the user explicitly authorizes immediate work.
