---
title: Land stacked branches with rebase --onto instead of copying content
created: 2026-09-07
last-reviewed: 2026-09-07
applies-to: shared
---

# Problem

Several feature branches are cut from one another instead of from `main`. Each upper branch already contains the lower branch's commits. Moving files between such branches by hand produces duplicated commits and conflicts, because the content is not missing — it is already present through the shared ancestor.

Detect the shape before editing anything:

```sh
# Where does each branch actually fork from?
git merge-base main <branch>

# behind / ahead relative to main
git rev-list --left-right --count main...<branch>

# Which commits are unique to the branch?
git log --oneline main..<branch>
```

If `git log --oneline main..<upper>` lists the lower branch's commits, the branches are stacked, not independent.

# Rule

Land the base branch first. Then move each upper branch onto the new `main` and drop the commits that arrived through the merge.

```sh
# 1. Base branch first: push and merge it through a PR.
git switch feat/base
git push -u origin feat/base

# 2. After the base merges, refresh the local main.
git switch main
git pull

# 3. Replay only the upper branch's own commits onto main.
#    --onto <newbase> <oldbase> <branch>
git rebase --onto main feat/base feat/upper
```

`git rebase --onto main feat/base feat/upper` replays exactly `feat/base..feat/upper`. The base commits are never replayed, so no duplicate-patch conflicts appear.

Plain `git rebase main feat/upper` often works too, because rebase drops commits whose patch-id already exists upstream. It stops being reliable when the base landed as a squash merge or was amended during review, since the patch-ids no longer match. Prefer the explicit `--onto` form.

# When rebase is a no-op

`git rebase main` does nothing when the branch is already based on the current `main` tip. Confirm with:

```sh
git rev-list --left-right --count main...<branch>   # "0  N" means 0 behind, N ahead
```

`0` behind means nothing to rebase yet. Rebasing becomes necessary only after `main` moves.

# Recovery

A rebase rewrites commits. Recover with the pre-rebase position rather than by re-editing files.

```sh
git rebase --abort              # during a conflicted rebase
git reflog                      # find the pre-rebase commit
git reset --hard <sha>          # only on a branch nobody else pulled
```

Never force push a shared branch to fix a rebase. See [[keep-main-green-through-issue-branches]].

# Ordering rule

Order pull requests by dependency, not by finish date. A branch whose `merge-base` is another feature branch cannot be reviewed honestly against `main`: the diff shows the base branch's work as if it were new.
