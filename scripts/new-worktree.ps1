param(
  [Parameter(Mandatory = $true)]
  [string]$Branch,

  [Parameter(Mandatory = $true)]
  [string]$Path,

  [string]$Base = "main"
)

$ErrorActionPreference = "Stop"

$repoRoot = git rev-parse --show-toplevel 2>$null
if (-not $repoRoot) {
  throw "Run this script inside a Git repository."
}

git -C $repoRoot fetch --all --prune

$existingBranch = git -C $repoRoot branch --list $Branch
if ($existingBranch) {
  git -C $repoRoot worktree add $Path $Branch
} else {
  git -C $repoRoot worktree add -b $Branch $Path $Base
}

Write-Host "Created worktree:"
Write-Host "  Branch: $Branch"
Write-Host "  Path:   $Path"
Write-Host ""
Write-Host "Next:"
Write-Host "  cd $Path"
Write-Host "  opencode"
