---
title: Public submission data boundary correction
date: 2026-09-03
status: active
project: none
---

# Goal

Investigate how a browser userscript can detect an online judge verdict and notify a local competition service without relying on a third-party submissions API.

# What happened

- A referenced MIT-licensed userscript was inspected to separate its DOM parsing from its same-origin verdict polling behavior.
- The script collects pending submission IDs from the user's submissions table, then checks the judge site's internal status endpoint until a final verdict appears.
- Cross-origin delivery to the local competition service was identified as a separate userscript-permission and pairing problem.

# What failed

- The initial live-page check selected an unrelated public submission merely because its URL was easy to find.
- The user rejected that test-data choice and supplied an acceptable account and submission boundary.
- Direct HTTP access to the approved page returned 403, and no browser backend was available, so current DOM verification remained incomplete.

# Misunderstandings corrected

- Publicly viewable submissions are not automatically acceptable as arbitrary integration-test inputs.
- The referenced script is not DOM-only: it uses the DOM to discover submission IDs and a logged-in same-origin JSON endpoint to obtain verdict changes.

# Reusable lessons

- The general privacy and test-data rule was distilled to [`agent-memory/shared/lessons/public-data-still-needs-purpose-and-permission.md`](../../agent-memory/shared/lessons/public-data-still-needs-purpose-and-permission.md).

# Open questions

- Verify the current judge-page selectors and status response using only a user-approved submission in an available signed-in browser.
- Finalize the userscript pairing, heartbeat, evidence schema, and same-second result reconciliation rules.
