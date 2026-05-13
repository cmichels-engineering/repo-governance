#!/usr/bin/env bash
set -euo pipefail

OWNER="${1:-cmichels}"

repos=("pr-monitor" "claude-config" "dotconfig")

for repo in "${repos[@]}"; do
  echo "Importing github_repository.managed[\"${repo}\"]"
  terraform import "github_repository.managed[\"${repo}\"]" "${OWNER}/${repo}"
done
