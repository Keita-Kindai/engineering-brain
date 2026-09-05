---
title: Share token primitives across two visual identities
created: 2026-09-05
last-reviewed: 2026-09-05
applies-to: shared
---

# Lesson

1つのproductが性格の違う2つの画面群（例: 静かなcontent側と、game的な対戦側）を持つとき、見た目を統一しようとしない。Token を primitive layer と semantic layer に分け、primitiveだけを共有する。

- Primitive（共有）: 余白scale、motion duration とeasing、type scale、z-index、radiusの刻み
- Semantic（skinごと）: 色role（canvas、surface、ink、accent）、書体

# Why

「1つに統一する」と「完全に分ける」はどちらも損をする。

- 統一すると、片方のdesign成果物が実装の参照元として使えなくなる。すでに高忠実度で実装済みの側を作り直すことにもなる。
- 完全に分けると、余白やmotionが画面間でずれ、同じproductに見えなくなる。共通のnavigationや認証も二重になる。

Semantic変数名がrole命名（`--color-canvas`、`--color-accent`）になっていれば、この分離は既存CSSを書き換えずに後付けできる。Skin側で同じ変数を再定義するだけで済む。

```css
:root { /* 既存skin: darkの値 */ }

[data-skin="practice"] {
  color-scheme: light;
  --color-canvas: ...;   /* 色と書体だけ差し替える */
  --font-body: ...;
  /* --space-*, --dur-*, --ease-* は再定義しない */
}
```

# Check the scales before assuming they differ

見た目が大きく違っても、下地は一致していることがある。実例では、2つのdesign成果物の余白scaleが偶然ほぼ同一（どちらも4px基準の4/8/12/16/20/24/32/48/64）で、その層はそのまま共有できた。

新しいdesignを受け取ったら、色の印象で判断する前に、余白・radius・motionの実数値を既存tokenと突き合わせる。差分が小さい層ほど共有の価値が高い。

# Where the seam goes

2つのskinの境目はnavigationと遷移にある。Designerが「どこでgame表現を使い、どこで使わないか」を指定している場合、その指定が接合部の仕様そのものになる。見た目が違うことは失敗ではなく、意図した二面性として扱う。

# Boundary

Skinを`[data-skin]`のようなattributeで切り替える場合、そのscopeの外にあるelement（`body`、global `main`）は元のstyleのままになる。Skin rootで背景・文字色・fontを明示的に塗り直し、element selectorで書かれたglobal ruleはclass selectorで打ち消す。

Class名の衝突は別問題として残る。[Namespace CSS when adding a second skin](namespace-css-when-adding-a-second-skin.md) を参照。
