#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../.."

export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$PATH"

if ! command -v opencode >/dev/null 2>&1; then
  echo "opencode is not installed. Run: npm install -g opencode-ai" >&2
  exit 1
fi

exec opencode --agent hermes -m deepseek/deepseek-v4-pro
