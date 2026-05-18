param(
  [string]$Path = "."
)

$ErrorActionPreference = "Stop"

if (-not (Get-Command opencode -ErrorAction SilentlyContinue)) {
  throw "opencode is not installed. Install it with: npm install -g opencode-ai"
}

Set-Location $Path
opencode
