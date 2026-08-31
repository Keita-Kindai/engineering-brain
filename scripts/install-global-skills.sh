#!/usr/bin/env bash

set -euo pipefail

mode="${1:---install}"
if [[ "$mode" != "--install" && "$mode" != "--check" ]]; then
  echo "Usage: $0 [--install|--check]" >&2
  exit 2
fi

script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
brain_root="$(CDPATH= cd -- "$script_dir/.." && pwd)"
canonical_root="$brain_root/agent-tools/skills"
skills=(brain-recall brain-learn brain-continue brain-capture brain-maintenance)
host_roots=("$HOME/.agents/skills" "$HOME/.claude/skills")

conflicts=0
missing=0

for host_root in "${host_roots[@]}"; do
  for skill in "${skills[@]}"; do
    source_dir="$canonical_root/$skill"
    link_path="$host_root/$skill"

    if [[ ! -f "$source_dir/SKILL.md" ]]; then
      echo "Missing canonical skill: $source_dir/SKILL.md" >&2
      conflicts=1
      continue
    fi

    if [[ -L "$link_path" ]]; then
      if [[ -d "$link_path" && "$(CDPATH= cd -- "$link_path" && pwd -P)" == "$(CDPATH= cd -- "$source_dir" && pwd -P)" ]]; then
        continue
      fi
      echo "Conflict: $link_path is a different symlink" >&2
      conflicts=1
    elif [[ -e "$link_path" ]]; then
      echo "Conflict: $link_path already exists" >&2
      conflicts=1
    else
      missing=1
    fi
  done
done

if [[ "$conflicts" -ne 0 ]]; then
  echo "No changes made. Resolve conflicts explicitly and rerun." >&2
  exit 1
fi

if [[ "$mode" == "--check" ]]; then
  if [[ "$missing" -ne 0 ]]; then
    echo "Global Engineering Brain skill links are incomplete." >&2
    exit 1
  fi
  echo "Global Engineering Brain skill links are valid for Codex and Claude Code."
  exit 0
fi

for host_root in "${host_roots[@]}"; do
  mkdir -p "$host_root"
  for skill in "${skills[@]}"; do
    source_dir="$canonical_root/$skill"
    link_path="$host_root/$skill"
    if [[ ! -e "$link_path" && ! -L "$link_path" ]]; then
      ln -s "$source_dir" "$link_path"
      echo "Linked $link_path -> $source_dir"
    fi
  done
done

"$0" --check

