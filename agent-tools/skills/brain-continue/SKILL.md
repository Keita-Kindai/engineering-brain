---
name: brain-continue
description: Reconstruct compact context for a registered software project so work can resume across sessions or days. Use when the user asks to continue, resume, pick up where they left off, or load the Engineering Brain context for the current repository.
---

# Brain Continue

Reconstruct enough context to resume work without loading Project history wholesale.

## Resolve context

1. Resolve the Brain root from this canonical `SKILL.md` real path (`agent-tools/skills/brain-continue/../../..`). Fallbacks are `ENGINEERING_BRAIN_ROOT`, the real target of the matching global Codex or Claude skill link, then a current-repository `BRAIN.md`.
2. Read `<brain-root>/BRAIN.md`, especially Progressive retrieval and the Project rules.

## Identify the current Project

1. Resolve the current Git root. Collect the normalized `remote.origin.url` when present and the root directory basename. Do not persist an absolute path in tracked files.
2. If `.local/project-registry.tsv` exists, check for an exact local mapping without exposing private entries.
3. Read `projects/README.md`, then use targeted `rg` over public `overview.md` metadata. Search `.private/projects/` only when the local mapping or user intent points there.
4. Accept only a unique match. If none exists, ask: “Engineering Brain にこの Project を登録しますか？” Do not create Project memory before confirmation. If multiple candidates exist, ask the user to choose.

After registration is approved, choose a stable Project ID, decide public versus private based on the content, instantiate only the useful files from `templates/`, add a public registry row only for public-safe metadata, and put machine-local path mapping in `.local/project-registry.tsv`.

## Reconstruct progressively

Read in this order, stopping when sufficient:

1. `overview.md`
2. `current-state.md`
3. `next-actions.md`
4. Relevant parts of `constraints.md` and `architecture.md`
5. Only decisions related to the next task
6. Only relevant recent Session Summary or agent memory

Do not read all decisions, all sessions, or archive by default.

## Output and resume

Return a compact brief containing Project purpose, current state, constraints that affect the next work, next actions, and unresolved blockers. Cite relative Brain paths. If the user supplied a concrete task, continue that task after reconstruction; otherwise stop after the brief. This workflow is read-only unless registration or a memory update is explicitly approved.

