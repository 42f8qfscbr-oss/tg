#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../.."

export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:$PATH"

for cmd in git python3 node npm gh uv opencode; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf '[ok] %s ' "$cmd"
    "$cmd" --version 2>/dev/null | head -1 || true
  else
    echo "[missing] $cmd"
  fi
done

echo
echo "OpenCode agents:"
opencode agent list | grep -E 'hermes|builder|reviewer|tester' || true

echo
echo "MCP servers:"
opencode mcp list || true
