# Local DeepSeek V4 Pro Deployment

DeepSeek V4 Pro can be used locally only after you run the open weights behind an OpenAI-compatible API server.

## Sources

- Hugging Face collection: <https://huggingface.co/collections/deepseek-ai/deepseek-v4>
- ModelScope collection: <https://modelscope.cn/collections/deepseek-ai/DeepSeek-V4>
- Technical report: <https://huggingface.co/deepseek-ai/DeepSeek-V4-Pro/blob/main/DeepSeek_V4.pdf>

## Practical Constraint

The model card describes DeepSeek-V4-Pro as a very large MoE model: 1.6T total parameters and 49B activated parameters. Local deployment is a server-grade GPU task, not a normal desktop task.

Recommended path:

1. Use DeepSeek official API for daily OpenCode work.
2. Use local DeepSeek V4 only on a Linux/WSL2 GPU server with enough VRAM, disk, and bandwidth.
3. Expose the local model as OpenAI-compatible API at `http://127.0.0.1:8000/v1`.
4. Start OpenCode with the local provider:

```powershell
.\scripts\start-opencode-local-deepseek.ps1
```

## vLLM Server

Run this on a Linux/WSL2 GPU environment, not plain Windows PowerShell:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -U vllm

vllm serve deepseek-ai/DeepSeek-V4-Pro \
  --host 0.0.0.0 \
  --port 8000 \
  --served-model-name deepseek-ai/DeepSeek-V4-Pro \
  --trust-remote-code \
  --tensor-parallel-size 8
```

Adjust `--tensor-parallel-size` to the number of GPUs.

## SGLang Server

Alternative Linux/WSL2 server:

```bash
python -m venv .venv
source .venv/bin/activate
pip install -U "sglang[all]"

python -m sglang.launch_server \
  --model-path deepseek-ai/DeepSeek-V4-Pro \
  --host 0.0.0.0 \
  --port 8000 \
  --tp 8 \
  --trust-remote-code
```

## OpenCode Provider

`opencode.jsonc` includes this local provider:

```text
local-deepseek-v4/deepseek-ai/DeepSeek-V4-Pro
```

Test the server:

```powershell
.\scripts\check-local-deepseek.ps1
```

Start OpenCode with the local model:

```powershell
opencode -m local-deepseek-v4/deepseek-ai/DeepSeek-V4-Pro
```

If the local server is not running, use the default cloud model instead:

```powershell
opencode
```

## Current Machine Check

Run:

```powershell
.\scripts\check-gpu.ps1
```

If `nvidia-smi` is unavailable, treat this Windows machine as an OpenCode controller and run the DeepSeek V4 local model on a separate GPU server.
