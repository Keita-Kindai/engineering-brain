---
project: custom-contest
updated: 2026-09-09
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

- 対戦側とは独立したroute（`/discover`、`/sets/*`、`/library`、`/settings`、`/signin`）とshell
- 問題セットはPostgreSQL。`repository.ts` は `/api/problem-sets/*` を叩くだけで、
  持ち主やいいねの本人はserverが `auth()` から決める。clientは誰なのかを送らない
- 公開範囲の判定は `server/problem-sets/queries.ts` に置く。画面で隠すだけではURL直打ちで素通りする
- 「無い」と「見せてよくない」はどちらも404。区別するとIDの総当たりで非公開セットの存在を確認できる
- 問題catalogは2か所にある。**検索は固定JSON**（4,764問、buildに同梱）、
  **DBの `problems` table**は外部キーの参照先と表示時のJOIN。書き手はdeployごとのseed scriptだけ
  （[[keep-the-hottest-read-off-a-metered-database]]）
- 挑戦状態はセットの中で閉じる。key は `(user_id, set_id, problem_id)`

# 配備

Vercel（Root Directory = `apps/web`）+ Neon。`vercel-build` が
`db:migrate` → `db:seed-problems` → `next build` の順に走る。
認証はAuth.js v5 + DrizzleAdapter、GitHub OAuth。session はDBに置く。

# 見た目

1つのdesign systemに2つのskin。primitive（余白、motion、type scale）を共有し、
semantic（色、書体）だけをskinごとに定義する。

- 対戦: dark + 緑accent
- 精進: light + 橙accent（`[data-skin="practice"]`）。
  ダークは`<html>`の`data-practice-theme`で上書きし、近黒とグレーの2案をヘッダーで切り替える

CSS class名は精進側を`ps-` / `practice-`で始めて衝突を避ける。
