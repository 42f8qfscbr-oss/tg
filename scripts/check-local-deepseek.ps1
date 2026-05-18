$ErrorActionPreference = "Stop"

$baseUrl = "http://127.0.0.1:8000/v1"

try {
  $models = Invoke-RestMethod -Uri "$baseUrl/models" -Method Get -TimeoutSec 10
  $models | ConvertTo-Json -Depth 10
} catch {
  Write-Host "Local DeepSeek server is not reachable at $baseUrl."
  Write-Host "Start vLLM or SGLang first. See docs/local-deepseek-v4.md."
  exit 1
}
