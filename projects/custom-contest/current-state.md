---
project: custom-contest
updated: 2026-09-05
---

# Current state

## Working now

- 対戦（AC Duel）の招待制BO1が縦切りで完走する。Room作成・参加、READY、host開始、countdown、先着AC、Pending待ち、DRAW/VOID、Forfeit、再戦、完了MatchのPostgreSQL保存と再表示まで
- 実PC 2台とTampermonkeyでの手動rehearsalが1度成功している
- 精進（問題セット）のfrontendが動く。Discover、セット詳細、作成（Problems検索して追加）、編集、マイページ。DBと認証は使っていない
- `pnpm check` は通る。domain/API test 9件がpass

## In progress

- 精進側は `feat/problem-set-frontend` にcommit済みでpush待ち
- 問題セットはbrowser内保存のみ。別端末からは開けない
- 作成者名・いいね数・公開範囲は認証がないため見せかけの値

## Blockers

- 精進側のDB永続化は、認証方式（DESIGN-074）と作成画面のstep数（DESIGN-081）が決まるまで着手しない
- PostgreSQL integration test 2件は `DATABASE_URL` 未設定の環境ではskipされる
- userscriptのDOM selectorは自動testで保証できない。logged-inのTampermonkey環境での手動確認が必要
