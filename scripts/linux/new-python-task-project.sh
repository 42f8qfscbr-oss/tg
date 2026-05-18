#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <project-name> [--no-bootstrap]" >&2
  exit 1
fi

name="$1"
no_bootstrap="${2:-}"

workspace_root="$(cd "$(dirname "$0")/../.." && pwd)"
template_root="$workspace_root/templates/python-project"
project_root="$workspace_root/projects"
project_path="$project_root/$name"

if [[ -e "$project_path" ]]; then
  echo "Project already exists: $project_path" >&2
  exit 1
fi

mkdir -p "$project_root"
cp -a "$template_root" "$project_path"
cp "$workspace_root/opencode.jsonc" "$project_path/"
cp "$workspace_root/AGENTS.md" "$project_path/"
cp -a "$workspace_root/.opencode" "$project_path/"
cp -a "$workspace_root/docs" "$project_path/"

mkdir -p "$project_path/scripts/linux"
cp "$workspace_root/scripts/linux/python-bootstrap.sh" "$project_path/scripts/linux/"
cp "$workspace_root/scripts/linux/python-validate.sh" "$project_path/scripts/linux/"

git -C "$project_path" init
git -C "$project_path" branch -M main

if [[ "$no_bootstrap" != "--no-bootstrap" ]]; then
  (cd "$project_path" && ./scripts/linux/python-bootstrap.sh)
fi

git -C "$project_path" add .
git -C "$project_path" commit -m "Initialize Python OpenCode task project"

echo
echo "Created Python task project:"
echo "  $project_path"
echo
echo "Start:"
echo "  cd $project_path"
echo "  opencode"
