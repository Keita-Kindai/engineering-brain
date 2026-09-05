---
title: Namespace CSS when adding a second skin to one app
created: 2026-09-05
last-reviewed: 2026-09-05
applies-to: shared
---

# Lesson

既存のglobal stylesheetを持つapplicationへ2つ目のvisual identity（skin、mode、section）を足すとき、新しいclass名は接頭辞で分離する。汎用的な名前をそのまま使うと、既存のglobal ruleが新しいcomponentへ黙って適用される。

Elementのstyleが「書いていないのに付いている」ときは、自分のCSSを疑う前にglobal stylesheetとのclass名衝突を疑う。

# Why

Global stylesheetは後から足したcomponentのことを知らない。`.difficulty`、`.field-label`、`.section-heading`のような一般名詞は、別々の担当者・別々の時期に同じ名前で書かれやすい。

衝突の厄介さは次の点にある。

- Build、type check、lintのどれも検出しない。
- 自分が定義したpropertyだけを上書きしても、相手側にしかないproperty（border、background、padding）は残る。
- Scopeを`[data-theme]`などで強めても、上書きしていないpropertyの継承は止まらない。

実例では、新しいDifficulty badgeが既存の`.difficulty`ruleを拾い、入力欄のような枠付きで描画された。Build成功、type check成功、lint成功、そしてbrowserで見て初めて分かった。

# Check

書き始める前と、書き終えた後の両方で機械的に確認する。

```sh
grep -oE '^\.[a-z0-9-]+' existing/globals.css | sort -u > /tmp/a.txt
grep -oE '\.[a-z0-9-]+'   new/feature.css    | sort -u > /tmp/b.txt
comm -12 /tmp/a.txt /tmp/b.txt   # 出力があれば衝突
```

# Renaming safely

一括置換するときは、class名としての出現だけを対象にする。

- CSS custom property（`--difficulty-color`）を巻き込まないよう、`(?<![\w-])`で直前のhyphenを除外する。
- TSX/JSXでは`className`の値の中だけを置換する。素朴な単語置換はobjectのkey（`difficulty:`）やcamelCase識別子（`difficultyBand`）まで壊す。
- Template literalの`` `foo foo-${key}` `` は単語境界に合わないため取りこぼす。置換後に`grep`で残りを確認する。

# Boundary

接頭辞は衝突を防ぐだけで、design systemを分けたことにはならない。共有すべきprimitive（余白、motion、type scale）は1か所に置き、skinごとに変えるのはsemantic layer（色、書体）に限る。[Share one design token layer across two visual identities](share-token-primitives-across-visual-identities.md) を参照。

検出はbrowserで行う。静的checkは通ってしまう。[Visual verification must be browser-observed](visual-verification-must-be-browser-observed.md) を参照。
