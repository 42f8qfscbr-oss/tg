$ErrorActionPreference = "Stop"

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
Test-Command "opencode"

$requiredFiles = @(
  "opencode.jsonc",
  "AGENTS.md",
  "docs/architecture.md",
  "docs/coding-rules.md",
  "docs/workflow.md",
  "docs/deepseek-setup.md",
  ".opencode/agents/architect.md",
  ".opencode/agents/builder.md",
  ".opencode/agents/reviewer.md",
  ".opencode/agents/tester.md",
  "templates/task-brief.md",
  "templates/parallel-plan.md",
  "scripts/new-worktree.ps1",
  "scripts/start-opencode.ps1"
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
