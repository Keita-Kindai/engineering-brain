# Engineering Brain Protocol

この file が Agent-neutral な運用 Protocol の Source of Truth です。`AGENTS.md`、`CLAUDE.md`、各 Skill は薄い entry point としてこの Protocol に従います。

## Objective

Engineering experience を保存し、再利用可能な memory に蒸留し、必要なときだけ検索して小さな Context へ入れます。Brain 全体を毎 Session 読み込むことは失敗です。

```text
Raw experience -> distillation -> structured memory -> selective retrieval -> reuse
```

## Resolve the Brain root

Skill から利用するときは、読み込まれた canonical `SKILL.md` の real path を基準に `agent-tools/skills/<skill>/../../..` を Brain root とします。Symlink 経由で path が不明な場合は、次の順に解決します。

1. `ENGINEERING_BRAIN_ROOT`（設定されている場合）
2. 現在の Agent の global skill link（`~/.agents/skills/<skill>` または `~/.claude/skills/<skill>`）の real path
3. Current repository 内の `BRAIN.md`

Root を一意に特定できなければ書き込みを行わず、global installer の実行を案内します。Tracked file に machine-specific absolute path を保存しません。

## Progressive retrieval

1. Task の intent と memory type を決める。
2. 対応する小さな `README.md` / index を読む。
3. `rg` で title、metadata、本文の候補を絞る。
4. Minimum relevant files だけを読む。
5. 足りない場合だけ隣接 memory へ広げる。
6. `sessions/archive/` は過去の試行や失敗を明示的に尋ねられた場合だけ検索する。

通常は `knowledge/` 全文、全 Project、全 Session、`.private/` を一括走査しません。Private memory は User が明示した場合、または local project registry が対象 Project を指す場合だけ検索します。

## Local-first policy

自分の復習、安定した基礎知識、過去の Project context は local memory を出発点にします。次の場合だけ authoritative external source を調べます。

- User が latest / current / verify を求めた。
- 高 volatility の内容が古い可能性がある。
- Local memory が不足、矛盾、または明らかに outdated。

External source と local memory に差があれば区別して説明し、Knowledge を自動更新しません。更新は candidate または maintenance report として提示します。

## Memory ownership and write boundaries

### `knowledge/`

Human が理解した semantic memory です。`brain-capture` で `inbox/` から統合します。Coding 中に見つけた知識は、勝手に大幅反映せず `inbox/` の Knowledge Candidate にします。

Metadata は `title`、`created`、`last-reviewed`、`confidence`、`volatility` を基本とし、必要な field だけ追加します。本文 section は強制しません。

### `agent-memory/`

次回の Agent がより速く正確に作業する procedural memory です。Agent-neutral なものは `shared/workflows`、`shared/lessons`、`shared/preferences`、Host 固有のものだけ `codex/` または `claude/` に置きます。Engineering と無関係な個人情報は保存しません。

### `projects/`

登録済み Project だけを扱います。`current-state.md` は現在を短く復元する snapshot であり、履歴ではありません。実質的な変更があった file だけ更新します。

Project identity は Git root、normalized `remote.origin.url`、directory basename を候補にし、`projects/README.md` と各 `overview.md` を検索します。Machine-local absolute path の対応は `.local/project-registry.tsv` に置けます。Private Project は `.private/projects/<project-id>/` に置き、public index に private detail を書きません。

未登録 Project は勝手に登録せず、User に「Engineering Brain にこの Project を登録しますか？」と確認します。

### `projects/<project>/decisions/`

User / team が採用した重要判断だけを記録します。Proposal や Agent の推測を accepted decision として保存しません。Context、alternatives、reason、trade-offs、date を可能な範囲で残します。

### `sessions/`

Raw transcript ではなく蒸留 Summary だけを保存します。明示的な `brain-learn`、または non-obvious failure、reusable workflow、重要な誤解修正、major project change、accepted decision があった Session に限定します。

Recent summary は `status: active` または `status: distilled` を持ちます。他領域へ十分蒸留された古い summary は削除せず `sessions/archive/YYYY/` へ移し、通常検索から外します。

## Project memory shape

登録時は必要に応じて次を作ります。

```text
projects/<project-id>/
  overview.md
  architecture.md
  current-state.md
  constraints.md
  next-actions.md
  decisions/
```

すべてを毎回更新しません。Decision directory には accepted decision だけを置きます。

## Privacy boundary

Public tree に credentials、API keys、tokens、passwords、private source code、confidential company information、unpublished sensitive research、不要な個人情報、raw conversations、private project details を書きません。該当内容は保存しないか `.private/` / `.local/` に置きます。

`.gitignore` を信用し切らず、Commit 前に staged file list と staged content を確認します。すでに Git history に入った秘密は `.gitignore` では消えません。

## Change and review policy

Memory を変更した Agent は、関連 index も小さく更新し、validation、`git status --short`、diff の要約を提示します。自動で stage、commit、push しません。Unrelated な User changes を変更しません。

## Session lifecycle

```text
brain-continue (when needed)
-> retrieve minimum relevant memory
-> coding / investigation
-> brain-learn only when explicit or important
-> classify and distill
-> show diff
-> User review and manual commit
```

## Maintenance lifecycle

`brain-maintenance` は volatility と `last-reviewed` から候補を絞り、必要なものだけ authoritative source と比較し、`maintenance/reports/` に report を作って停止します。Knowledge 本文や review date は User が更新対象を選ぶまで変更しません。Scheduler はこの repository の責務に含めません。

