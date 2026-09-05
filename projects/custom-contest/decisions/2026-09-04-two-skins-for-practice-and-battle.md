---
title: Share token primitives and give practice and battle separate skins
date: 2026-09-04
status: accepted
---

# Decision

精進（問題セット）側と対戦（AC Duel）側を1つのdesign systemの2つのskinとして扱う。

- Primitive（余白、motion、type scale、z-index）は共有する
- Semantic（色role、書体）だけをskinごとに定義する。精進=light + 橙accent、対戦=現行のdark + 緑accent
- 作成画面はdesign 13章（AtCoder Problemsを検索して1問ずつ追加）を正とし、12章の条件生成は採らない
- 最初の実装ではPostgreSQLを使わず、repository interfaceの背後をfixtureとbrowser内保存で満たす
- top `/` と対戦側の画面には手を入れず、精進側は独立したrouteとして作る

Repository内の正本は `docs/decisions/0007-problem-set-frontend-boundary.md`。

# Context

2026-09-06のLAN demoへ向けて対戦側が完成し、`pnpm check` が通る状態にあった。そこへ問題セットのdesignを受領したが、対戦側は`color-scheme: dark`固定で緑accent、精進側のdesignはlight標準で橙accentと、前提が異なっていた。和文書体も違う。

# Alternatives considered

- **単一skinへ統合**: 精進をdarkへ寄せるか、対戦をlightへ作り替える
- **別applicationに分ける**: 精進を独立したNext.js appにする
- **primitive共有の2 skin**（採用）

# Why

受領したdesignの10章が「どこでgame表現を使い、どこで使わないか」を明示していた。精進側は静かなcontent platform、対戦側はgame、という二面性が設計意図そのものであり、見た目を揃えることはその意図に反する。

単一skinへ寄せると、どちらかのdesign成果物が実装の参照元として使えなくなる。特に対戦側は高忠実度で実装済みで、日曜demoの対象でもあった。

別applicationに分けると、最終目標である単一platformから遠ざかり、navigationと認証を二重に持つことになる。

既存の`tokens.css`が変数をrole命名にしていたため、この分離は対戦側のCSSを1行も書き換えずに後付けできた。2つのdesignの余白scaleが偶然ほぼ一致していたことも、primitive共有を後押しした。

# Trade-offs

- Token集合を2つ維持する必要がある
- Platformとしての統一感は単一skinに劣る。接合部（「友達と対戦する」を押した瞬間の遷移）で二面性を説明する必要がある
- 対戦の抽選poolと精進の検索catalogが当面別のfixtureとして併存する。統合はDB導入時
- 認証がないため、公開範囲のUIは作られるが実際のaccess制御は効かない
