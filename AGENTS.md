# Engineering Brain adapter for Codex

この repository では [`BRAIN.md`](BRAIN.md) が Agent-neutral protocol の Source of Truth です。作業前に全文ではなく task に必要な section と該当 directory の index だけを読んでください。

- Memory retrieval は local-first / progressive disclosure で行う。
- 未登録 Project を勝手に登録しない。
- Public/private boundary と Knowledge ownership を守る。
- Memory publishingは`BRAIN.md`の境界に従う。Agent-authored `brain-learn` memoryだけが限定的な自動commit/push対象である。
- Canonical skills は `agent-tools/skills/`、Codex adapter は `.agents/skills/` にある。

## Learning documentation

`engineering-brain` is not only an archive of AI conversations.
`knowledge/` is the canonical, reviewable knowledge base for concepts the user has actually learned.

When the user asks to record, summarize, preserve, review, or update a learning session, follow these rules.

### Source of truth

- Treat Markdown under `knowledge/` as the canonical source of truth.
- Do not maintain the same prose manually in both Markdown and HTML.
- A future documentation site may render Markdown into HTML, but generated HTML is a view/build artifact, not the canonical knowledge record.
- Keep raw conversation material out of `knowledge/`. In Version 1, `sessions/` contains distilled summaries only; raw transcripts are not ingested.

### Goal of a learning note

A learning note must be useful to the user's future self.

Do not write only a textbook-style summary. Preserve the learning process when it adds value:

1. what was being learned;
2. what was initially confusing;
3. the user's initial mental model;
4. what was corrected or clarified;
5. the final mental model;
6. the actual execution/data/request flow;
7. important code and syntax;
8. common confusion points;
9. a short review section.

Prefer explanations that answer:

- Who calls this?
- When does it run?
- What arguments are passed?
- Where do those arguments come from?
- What does it return?
- Who receives the return value?
- What state, request, session, database, or UI changes as a result?

### Required structure

Use the following structure when it fits the topic:

```md
---
title: ...
date: YYYY-MM-DD
tags:
  - ...
status: learning | understood | review-needed
---

# Title

## 30-second summary
## Why this was confusing
## Final mental model
## End-to-end flow
## Important code and what it means
## What I misunderstood / corrected
## Common pitfalls
## Review questions
```

Do not force empty sections. Merge or omit sections when they do not improve the note.

### Visual explanations

For a technical learning record with enough substance to show a flow, boundary, relationship, state change, or important contrast, create Markdown and a Visual HTML page as a pair by default.

The Markdown may still use Mermaid for maintainable flows and sequences. The paired HTML serves a different purpose: rapid visual review.

HTML may be omitted only for a very short learning memo or when visualization would add almost no review value. State the omission and reason in the completion report.

For important flows, prefer diagrams that make boundaries explicit, such as:

- Client
- Server
- Proxy / Middleware
- Auth provider
- Database
- External service

Diagrams should show actual direction of data/control flow. Avoid decorative diagrams that do not improve understanding.

### Visual artifact relationship

Use this default pair:

```text
knowledge/<domain>/<topic>.md
knowledge/<domain>/visuals/<topic>.html
```

- Keep the explanatory Markdown as the canonical source of truth.
- Treat HTML as a derived learning artifact and link the two files in both directions.
- Do not duplicate the Markdown prose in HTML. Select only the mental model, end-to-end flow, boundaries, function/file relationships, important contrasts, critical code, pitfalls, and review prompts needed for quick review.
- Prioritize clear boundaries such as Client, Server, Proxy / Middleware, Auth provider, Database, and External service.
- Prefer a self-contained HTML file with inline CSS and SVG; use only minimal JavaScript when interaction materially helps.
- Avoid external CDN dependencies and make the page resilient on desktop and mobile.
- When the canonical concepts change, update or regenerate the derived HTML in the same task.

### Code handling

- Preserve only code that is important for the mental model.
- Add explanations around framework-generated or library-generated behavior.
- Clearly distinguish:
  - language syntax;
  - framework conventions;
  - library APIs;
  - application-specific code.
- When a short framework expression hides multiple operations, expand it conceptually.

Example:

```ts
export default NextAuth(authConfig).auth;
```

may be explained conceptually as:

```ts
const nextAuth = NextAuth(authConfig);
const authHandler = nextAuth.auth;
export default authHandler;
```

Do not claim conceptual expansions are literal library source code unless verified.

### Learning accuracy

Before finalizing:

- Separate Authentication from Authorization when relevant.
- Separate compile-time TypeScript types from runtime validation.
- Separate framework conventions from arbitrary filenames.
- Separate redirect/control-flow behavior from normal function return values.
- Distinguish current-request data from session state persisted across requests.
- Mark uncertain claims instead of guessing.

### File placement

Choose the most specific existing domain directory in `knowledge/`.

Examples:

```text
knowledge/
  nextjs/
  aws/
  linux/
  networking/
  databases/
```

Prefer one durable note per concept rather than many tiny session fragments.

If a matching note already exists, update it instead of creating a duplicate unless the new material is intentionally a separate topic.

### Naming

Use descriptive kebab-case filenames.

Examples:

```text
nextjs-authentication.md
server-actions.md
s3-fundamentals.md
linux-process-memory.md
```

### Metadata

Use frontmatter for durable notes where practical:

```yaml
---
title: Next.js Authentication
date: 2026-09-03
tags:
  - nextjs
  - authjs
  - authentication
  - authorization
status: understood
---
```

Use `status: review-needed` when important uncertainty remains.

### Review section

End substantial learning notes with a small self-check.

Prefer 3–7 questions that test the mental model rather than terminology memorization.

### Validation

After creating or updating a learning note:

- verify internal links and asset paths;
- verify Mermaid syntax when Mermaid is used;
- verify the Visual HTML in a browser at desktop and mobile sizes;
- check layout, overflow, readability, interaction, and browser console errors;
- if a docs-site build exists, run its build/check command;
- do not introduce a new docs framework during an unrelated learning-note task.

### Skill usage

When the request is primarily about turning a completed learning session into a durable note, use the `learning-note` skill if available.

Use `brain-maintenance` for repository-wide cleanup, distillation, archival, or cross-note maintenance rather than as the primary workflow for documenting one learning session.
