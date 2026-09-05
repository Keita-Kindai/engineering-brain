---
title: Confirm branch identity before committing and when files look reverted
created: 2026-09-05
last-reviewed: 2026-09-05
applies-to: shared
---

# Lesson

複数のAgentやUserが同じworktreeを共有するrepositoryでは、branchはSession中に外から切り替わる。Session開始時に確認したbranch名を、後続のcommitでも有効だと仮定しない。

`git commit`の直前に必ず`git branch --show-current`を実行し、意図したbranchであることを確かめる。

# Why

実例では、作業branchで実装をcommitした後、外部の操作でworktreeが別branch（別Agentの作業branch）へ切り替わった。その状態に気づかずdocumentのcommitを作り、他人のbranchの上に載せてしまった。

Branchの切り替えはtool outputに現れないことがある。`git status --short`はtracked fileの差分しか出さず、branch名は`-b`を付けないと表示されない。

# The second failure mode: misreading a branch switch as data loss

同じ切り替えは「fileが勝手に元に戻った」ようにも見える。

- Working treeのfileが、自分が書いた内容ではなく古い内容になっている
- `git show HEAD:path`で確認しても古い内容が返る

このとき「保存が失われた」と結論すると誤診になる。実際にはHEADが別branchを指しているだけで、自分のcommitは元のbranchに無傷で残っている。実例ではこれを取り違えて「記録が失われた」とUserへ報告し、後から訂正した。

先に確認する。

```sh
git branch --show-current
git log --all --oneline | grep '<自分のcommitの主題>'
git branch -v
```

Commitが`--all`で見つかるなら、失われていない。Worktreeの位置の問題である。

# Recovery

間違ったbranchへ載せたcommitは、内容が自分のものだけであることを確認してから戻す。

```sh
git show --stat --format='%h %an %s' <commit>   # 範囲と作者を確認
git rev-parse <commit>^                          # 元のtipを控える
```

`git branch -f`や`git reset`はguardで拒否されることがある。その場合は自分で書き換えず、対象commit、元のtip、復旧commandをUserへ提示して判断を委ねる。他人のbranchの履歴を無断で書き換えない。

# Boundary

Worktreeを分けても解決しない。`git worktree`は同じbranchの二重checkoutを防ぐが、同じworktreeが別branchへ切り替わることは防がない。防げるのは確認の習慣だけである。
