---
name: brain-recall
description: Retrieve only the relevant parts of the user's Engineering Brain to answer questions about previously learned knowledge, project memory, past investigations, or reusable engineering lessons. Use for prompts such as “what did I learn about X?”, “did we investigate this before?”, or “teach me from my own knowledge.”
---

# Brain Recall

Use the Engineering Brain as a selective, local-first memory source.

## Resolve context

1. Resolve the Brain root from this canonical `SKILL.md` real path (`agent-tools/skills/brain-recall/../../..`). If that path is unavailable, try `ENGINEERING_BRAIN_ROOT`, then the real target of `~/.agents/skills/brain-recall` or `~/.claude/skills/brain-recall`, then a `BRAIN.md` in the current repository.
2. Read `<brain-root>/BRAIN.md`, focusing on Progressive retrieval and Local-first policy.
3. Do not scan the whole Brain to orient yourself.

## Route the request

- Personal learning or review: start with `knowledge/README.md` and `knowledge/`.
- How an agent should work: start with `agent-memory/README.md`; prefer `shared/`, using `codex/` or `claude/` only for host-specific details.
- Current Project state or constraints: identify the registered Project through `projects/README.md`, its `overview.md`, or the private/local registry when explicitly relevant.
- Accepted architecture rationale: search that Project's `decisions/`.
- “What did we try?” or a past failure: search `sessions/recent/`; search `sessions/archive/` only when the episodic question requires it.

## Retrieve progressively

1. Read the smallest relevant index.
2. Use `rg --glob '*.md'` for distinctive terms, synonyms, metadata titles, and related links within the selected memory type.
3. Read only the best candidates. Expand to adjacent files only when the answer is incomplete.
4. Prefer local memory for review and stable fundamentals.
5. If the user asks for current information, the note has high volatility and may be stale, or local memory is insufficient, consult authoritative external sources and distinguish new evidence from stored memory.
6. Never silently rewrite Knowledge during recall. Offer an update candidate when a material difference exists.

## Answer

Answer the question directly, name the local note(s) used with relative paths, and briefly flag confidence or staleness only when it matters. State when no relevant memory was found. This workflow is read-only unless the user separately requests an update.

