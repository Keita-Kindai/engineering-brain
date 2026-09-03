---
title: Learning Note and Visual HTML workflow
date: 2026-09-03
status: distilled
project: none
---

# Goal

Humanの技術学習を将来復習しやすい形で保存する`learning-note` Skillを追加し、十分な内容ではcanonical Markdownとderived Visual HTMLを原則セットで生成する運用へ移行する。

# What happened

- Learning documentation規則をroot `AGENTS.md`へ、既存のprivacy・raw transcript・Markdown canonical方針を弱めずに統合した。
- `learning-note`をcanonical skillとして追加し、repository/globalのCodex・Claude Code adaptersから同じSourceを参照させた。
- Human作成のNext.js Authentication Noteを`knowledge/nextjs/`へ移し、domain indexとmetadataを整えた。
- Substantive learning noteのdefault outputを`<topic>.md`と`visuals/<topic>.html`のpairへ変更した。
- Next.js認証について、Authentication / Authorization、request boundary、function/file relationship、重要code、誤解修正、review promptsをまとめたsingle-file Visual HTMLを作成した。

# What worked

- Markdownを詳細なcanonical source、HTMLを短時間復習用のderived artifactとして分離できた。
- HTMLはinline CSSと最小JSだけで構成し、外部CDN依存をなくした。
- Skill validator、repository/global link、HTML parser、JavaScript syntax、relative links、secret scan、responsive rule、HTTP servingの各checkを通過した。
- Canonical skillをsymlink共有するため、Skill本文の更新はCodexとClaude Code両方へ即時反映される。

# What failed

- Browser runtimeに利用可能なbackendがなく、desktop/mobileの実rendering、interaction、consoleをinspectionできなかった。
- Static checksとHTTP 200までは確認できたが、これはvisual verificationの完了を意味しない。

# Decisions

- 十分な内容がある技術学習記録は、MarkdownとVisual HTMLを原則セットで生成する。
- Markdownはcanonical source of truthを維持し、HTMLは全文を複製しないderived artifactとする。
- 非常に短いmemo、またはvisualization valueがほぼない場合だけHTMLを省略し、理由をreportする。
- HTMLは原則single-file、外部CDN非依存、desktop/mobile対応とし、完成後にbrowserでvisual verificationする。

# Reusable lessons

- Browser-observed verificationとstatic validationの境界は[`agent-memory/shared/lessons/visual-verification-must-be-browser-observed.md`](../../agent-memory/shared/lessons/visual-verification-must-be-browser-observed.md)へ蒸留した。
- Visual HTMLはMarkdownの別表現ではなく、flow・boundary・relationship・contrastを再構成したreview surfaceとして設計する。

# Open questions

- Next.js Authentication Visual HTMLのdesktop/mobile browser verificationは、利用可能なBrowser backendへ接続後に実施する必要がある。
