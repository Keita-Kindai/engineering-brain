---
type: knowledge-candidate
title: External service use starts with rules, purpose, and a request budget
created: 2026-09-04
source: Custom Contest AtCoder integration review
---

# Mental model

外部サービス連携は「技術的に取得できるか」だけでは判断しない。

```text
公式規約・個別ルール・API文書を読む
→ 何のために、誰の、どのデータを使うか決める
→ request頻度・同時実行・retry・保存を数える
→ 明確な禁止／技術的推測／未解決を分ける
→ 懸念をUserへ示し、曖昧または高影響なら別Agentでも再確認
→ 小さい範囲で実装し、公開・拡大前に再審査
```

公開Web上の規約や技術情報を調べることと、特定ユーザーの活動データをアプリへ取り込むことは別です。後者はUser本人のデータ、または対象を明示して許可されたものを優先し、必要なfield、利用理由、送信先、保存期間を先に説明します。

# 今回の具体例

AtCoderResultNotifierはPending提出のIDをDOMから得て、Pending中だけ5秒ごとに判定JSONを確認します。Custom Contestの初期版は提出の自動発見のため、提出一覧HTMLを5秒ごとに読み、Pending時にはJSONも追加取得していました。timerが同じでもrequest数とpayloadは同じではありません。

監査後は、対戦中のAtCoder通信を提出一覧HTMLの最大5秒に1回へ絞り、待機中は到達確認を最大15秒に1回としました。失敗時は10、20、40、最大60秒へ間隔を延ばし、認証拒否や`429`では直ちに60秒へ延ばします。ただし提出一覧とstatus JSONは公式公開APIとして文書化されていないため、参考userscriptの存在だけで公式許可済みとは判断できません。2人招待制デモの低負荷運用と、公開・多人数サービスの判断は分けます。

AtCoder ProblemsのAPI文書はアクセス間に1秒より長いsleepを求めています。問題pool生成はruntimeから切り離し、2 resourceを1.1秒空けて逐次取得する形が適切です。

AtCoder規約は1人1accountとaccountの貸与・共有禁止を明記しています。複数人テストでは1人が予備accountを作るのではなく、各参加者が本人のaccountを使います。アクセス頻度だけを見ていると、このような別種類の制約を見落とします。

# Review questions

1. 公式sourceと第三者の実装例を区別できているか。
2. 「5秒ごと」を、request数・payload・継続時間・tab数まで展開したか。
3. 特定ユーザーのデータは誰のもので、なぜ必要か。
4. 不要な本文や識別情報を取得・送信・保存していないか。
5. 公開、多人数化、収益化、規約変更時の再確認条件があるか。
