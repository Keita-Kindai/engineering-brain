---
project: custom-contest
updated: 2026-09-05
---

# Constraints

# 外部サービス

- AtCoderの提出判定は公開APIではない。undocumentedな認証済みendpointを読むため、2人の招待制demoという低負荷・自分のdataの範囲に留める
- active Match中のAtCoderへの要求は5秒に1回の非重複loopだけ。到達確認は最大15秒に1回
- AtCoder Problemsは呼び出し間に1秒以上のsleepを求めている。取り込みはoffline generatorだけで行い、runtimeでは呼ばない
- AtCoderは1人1アカウント。対戦の検証は各本人のアカウントで行う
- 実data検証は `Litms` またはその場で明示的に許可された相手だけ。無関係な第三者の公開提出をtest dataにしない
- 提出のsource code本文とcode長は取得・送信・保存しない

# 実行環境

- Node 24.19.0 / pnpm 11.19.0。shellの既定Nodeと異なるため明示的に切り替える
- PostgreSQL 18はHomebrew管理。`brew services start`の成功表示はdatabase readinessを意味しない

# 開発の進め方

- `main`へ直接commit、push、mergeしない。Issue → branch → `pnpm check` → PR → Userがmerge
- 対戦側と精進側は担当が分かれる。相手の担当fileを書き換えない
- API・eventを変える前に `packages/contracts` を先に更新する
- 依存追加は `docs/security/dependency-policy.md` に従い、inventoryへ記録する
