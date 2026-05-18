# Agent Usage Guide

## Universal Agent Flow

1. Read `SKILL.md`.
2. Run `bash scripts/bootstrap-ubuntu.sh` from the skill folder.
3. If the script reports missing credentials, perform the requested login steps or ask the user for the required secrets.
4. Run `bash scripts/verify-env.sh`.
5. Start Hermes from `~/codex/Coding-framework`.

## Codex

- Use this skill when the user asks to install, replicate, migrate, or verify the AI parallel coding environment.
- Prefer the bundled scripts over retyping setup commands.
- Do not edit Windows repository paths for development work.
- After setup, use Hermes for planning and approval checkpoints.

## Hermes

- Act as the controller, not the low-level installer unless asked.
- Use the operator/Flash path for routine checks and installs.
- Use Pro for planning, code, architecture, debugging, and review.
- Before implementation, report goal, assumptions, task folders, validation commands, risks, and questions.

## OpenClaw or Other CLI Agents

- Treat this skill as a runbook plus executable installer.
- Execute `scripts/bootstrap-ubuntu.sh` in Ubuntu/WSL.
- Do not copy secrets into logs or prompts.
- When bootstrap completes, hand control to Hermes/OpenCode in the canonical workspace.

## OpenCode

- Start Hermes with:

```bash
cd ~/codex/Coding-framework
./scripts/linux/start-hermes.sh
```

- For task-specific work, create one project folder per independent task and start one OpenCode session inside each folder.
