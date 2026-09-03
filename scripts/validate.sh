#!/usr/bin/env bash

set -euo pipefail

script_dir="$(CDPATH= cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
brain_root="$(CDPATH= cd -- "$script_dir/.." && pwd)"
cd "$brain_root"

required_dirs=(
  inbox knowledge/web knowledge/computer-science knowledge/cloud
  knowledge/machine-learning knowledge/ai-agents projects
  agent-memory/shared/workflows agent-memory/shared/lessons
  agent-memory/shared/preferences agent-memory/codex agent-memory/claude
  sessions/recent sessions/archive maintenance/reports templates
  agent-tools/skills .agents/skills .claude/skills .private .local
)
skills=(brain-recall brain-learn brain-continue brain-capture brain-maintenance learning-note)

for dir in "${required_dirs[@]}"; do
  [[ -d "$dir" ]] || { echo "Missing directory: $dir" >&2; exit 1; }
done

for skill in "${skills[@]}"; do
  canonical="agent-tools/skills/$skill"
  [[ -f "$canonical/SKILL.md" ]] || { echo "Missing skill: $canonical/SKILL.md" >&2; exit 1; }
  rg -q "^name: $skill$" "$canonical/SKILL.md" || { echo "Invalid skill name: $skill" >&2; exit 1; }
  rg -q '^description: .+' "$canonical/SKILL.md" || { echo "Missing skill description: $skill" >&2; exit 1; }

  for adapter_root in .agents/skills .claude/skills; do
    adapter="$adapter_root/$skill"
    [[ -L "$adapter" ]] || { echo "Adapter is not a symlink: $adapter" >&2; exit 1; }
    [[ -f "$adapter/SKILL.md" ]] || { echo "Broken adapter: $adapter" >&2; exit 1; }
    [[ "$(CDPATH= cd -- "$adapter" && pwd -P)" == "$(CDPATH= cd -- "$canonical" && pwd -P)" ]] || {
      echo "Adapter has wrong target: $adapter" >&2
      exit 1
    }
  done
done

git check-ignore --no-index -q .private/probe
git check-ignore --no-index -q .local/probe
git diff --check

if [[ "${CHECK_GLOBAL_SKILLS:-0}" == "1" ]]; then
  ./scripts/install-global-skills.sh --check
fi

echo "Engineering Brain structure, skills, adapters, ignore rules, and diff checks passed."
