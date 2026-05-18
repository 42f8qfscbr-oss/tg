$ErrorActionPreference = "Stop"

$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")

if (-not (Get-Command opencode -ErrorAction SilentlyContinue)) {
  throw "opencode is not installed. Install it with: npm install -g opencode-ai"
}

opencode --agent hermes -m deepseek/deepseek-v4-pro
