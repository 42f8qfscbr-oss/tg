param(
  [Parameter(Mandatory = $true)]
  [string]$Repo,

  [string]$DestinationRoot = "external_repos"
)

$ErrorActionPreference = "Stop"

$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  throw "GitHub CLI is not installed. Install it with: winget install --id GitHub.cli -e"
}

$safeName = $Repo.Replace("/", "-")
$destination = Join-Path $DestinationRoot $safeName

New-Item -ItemType Directory -Force -Path $DestinationRoot | Out-Null

if (Test-Path $destination) {
  Write-Host "Reference repo already exists: $destination"
} else {
  gh repo clone $Repo $destination
}

Write-Host ""
Write-Host "Reference repo path: $destination"
Write-Host "Before copying code, inspect its license:"
Write-Host "  Get-ChildItem $destination -Filter LICENSE*"
