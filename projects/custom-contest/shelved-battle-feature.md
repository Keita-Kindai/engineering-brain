---
project: custom-contest
updated: 2026-09-09
status: shelved
---

# 棚上げした対戦機能（AC Duel）

2026-09-09に、Custom Contestの表向きの入口から対戦を外した。精進（問題セット）側を先に公開し、対戦はそのあとで仕上げる方針になったため。

**コードは1行も消していない。** 消したのは入口だけで、画面もAPIもそのまま残っている。この文書は「何があったか」を後から思い出すためのもの。

## 何をしたか

`apps/web/next.config.ts`の`redirects()`に2本足しただけ。

```ts
{ source: "/", destination: "/discover", permanent: false },
{ source: "/battle/:path*", destination: "/discover", permanent: false },
```

`permanent: false`（307）にしてある。恒久リダイレクトはブラウザーが覚えてしまい、対戦を戻したあとも古い転送が効き続けるため。

あわせて外した導線は3つ。

- `apps/web/src/app/_practice/practice-shell.tsx`のヘッダー右にあった「対戦へ」リンク
- `apps/web/src/app/_practice/set-detail-view.tsx`のセット詳細サイドにあった「友達と対戦する」ボタン
- `apps/web/src/app/layout.tsx`のtitleを「AC Duel — 友達とAtCoder BO1」から「Custom Contest」へ

`/api/rooms/*`と`/api/userscript/*`は転送していない。userscriptが直接叩くため。

## 戻すとき

`redirects()`の2行を消し、上の3つの導線を戻す。それだけで元に戻る。

ただし戻す前に、公開先の制約を確認すること。Room stateがprocess内のMapにあるので、対戦はserverless（Vercel）に載らない（ADR-0003・ADR-0009・ADR-0010）。

## 対戦画面はどうなっていたか

招待制のBO1（1問先取）。全体の流れは Room作成 → 招待URL共有 → 両者READY → hostが開始 → countdown → AtCoderで解く → 先にACした側の勝ち。

### `/`（トップ）

`apps/web/src/app/page.tsx`。見出しは「1問だけ。先に通した方が勝ち。」。

- ボタン3つ: 「Roomを作る →」「IDで参加」「問題セットを探す」
- 右にデモ条件のパネル（`SUNDAY DEMO / すぐ遊べる範囲に固定`）。MODE=BO1 2人、POOL=ABC C/D 400–1200、JUDGE=userscript確認・カジュアル
- 下に`ProfileCard`（AtCoder IDの自己申告）と`RecentMatches`（直近の完了Match）

### `/battle/new`（Room作成）

`CreateRoomForm`。kickerは`CREATE ROOM`、見出しは「対戦条件を決める」。デモ用に選択肢を絞ってあった。問題は開始するまで両者へ送られない。

### `/battle/join`（参加）

`JoinRoomForm`。kickerは`JOIN ROOM`、見出しは「友達のRoomへ参加」。招待URLを受け取っていれば入力不要で、Room IDしかない場合だけ6桁を入れる。

### `/battle/r/[roomId]`（Room本体）

`BattleRoom`（`apps/web/src/app/_components/battle-room.tsx`、約23KB）。この機能の中心。1秒ごとにserverのsnapshotをpollingして、同じcomponentが状態ごとに別の画面を出す。

- **待機中**（`WAITING ROOM / 両者の準備を確認`）: 自分と相手のカードを並べ、それぞれにAtCoder ID、接続状況、`✓ READY`か`READY前`。相手が未着席なら「空席」と「招待URLまたはRoom IDを共有してください」。ボタンは「AtCoderと接続」「READY」、hostだけ「開始する」
- **開始直前**（`MATCH STARTS IN`）: 大きなcountdown数字。START前は問題名を出さない
- **対戦中**: `PROBLEM`欄にコンテストID・問題記号・問題名（問題文はAtCoder側で読む）。自分の提出一覧（「時間ペナルティなし」）。「対戦を終了する」欄に棄権ボタン
- **棄権の確認dialog**（`FORFEIT`）: 「棄権を確定すると、相手の勝利として保存されます。この操作は取り消せません。」
- **終了後**: 「再戦を申し込む」／「再戦を承認」
- **Room終了**（`ROOM CLOSED`）: 「このRoomは終了しました」
- 右上に常時「接続中 / 再接続中」の表示。再接続中も「タイマーは進み続けます」と明示していた

### `/battle/m/[matchId]`（結果）

`MatchResult`。Roomを再利用しても過去の結果を参照できるよう、Match専用URLにしてあった（DESIGN-008）。

### API

`/api/rooms`（作成）と`/api/rooms/[roomId]/`配下に `join` `leave` `ready` `start` `cancel-start` `forfeit` `rematch` `link-key` `problem-unavailable`。ACの検知は`/api/userscript/evidence`、接続確認は`/api/userscript/heartbeat`と`/api/userscript/link`。

## 覚えておくべき前提

- Room stateは`apps/web/src/server/rooms/store.ts`のprocess内Map。DBではない。だからserverlessに載らないし、server再起動で進行中のRoomは消える
- ACの判定はTampermonkey userscriptがAtCoderのページから拾って`/api/userscript/evidence`へ送る（ADR-0004）。userscriptのDOM selectorは自動testで保証できない
- 完了MatchだけPostgreSQLに保存する（ADR-0005）。保持期間は90日
- BO3は設計だけ済んでいて未実装（ADR-0008、`feat/bo3`branch）

## 関連

- `docs/decisions/0003-room-authority.md`（Room stateの正本）
- `docs/decisions/0004-submission-evidence.md`（AC検知）
- `docs/decisions/0008-bo3-series-model.md`
- `docs/decisions/0010-practice-first-deployment-and-database.md`（精進側を先に公開する判断）
- [[keep-main-green-through-issue-branches]]
