#!/usr/bin/env bash
set -euo pipefail

FRAMEWORK_DIR="${FRAMEWORK_DIR:-$HOME/codex/Coding-framework}"
export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

ok() { printf '[ok] %s\n' "$*"; }
warn() { printf '[missing] %s\n' "$*"; }
fail_count=0

check_cmd() {
  local cmd="$1"
  if command -v "$cmd" >/dev/null 2>&1; then
    ok "$cmd: $($cmd --version 2>/dev/null | head -1 || true)"
  else
    warn "$cmd"
    fail_count=$((fail_count + 1))
  fi
}

if [[ "$(uname -s)" == "Linux" ]] && [[ -r /etc/os-release ]]; then
  # shellcheck source=/dev/null
  . /etc/os-release
  if [[ "${ID:-}" == "ubuntu" ]]; then
    ok "Ubuntu detected: ${PRETTY_NAME:-unknown}"
  else
    warn "Expected Ubuntu, found ${PRETTY_NAME:-unknown}"
    fail_count=$((fail_count + 1))
  fi
else
  warn "Expected Linux/Ubuntu environment"
  fail_count=$((fail_count + 1))
fi

for cmd in git curl python3 node npm gh uv opencode; do
  check_cmd "$cmd"
done

if python3 -m venv --help >/dev/null 2>&1; then
  ok "python3 venv available"
else
  warn "python3 venv unavailable"
  fail_count=$((fail_count + 1))
fi

if [[ -d "$FRAMEWORK_DIR/.git" ]]; then
  ok "framework repository exists: $FRAMEWORK_DIR"
else
  warn "framework repository missing: $FRAMEWORK_DIR"
  fail_count=$((fail_count + 1))
fi

if [[ -d "$FRAMEWORK_DIR" ]]; then
  cd "$FRAMEWORK_DIR"

  for path in AGENTS.md opencode.jsonc scripts/linux/start-hermes.sh scripts/linux/check-env.sh .opencode/agents/hermes.md .opencode/agents/operator.md; do
    if [[ -e "$path" ]]; then
      ok "repo file exists: $path"
    else
      warn "repo file missing: $path"
      fail_count=$((fail_count + 1))
    fi
  done

  if command -v opencode >/dev/null 2>&1; then
    agents="$(opencode agent list 2>/dev/null || true)"
    for agent in hermes operator builder architect reviewer tester; do
      if printf '%s\n' "$agents" | grep -q "^$agent "; then
        ok "OpenCode agent: $agent"
      else
        warn "OpenCode agent not listed: $agent"
        fail_count=$((fail_count + 1))
      fi
    done

    mcps="$(opencode mcp list 2>/dev/null || true)"
    for mcp in gh_grep context7; do
      if printf '%s\n' "$mcps" | grep -q "$mcp"; then
        ok "MCP configured: $mcp"
      else
        warn "MCP not listed: $mcp"
        fail_count=$((fail_count + 1))
      fi
    done
  fi
fi

if gh auth status >/dev/null 2>&1; then
  ok "GitHub CLI authenticated"
else
  warn "GitHub CLI not authenticated; run: gh auth login"
fi

auth_file="$HOME/.local/share/opencode/auth.json"
if [[ -r "$auth_file" ]] && python3 - "$auth_file" <<'PY'
import json
import sys
from pathlib import Path
try:
    data = json.loads(Path(sys.argv[1]).read_text())
except Exception:
    raise SystemExit(1)
raise SystemExit(0 if data.get("deepseek", {}).get("key") else 1)
PY
then
  ok "OpenCode DeepSeek auth present"
else
  warn "OpenCode DeepSeek auth missing; run: opencode auth login"
fi

if [[ "$fail_count" -gt 0 ]]; then
  printf '\n[verify] Failed with %s missing required checks.\n' "$fail_count" >&2
  exit 1
fi

printf '\n[verify] Required environment checks passed.\n'
printf 'Start Hermes with:\n  cd %s\n  ./scripts/linux/start-hermes.sh\n' "$FRAMEWORK_DIR"
