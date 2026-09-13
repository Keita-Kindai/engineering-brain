---
type: knowledge-candidate
title: Free Postgres tiers fail in opposite ways
created: 2026-09-09
source: Custom Contest deployment platform choice (2026-09時点で確認)
---

# Mental model

無料のmanaged Postgresを比べるとき、見るべきは容量ではなく**どう壊れるか**。2つの代表的な壊れ方は正反対で、どちらが致命的かはアプリの使われ方で決まる。

```text
使われない期間がある  ->  Supabase が止まる
使われすぎる          ->  Neon が止まる
```

# 2026-09時点の具体

**Supabase Free**: APIリクエストが1週間ないとプロジェクトが**一時停止**する（2026-02-01に明文化）。データは残るが、**手動で再開するまでサイトが動かない**。停止から約90日でワンクリック復旧ができなくなる。compute時間の上限はない。

**Neon Free**: 5分の無操作でcomputeがゼロへ落ちるだけで、次のqueryで自動的に戻る。無操作を理由にプロジェクトを消す規定は文書にない。代わりに**月100 CU-hours**の上限があり、0.25 CUなら約400時間。1か月は730時間なので、連続して使われると17日目あたりでcomputeが止まり、翌月まで戻らない。容量は0.5 GB。

# 判断の順序

1. **使われ方が読めるか。** 社内ツールで毎日触るならSupabaseの停止は起きない。一般公開で読めないなら、静かな期間で死ぬほうが危険。公開直後に黙って止まっているのは、最初に来た人を永久に失う壊れ方。
2. **付属機能を使うか。** Supabaseの価値の中心はAuth・Storage・Realtime・RLS。認証を別に実装済みなら、SupabaseはただのPostgresになり選ぶ理由が薄い。RLSを使うにはSupabase Authのトークンが要るので、認証ごと乗り換える前提になる。
3. **超えた先の形。** Supabase Proは月$25の定額（段差）。Neonは従量（傾斜）。

# 副次

VercelはVercel Postgresを2024-12にNeonへ移し、現在Neonを推奨DBにしている。Vercelと組むなら、Neonのプロジェクトは**Vercel Marketplaceの統合から作る**。`DATABASE_URL` にpooled接続文字列が自動で入る。serverlessから非pooledで繋ぐと接続が枯渇する。

統合はProductionとDevelopmentへ同じ `DATABASE_URL` を入れるので、**Preview deployが本番と同じDBを触る**。PRごとに使い捨てDBが要るなら別途Previews Integrationが要る。

# Volatility

高い。無料枠の条件は年単位で変わる。採用前に一次情報で確かめ直す。

- <https://neon.com/docs/introduction/plans>
- <https://supabase.com/docs/guides/platform/free-project-pausing>
