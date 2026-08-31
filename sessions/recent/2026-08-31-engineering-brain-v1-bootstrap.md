---
title: Engineering Brain Version 1 bootstrap
date: 2026-08-31
status: distilled
project: none
---

# Goal

CodexとClaude Codeが長期共有できる、Agent-neutral・local-first・token-efficientなEngineering External Brain Version 1を、既存環境を壊さず実装する。

# What happened

- Markdown、Git、`rg`を中心に、Knowledge、Agent memory、Project memory、Session、Inbox、Maintenanceの境界を構築した。
- `BRAIN.md`をprotocolのSource of Truthとし、`AGENTS.md`と`CLAUDE.md`を薄いadapterにした。
- 5 Skillsを`agent-tools/skills/`へ一度だけ実装し、repository/globalのCodex・Claude Code discovery directoryからsymlinkした。
- `.private/`と`.local/`をpublic Git boundaryの外に置き、秘密情報向けignore patternとvalidationを追加した。
- Git repositoryを`main` branchで初期化したが、stage、commit、pushは行わなかった。

# What worked

- Installed CLI、local configのkey、既存skill名を秘密値を表示せず確認してから実装できた。
- Codex CLI 0.151.0とClaude Code 2.1.251のsupported skill locationsおよびsymlink対応をcurrent documentationとlocal environmentの両方で確認できた。
- Global installerは全targetをpreflightし、name conflict時に部分変更せず停止する設計にできた。
- Canonical Skillsはbundled validator、shell syntax、broken-link、privacy、secret-pattern、target-resolution checksを通過した。

# What failed

- Codex manualの初回取得はsandbox内DNS制限で失敗し、限定したnetwork approvalで再実行した。
- Repository内の`.agents/`と`.git/`はmetadata path protectionにより通常writeが拒否され、対象を限定したapprovalが必要だった。
- 空の新規repositoryでは通常の`git diff`にuntracked filesが出ないため、`git status`とuntracked candidate listを併用した。

# Important discoveries

- 追加のsetupは不要。`scripts/install-global-skills.sh`と`scripts/validate.sh`はbootstrap中に実行済みである。
- Installerは新しいmachineへの導入、repository移動後のlink再構築、global linkの修復時に再実行する。通常利用のたびには実行しない。
- `validate.sh`はstructureやadapterを変更した後、またはlink健全性を確認したいときに実行する。
- 通常運用は、Codexでは`$brain-*`、Claude Codeでは`/brain-*`を新しいsessionから呼び出す。
- Userは、`brain-learn`でAgent自身が生成した`agent-memory/**`と`sessions/**`だけの変更について、Agentがcommit messageを作成して通常pushまで行う運用を承認した。その他のmemory typeやunrelated changesが混ざる場合は自動publishしない。

# Reusable lessons

- Cross-agent skill sharingの手順は[`agent-memory/shared/workflows/share-skills-across-agents.md`](../../agent-memory/shared/workflows/share-skills-across-agents.md)へ蒸留した。
- Brain全体を読むのではなく、index、`rg`、candidate fileの順で必要なmemoryだけを取得する。
- Human Learningは`inbox/`から`brain-capture`、Coding Sessionの重要な学びは`brain-learn`、Project再開は登録済みProjectに対する`brain-continue`で扱う。

# Open questions

- Engineering Brain repository自体をProject memoryへ登録するかは未決定。Userの明示確認なしでは登録しない。
