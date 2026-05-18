$ErrorActionPreference = "Stop"

$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")

if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  Write-Host "[missing] gh"
  exit 1
}

Write-Host "[ok] gh"
gh --version | Select-Object -First 1

Write-Host ""
gh auth status

Write-Host ""
Write-Host "OpenCode MCP servers:"
opencode mcp list
