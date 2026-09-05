---
title: Review an external service before integrating it
created: 2026-09-04
last-reviewed: 2026-09-04
applies-to: shared
---

# Purpose

Prevent a technically working integration from violating service rules, overloading someone else's infrastructure, or using a person's data without an agreed purpose.

# Workflow

1. Inventory the service boundary from code: hosts, endpoints, methods, authentication, fields read or written, runtime versus one-time development access, frequency, concurrency, retries, storage, and downstream sharing.
2. Read current first-party sources before implementation: terms of service, service-specific rules, API documentation, rate limits, privacy/data terms, copyright or license conditions, and relevant contest or community rules. Record the review date and direct links.
3. Treat third-party examples as technical evidence only. A popular userscript or client demonstrates an approach; it does not grant permission from the service operator.
4. Separate public-information research from personal-data use. For named-user activity, prefer fixtures or the user's own data; otherwise obtain explicit permission for the exact account/artifact and state why and how it will be used.
5. Minimize both data and load. Request only needed fields, cache stable results, serialize calls where required, prevent overlapping loops and per-tab multiplication, add backoff for `429`/`5xx`, and stop on authorization failures.
6. Quantify the budget per user and at expected scale. Compare frequency, payload size, duration, and endpoint type—not just a timer constant.
7. Report three outcomes separately: confirmed rule, engineering inference, and unresolved ambiguity. Never turn “not explicitly forbidden” into “officially allowed.”
8. If the endpoint is undocumented, the rules are ambiguous, or scale/impact is material, surface concerns to the user and obtain a second independent review from another capable agent such as Codex or Claude Code. The user remains the decision owner; legal or operator confirmation may still be required.
9. Record guardrails and revisit triggers in the project. Re-review before public launch, multi-user scaling, monetization, new data fields, shorter polling, new endpoints, or terms changes.

# Minimum project record

- Service and purpose
- Official sources and review date
- Data fields, owner/permission, destination, retention
- Endpoint, authentication, cadence, concurrency, retry/backoff
- Known prohibitions and unclear areas
- Current decision and scope limit
- Revisit triggers and responsible decision owner

# Lesson from polling comparisons

“Every five seconds” is not enough to establish equivalence. One implementation may make one small JSON request only while work is pending, while another makes a full HTML request continuously and an additional JSON request during pending work. Count requests, payloads, active duration, and tab/process multiplication before claiming the load is comparable.
