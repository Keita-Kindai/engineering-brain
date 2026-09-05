---
name: grill-with-docs
description: A relentless interview to sharpen a plan or design, which also creates docs (ADR's and glossary) as we go.
---

# Grill with Docs

Apply the `grilling` and `domain-modeling` workflows together.

1. Read and follow [the grilling workflow](../grilling/SKILL.md) to explore the design tree in dependency-ordered rounds. Do not implement the plan until the user confirms the shared understanding.
2. Read and follow [the domain-modeling workflow](../domain-modeling/SKILL.md) throughout the interview. Check existing terminology and code, update the relevant `CONTEXT.md` as terms are resolved, and offer ADRs only when its stated criteria are met.

The grilling workflow controls the interview sequence and confirmation boundary. The domain-modeling workflow controls how terminology and decisions are challenged and documented.
