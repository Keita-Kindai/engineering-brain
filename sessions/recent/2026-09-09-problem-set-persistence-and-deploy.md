---
title: Problem set persistence, accounts, and the first public deploy
date: 2026-09-09
status: active
project: custom-contest
---

# Goal

精進（問題セット）側をlocalStorageから外してアカウントへ結び付け、一般公開する。あわせてUI指摘の消化と、対戦（AC Duel）の棚上げ。

# What happened

UI round 3・4 → 対戦の棚上げ → DB設計（ADR-0011）→ 構成選定（ADR-0010確定）→ schema + migration + seed → API層 → client差し替え → Vercel + Neonへ配備 → catalog拡大の順で進んだ。1日で `main` へ7 PRが入った。

配備先は <https://custom-problems.vercel.app>。

# What worked

- **Grilling形式で先に仕様を潰す。** 実装前にAskUserQuestionで4問ずつ確認し、決まってからbranchを切った。UI round 4もDB設計もこの形で、手戻りがほぼ出なかった。
- **server → clientの順で切る。** `queries.ts` + Route Handler + integration testを1 commitにし、`repository.ts` の差し替えを次のcommitにした。前半だけで実DBに対する検証が完結する。
- **使い捨てDBでの検証。** `createdb` した空DBへmigrationとseedを流し、制約違反6件とCASCADE 4件をSQLで直接確かめてから画面を触った。

# What failed

- **`main` への直commitを2回やった。** どちらもHEADが`main`に戻っていることに気づかず作業した。退避（`git branch` → `reset --hard origin/main`）は通ったが、`reset`と`switch`はpermission classifierに拒否されるので、最終的にUserの手作業になった。
- **積み上げたbranchを一度作ってしまった。** schema → contracts → auth の3段。Userに「先にmergeすべきか」と聞かれて初めて、Cを積む前に解消した。前回のsessionで同じ問題を扱ったばかりだった。
- **`zod` を `apps/web` から直接importした。** `apps/web` の直接依存ではないため `TS2307`。API schemaは `packages/contracts` に置くというAGENTS.mdの規則どおりに直した。
- **seed scriptが `@custom-contest/domain` をimportして `ERR_MODULE_NOT_FOUND`。** Nodeのtype strippingは、workspace package内部の拡張子なしTypeScript import（`./random`）を解決できない。`migrate.ts` と同じくJSONを直接読む形にした。

# Important discoveries

- **`problems.problem_index` が `varchar(8)` では足りない。** JOIの問題記号は `fortune_telling` のような単語で最長15文字。catalogを広げた時点で本番のseedが落ちていた。migration 0004で `varchar(32)` に広げた。**列幅は、これから入れるデータの実測から決める。**
- **AtCoder Weekday Contest（awc）は再掲ではない。** 780問すべて固有の問題ID。同名は偶然の3件だけ。再掲なのは AtCoder Daily Training（1,472問）のほう。最初に逆を伝えていた。
- **`abs`（Beginners Selection）は条件に足しても1問も増えない。** 選抜コンテストなので、AtCoder Problems上では元のABCの問題として登録されている。唯一そこに無い1問目は `practice` コンテストにある。
- **Neonの無料枠の天井は容量ではなくcompute時間。** 月100 CU-hours ≒ 0.25 CUで400時間。1か月730時間なので、24時間使われ続けると17日目で止まる。0.5 GBのほうは4,764問で1MB程度と余裕がある。
- **pgのsslmode警告は「将来弱くなる」予告。** 現在 `require` は `verify-full` として扱われるが、pg 9で libpq の意味（検証しない）へ変わる。

# Misunderstandings corrected

- **Auth.jsは同じメールアドレスでもproviderをまたいでuserを結合しない。** `allowDangerousEmailAccountLinking` が既定でfalse。GitHubで登録した人が同じメールでGoogleから入ると `OAuthAccountNotLinked` になる。ADR-0009に「同じemailなら同じusers行になる」と書いていたのを訂正した。
- **awcの性質**（上記）。
- **Neonのプロジェクトは単体で作るものではない。** Vercelと組むなら Vercel Marketplace の統合から作る。`DATABASE_URL` にpooled接続文字列が自動で入る。
- **Neonは配備の直前まで要らない。** 実装はローカルのPostgreSQL 18で最後まで進む。最初に「先に人がやる作業が2つ」と伝えたのは強すぎた。

# Decisions

- 公開構成は **Vercel + Neon**（`decisions/2026-09-09-vercel-and-neon-for-the-practice-side.md`）
- 書き込みは全てログイン必須。localStorageとDBの二重保存を作らない
- localStorageの既存セットは引き継がない
- 作成者名は「ユーザー名」（`users.display_name`）。AtCoder IDは自己申告の別項目のまま
- AC記録はセット単位 `(user_id, set_id, problem_id)`
- 「使用回数」は廃止。「人気順」はいいね数へ、重複する「いいね順」を選択肢から外す
- catalogは ABC/ARC/AGC/AWC + JOI + 常設練習セットで4,764問。ADT・大学自主コン・AHCは除外
- localStorage版の先行公開はしない（ADR-0010でOption Gを却下）
- 対戦は `redirects()` で `/discover` へ寄せて棚上げ。コードは残す

# Project state changes

`current-state.md`、`next-actions.md`、`architecture.md` を全面的に更新した。localStorage前提の記述はすべて古い。

# Knowledge candidates

- `inbox/free-postgres-tiers-fail-in-opposite-ways.md`
- `inbox/oauth-providers-do-not-merge-accounts-by-email.md`

# Open questions

- Googleを足すか。足すならprovider取り違えの案内をどうするか
- Preview deployが本番と同じDBを触る（Neon Previews Integrationは未導入）
- 練習画面（`/practice/[setId]`）は未着手。詳細画面のボタンはdisabledのまま
- 対戦を戻す時期と、そのときのホスティング
