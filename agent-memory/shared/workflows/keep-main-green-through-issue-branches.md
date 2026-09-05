---
title: Keep main green through issue branches and reviewed PRs
created: 2026-09-04
last-reviewed: 2026-09-04
applies-to: shared
---

# Goal

Treat `main` as the known-good integration line. Isolate unfinished Agent work on an issue branch and let tests plus human review decide whether it enters `main`.

# Workflow

1. Before a write task, run `git branch --show-current` and `git status --short`.
2. If currently on `main`, create a work branch before editing. Prefer `feat/<issue>-slug`, `fix/<issue>-slug`, `docs/<issue>-slug`, or `chore/<issue>-slug`.
3. If uncommitted work already exists on `main`, preserve it and create the branch in place. Do not reset, clean, or discard it merely to restore branch hygiene.
4. Give the work one Issue with the outcome, scope, exclusions, acceptance criteria, and evidence required. Split materially independent outcomes into separate Issues and branches.
5. Commit only reviewed in-scope files. Exclude local tool state, raw scratch notes, secrets, generated caches, and unrelated user changes.
6. Run the repository's complete check and inspect staged changes before committing.
7. Push the work branch and open a PR against `main`. Link it with `Closes #<issue>`, record verification, risks, rollback, and browser-observed screenshots for UI work.
8. Do not merge when required checks fail. Agents may prepare and review the PR but do not merge into `main` without explicit user authorization.
9. Enforce the convention remotely with a GitHub ruleset: PR required, force push and deletion blocked, branch up-to-date, and CI status required. Documentation alone is guidance, not enforcement.

# Additional worktree lifecycle

Use the repository's normal working directory and one work branch by default. Create an additional worktree only when unrelated uncommitted work must remain untouched while another bounded task proceeds.

1. Before creating one, run `git worktree list` and explain why isolation is needed.
2. Give the worktree an explicit temporary path and a dedicated branch.
3. Work, verify, and commit inside that worktree. Do not mix it with the original dirty tree.
4. Before finishing, confirm `git -C <path> status --short --branch` is clean and `git -C <path> log -1 --oneline` shows the retained commit.
5. Run `git worktree remove <path>` without `--force`, then confirm removal with `git worktree list`.
6. Never use `rm -rf` as the normal cleanup path. If the worktree is dirty, stop and preserve it.

Git intentionally prevents the same branch from being checked out by two worktrees. A leftover worktree therefore causes `fatal: '<branch>' is already used by worktree at '<path>'`. Remove the clean, finished worktree registration; do not delete the branch or rewrite its commit.

# Solo-project boundary

Requiring one approving review can deadlock a solo repository because the PR author cannot provide an independent approval. Start with PR plus required CI and user-controlled merge. Require one approval when another GitHub reviewer is actually available.

# Recovery

- Edited but not committed on `main`: create a new branch without discarding the working tree.
- Accidentally committed locally on `main`: stop and inspect publication state before choosing a safe move.
- Accidentally pushed to shared `main`: do not force push or rewrite history automatically; use a reviewed revert or another user-approved recovery.
- Branch reported as already used by another worktree: inspect `git worktree list`, verify that worktree is clean and committed, then remove the finished worktree with `git worktree remove <path>`.
