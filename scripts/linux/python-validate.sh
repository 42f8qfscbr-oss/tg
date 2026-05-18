#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../.."

if [[ ! -x .venv/bin/python ]]; then
  echo "Python virtual environment not found. Run: ./scripts/linux/python-bootstrap.sh" >&2
  exit 1
fi

./.venv/bin/python -m ruff check .
./.venv/bin/python -m mypy
./.venv/bin/python -m pytest
