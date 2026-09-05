---
title: Adding a second visual identity and frontend to an existing app
date: 2026-09-05
status: active
project: custom-contest
---

# Goal

対戦機能が完成済みのapplicationへ、性格の異なる2つ目の機能群（問題セットの発見・作成・管理）をfrontendだけで足す。既存機能のdemoを壊さず、後からdatabaseへ移行できる形にする。

# What happened

- 別Agentが完成させたbackendをまず読み、docs、HTTP API、userscriptの判定検知経路を確認した。`pnpm check`が通ることを実測してから新規作業へ入った。
- 受領した2つのdesign成果物が、dark + 緑 と light + 橙で前提から違うことを突き止めた。統一せず、primitive共有の2 skinで進めるADRをUserの判断を得て確定した。
- Zod schema、固定問題catalog、server側検索endpoint、repository interface、4画面を実装した。Databaseと認証は使わず、fixtureとbrowser内保存で満たした。
- Production buildをbrowserで開き、作成flowを通しで操作して確認した。この確認で2件の不具合を発見・修正した。
- 作業branchへcommitしたが、途中でworktreeが外部から別branchへ切り替わっており、後続のdocument commitを他人のbranchへ載せてしまった。

# What worked

- 実装前にdesignの章構成を抽出し、後の章が前の章を上書きしている箇所（作成flowが条件生成から検索追加へ変更）を先に特定した。古い章のまま作らずに済んだ。
- Design成果物のなかにあった「どこでgame表現を使い、どこで使わないか」の指定が、2つのskinを共存させる根拠そのものだった。設計判断を自分で発明せずに済んだ。
- Fixtureを実catalogから生成し、内容と一致しない名前のsetは名前のほうを直した。「二分探索まとめ」は判定できないため「ABC D 早解き7問」のような、抽出条件で説明できる名前へ変えた。
- 3295問・約470KBのcatalogをclientへ配らず、Route Handlerで検索して上位20件だけ返した。将来のDB移行がhandler内部の差し替えで済む形になった。
- Repository interfaceを1枚挟んだことで、画面側のcodeがfixtureかDBかを知らずに済んだ。

# What failed

- 新しいCSSのclass名5つが既存のglobal stylesheetと衝突し、Difficulty badgeが入力欄のような枠付きで描画された。Build、type check、lintはすべて通っていた。
- Discoverの一覧に下書きが出ていた。自分の下書きだからと可視判定へ含めたのが誤りで、下書きはlibraryからだけ辿れるのが正しい。
- Catalogの既定の並びが古いcontest順で、先頭がDifficulty推定のない問題ばかりになった。新しい回が先に出るよう並びを変えた。
- Effect内の同期`setState`をlintが拒否した。再取得中もloadingへ戻さず前の結果を出したままにすることで、lintも表示のちらつきも同時に解消した。
- 同じportへserverを起動し直す際、前のprocessが残っていて2回起動に失敗した。`lsof`でPIDを確認してから起動する必要があった。
- Branch切り替えに気づかず、「fileが元に戻った、記録が失われた」と誤診してUserへ報告し、後から訂正した。

# Important discoveries

- 2つのdesign成果物の余白scaleは偶然ほぼ同一（4px基準の4/8/12/16/20/24/32/48/64）で、その層はそのまま共有できた。色の印象が違っても下地は一致していることがある。
- AtCoder Problemsは、EDPC・典型90・鉄則のようなrated外の問題にDifficulty推定値を持たない。古いcontestは`is_experimental`で推定値が信頼できない。合わせて788問。除外せず「—」として検索対象に残す判断にした。
- Difficultyの色帯は、brand accentと同じ色相を避けて設計されていた。色だけに依存させず、色ドット・数値・色名の3点を併記する指定も含まれていた。
- 一括renameでCSS custom property（`--difficulty-color`）とobject key（`difficulty:`）とcamelCase識別子（`difficultyBand`）を巻き込む危険がある。置換対象をclass名の出現位置に限定する必要がある。
- Template literal内の`` `foo foo-${key}` ``は単語境界に合わず、regex置換から漏れる。置換後の確認が必須。

# Misunderstandings corrected

- 「handoff noteの記録が失われた」は誤り。自分のcommitは元のbranchに無傷で残っており、別branchがcheckoutされていただけだった。`git log --all`で確認すれば分かる。
- Stop hookが「未実装がある」と繰り返した件で、hookの判定をUserの明示的な禁止より優先しかけた。Hookは進捗の判定器であって、作業の正しさの判定器ではない。

# Reusable lessons

- [Namespace CSS when adding a second skin](../../agent-memory/shared/lessons/namespace-css-when-adding-a-second-skin.md)
- [Share token primitives across two visual identities](../../agent-memory/shared/lessons/share-token-primitives-across-visual-identities.md)
- [Confirm branch identity before committing](../../agent-memory/shared/lessons/confirm-branch-identity-before-committing.md)
- [Write terminating goal conditions for Claude Code /goal](../../agent-memory/claude/write-terminating-goal-conditions.md)
- Demo用fixtureは実dataから生成し、内容と一致しない名前は名前のほうを直す。分類を判定できないなら、抽出条件で説明できる名前にする。
- 静的checkが全部通っていることは、visual verificationの代替にならない。この Session の2件の不具合はどちらもbrowserで見て初めて分かった。

# Project state changes

Project `custom-contest` をこのSessionで Engineering Brain へ登録した。精進側のfrontendが動く状態、browser内保存しかない制約、認証とstep数が決まるまでDB永続化へ進まない判断を `projects/custom-contest/` へ反映した。

# Open questions

- 認証方式が決まるまで、作成者名・いいね数・公開範囲は見せかけのままになる。UIを先に作る判断は妥当だったか、実data導入時に作り直しが出ないか。
- 作成画面をstep式にするか1画面のままにするかは、design側が「次のラウンドで確定」としており未決。
- `is_experimental`のDifficulty推定値を伏せる現在の扱いは、利用者にとって「—」が多すぎないか。
- Browser内保存しかない状態で、別端末から開けない制約をどこまで画面で説明すべきか。
