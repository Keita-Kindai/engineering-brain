---
title: Custom Contest
project-id: custom-contest
repository: github.com/Keita-Kindai/custom-contest
visibility: public
---

# Purpose

AtCoderの過去問を使い、「問題セットを探す → 練習する → 友達と対戦する → 良いセットを共有する」という循環を作る日本語圏向けplatform。

# Scope

2つの機能群が1つのplatformに同居する。

- **対戦（AC Duel）**: 招待制Roomでの2人BO1。AtCoderの実提出をuserscriptが検知し、serverが勝敗を確定する。
- **精進（問題セット）**: 問題セットの発見、作成、共有、library管理。

Rating、ranking、自動matchmakingは対象外。

# Important files

Repository内の文書が正本で、Brainはそこへ重複を作らない。

- `CONTEXT.md`: domain用語
- `docs/product/mvp.md`: 実装境界
- `docs/decisions/`: ADR
- `docs/flows/`: sequence diagram
- `docs/architecture/http-api.md`: endpoint、snapshot状態遷移、polling
- `docs/ai/handoffs/`: 作業単位の引き継ぎ
- `docs/ai/git-workflow.md`: Issue → branch → PR

# Memory map

- [Architecture](architecture.md)
- [Current state](current-state.md)
- [Constraints](constraints.md)
- [Next actions](next-actions.md)
- [Decisions](decisions/)
