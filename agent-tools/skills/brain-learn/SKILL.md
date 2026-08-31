---
name: brain-learn
description: Distill an important coding session into reusable Engineering Brain memory and safely publish eligible Agent-authored memory. Use whenever the user explicitly invokes brain-learn, or after a non-obvious failure, reusable workflow, corrected assumption, major project-state change, or accepted engineering decision; do not use for trivial sessions.
---

# Brain Learn

Distill the current Session; never copy a raw transcript.

## Resolve context

1. Resolve the Brain root from this canonical `SKILL.md` real path (`agent-tools/skills/brain-learn/../../..`). Fallbacks are `ENGINEERING_BRAIN_ROOT`, the real target of the matching global Codex or Claude skill link, then a current-repository `BRAIN.md`.
2. Read `<brain-root>/BRAIN.md` and the indexes/templates for only the memory types you will write.

## Decide whether to run

- Explicit invocation: always perform the distillation workflow and create or update an appropriate concise Session Summary.
- Implicit use: proceed only for a non-obvious failure, reusable workflow, important corrected assumption, major Project-state change, or accepted decision.
- Skip implicit capture for typo fixes, routine formatting, and other low-value episodes.

## Distill and classify

Summarize the goal, outcome, useful evidence, failed approaches and why, corrected misunderstandings, remaining questions, and reusable next-session value. Then route each durable item:

- Human learning -> a concise `inbox/` Knowledge Candidate; do not make a large direct `knowledge/` edit.
- Agent-neutral workflow / lesson / engineering preference -> `agent-memory/shared/`.
- Codex- or Claude-only behavior -> the corresponding host-specific directory.
- Material state or next-action change -> the registered Project's relevant file only.
- Accepted design decision -> that Project's `decisions/`, using `templates/decision.md`.
- Important episode -> `sessions/recent/YYYY-MM-DD-short-topic.md`, using `templates/session-summary.md` and removing empty sections.

Search the relevant index and filenames before writing. Merge with an existing memory when it represents the same durable idea; do not create near-duplicates.

## Project boundary

Identify the current Git root and remote, then match the public or private registry. If the current Project is unregistered, ask exactly whether to register it before creating Project memory. You may still save a genuinely general agent lesson or a project-neutral Session Summary without registering it. Never record a proposed decision as accepted.

## Finish

Keep current-state files compact and update only materially changed sections. Update small indexes only when discovery benefits. Validate edited files, inspect the complete `git status` and diff, and summarize where each item was classified.

When every change in the worktree and index was authored by this learning workflow and is limited to `agent-memory/**` and `sessions/**`, including their small indexes, follow the Agent-managed publishing exception in `BRAIN.md`: unless the user requested review-only, run privacy and secret checks, create a concise `brain:` commit message, commit exactly those changes, and push the current branch normally to its configured remote. Never force push or rewrite history.

If any Human Knowledge, Inbox, Project state, Decision, Maintenance report, unrelated change, ambiguous ownership, validation failure, remote divergence, conflict, or authentication failure is present, do not auto-publish. Show the diff and stop for user direction. Report the commit hash, push destination, and final status after a successful publish.
