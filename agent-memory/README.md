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
- [Review an external service before integrating it](shared/workflows/review-external-service-before-integrating.md)
- [Keep main green through issue branches and reviewed PRs](shared/workflows/keep-main-green-through-issue-branches.md)

## Lessons

- [Visual verification must be browser-observed](shared/lessons/visual-verification-must-be-browser-observed.md)
- [Public user data still needs purpose and permission](shared/lessons/public-data-still-needs-purpose-and-permission.md)
- [Namespace CSS when adding a second skin to one app](shared/lessons/namespace-css-when-adding-a-second-skin.md)
- [Share token primitives across two visual identities](shared/lessons/share-token-primitives-across-visual-identities.md)
- [Confirm branch identity before committing and when files look reverted](shared/lessons/confirm-branch-identity-before-committing.md)

## Claude Code

- [Write terminating goal conditions for Claude Code /goal](claude/write-terminating-goal-conditions.md)
