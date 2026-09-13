---
title: Size columns from the data you will load, not from the sample you started with
created: 2026-09-09
last-reviewed: 2026-09-09
applies-to: shared
---

# Lesson

`varchar(n)` の `n` を、いま手元にあるデータの見た目から決めない。**これから入りうるデータの最大長を実測してから決める。** 取り込み範囲を広げるときは、広げた後のデータで測り直す。

# Why

Custom Contestで `problems.problem_index` を `varchar(8)` にした。ABC/ARC/AGCの問題記号は `A`〜`G` の1文字なので、8で十分に見えた。

あとでカタログをJOIまで広げたところ、JOIの問題記号は `fortune_telling` のように単語で、最長15文字だった。schemaはそのままだったので、**次のdeployでseedが落ちる状態になっていた。** 落ちるのはbuildの中なので本番が壊れるわけではないが、気づかなければ「なぜか新しい問題が入らない」になる。

取り込み範囲の変更とschemaの変更は、別のcommitどころか別の日に起きる。**範囲を広げた側が、列幅を確かめる責任を持つ。**

# Check

流し込む前に、実際のデータで測る。

```sh
python3 -c "
import json; ps=json.load(open('catalog.json'))['problems']
for k in ('problemId','contestId','problemIndex','source'):
    print(k, max(len(p[k]) for p in ps))
"
```

流し込んだ後にDB側でも確かめる。

```sql
select max(length(problem_index)), max(length(source)) from problems;
```

余裕を持たせるが、無制限にはしない。`text` にすると「ここには短い記号が入る」という意図が読めなくなる。実測15なら32程度。

# Boundary

長さ制約は入力検証の代わりにならない。Zod側の `max()` と二重に持つのは冗長ではなく、DBはmigrationや手書きSQLにも効く唯一の関門である。
