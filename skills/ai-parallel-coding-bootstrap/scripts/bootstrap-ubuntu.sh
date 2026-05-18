#!/usr/bin/env bash
set -euo pipefail

START_HERMES_FLAG="${START_HERMES:-0}"
DRY_RUN="0"
for arg in "$@"; do
  case "$arg" in
    --start-hermes) START_HERMES_FLAG="1" ;;
    --dry-run) DRY_RUN="1" ;;
    -h|--help)
      cat <<'EOF'
Usage: bash scripts/bootstrap-ubuntu.sh [--dry-run] [--start-hermes]

Options:
  --dry-run       Check platform and planned setup actions without changing the system.
  --start-hermes  Start Hermes after successful bootstrap and verification.
EOF
      exit 0
      ;;
    *) printf '\n[error] Unknown argument: %s\n' "$arg" >&2; exit 1 ;;
  esac
done

FRAMEWORK_DIR="${FRAMEWORK_DIR:-$HOME/codex/Coding-framework}"
FRAMEWORK_REPO_SSH="${FRAMEWORK_REPO_SSH:-git@github.com:42f8qfscbr-oss/tg.git}"
FRAMEWORK_REPO_HTTPS="${FRAMEWORK_REPO_HTTPS:-https://github.com/42f8qfscbr-oss/tg.git}"
REQUIRED_NODE_MAJOR="${REQUIRED_NODE_MAJOR:-20}"

log() { printf '\n[bootstrap] %s\n' "$*"; }
warn() { printf '\n[warning] %s\n' "$*" >&2; }
fail() { printf '\n[error] %s\n' "$*" >&2; exit 1; }

if [[ "$(uname -s)" != "Linux" ]]; then
  fail "This bootstrap supports WSL2 Ubuntu or native Ubuntu only. Run it inside Ubuntu."
fi

if [[ ! -r /etc/os-release ]]; then
  fail "Cannot detect OS. /etc/os-release is missing."
fi

# shellcheck source=/dev/null
. /etc/os-release
if [[ "${ID:-}" != "ubuntu" ]]; then
  fail "Unsupported Linux distribution: ${PRETTY_NAME:-unknown}. Use Ubuntu 24.04 or WSL2 Ubuntu 24.04."
fi

if [[ "${VERSION_ID:-}" != "24.04" ]]; then
  warn "Detected ${PRETTY_NAME:-Ubuntu}. This skill is tuned for Ubuntu 24.04; continuing best-effort."
fi

if [[ "$DRY_RUN" == "1" ]]; then
  log "Dry run only; no packages, credentials, or repositories will be changed"
  printf 'Platform: %s\n' "${PRETTY_NAME:-Ubuntu}"
  printf 'Framework dir: %s\n' "$FRAMEWORK_DIR"
  printf 'Framework SSH repo: %s\n' "$FRAMEWORK_REPO_SSH"
  printf 'Framework HTTPS repo: %s\n' "$FRAMEWORK_REPO_HTTPS"
  for cmd in git curl python3 node npm gh uv opencode; do
    if command -v "$cmd" >/dev/null 2>&1; then
      printf '[present] %s\n' "$cmd"
    else
      printf '[would install] %s\n' "$cmd"
    fi
  done
  if [[ -d "$FRAMEWORK_DIR/.git" ]]; then
    printf '[would update] %s\n' "$FRAMEWORK_DIR"
  else
    printf '[would clone] %s\n' "$FRAMEWORK_DIR"
  fi
  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    printf '[credential] GITHUB_TOKEN is set; would configure gh auth if needed.\n'
  else
    printf '[credential] GITHUB_TOKEN is not set; would require gh auth login if not already authenticated.\n'
  fi
  if [[ -n "${DEEPSEEK_API_KEY:-}" ]]; then
    printf '[credential] DEEPSEEK_API_KEY is set; would configure OpenCode DeepSeek auth.\n'
  else
    printf '[credential] DEEPSEEK_API_KEY is not set; would require opencode auth login if auth is missing.\n'
  fi
  exit 0
fi

if [[ "$(id -u)" -eq 0 ]]; then
  SUDO=""
else
  command -v sudo >/dev/null 2>&1 || fail "sudo is required. Install sudo or run as root."
  SUDO="sudo"
fi

export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"

ensure_path_line() {
  local line='export PATH="$HOME/.npm-global/bin:$HOME/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"'
  touch "$HOME/.bashrc"
  if ! grep -Fq "$line" "$HOME/.bashrc"; then
    printf '\n# AI parallel coding toolchain\n%s\n' "$line" >> "$HOME/.bashrc"
  fi
}

apt_install_base() {
  log "Installing base Ubuntu packages"
  $SUDO apt-get update
  $SUDO DEBIAN_FRONTEND=noninteractive apt-get install -y \
    ca-certificates curl git gnupg lsb-release openssh-client python3 python3-venv python3-pip unzip zip
}

node_major() {
  if command -v node >/dev/null 2>&1; then
    node -p 'Number(process.versions.node.split(".")[0])' 2>/dev/null || echo 0
  else
    echo 0
  fi
}

ensure_node() {
  local major
  major="$(node_major)"
  if [[ "$major" -ge "$REQUIRED_NODE_MAJOR" ]] && command -v npm >/dev/null 2>&1; then
    log "Node.js $(node --version) and npm $(npm --version) already available"
    return
  fi

  log "Installing Node.js 22 from NodeSource"
  curl -fsSL https://deb.nodesource.com/setup_22.x | $SUDO -E bash -
  $SUDO DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs
}

ensure_gh() {
  if command -v gh >/dev/null 2>&1; then
    log "GitHub CLI already available: $(gh --version | head -1)"
    return
  fi

  log "Installing GitHub CLI"
  if $SUDO DEBIAN_FRONTEND=noninteractive apt-get install -y gh; then
    return
  fi

  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    $SUDO dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg >/dev/null
  $SUDO chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
    $SUDO tee /etc/apt/sources.list.d/github-cli.list >/dev/null
  $SUDO apt-get update
  $SUDO DEBIAN_FRONTEND=noninteractive apt-get install -y gh
}

ensure_uv() {
  if command -v uv >/dev/null 2>&1; then
    log "uv already available: $(uv --version)"
    return
  fi

  log "Installing uv"
  curl -LsSf https://astral.sh/uv/install.sh | sh
  export PATH="$HOME/.local/bin:$PATH"
}

ensure_opencode() {
  mkdir -p "$HOME/.npm-global"
  npm config set prefix "$HOME/.npm-global" >/dev/null
  ensure_path_line
  export PATH="$HOME/.npm-global/bin:$PATH"

  if command -v opencode >/dev/null 2>&1; then
    log "OpenCode already available: $(opencode --version)"
    return
  fi

  log "Installing OpenCode"
  npm install -g opencode-ai
  hash -r || true
}

choose_clone_url() {
  if git ls-remote "$FRAMEWORK_REPO_SSH" HEAD >/dev/null 2>&1; then
    printf '%s' "$FRAMEWORK_REPO_SSH"
  else
    printf '%s' "$FRAMEWORK_REPO_HTTPS"
  fi
}

sync_framework_repo() {
  local repo_url
  repo_url="$(choose_clone_url)"
  mkdir -p "$(dirname "$FRAMEWORK_DIR")"

  if [[ -d "$FRAMEWORK_DIR/.git" ]]; then
    log "Updating framework repository at $FRAMEWORK_DIR"
    git -C "$FRAMEWORK_DIR" remote set-url origin "$repo_url" || true
    git -C "$FRAMEWORK_DIR" fetch origin main
    git -C "$FRAMEWORK_DIR" checkout main
    git -C "$FRAMEWORK_DIR" pull --ff-only origin main
  elif [[ -e "$FRAMEWORK_DIR" ]]; then
    fail "$FRAMEWORK_DIR exists but is not a Git repository. Move it aside or set FRAMEWORK_DIR."
  else
    log "Cloning framework repository to $FRAMEWORK_DIR"
    git clone "$repo_url" "$FRAMEWORK_DIR"
  fi
}

configure_github_auth() {
  if gh auth status >/dev/null 2>&1; then
    log "GitHub CLI is already authenticated"
    return 0
  fi

  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    log "Configuring GitHub CLI from GITHUB_TOKEN"
    printf '%s\n' "$GITHUB_TOKEN" | gh auth login --with-token
    return 0
  fi

  warn "GitHub CLI is not authenticated. Run: gh auth login"
  return 1
}

configure_deepseek_auth() {
  local auth_file="$HOME/.local/share/opencode/auth.json"
  if [[ -n "${DEEPSEEK_API_KEY:-}" ]]; then
    log "Configuring OpenCode DeepSeek auth from DEEPSEEK_API_KEY"
    mkdir -p "$(dirname "$auth_file")"
    python3 - "$auth_file" <<'PY'
import json
import os
import stat
import sys
from pathlib import Path

auth_file = Path(sys.argv[1])
data = {}
if auth_file.exists():
    try:
        data = json.loads(auth_file.read_text())
    except json.JSONDecodeError:
        data = {}
data["deepseek"] = {"type": "api", "key": os.environ["DEEPSEEK_API_KEY"]}
auth_file.write_text(json.dumps(data, indent=2) + "\n")
auth_file.chmod(stat.S_IRUSR | stat.S_IWUSR)
PY
    return 0
  fi

  if [[ -r "$auth_file" ]] && python3 - "$auth_file" <<'PY'
import json
import sys
from pathlib import Path
try:
    data = json.loads(Path(sys.argv[1]).read_text())
except Exception:
    raise SystemExit(1)
key = data.get("deepseek", {}).get("key")
raise SystemExit(0 if key else 1)
PY
  then
    log "OpenCode DeepSeek auth already exists"
    return 0
  fi

  warn "DeepSeek auth is missing. Run: opencode auth login"
  return 1
}

run_framework_check() {
  log "Running framework environment check"
  cd "$FRAMEWORK_DIR"
  chmod +x scripts/linux/*.sh 2>/dev/null || true
  ./scripts/linux/check-env.sh
}

apt_install_base
ensure_node
ensure_gh
ensure_uv
ensure_opencode
sync_framework_repo

github_ok=0
deepseek_ok=0
configure_github_auth || github_ok=1
configure_deepseek_auth || deepseek_ok=1
run_framework_check

cat <<EOF

[bootstrap] Framework workspace is ready at:
  $FRAMEWORK_DIR

[bootstrap] Start Hermes with:
  cd $FRAMEWORK_DIR
  ./scripts/linux/start-hermes.sh
EOF

if [[ "$github_ok" -ne 0 || "$deepseek_ok" -ne 0 ]]; then
  cat <<'EOF'

[action required]
Some credentials are missing. Complete the relevant steps, then rerun verification:

  gh auth login
  opencode auth login
  bash scripts/verify-env.sh

You can avoid interactive setup on another run by exporting:

  export GITHUB_TOKEN="..."
  export DEEPSEEK_API_KEY="..."
EOF
  exit 2
fi

if [[ "$START_HERMES_FLAG" == "1" ]]; then
  log "Starting Hermes"
  cd "$FRAMEWORK_DIR"
  exec ./scripts/linux/start-hermes.sh
fi
