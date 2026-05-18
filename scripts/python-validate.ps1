$ErrorActionPreference = "Stop"

$python = ".\.venv\Scripts\python.exe"

if (-not (Test-Path $python)) {
  throw "Python virtual environment not found. Run: .\scripts\python-bootstrap.ps1"
}

& $python -m ruff check .
& $python -m mypy
& $python -m pytest
