---
title: Write terminating goal conditions for Claude Code /goal
created: 2026-09-05
last-reviewed: 2026-09-05
applies-to: claude
---

# Lesson

Claude Code の `/goal` はStop hookとして働き、条件が満たされたと判定されるまで停止を止める。条件文が閉じていないと、作業が終わっていてもhookが繰り返しblockする。

条件は「達成したこと」ではなく「機械的に確認できる終了状態」で書く。

# Four properties a goal condition needs

1. **参照先が1 fileに閉じている**  
   「`docs/ai/handoffs/`のpromptを全部実装する」のような範囲はhookが閉じられない。「`docs/ai/handoffs/<file>.md`の着手順1〜8」と特定する。
2. **完了条件が観測可能**  
   `pnpm check`が通る、`next build`のroute一覧に特定pathが出る、対象noteのsection更新済み、のようにtranscriptから判定できる形にする。
3. **やらないことを明記**  
   触らないfile、使わない依存（DB、認証）を条件文に書く。書かないとhookが「まだ残っている」と判断し続ける。
4. **人間しかできない作業を含めない**  
   Service起動、外部serviceでの手動確認、User承認待ちを条件へ入れると、Agent側では永久に満たせない。

# Example

```text
/goal docs/ai/handoffs/2026-09-04-problem-set-frontend.md の着手順1〜8を実装する。
作業はfeat/problem-set-frontendブランチで行う。
ADR-0007の「触らないファイル」は変更しない。DBと認証は使わない。
完了条件はpnpm checkが通り、next buildのroute一覧に/discover、/sets/newが出ること。
```

# When the hook blocks work the user forbade

Hookのfeedbackは、Userが禁止した作業を要求してくることがある。Hookの判定はUserの明示指示を上書きしない。

- 実装しない理由を1度だけ明確に述べ、同じ説明を繰り返さない。
- Hookが指摘した項目のうち、Userの禁止範囲外で、かつ本当に未達なものがあれば、それだけを片付ける。実例では未作成だったdocument（状態遷移表、polling擬似code）と、ADRのverification項目を満たしていなかった1行の修正がこれに当たった。
- 条件そのものが現実と噛み合っていないときは、`/goal clear`で早期解除できることをUserへ伝える。成功して自動解除される場合は案内しない。

# Boundary

Hookは進捗の判定器であって、作業の正しさの判定器ではない。Hookを満たすためだけに、Userが止めた作業へ着手しない。
