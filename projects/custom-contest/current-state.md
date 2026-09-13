---
project: custom-contest
updated: 2026-09-09
---

# Current state

## Working now

- **精進側が公開されている。** <https://custom-problems.vercel.app>（Vercel + Neon）
- GitHub OAuthでログインでき、問題セットの作成・編集・削除・いいね・保存・AC記録がアカウントに残る。別の端末からも開ける
- 公開範囲が実際に効く。非公開は本人のみ、限定公開はURLを知る人のみ、Discoverには公開済みの公開のみ
- 問題カタログ4,764問（ABC/ARC/AGC/AWC + JOI + EDPC・典型90・鉄則・数学・practice）。週次workflowが再生成し、新しい問題があればPRを作る
- `pnpm check` は通る。unit test 14件がpass
- **対戦（AC Duel）は棚上げ。** `/` と `/battle/*` を `/discover` へ307転送している。コードは1行も消していない。画面の内容と戻し方は [[shelved-battle-feature]]

## In progress

- 練習画面（`/practice/[setId]`）は未着手。セット詳細の「このセットで練習する」はdisabledのまま
- Googleを足すかは未決。providerを2つ出すと、取り違えた人が `OAuthAccountNotLinked` になる
- `fix/pin-ssl-mode` が未merge。pgのsslmode警告への対応で、現在の動作には影響しない

## Blockers

- **Neon無料枠の天井はcompute時間。** 月100 CU-hours（0.25 CUで約400時間）で、連続して使われると17日目あたりで止まり翌月まで戻らない。容量0.5 GBのほうは4,764問で1MB程度と余裕がある。usage画面を見る運用が要る
- **Preview deployが本番と同じDBを触る。** Vercel Marketplace統合がProductionとDevelopmentへ同じ `DATABASE_URL` を入れるため
- Vercel Hobbyは非商用限定。収益化した時点で有料プランへ移る
- PostgreSQL integration testは `DATABASE_URL` 未設定の環境でskipされる。`pnpm check` は環境変数を読まないので、CIでも常にskipされている
- userscriptのDOM selectorは自動testで保証できない（対戦を戻すときに再び関係する）

## Recurring hazard

**HEADが `main` に戻っていることに気づかず作業する事故がこのProjectで繰り返している。** 復旧は [[keep-main-green-through-issue-branches]]。退避branchを作るところまでは通るが、`git reset --hard` と `git switch` はpermission classifierに拒否されるため、そこから先はUserの手作業になる。
