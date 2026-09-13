---
title: Keep the highest-frequency read off a metered database
created: 2026-09-09
last-reviewed: 2026-09-09
applies-to: shared
---

# Lesson

従量課金またはcompute時間で頭打ちになるDBを使うとき、**一番回数の多い読み出しがどれかを先に数え、それがDBを叩く必要があるかを問う。** 変わらないデータへの検索なら、buildに同梱した固定データを読ませ、DBは参照整合性と「現在の値」を返すJOINに使う。

# Why

Serverless + 従量DBでは、**課金と可用性の天井をclick数ではなくquery頻度が決める。**

Custom Contestの例。問題検索は入力250msごとに走る、アプリで最も回数の多い処理だった。これをPostgreSQLに当てると、誰かが問題を探しているあいだcomputeが起きたままになる。Neon無料枠は月100 CU-hours（0.25 CUで約400時間）で、1か月は730時間。連続利用で17日目に止まる。止まるのは容量ではなく時間のほう。

カタログはdeployのあいだ変わらない固定データなので、DBを経由して得るものが無かった。

# How to split

同じデータを2か所に置くことになるが、**書き手を1つに限れば破綻しない。**

- 固定JSON: buildに同梱。最頻の検索がここだけを読む
- DBのtable: 外部キーの参照先と、表示時のJOIN。deployごとにseed scriptが同じJSONからUPSERTする

この分割で、丸ごとコピーの欠点（作成時点の値が凍る）も同時に消える。セット表示はJOINなので、元データの更新が過去の作成物へ届く。

# Boundary

固定JSONで書けない条件（作成者で絞る、全文検索、集計）が要るようになったら、検索をDBへ移す判断をし直す。そのときはキャッシュの失効設計が伴う。

Seedは**deployのたびに自動で走らせる。** 手動にすると忘れたときに外部キー違反で保存が失敗し、しかもdeploy自体は成功するので気づきにくい。
