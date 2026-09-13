---
type: knowledge-candidate
title: OAuth providers do not merge accounts by email
created: 2026-09-09
source: Custom Contest の認証実装（Auth.js v5 + DrizzleAdapter）
---

# Mental model

OAuthを2つ以上受け付けるとき、**providerのIDとアプリのユーザーIDは別物**で、`accounts` tableが翻訳表になっている。

```text
GitHub の数値ID ─┐
                 ├─ accounts (provider + provider_account_id) ─→ users.id
Google の sub  ─┘
```

同じ人が両方で入ると `accounts` は2行、`users` は1行になる **ように見える** が、**Auth.jsは既定でそれをしない。**

# 何が起きるか

`allowDangerousEmailAccountLinking` は既定でfalse。GitHubで登録済みの人が同じメールでGoogleからログインすると、行が結合されず `OAuthAccountNotLinked` で失敗する。

**既定がこうなっているのは安全のため。** providerがメールの所有を検証していない場合、他人のメールを名乗るだけで既存アカウントを乗っ取れる。自動結合はその経路を開く。

# 結果として選べるのは3つ

1. **providerを1つに絞る**（対象者が確実に持っているもの。競プロならGitHub）
2. **両方出して、取り違えた人へ「別の方法で登録済みです」と案内する**
3. **ログイン後に明示的な連携画面を作る**（既にログインしている状態で第2のproviderを繋ぐ。これなら本人確認が済んでいる）

**追加した時期は関係ない。** あとからGoogleを足しても、最初からGoogleがあっても、同じ衝突が起きる。

# 実装上の副次

- providerを増やすのはコード変更ではなく環境変数の追加で済む（環境変数が揃っているproviderだけを一覧に出す作りにしておく）
- OAuthの表示名（`users.name`）は**次回ログインでproviderの値に上書きされる**。利用者が決めた名前は別の列（`display_name`）へ置く
- 1つのOAuth Appにcallback URLは1つ。localhost用と本番用でAppを分ける
