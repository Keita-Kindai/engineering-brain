---
name: brain-capture
description: Integrate human-authored learning from the Engineering Brain inbox into durable knowledge by detecting duplicates, merging or creating notes, adding lightweight metadata and links, and presenting a reviewable diff. Use when the user asks to process, organize, or capture inbox notes.
---

# Brain Capture

Turn inbox material into Human semantic memory without requiring the user to pre-classify it.

## Resolve context

1. Resolve the Brain root from this canonical `SKILL.md` real path (`agent-tools/skills/brain-capture/../../..`). Fallbacks are `ENGINEERING_BRAIN_ROOT`, the real target of the matching global Codex or Claude skill link, then a current-repository `BRAIN.md`.
2. Read `<brain-root>/BRAIN.md`, `inbox/README.md`, `knowledge/README.md`, and `templates/knowledge-note.md`.

## Select and understand input

Use user-specified inbox items, or list Markdown items under `inbox/` excluding `README.md` and ask only if the intended selection is genuinely ambiguous. Check public/private suitability before moving any content into `knowledge/`; secrets or private details must not enter the public tree.

## Integrate

For each item:

1. Identify the topic, the user's mental model, unique insights, misunderstandings corrected, examples, sources, and uncertainty.
2. Read the likely Knowledge area index and use targeted `rg` for duplicates and overlap.
3. Merge into an existing note when it is the same concept; otherwise create a focused note in the natural area.
4. Preserve the user's meaning and uncertainty. Add lightweight `title`, `created`, `last-reviewed`, `confidence`, and `volatility` metadata; do not force unused sections.
5. Add only useful related links and update the smallest relevant index.
6. Do not browse merely to modernize the note. Report obvious conflicts or suspected staleness; verify externally only when needed to avoid capturing a material falsehood.

After verifying that all unique content is represented, remove the processed inbox item from the queue. Before removing an untracked source, preserve a recoverable copy under `.local/captured-inbox/YYYY-MM-DD/`; tracked sources are also recoverable through Git. Never discard material that was not integrated.

## Finish

Check links and metadata, show `git status --short` and the relevant diff, identify merges versus new notes, and mention any local backup. Do not stage, commit, or push.

