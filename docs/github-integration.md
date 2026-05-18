# GitHub Integration

This workspace connects GitHub in three layers:

1. `gh` CLI for login, repository operations, issues, pull requests, and Actions logs.
2. OpenCode MCP tools for open source research:
   - `gh_grep`: search public GitHub code snippets.
   - `context7`: fetch current official library and framework docs.
3. GitHub Actions templates for running OpenCode from issues, pull requests, schedules, and manual dispatch.

## Local GitHub Login

Run:

```powershell
gh auth login
```

Recommended choices:

- Host: `GitHub.com`
- Protocol: `HTTPS`
- Authenticate Git with GitHub credentials: `Yes`
- Login method: browser

Check login:

```powershell
gh auth status
```

## Open Source Research Workflow

Use this prompt shape inside OpenCode:

```text
Research how mature open source projects solve this problem. Use context7 for official docs and gh_grep for GitHub examples. Summarize patterns, tradeoffs, licenses if code may be copied, then propose an implementation for this repository.
```

Good uses:

- Learn idiomatic API usage.
- Compare architecture patterns.
- Find examples of framework integration.
- Investigate common edge cases.

Bad uses:

- Copying large code blocks without license review.
- Importing unknown dependencies without maintenance/security checks.
- Sending private code or secrets to public search tools.

## GitHub MCP Scope

OpenCode documentation warns that broad GitHub MCP servers can add many tools and consume context quickly. This workspace enables `gh_grep` by default for lightweight public code search.

For full repository management, prefer `gh` CLI first. Add GitHub's official MCP server only when you need natural-language access to GitHub issues, PRs, Actions, or repository APIs from inside the agent.

## Useful `gh` Commands

Search repositories:

```powershell
gh search repos "nextjs auth stars:>500" --limit 20
```

Search code:

```powershell
gh search code "createServerClient language:TypeScript" --limit 20
```

Clone a reference repo:

```powershell
gh repo clone owner/repo external_repos/owner-repo
```

Inspect issues:

```powershell
gh issue list --repo owner/repo --limit 20
```

Inspect pull requests:

```powershell
gh pr list --repo owner/repo --limit 20
```

View Actions runs:

```powershell
gh run list --repo owner/repo --limit 20
```

## GitHub Actions OpenCode

Use templates from `templates/github-actions/` in a real GitHub repository:

- `opencode-review.yml`: review pull requests.
- `opencode-dispatch.yml`: manually run an OpenCode task from the Actions tab.
- `opencode-scheduled.yml`: run scheduled automation.

Before enabling them, add the required model API key as a GitHub Actions secret and update the `model` field if your OpenCode provider uses a different DeepSeek model id.
