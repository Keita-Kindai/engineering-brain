---
title: Ship the practice side first, on Vercel and Neon
date: 2026-09-09
status: accepted
---

# Decision

精進（問題セット）側を先に公開し、対戦（AC Duel）は後回しにする。公開先はVercel、DBはNeon。

- 対戦の入口は `next.config.ts` の `redirects()` で `/discover` へ寄せる。コードは消さない
- Neonのプロジェクトは Vercel Marketplace の統合から作る（`DATABASE_URL` がpooledで入る）
- localStorageのままの版は先に公開しない
- 書き込みはすべてログイン必須。認証は既存のAuth.js（GitHub OAuth）をそのまま使う

Repository内の正本は `docs/decisions/0010-practice-first-deployment-and-database.md` と `0011-problem-set-persistence.md`。

# Context

ADR-0009はVercelを退けていた。理由はRoom stateが `apps/web/src/server/rooms/store.ts` のprocess内Mapにあり、serverlessでは複数instanceへ分かれて消えるから。代わりに常駐process（Fly.io / Render）+ Neonを選んでいた。

公開の順番が精進側先行に変わったことで、この前提が外れた。**精進側はprocess内に状態を持たない。** 問題セットはlocalStorage、server処理は固定カタログを読む `/api/problems/search` だけ。今のコードのままserverlessで動く。

同時に、ADR-0009が挙げた無料枠が2026-09時点で成立しなくなっていた。Fly.ioは2024-10以降、新規アカウントに無料枠がない。Renderの無料PostgreSQLは作成から30日で期限切れになり、猶予14日のあとデータごと削除される。

# Alternatives considered

- **Vercel + Supabase**: ChatGPTとの相談でもう1つの候補として挙がっていた
- **Vercel + Neon**（採用）
- **Cloudflare Workers + D1**: 無料枠は寛容だがSQLiteなので、PostgreSQL前提のADR-0005・0009を書き直すことになる
- **常駐process host**（ADR-0009の当初案）: 上記のとおり無料枠が消えた
- **DBなしでlocalStorage版を先に公開**: URLを早く渡せるが、引き継がない以上、試した人のセットが切り替え時に全部消える

# Why

Supabaseとの比較は3点で決まった。

1. **Auth.jsを残すと、Supabaseの利点がStorageとRealtimeだけになる。** 認証は実装済みで、画像アップロードの予定はなく、Realtimeは精進側に要らない。対戦側はRoom stateがprocess内にある以上どのみち書き直しになるので、Realtimeがあっても解決しない。
2. **使われ方が読めない。** 一般公開する以上、まったく使われない期間もありうる。Supabase無料は1週間の無操作で停止し、手動再開まで動かない。公開直後に黙って止まっているのが最も避けたい壊れ方。
3. **VercelはNeonを推奨DBにしている。** Vercel Postgresを2024-12にNeonへ移した。serverless driverがHTTPで通信するのでpooling設定が要らない。

localStorage版の先行公開を採らなかったのは、得られるのが「URLを早く渡せる」ことだけで、DBの作業は結局あとで全部やるため。順番が入れ替わるだけで、告知が2回になり、試した人のセットが消える。

# Trade-offs

- **Neonの天井はcompute時間。** 月100 CU-hours ≒ 400時間。連続利用だと17日目で止まる。使われすぎたときに壊れる形を、使われないときに壊れる形より選んだ。人気が出たら従量課金へ移れば済み、Supabase Proのような月$25の段差もない
- **Vercel Hobbyは非商用限定。** 収益化した時点で有料プランへ移る
- **対戦側はこの構成に載らない。** 戻すときはRoom stateを外部storeへ移すか、常駐processへ月数ドル払うかを選び直す（別ADR）
- **Preview deployが本番と同じDBを触る。** Marketplace統合がProductionとDevelopmentへ同じ `DATABASE_URL` を入れるため
- 最頻の読み出し（問題検索）をDBから外す設計が要る。カタログが固定JSONとDBの2か所に載る（[[keep-the-hottest-read-off-a-metered-database]]）
