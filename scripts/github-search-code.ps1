param(
  [Parameter(Mandatory = $true)]
  [string]$Query,

  [int]$Limit = 20
)

$ErrorActionPreference = "Stop"

$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  throw "GitHub CLI is not installed. Install it with: winget install --id GitHub.cli -e"
}

gh search code $Query --limit $Limit
