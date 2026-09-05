---
title: Public user data still needs purpose and permission
created: 2026-09-03
last-reviewed: 2026-09-04
applies-to: shared
---

# Lesson

Publicly accessible user data is not automatically appropriate as convenient test data. When an integration can be validated with fixtures, the user's own data, or an explicitly approved account and artifact, use those narrower sources.

Separate open-web research from using a person's activity as application data. Reading an official public rule or technical document to understand a service is generally research; ingesting a named user's submissions, profile, content, or history for a test is a data-use decision that needs purpose, minimization, and ownership or explicit permission.

# Why

Technical accessibility answers whether data can be fetched, not whether an unrelated person's activity should be pulled into a development workflow. Selecting an arbitrary public account can violate the user's privacy expectations and collect fields that the test never needed.

# Workflow

1. State which external user data and fields the validation actually needs.
2. Prefer repository fixtures or synthetic data when they can prove the same behavior.
3. For a live integration test, use only user-owned data or a target the user explicitly approved.
4. Minimize fields at acquisition time; do not fetch source content when IDs, timestamps, and verdicts are sufficient.
5. If the approved target is unavailable, report the verification gap. Do not silently substitute another person's data.
6. Record the approved test-data boundary in the project's working agreement or test plan.
7. Record why each field is needed, where it is sent, and how long it is retained. Do not collect a broader response merely because the endpoint exposes it.

# Boundary

This is an engineering privacy rule, not a claim that public data is legally private. Broader collection requires a stated purpose and explicit project authorization rather than convenience.
