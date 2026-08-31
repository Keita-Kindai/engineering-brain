---
title: Share one skill source across coding agents
created: 2026-08-31
last-reviewed: 2026-08-31
applies-to: shared
volatility: medium
---

# TL;DR

複数の Coding Agent で同じ workflow を使うときは、Agent-neutral な canonical skill directory を1つだけ持ち、各 Agent の supported discovery directory から symlink します。Tracked file に machine-specific absolute path を書かず、global link は再実行可能な installer が実行時に解決します。

# Workflow

1. Installed CLI version、既存 global skill、現在公式に対応する discovery path と symlink behavior を確認する。
2. Repository 内の Agent-neutral な場所に canonical `SKILL.md` を作る。
3. Repository-specific discovery directory には relative symlink を置く。
4. Personal/global discovery directory には、repository root を動的解決する installer で symlink を置く。
5. 全 target を先に conflict checkし、既存 fileや異なる symlinkがあれば何も変更せず停止する。
6. Frontmatter、broken link、real target、ignore rulesを検証し、必要なら新しいAgent sessionでdiscoveryを確認する。

# Lessons

- Global configを編集しなくても、各Agentが正式対応するpersonal skill directoryでglobal accessを実現できる場合がある。
- Repository adapterとglobal adapterの両方が同じcanonical directoryを指せば、Skill sourceの重複とdriftを防げる。
- `.agents/` や `.git/` などのmetadata pathはsandboxで保護される場合がある。通常fileを先に構築し、必要なmetadata writeだけを明確なscopeで承認依頼する。
- 新規Git repositoryではbaseline commitがないため、通常の`git diff`だけではuntracked implementationが表示されない。`git status`とuntracked file listもreviewに含める。
- Skill discovery conventionsは変化し得る。別machineへの再導入やCLI更新後は、過去の記憶だけでpathを決めず再確認する。

# Safety checks

- Existing skillやglobal configを上書きしない。
- Canonical source以外へSkill本文を複製しない。
- Tracked fileへlocal home pathを保存しない。
- Installation後も自動commit / pushしない。
