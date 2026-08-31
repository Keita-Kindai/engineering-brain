# Maintenance

Knowledge freshness の read-only review workflow です。月 1 回程度を想定しますが、scheduler には依存しません。

`brain-maintenance` は volatility と `last-reviewed` から候補を絞り、必要な場合だけ authoritative source を確認し、`reports/YYYY-MM-DD.md` を生成して停止します。Knowledge 本文や metadata を自動更新しません。

