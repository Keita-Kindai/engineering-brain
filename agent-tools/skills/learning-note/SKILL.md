---
name: learning-note
description: >
  Turn a completed or partially completed technical learning session into a durable
  engineering-brain knowledge note for future review. Use when the user asks to
  record, summarize, preserve, revisit, or add what they learned to their notes,
  especially after a back-and-forth explanation where misunderstandings were
  corrected. Capture the final mental model, execution/data flow, important code,
  initial confusion and corrections, pitfalls, review questions, and useful diagrams.
  For substantive topics, create paired canonical Markdown and a derived single-file
  Visual HTML page by default. Update existing artifacts instead of duplicating them.
---

# Learning Note

Create or update a durable learning note from the user's learning session.

The goal is not to archive the conversation.
The goal is to produce a note that lets the user's future self reconstruct the concept quickly and accurately.

## 1. Resolve the Brain root and inspect context first

Before writing:

1. Resolve the Brain root from this canonical `SKILL.md` real path (`agent-tools/skills/learning-note/../../..`). If unavailable, try `ENGINEERING_BRAIN_ROOT`, then the real target of `~/.agents/skills/learning-note` or `~/.claude/skills/learning-note`, then a `BRAIN.md` in the current repository.
2. Read the Brain root's `BRAIN.md` and `AGENTS.md`.
3. Inspect the relevant `knowledge/` domain directory.
4. Search for an existing note covering the same concept.
5. Reuse existing naming, metadata, and organization conventions.
6. If the topic already has a durable note, update it rather than creating a near-duplicate.

Do not reorganize unrelated repository content.

## 2. Extract the learning story

Identify:

- the topic being learned;
- the user's original questions;
- which parts initially looked like unexplained template code;
- the user's initial mental model;
- corrections made during the session;
- the final mental model;
- important request/data/control flow;
- important code snippets;
- framework/library behavior hidden behind short expressions;
- remaining uncertainty.

Do not preserve every conversational turn.

Prefer the smallest set of facts that reconstructs the learning progression.

## 3. Distinguish layers explicitly

For technical notes, label concepts by layer when confusion is likely.

Examples:

- JavaScript / TypeScript syntax
- React behavior
- Next.js framework convention
- Auth.js / NextAuth API
- HTTP Request / Response
- Cookie / Session / JWT
- Database
- Application-specific logic

A reader should be able to tell which behavior is caused by the language, framework, library, or application.

## 4. Explain hidden invocation

For callbacks, framework handlers, hooks, Server Actions, middleware/proxy, ORM callbacks, event handlers, and similar abstractions, explicitly answer:

- Who invokes it?
- What causes it to run?
- What arguments are passed?
- Who constructs those arguments?
- What is returned?
- Who consumes that return value?
- What side effects occur?
- Does a new HTTP request occur afterward?

This is a high-priority requirement.

## 5. Build the final mental model

Prefer a small number of durable statements over many disconnected details.

For example:

```text
Authentication
= Are these credentials really this user?

Authorization
= May this already-identified user access this resource?
```

When multiple files participate in one workflow, summarize each file's responsibility.

## 6. Show the end-to-end flow

For workflows, include an end-to-end flow.

Prefer Mermaid when it improves understanding.

Good candidates:

- request lifecycle;
- login flow;
- redirect flow;
- DB query flow;
- component -> Server Action -> database flow;
- client/server boundaries;
- state transitions.

Do not use Mermaid when plain prose is clearer.

## 7. Write the note

Use frontmatter when repository conventions allow it.

Recommended structure:

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

Adapt the headings to the topic. Do not generate empty boilerplate.

## 8. Preserve useful code, not all code

Include code when it is needed to understand:

- API contracts;
- arguments;
- return values;
- destructuring;
- framework conventions;
- flow control;
- type relationships.

When useful, expand compressed expressions conceptually.

Example:

```ts
NextAuth(authConfig).auth
```

can be explained as:

```ts
const configuredAuth = NextAuth(authConfig);
const auth = configuredAuth.auth;
```

State clearly that conceptual expansions are explanations, not necessarily literal source implementation.

## 9. Capture corrections

Include a concise section explaining meaningful corrections made during learning.

Examples:

- `matcher` decides whether Proxy runs; it does not itself decide whether authentication is required.
- `User` TypeScript types do not runtime-validate DB rows.
- `bcrypt.compare()` compares a plain input password against the stored hash; it does not hash for storage.
- `authorize()` and `authorized()` are separate stages.
- `return user` does not directly assign the object to a later callback's `auth.user`.

Avoid cataloging trivial typos.

## 10. Add review questions

Add 3-7 questions.

Questions should require reconstruction of the mechanism.

Bad:

```text
What does auth mean?
```

Better:

```text
Why does `proxy.ts` run again after a successful login redirect?
```

## 11. Create paired Visual HTML by default

After the Markdown is complete, create or update its paired Visual HTML whenever the learning record has enough substance to show a flow, boundary, relationship, state change, or important conceptual contrast.

Use this default pair:

```text
knowledge/<domain>/<topic>.md
knowledge/<domain>/visuals/<topic>.html
```

The Markdown remains the canonical source of truth. The HTML is a derived artifact for rapid human review, not a second prose document.

The HTML should prioritize:

- the end-to-end flow;
- Client / Server / Proxy or Middleware / Auth provider / Database / External service boundaries;
- function and file relationships;
- important distinctions such as Authentication versus Authorization;
- only the code needed to understand the mechanism;
- high-value misconceptions, pitfalls, and review prompts.

Do not copy the full Markdown into HTML. Synthesize a visual model from it. Link Markdown to HTML and HTML back to Markdown.

Prefer one self-contained HTML file with semantic HTML, inline CSS, and inline SVG. Use minimal JavaScript only when it materially improves exploration or review. Avoid external CDN, font, image, and script dependencies. Make it responsive, keyboard-usable, and readable without requiring interaction.

Omit HTML only for a very short memo or when visualization would add almost no value. Record the reason in the completion report.

## 12. File placement

Use the narrowest suitable domain.

Example:

```text
knowledge/nextjs/nextjs-authentication.md
knowledge/nextjs/visuals/nextjs-authentication.html
```

Use descriptive kebab-case names.

## 13. Final checks

Before completion, verify:

- the note reflects the user's final understanding, not an earlier misunderstanding;
- Authentication and Authorization are not conflated;
- framework-generated arguments are explained;
- return values and consumers are explained;
- redirect behavior is correctly described;
- TypeScript-only types are not described as runtime validation;
- raw secrets, credentials, tokens, private URLs, and sensitive personal data are absent;
- links/assets resolve;
- Mermaid syntax is valid when used;
- Visual HTML contains no external runtime dependency;
- canonical Markdown and derived HTML link to each other;
- Visual HTML is opened in a browser and verified at desktop and mobile viewport sizes;
- no horizontal page overflow, clipped content, broken interaction, or browser console error remains;
- an existing docs-site build passes if one already exists.

## 14. Completion report

At the end, report only:

- file created or updated;
- Visual HTML created or updated, or the explicit reason it was omitted;
- any unresolved point marked `review-needed`;
- browser verification and validation/build result.

Do not repeat the entire note in the completion report.
