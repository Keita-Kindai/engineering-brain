# Agent memory index

Coding Agent が次回より効率的・正確に作業するための procedural memory です。

- `shared/workflows/`: 再利用可能な作業手順
- `shared/lessons/`: 成功・失敗から得た一般化可能な教訓
- `shared/preferences/`: Engineering work に関係する User preference
- `codex/`: Codex 固有
- `claude/`: Claude Code 固有

Agent-neutral な内容を Host 固有 directory に重複保存しません。個人情報や Session transcript は保存しません。

## Workflows

- [Share one skill source across coding agents](shared/workflows/share-skills-across-agents.md)

## Lessons

- [Visual verification must be browser-observed](shared/lessons/visual-verification-must-be-browser-observed.md)
