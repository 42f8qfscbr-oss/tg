$ErrorActionPreference = "Stop"

$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")

function Test-Command($Name) {
  if (Get-Command $Name -ErrorAction SilentlyContinue) {
    $version = & $Name --version 2>$null
    Write-Host "[ok] $Name $version"
  } else {
    Write-Host "[missing] $Name"
  }
}

Test-Command "node"
Test-Command "git"
Test-Command "gh"
Test-Command "uv"
Test-Command "opencode"

$requiredFiles = @(
  "opencode.jsonc",
  "AGENTS.md",
  "docs/architecture.md",
  "docs/coding-rules.md",
  "docs/workflow.md",
  "docs/deepseek-setup.md",
  "docs/github-integration.md",
  "docs/python-workflow.md",
  "docs/local-deepseek-v4.md",
  ".opencode/agents/architect.md",
  ".opencode/agents/builder.md",
  ".opencode/agents/reviewer.md",
  ".opencode/agents/tester.md",
  "templates/task-brief.md",
  "templates/parallel-plan.md",
  "scripts/new-worktree.ps1",
  "scripts/start-opencode.ps1",
  "scripts/github-login.ps1",
  "scripts/github-check.ps1",
  "scripts/github-search-code.ps1",
  "scripts/github-clone-reference.ps1",
  "scripts/python-bootstrap.ps1",
  "scripts/python-validate.ps1",
  "scripts/new-python-worktree.ps1",
  "scripts/new-python-task-project.ps1",
  "scripts/start-task-project.ps1",
  "scripts/check-gpu.ps1",
  "scripts/check-local-deepseek.ps1",
  "scripts/start-opencode-local-deepseek.ps1",
  "templates/python-project/pyproject.toml",
  "templates/python-project/src/task_project/__init__.py",
  "templates/python-project/tests/test_smoke.py",
  "templates/task-dispatch.md",
  "templates/github-actions/opencode-review.yml",
  "templates/github-actions/opencode-dispatch.yml",
  "templates/github-actions/opencode-scheduled.yml"
)

foreach ($file in $requiredFiles) {
  if (Test-Path $file) {
    Write-Host "[ok] $file"
  } else {
    Write-Host "[missing] $file"
  }
}

Write-Host ""
Write-Host "OpenCode agents:"
opencode agent list | Select-String -Pattern "architect|builder|reviewer|tester" -SimpleMatch

Write-Host ""
Write-Host "Next manual step: run 'opencode', then '/connect', choose 'deepseek', and select DeepSeek-V4-Pro with '/models'."
