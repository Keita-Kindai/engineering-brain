# Engineering Brain — Initial Implementation Request

これから `engineering-brain` という、私自身とAI Coding Agentが長期的に共有して利用する **Engineering External Brain / Long-term Memory Repository** を構築してください。

これは単なるメモRepositoryではありません。

目的は、

* 私自身が学んだComputer Science / Programming / Machine Learning / Cloud / AI Agent等の知識を長期保存する
* Codex / Claude Codeなどが、同じことを何度も調査せず過去のKnowledgeを再利用できるようにする
* Coding SessionからAI自身も「より良い作業方法」を学習する
* Projectの現在状態を保持して、別Sessionでも「昨日の続き」から再開できるようにする
* 過去の設計判断と理由を保持する
* 重要なSessionの成功・失敗を蒸留して再利用する
* 必要な情報だけContextへ入れ、不要なToken消費を避ける
* Codex固有ではなく、Claude Codeや将来のCoding Agentへ移行可能にする

ことです。

以下の設計判断はすでにユーザーとのGrillingで確定しています。

**再検討のための質問はしないでください。**
環境から調査できる事実は自分で調査し、実装してください。

ただし既存ファイルの破壊、秘密情報の公開、既存global設定の上書きなど不可逆・危険な操作が必要な場合は実行せず報告してください。

---

# 1. Core Philosophy

このRepository全体を、

> My Engineering External Brain

として扱います。

重要なのは「大量の履歴を毎回AIへ渡す」ことではありません。

基本原則は、

1. Experienceを保存する
2. ExperienceからReusable Memoryを蒸留する
3. 必要なMemoryだけ検索する
4. 必要なものだけContextへ入れる
5. 同じ調査・推論・失敗を可能な限り繰り返さない

です。

つまり、

Raw Experience
→ Distillation
→ Structured Memory
→ Retrieval
→ Reuse

というMemory Lifecycleを作ります。

このRepositoryを毎回全部読んではいけません。

---

# 2. Memory Taxonomy

Repository内の記憶を明確に分離してください。

## `knowledge/`

**私自身が学び、理解した知識。**

Human Semantic Memoryです。

例：

* Next.js
* React
* Go
* C++
* Linux
* OS
* Network
* Database
* AWS
* Docker
* Machine Learning
* Deep Learning
* AI Agents
* MCP
* Codex
* Claude Code

など。

主な用途は、

> 「以前勉強したSuspenseを忘れたから、自分のKnowledgeから復習したい」

というケースです。

Knowledgeは基本的に、

* ChatGPTなどで学習
* 自分が理解
* Knowledge用Markdownを作成
* `inbox/`へ投入
* `$brain-capture` でKnowledgeへ統合

という流れを想定しています。

AIがCoding Session中に勝手に `knowledge/` を大幅更新しないでください。

Coding中に新しい知識を発見した場合は「Knowledge Candidate」として扱ってください。

---

## `agent-memory/`

**AI Agentが次回より効率的・正確に作業するための記憶。**

Procedural Memoryです。

例：

* この種類のbugでは最初にこのtestを実行する
* この調査方法は無駄だった
* このrepositoryではこのREADMEを先に読む
* 特定のbuildを毎回実行する必要はない
* この順番で調査すると早い
* ユーザーは大規模rewriteより段階的変更を好む

など。

Engineering作業と直接関係しないユーザー個人情報は保存しないでください。

構造は、

agent-memory/
shared/
workflows/
lessons/
preferences/
codex/
claude/

を基本としてください。

Agent-neutralな学びは `shared/` に置き、
Codex固有 / Claude固有の情報だけそれぞれのdirectoryへ置きます。

---

## `projects/`

Project-specific Long-term Memoryです。

各Projectについて、

* 何を作っているか
* architecture
* current state
* constraints
* next actions
* important files
* decisions

を保持します。

例：

projects/
online-judge/
overview.md
architecture.md
current-state.md
constraints.md
next-actions.md
decisions/

目的は、

> 新しいCodex Sessionを開いても「昨日の続き」から開始できる

ようにすることです。

Projectに実質的な変更が発生した場合のみ `current-state.md` 等を更新してください。

Typo修正など小さな変更のたびにMemoryを書き換えないでください。

未知のProjectを勝手に登録しないでください。

登録されていないProjectでBrain機能が使われた場合は、

> Engineering BrainにこのProjectを登録しますか？

とユーザーに確認してください。

---

## `projects/<project>/decisions/`

Decision Memoryです。

これはAIが勝手に決めたことを記録する場所ではありません。

**ユーザー / teamが採用した重要な設計判断と、その理由**を保存します。

例えば、

* PostgreSQLを選んだ理由
* Next.jsを選んだ理由
* runnerをGoにした理由
* MLEを現段階ではRE扱いにした理由

など。

Decisionには可能なら、

* Decision
* Context
* Alternatives considered
* Why
* Trade-offs
* Date

を残してください。

目的は、

> 半年後に「なぜこうなっているのか」が分からなくなる

ことを防ぐことです。

AIが将来別の設計を提案するときも、既存Decisionの前提が現在も有効か確認してから提案できるようにします。

Top-levelの `decisions/` は作らず、Project-specific decisionはProject配下へ置いてください。

---

## `sessions/`

重要なCoding SessionのEpisodic Memoryです。

Raw transcriptではありません。

保存するのは蒸留したSession Summaryだけです。

例えば、

* Goal
* What happened
* What worked
* What failed
* Important discoveries
* Misunderstandings corrected
* Decisions
* Reusable lessons
* Project state changes
* Knowledge candidates
* Open questions

など。

ただし全Sessionを保存してはいけません。

Session Summaryを作るのは、

1. ユーザーが `$brain-learn` を明示的に実行した場合
2. AIが「将来再利用する価値が高い」と判断した重要Session

のみです。

軽微な作業では保存しないでください。

構造は、

sessions/
recent/
archive/
YYYY/

を基本とします。

十分に、

* knowledge
* agent-memory
* projects
* decisions

へ蒸留された古いSessionはarchiveしてください。

通常の検索ではarchiveを読みません。

ユーザーが、

> 「以前何を試した？」
> 「あの時何が失敗した？」

など過去エピソードを求めた場合だけ検索してください。

---

# 3. Raw Sessions

初期VersionではRaw Codex / Claude transcriptをEngineering Brainへ複製しません。

Raw Session HistoryはAgent自身の履歴に任せます。

つまり初期Versionでは、

.raw/sessions/

のような仕組みは不要です。

将来必要性が明確になった場合のみ追加します。

---

# 4. Inbox

以下を作ってください。

inbox/

これはHuman LearningとEngineering Brainの境界です。

例えば私はChatGPTでNext.jsについて学習したあと、

inbox/
use-action-state.md
server-actions.md

のように学習内容を置きます。

この時点では、

* directory分類
* metadata
* 重複排除
* 既存Knowledgeとの統合

を人間が考える必要はありません。

`$brain-capture` が整理します。

---

# 5. Retrieval Policy — Flexible Local First

これは非常に重要です。

質問や作業で知識が必要になった場合、

**Local First**

で行動してください。

基本フロー：

Question / Task
↓
Relevant Engineering Brain Memoryを検索
↓
十分な情報がある？
├─ YES → Local Memoryを利用
└─ NO / outdated / user asks latest
↓
authoritative external sourcesを調査
↓
local knowledgeとの差分を確認
↓
必要ならupdate candidateを提示

Local Knowledgeは「出発点」であり、「絶対的な真実」ではありません。

特に、

* Next.js
* React
* Codex
* Claude Code
* AWS SDK
* rapidly changing libraries

などは古くなる可能性があります。

一方、

* algorithms
* OS fundamentals
* networking fundamentals
* mathematics

など安定したKnowledgeについて、毎回Web検索してはいけません。

「以前自分が学んだ内容を復習したい」という質問では、原則Web検索不要です。

---

# 6. Retrieval Efficiency

Version 1では、

* Markdown
* README / index files
* filesystem search
* `rg` / ripgrep

を利用してください。

**RAG、Vector DB、Embedding Database、Elasticsearch等は導入しないでください。**

Knowledge Baseが十分大きくなり、実際に検索精度に問題が発生してから検討します。

各主要directoryにREADME/indexを作り、AIと人間の両方が、

> どこに何があるか

を低コストで把握できるようにしてください。

巨大なREADMEを作ってはいけません。

READMEはKnowledge本文ではなく「地図」として機能させてください。

---

# 7. Context Budget Policy

Token Efficiencyを最優先設計原則の1つとします。

禁止：

* Repository全体を毎Session読み込む
* `knowledge/` 全文を読む
* 全Session Summaryを読む
* archiveを通常検索する
* 巨大AGENTS.md / CLAUDE.mdを作る

推奨：

1. indexを見る
2. `rg` 等で候補を探す
3. relevant fileだけ読む
4. 必要なら周辺fileへ広げる

Progressive Disclosureを徹底してください。

---

# 8. Knowledge Metadata

Knowledge Noteには軽量metadataを使用します。

厳格すぎるschemaにはしないでください。

例：

---

title: useActionState
created: 2026-08-31
last-reviewed: 2026-08-31
confidence: high
volatility: medium
------------------

本文構造は柔軟で構いません。

必要に応じて、

* TL;DR
* Mental Model
* Details
* Example
* What I Misunderstood
* Gotchas
* Related Notes
* Sources

等を利用してください。

すべてのNoteへ全部のsectionを強制してはいけません。

Knowledgeを書くこと自体が面倒になる設計を避けてください。

`volatility` は例えば、

* low
* medium
* high

程度で十分です。

---

# 9. Maintenance

Agent-neutralな、

`brain-maintenance`

workflow / Skillを作ってください。

目的：

Engineering BrainのKnowledge freshnessを定期確認する。

ただし**Knowledgeを自動更新してはいけません。**

Maintenance flow：

対象候補抽出
↓
metadata / volatility / last-reviewedを見る
↓
更新可能性が高いKnowledgeだけ選択
↓
必要に応じてauthoritative sourceを調査
↓
既存Knowledgeとの差分を確認
↓
Maintenance Report生成
↓
STOP

ユーザーがreportを確認し、

> この2件を更新して

などと指示した場合に初めて変更します。

Version 1ではscheduleそのものを特定Agentへ依存させません。

将来、

* Codex Automation
* Claude Scheduler
* cron
* GitHub Actions

などどこからでも呼び出せる構造にしてください。

Maintenance Reportを保存する適切なdirectoryも設計してください。

月1回程度の実行を想定していますが、この初期構築でschedulerは設定しなくて構いません。

---

# 10. Public Repository / Private Data

`engineering-brain` はPublic GitHub Repositoryとして利用する想定です。

ただしprivate情報用として、

.private/
.local/

を用意し、必ず `.gitignore` してください。

例えば、

.private/
projects/
research/
notes/

等を置けるようにしてください。

以下は絶対にpublic commitしてはいけません。

* credentials
* API keys
* tokens
* secrets
* passwords
* private source code
* confidential company information
* unpublished sensitive research
* unnecessary personal information
* raw AI conversations
* private project details

重要：

`.gitignore` に入っているから安全だと盲信しないでください。

Commit前にはstaged filesを確認し、秘密・private情報が含まれていないかチェックしてください。

一度Git historyへcommitしたprivate informationは `.gitignore` 追加だけでは消えないため、最初からpublic/private boundaryを厳格に扱ってください。

---

# 11. Git Policy

AIがMemoryを変更した場合：

AI modifies files
↓
AI shows `git diff`
↓
User reviews
↓
User explicitly approves
↓
commit

とします。

自動commit / pushは禁止です。

初期構築でも、

* filesを作成
* validation
* git diff提示

まで進め、

**commit/pushはしないでください。**

将来的に一部自動化する可能性はありますがVersion 1では行いません。

---

# 12. Agent-neutral Architecture

このRepositoryはCodex専用にしてはいけません。

Source of TruthはAgent-neutralにしてください。

例えば、

engineering-brain/
README.md <agent-neutral brain protocol>
agent-tools/
skills/
...

という構造を検討してください。

`AGENTS.md` と `CLAUDE.md` は巨大なKnowledge Baseにせず、

> Agent-neutral Brain Protocolへの薄いadapter / entry point

として作ってください。

可能であれば同じSkill sourceを、

* Codex
* Claude Code

から共有してください。

Agent-specificなfrontmatterや構造へ過度に依存しないでください。

Skill formatについては、現在インストールされているCodex / Claude Code環境と現在のsupported conventionsを自分で確認してから実装してください。

古い記憶だけでpathや仕様を決めないでください。

---

# 13. Global Brain Access

`engineering-brain` は各Projectへコピーしません。

唯一のSource of Truthとして1Repositoryだけ持ちます。

例：

~/repos/
engineering-brain/
project-a/
project-b/
project-c/

各ProjectでCodex / Claude Codeを起動してもBrain Skillsを利用可能にしてください。

つまりproject-aで、

`$brain-continue`

などを実行すると、

current git repository
↓
Engineering Brain内のProject registry
↓
対応Project特定
↓
current-state / decisions / relevant memory取得

という流れを実現します。

Global Skills / symlink / lightweight adapter等、現在のAgentが正式にサポートしている安全な方法を調査して利用してください。

重要：

* machine-specific absolute pathをGit tracked fileへhard-codeしない
* private local configurationが必要なら `.local/` 等gitignored領域を使う
* existing global skills/configを上書きしない
* name conflictがある場合は止めて報告
* symlink等を使う場合はsource of truthがengineering-brain側になるようにする

Global adapterのinstallationを再実行可能なscriptとして用意することも検討してください。

Macで利用することを想定します。

---

# 14. Initial Skills

Version 1では以下の5 Skillsだけ作ってください。

Skill explosionを避けます。

## 1. `brain-recall`

目的：

過去のEngineering Brainから必要な情報だけ取得して回答する。

主なケース：

* 「Suspenseって何だった？」
* 「以前S3について何を学んだ？」
* 「前にこの問題を調べなかった？」
* 「自分のKnowledgeから復習させて」

Behavior：

1. intentを理解
2. appropriate memory typeを選択
3. index / `rg` を使って検索
4. minimum relevant filesだけ読む
5. local memoryをベースに回答
6. outdated可能性が高い場合のみそれを指摘
7. 必要な場合だけexternal research

Learning questionsでは `knowledge/` を優先してください。

---

## 2. `brain-learn`

目的：

現在の重要Sessionから再利用可能なMemoryを蒸留する。

明示的に呼ばれた場合は必ず実行。

また、Agent自身が、

* non-obvious failure
* reusable workflow
* important corrected assumption
* major project-state change
* important decision

などを検出した重要Sessionについても利用可能。

ただし小さなSessionでは実行しないこと。

分類先：

* Human learning → Knowledge Candidate
* Agent workflow → agent-memory
* Project state → projects
* Accepted design decision → projects/<project>/decisions
* Important episode → sessions/recent

Knowledgeを勝手に大幅更新しないでください。

---

## 3. `brain-continue`

目的：

別Session / 別日でもProject作業を続きから再開する。

Flow：

current repository identify
↓
registered project search
↓
project overview
↓
current-state
↓
next-actions
↓
relevant decisions
↓
必要ならrelevant recent session / agent-memory
↓
brief context reconstruction
↓
作業再開

全部読むのではなく必要な情報だけ取得してください。

Projectが未登録ならユーザーへ登録確認してください。

---

## 4. `brain-capture`

目的：

`inbox/` に入れられたHuman Learningを正式なKnowledgeへ統合する。

Flow：

inbox item
↓
content理解
↓
既存Knowledge検索
↓
duplicate / overlap確認
↓
existing noteへmerge OR new note作成
↓
lightweight metadata付与
↓
related links / index更新
↓
inbox item処理完了
↓
git diff提示

内容を勝手に「最新化」するために毎回Web検索してはいけません。

明らかな矛盾や古さが疑われる場合のみ報告してください。

---

## 5. `brain-maintenance`

前述のMonthly Maintenance Workflow。

Knowledgeを勝手に更新せず、reportだけ生成してください。

---

# 15. Session Lifecycle

理想的なCoding lifecycle：

New Session
↓
必要なら `$brain-continue`
↓
Relevant Memoryだけ取得
↓
Coding / investigation
↓
重要な学びがあった？
├─ NO → 終了
└─ YES
↓
`$brain-learn`
↓
classify
↓
agent-memory / project / decision / session
↓
Knowledge Candidate if applicable
↓
git diff
↓
User review

これを設計の中心にしてください。

---

# 16. Human Learning Lifecycle

私自身の学習は主にChatGPTなどで行います。

Flow：

ChatGPTで学習
↓
自分の理解が固まる
↓
Knowledge用Markdown作成
↓
engineering-brain/inbox/
↓
`$brain-capture`
↓
existing knowledgeと統合
↓
git diff
↓
review
↓
commit

将来忘れた場合：

question
↓
`$brain-recall`
↓
knowledge検索
↓
過去の自分の理解をベースに復習

となります。

---

# 17. Project Memory Lifecycle

Projectについて実質的な変更があった場合、

* current-state
* next-actions
* architecture
* constraints

のうち必要なものだけ更新してください。

毎回全部を書き直してはいけません。

過去状態の詳細はGit historyやSession Summaryに任せ、

`current-state.md` は**現在を素早く理解するためのcompactなmemory**として保ってください。

これはContext Token削減上重要です。

---

# 18. Session Archival

Session Summaryには、

* status: active
* status: distilled

のような軽量状態を付ける方法を検討してください。

十分なMemoryが他領域へ蒸留された古いSessionは、

sessions/archive/YYYY/

へ移します。

archiveは通常のretrieval対象外。

ただし削除はしません。

---

# 19. Initial Repository Structure

以下をベースにしてください。

ただし、目的を保ったままより自然な構成がある場合は軽微な改善をして構いません。

engineering-brain/
├── README.md
├── AGENTS.md
├── CLAUDE.md
├── .gitignore
│
├── inbox/
│   └── README.md
│
├── knowledge/
│   ├── README.md
│   ├── web/
│   ├── computer-science/
│   ├── cloud/
│   ├── machine-learning/
│   └── ai-agents/
│
├── projects/
│   └── README.md
│
├── agent-memory/
│   ├── README.md
│   ├── shared/
│   │   ├── workflows/
│   │   ├── lessons/
│   │   └── preferences/
│   ├── codex/
│   └── claude/
│
├── sessions/
│   ├── README.md
│   ├── recent/
│   └── archive/
│
├── maintenance/
│   ├── README.md
│   └── reports/
│
├── templates/
│   ├── knowledge-note.md
│   ├── session-summary.md
│   ├── project-overview.md
│   ├── project-current-state.md
│   ├── decision.md
│   └── maintenance-report.md
│
├── agent-tools/
│   └── skills/
│       ├── brain-recall/
│       ├── brain-learn/
│       ├── brain-continue/
│       ├── brain-capture/
│       └── brain-maintenance/
│
├── .agents/
│   └── skills/
│
├── .claude/
│   └── skills/
│
├── .private/
└── .local/

Agent-neutral Brain Protocolを置くファイルも追加してください。

名前は、

* BRAIN.md
* SYSTEM.md
* docs/brain-protocol.md

等から、この用途に最も分かりやすいものを選んでください。

AGENTS.md / CLAUDE.mdはそこへのadapterにしてください。

---

# 20. Documentation

README.mdは、

> このRepositoryは何なのか？

を人間が初見で理解できる内容にしてください。

最低限、

* Concept
* Memory types
* Folder map
* Typical workflows
* Skills
* Human learning workflow
* Coding Agent workflow
* Privacy rules
* Token efficiency philosophy
* Getting started

を簡潔に書いてください。

巨大な設計書にはしないでください。

詳細protocolは別fileへ分離してください。

---

# 21. Validation

実装後、最低限以下を検証してください。

### Structure

* required directories exist
* README/indexが適切に存在
* `.private/` / `.local/` がgitignored
* empty directory保持が必要なら適切に処理

### Skills

* Codexから5 Skillsがdiscoverできる
* possibleならClaude Codeからもdiscover可能
* source of truthが重複していない
* adapters/symlinksが壊れていない
* existing user skillsを上書きしていない

### Retrieval

簡単なdummy Knowledgeを永続的に追加する必要はありません。

必要ならtemporary fixtureで、

* knowledge検索
* project lookup
* inbox capture path

の構造が成立するか検証してください。

### Privacy

`git status`
`git check-ignore`
staged files等を利用し、

`.private/`
`.local/`

がcommit対象にならないことを確認してください。

---

# 22. Avoid Overengineering

Version 1では以下を実装しないでください。

* Vector database
* Embeddings
* RAG infrastructure
* Database server
* Web UI
* daemon
* always-on service
* automatic public publishing
* automatic git push
* autonomous rewriting of all knowledge
* raw session ingestion pipeline
* elaborate ontology
* excessive metadata
* dozens of Skills

まず、

Markdown

* Git
* rg
* Agent Skills
* Good Memory Lifecycle

で成立させてください。

---

# 23. Implementation Strategy

まず現在のfilesystem / Codex / Claude Code環境を確認してください。

特に、

* current directory
* whether engineering-brain already exists
* Git state
* existing Codex skill directories
* existing Claude skill directories
* supported skill discovery conventions
* symlink feasibility
* `rg` availability

など、自分で確認できることはユーザーへ質問しないでください。

その後：

1. Repository structure作成
2. Agent-neutral Brain Protocol作成
3. README / indexes / templates作成
4. 5 Skills実装
5. Codex adapter実装
6. Claude adapterを安全に作れる範囲で実装
7. Global Skill accessを安全な方法で構成
8. Privacy / gitignore設定
9. Validation
10. `git diff` / resulting tree提示

まで実行してください。

既存global configを破壊しないでください。

---

# 24. Final Report

作業終了後は長大な説明ではなく、以下をまとめてください。

## Created

主要files/directories

## How it works

Memory lifecycleを短く説明

## Skills

5 Skillsと使い方

## Global integration

Codex / Claudeからどう参照される状態になったか

## Privacy

何がGitHubへ出ず、どう守られているか

## Validation

何を確認したか

## Git diff

重要な変更

## Try it

最初に試すコマンド / promptを3〜5個。

例えば：

`$brain-recall ...`

`$brain-capture`

`$brain-continue`

`$brain-learn`

`$brain-maintenance`

## Remaining issues

現在の環境上どうしても自動設定できなかったものだけ。

---

# 25. Most Important Principle

このシステムの成功基準は、

> AIが大量のMemoryを持つこと

ではありません。

成功基準は、

> 必要なときに、過去の正しいMemoryを、小さなContextで取り出せること

です。

そのため、

**Store more, read less, distill aggressively, retrieve selectively.**

をEngineering Brainの基本思想として設計してください。

では、設計案だけ返すのではなく、現在の環境を調査してVersion 1を実際に構築してください。

