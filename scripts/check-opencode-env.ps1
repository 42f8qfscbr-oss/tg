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
Test-Command "opencode"

$requiredFiles = @(
  "opencode.jsonc",
  "AGENTS.md",
  "docs/architecture.md",
  "docs/coding-rules.md",
  "docs/workflow.md",
  "docs/deepseek-setup.md",
  "docs/github-integration.md",
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
