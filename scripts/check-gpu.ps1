$ErrorActionPreference = "Stop"

if (Get-Command nvidia-smi -ErrorAction SilentlyContinue) {
  nvidia-smi
} else {
  Write-Host "nvidia-smi not found. This machine is not currently exposing an NVIDIA CUDA GPU to PowerShell."
  Write-Host "DeepSeek-V4-Pro local deployment requires a server-grade GPU environment. Use the cloud API until vLLM/SGLang is available."
}
