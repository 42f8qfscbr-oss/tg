param(
  [Parameter(Mandatory = $true)]
  [string]$Path,

  [switch]$LocalDeepSeek
)

$ErrorActionPreference = "Stop"

Set-Location $Path

if ($LocalDeepSeek) {
  .\scripts\start-opencode-local-deepseek.ps1
} else {
  opencode
}
