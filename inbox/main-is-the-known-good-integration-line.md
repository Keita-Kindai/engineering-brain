---
type: knowledge-candidate
title: Main is the known-good integration line, not a workbench
created: 2026-09-04
source: Custom Contest Git workflow decision
---

# Mental model

```text
Issue = 何を、なぜ、どこまで行うか
branch = 未完成の変更をmainから隔離する場所
check = 機械的に壊れていないことを確認する門
PR = mainへ入る差分を人が確認する場所
main = それらを通過した既知の正常状態
```

branchを作ること自体はmainを保証しません。GitHub側で直接pushとforce pushを禁止し、Pull RequestとCI成功を必須にすることで、手順を「お願い」から「強制される仕組み」へ変えます。

一人開発ではapproval 1件必須にすると、自分のPRを自分で承認できず進めなくなる場合があります。最初はPR必須、CI必須、最終mergeはUserが明示判断する運用にし、別reviewerが参加した時点でapproval必須へ強化します。

# 事故時

main上に未commit変更があるだけなら、内容を消さず、その場で新しいbranchを作れば変更は引き継がれます。すでに共有mainへpushした場合は、安易なresetやforce pushで履歴を書き換えず、revertなどの追跡可能な復旧を選びます。

# Review questions

1. 編集前に現在branchとdirty stateを確認したか。
2. Issueの完了条件とPRの検証結果が対応しているか。
3. CIが実際にrequired status checkとして設定されているか。
4. UI変更の画像は実browserで観測され、秘密や個人情報を含んでいないか。
5. AgentがUserの許可なくmergeしようとしていないか。
