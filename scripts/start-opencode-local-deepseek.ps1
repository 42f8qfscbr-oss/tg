$ErrorActionPreference = "Stop"

$env:Path = [Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")

if (-not $env:LOCAL_DEEPSEEK_API_KEY) {
  $env:LOCAL_DEEPSEEK_API_KEY = "local-no-key"
}

.\scripts\check-local-deepseek.ps1
opencode -m local-deepseek-v4/deepseek-ai/DeepSeek-V4-Pro
