param(
  [Parameter(Mandatory = $true)]
  [string]$Name,

  [string]$Root = "projects",

  [switch]$NoBootstrap
)

$ErrorActionPreference = "Stop"

$workspaceRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
$templateRoot = Join-Path $workspaceRoot "templates/python-project"
$projectRoot = Join-Path $workspaceRoot $Root
$projectPath = Join-Path $projectRoot $Name

if (Test-Path $projectPath) {
  throw "Project already exists: $projectPath"
}

New-Item -ItemType Directory -Force -Path $projectRoot | Out-Null
Copy-Item -Path $templateRoot -Destination $projectPath -Recurse

Copy-Item -Path (Join-Path $workspaceRoot "opencode.jsonc") -Destination $projectPath
Copy-Item -Path (Join-Path $workspaceRoot "AGENTS.md") -Destination $projectPath
Copy-Item -Path (Join-Path $workspaceRoot ".opencode") -Destination $projectPath -Recurse
Copy-Item -Path (Join-Path $workspaceRoot "docs") -Destination $projectPath -Recurse

New-Item -ItemType Directory -Force -Path (Join-Path $projectPath "scripts") | Out-Null
$scriptNames = @(
  "python-bootstrap.ps1",
  "python-validate.ps1",
  "check-local-deepseek.ps1",
  "start-opencode-local-deepseek.ps1",
  "github-search-code.ps1",
  "github-clone-reference.ps1"
)

foreach ($scriptName in $scriptNames) {
  Copy-Item -Path (Join-Path $workspaceRoot "scripts/$scriptName") -Destination (Join-Path $projectPath "scripts/$scriptName")
}

git -C $projectPath init
git -C $projectPath branch -M main

$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")

if (-not $NoBootstrap) {
  Push-Location $projectPath
  try {
    .\scripts\python-bootstrap.ps1
  } finally {
    Pop-Location
  }
}

git -C $projectPath add .
git -C $projectPath commit -m "Initialize Python OpenCode task project"

Write-Host ""
Write-Host "Created Python task project:"
Write-Host "  $projectPath"
Write-Host ""
Write-Host "Start:"
Write-Host "  cd $projectPath"
Write-Host "  opencode"
