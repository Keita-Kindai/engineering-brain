---
project: custom-contest
updated: 2026-09-05
---

# Next actions

1. 精進側の画面を見て、2 skinの方向性とcardの密度でよいか判断する
2. DESIGN-081（作成をstep式にするか1画面のままか）とDESIGN-074（認証方式）を決める
3. 決まったら問題セットのPostgreSQL永続化をADRにし、`repository.ts` の実装を差し替える
4. 練習画面（`/practice/[setId]`）を設計する
5. 対戦側と精進側を1つのtopとglobal navigationへ統合する
6. 対戦の抽選poolと精進の検索catalogを1つのカタログへ統合する
