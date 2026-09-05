---
project: custom-contest
updated: 2026-09-05
---

# Architecture

TypeScript、Next.js App Router、PostgreSQL、Zod、pnpm workspaceのmonorepo。

```text
apps/web          Web UIと通常HTTP API。Roomの正本もこのprocess内
apps/userscript   Tampermonkey用。AtCoderの提出判定を検知して通知
apps/realtime     未実装。専用realtime serviceは初期段階では作らない
packages/contracts  API・event境界のZod schema
packages/domain     framework非依存のrule、状態機械、問題pool、catalog
```

# 対戦側

- 単一のNext.js processがRoom、Match、勝敗の正本。browserは意図だけ送る
- 画面は1秒HTTP pollingでsnapshot全体を取得。差分同期はしない
- activeなRoom/Matchはprocess内memory、完了MatchだけをPostgreSQLへ90日保存
- userscriptは一回限りの接続keyを専用tokenへ交換し、提出一覧HTMLから判定を検知する
- 勝者はserverが最初に受理した有効AC

# 精進側

- 対戦側とは独立したroute（`/discover`、`/sets/*`、`/library`）とshell
- 問題catalogは事前生成した固定JSON（約3300問）。server側で検索し、clientへは配らない
- 問題セットの読み書きはrepository interfaceの背後。現在はfixture + browser内保存

# 見た目

1つのdesign systemに2つのskin。primitive（余白、motion、type scale）を共有し、
semantic（色、書体）だけをskinごとに定義する。

- 対戦: dark + 緑accent
- 精進: light + 橙accent（`[data-skin="practice"]`）

CSS class名は精進側を`ps-` / `practice-`で始めて衝突を避ける。
