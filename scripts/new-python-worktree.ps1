param(
  [Parameter(Mandatory = $true)]
  [string]$Branch,

  [Parameter(Mandatory = $true)]
  [string]$Path,

  [string]$Base = "main"
)

$ErrorActionPreference = "Stop"

.\scripts\new-worktree.ps1 -Branch $Branch -Path $Path -Base $Base

Push-Location $Path
try {
  $env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")
  if (Get-Command uv -ErrorAction SilentlyContinue) {
    uv sync --dev
  } else {
    Write-Host "uv is not installed. Run: winget install --id astral-sh.uv -e"
  }
} finally {
  Pop-Location
}
