$ErrorActionPreference = "Stop"

$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  throw "GitHub CLI is not installed. Install it with: winget install --id GitHub.cli -e"
}

gh auth login
gh auth status
