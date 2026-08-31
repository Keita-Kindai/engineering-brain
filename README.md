# Engineering Brain

自分と Coding Agent が長期的に共有する、Markdown と Git ベースの Engineering External Brain です。履歴を大量に読み込むのではなく、経験を蒸留し、必要な記憶だけを小さな Context で再利用します。

> Store more, read less, distill aggressively, retrieve selectively.

## Memory types

| 場所 | 内容 | 主な書き手 |
| --- | --- | --- |
| `knowledge/` | 自分が理解した技術知識 | Human 主導、`brain-capture` で統合 |
| `agent-memory/` | Agent が次回うまく作業するための手順・教訓 | Coding Agent |
| `projects/` | 登録済み Project の現在状態・制約・採用済み判断 | Human + Coding Agent |
| `sessions/` | 再利用価値が高い Session の蒸留 Summary | Coding Agent |
| `inbox/` | 整理前の Human Learning | Human |
| `maintenance/reports/` | Knowledge freshness の確認結果 | Coding Agent |

Private な Project や Note は `.private/`、machine-local な対応表などは `.local/` に置きます。両方とも Git の対象外です。

## Folder map

- [`BRAIN.md`](BRAIN.md): Agent-neutral な運用 Protocol（Source of Truth）
- `knowledge/`: Web、CS、Cloud、ML、AI Agent の Knowledge
- `agent-memory/shared/`: Agent-neutral な workflow、lesson、preference
- `agent-memory/codex/`, `agent-memory/claude/`: Agent 固有の記憶
- `projects/`: Public に保存できる登録済み Project memory
- `sessions/recent/`, `sessions/archive/YYYY/`: Recent / distilled session memory
- `templates/`: 軽量な Note、Project、Decision、Report templates
- `agent-tools/skills/`: 5 Skills の唯一の Source of Truth
- `.agents/skills/`, `.claude/skills/`: Repository 内 discovery 用 symlink

各主要 directory の `README.md` は本文ではなく、必要な file へ到達するための小さな index です。

## Typical workflows

Human learning:

```text
learn -> inbox/ -> brain-capture -> knowledge/ -> review diff -> commit manually
```

Coding session:

```text
brain-continue -> retrieve only relevant memory -> work
               -> brain-learn (important sessions only) -> review diff -> commit manually
```

Recall and maintenance:

```text
question -> brain-recall -> local memory -> external source only when needed
monthly  -> brain-maintenance -> report only -> human chooses updates
```

## Skills

| Skill | Purpose |
| --- | --- |
| `brain-recall` | 過去の Knowledge / Memory から必要部分だけ回答 |
| `brain-learn` | 重要 Session から再利用可能な Memory を蒸留 |
| `brain-continue` | 登録済み Project の Context を復元 |
| `brain-capture` | `inbox/` の Human Learning を Knowledge に統合 |
| `brain-maintenance` | 古くなった可能性のある Knowledge の report を生成 |

Codex では `$brain-recall`、Claude Code では `/brain-recall` のように呼び出します。説明に一致すれば暗黙に利用される場合もあります。

## Privacy and Git

- credentials、secrets、private source、confidential information、raw AI transcript は public tree に保存しません。
- `.gitignore` は最後の防壁ではありません。Commit 前に `git status`、staged diff、secret の有無を必ず確認します。
- Agent は commit / push しません。変更と diff を提示し、User の明示承認後に User が commit します。
- `knowledge/` は Human semantic memory です。Coding session 中に Agent が勝手に大幅更新せず、まず Knowledge Candidate として `inbox/` に置きます。

## Token efficiency

最初に index、次に `rg`、その後に候補 file だけを読みます。通常検索で repository 全体、`knowledge/` 全文、全 Session、`sessions/archive/` を読みません。Version 1 は Vector DB、Embedding、RAG、daemon を使いません。

## Getting started

```bash
./scripts/install-global-skills.sh
./scripts/validate.sh
```

Global installer は既存の同名 file を上書きせず、Codex の `~/.agents/skills` と Claude Code の `~/.claude/skills` に canonical skill への symlink を作ります。その後、新しい Agent session で `$brain-recall` または `/brain-recall` を試してください。

