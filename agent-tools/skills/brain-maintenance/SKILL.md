---
name: brain-maintenance
description: Review Engineering Brain knowledge freshness and create a maintenance report without changing knowledge. Use for periodic or monthly audits of volatile, stale, contradictory, or weakly supported notes; stop after reporting until the user chooses updates.
---

# Brain Maintenance

Produce a report-only freshness review. Never update Knowledge in this workflow.

## Resolve context

1. Resolve the Brain root from this canonical `SKILL.md` real path (`agent-tools/skills/brain-maintenance/../../..`). Fallbacks are `ENGINEERING_BRAIN_ROOT`, the real target of the matching global Codex or Claude skill link, then a current-repository `BRAIN.md`.
2. Read `<brain-root>/BRAIN.md`, `knowledge/README.md`, `maintenance/README.md`, and `templates/maintenance-report.md`.

## Select candidates cheaply

Use indexes and metadata searches before reading note bodies. Prioritize:

- high-volatility notes not reviewed in roughly 30 days;
- medium-volatility notes not reviewed in roughly 90 days;
- low-volatility notes not reviewed in roughly one year;
- notes missing review metadata, containing explicit uncertainty/TODOs, or implicated by a known ecosystem change.

These are selection heuristics, not a rigid schema. Respect a narrower scope requested by the user. Do not scan Session archives or unrelated memory.

## Review

1. Read only selected candidate notes.
2. Decide whether external verification is warranted. Stable fundamentals usually do not need it.
3. For likely-changing claims, consult authoritative primary sources and compare their current state with the stored note.
4. Classify each candidate as no change indicated, update recommended, uncertain, or unable to verify.
5. Do not alter the candidate note, including `last-reviewed`.

## Report and stop

Create `maintenance/reports/YYYY-MM-DD.md` from the template, adding a short suffix only if a report for that date already exists. Include selection reason, concise difference, evidence links, confidence, and a proposed action. Avoid copying entire source documents.

Validate the report, show `git status --short` and its diff, then stop. Ask the user to select which notes to update. Do not update Knowledge, stage, commit, push, or configure a scheduler.

