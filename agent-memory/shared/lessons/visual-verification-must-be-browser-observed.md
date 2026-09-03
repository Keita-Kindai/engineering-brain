---
title: Visual verification must be browser-observed
created: 2026-09-03
last-reviewed: 2026-09-03
applies-to: shared
---

# Lesson

HTML parser、JavaScript syntax、relative link、responsive CSS、HTTP 200などの静的・構造的checkがすべて通っても、desktop/mobileでのvisual verificationが完了したとは扱わない。

# Why

実際のbrowser renderingでしか確認できない問題がある。

- text wrapping、clipping、unexpected overflow
- font metricsやviewportによるhierarchy崩れ
- sticky / scroll / focusの使い勝手
- interaction後の表示状態
- runtime console error
- desktopとmobileでの情報密度

# Workflow

1. Static HTML、script、dependency、link、secret checksを先に通す。
2. Local server等でartifactをbrowserから開く。
3. Desktop viewportで全体hierarchy、flow、interaction、consoleを確認する。
4. Mobile viewportで1-column化、横overflow、touch target、readabilityを確認する。
5. 問題を修正して再確認する。
6. Browser backendが利用できなければ、static validation結果とvisual verification未完了を分けて報告し、完了を装わない。

# Boundary

Static validationはbrowser checkの前提を強くするが、その代替ではない。Browser接続不在時は別の無許可surfaceへ切り替えず、残作業として明示する。
