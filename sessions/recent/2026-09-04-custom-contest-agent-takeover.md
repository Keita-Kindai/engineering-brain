---
title: Custom Contest interrupted-agent takeover
date: 2026-09-04
status: active
project: none
---

# Goal

Recover an interrupted backend implementation from an existing dirty worktree and complete the invite-only, two-participant BO1 demo vertical slice without discarding prior work.

# What happened

- The partially implemented contracts, domain state machine, and fixed problem pool were treated as evidence, then compared with accepted product, ADR, flow, and design documents.
- Missing HTTP routes, in-process room authority, PostgreSQL result persistence, userscript delivery, frontend integration, and automated tests were completed around the existing schemas.
- A durable repository handoff and demo runbook now describe the implemented boundary and the remaining live-service rehearsal.
- The normal Homebrew PostgreSQL 18 service was diagnosed and restored without replacing or reinitializing its cluster. The project database, migration, DB integration tests, localhost health, and LAN health then passed.
- The accumulated uncommitted MVP work was found directly on `main`. It was preserved in place and moved to `feat/lan-demo-mvp` before creating the first project snapshot commit, `4126938` (`feat: deliver invite-only LAN duel MVP`). Local and remote `main` remained at the initial commit.
- Repository guidance, Issue forms, a PR template, and a minimal `pnpm check` GitHub Actions workflow were added so future work follows Issue → branch → checks → PR → user-approved merge.
- A later fake-opponent task was isolated from unrelated work with `/private/tmp/custom-contest-fake-opponent`. Leaving that finished worktree registered blocked checkout of `feat/fake-opponent`; the lifecycle was corrected to include clean-state verification and `git worktree remove` before handoff.

# What worked

- Recovering intent from contracts, tests, accepted ADRs, and current diffs was more reliable than guessing what the interrupted agent planned next.
- A production Next.js server, temporary PostgreSQL 18 instance, and two independent Chromium contexts exercised the real browser/server/database boundary.
- Extending the browser test through saved-result reload and mutual rematch caught a gap between the written acceptance criteria and the earlier test.
- Visual evidence exposed a transient `4` before a required `3 → 2 → 1` countdown; clamping the display to the shared countdown duration fixed it.
- Synthetic evidence verified the flow without accessing unrelated users' submissions.
- Checking each service layer independently (`brew services`, `launchctl`, `pg_ctl`, `pg_isready`, then `psql`) isolated a launchd spawn problem from PostgreSQL installation, cluster, port, and SQL problems.
- Starting the already-loaded LaunchAgent with `launchctl kickstart` restored a launchd-owned PostgreSQL PID after the unified log showed `pending spawn, domain in on-demand-only mode`.
- A real two-PC rehearsal with Tampermonkey, separate AtCoder accounts, an actual submission, verdict ingestion, and winner determination completed successfully without an observed interruption.

# What failed

- The default shell Node version did not match the repository version; explicitly selecting Node 24.19.0 was required.
- PostgreSQL startup needed permissions unavailable in the restricted sandbox because of shared-memory and local-process constraints.
- A development-server lock conflicted with browser testing; using a production build and `next start` produced a deterministic E2E server.
- Vitest initially collected the Playwright spec; restricting its include pattern separated fast tests from browser tests.
- An early result screenshot captured a transition frame; moving animation to the card and waiting briefly before capture produced stable evidence.
- `brew services start` reported success even while launchd had registered but not spawned the process; service-manager success was not database readiness.
- A validation rerun accidentally used the default Node 22 even though pnpm itself was 11.19.0. Prepending the Node 24.19.0 bin directory to `PATH` and printing both versions made the runtime proof explicit.
- The temporary fake-opponent worktree was left registered after its commit. Git correctly rejected a second checkout of the same branch with `already used by worktree`; worktree creation without explicit cleanup is an incomplete workflow.

# Important discoveries

- Homebrew's PostgreSQL 18.3 installation and `/opt/homebrew/var/postgresql@18` cluster were valid. The practical root cause was a loaded LaunchAgent whose spawn was pending because the GUI launchd domain was in on-demand-only mode.
- The earlier `database "keita" does not exist` log was the default-database-name behavior of a client that omitted `-d`, not evidence that the server or cluster was broken.
- `brew services stop` initiated smart shutdown, but launchd sent SIGKILL after five seconds; the next direct start recovered successfully and no corruption evidence was found.
- The migration script intentionally re-executes idempotent SQL and prints `applied 0001_match_results` even when the migration row already exists; the table or health endpoint is the authoritative applied-state check.
- The first live rehearsal exposed experience and traffic issues that synthetic tests did not: routine success notifications stayed visible, LOSE reused the win color, START changed too abruptly, and submission polling was duplicated by heartbeat and timer paths.
- Userscript `0.1.1-demo` limits the AtCoder reachability probe to once per 15 seconds, uses one non-overlapping five-second submission loop, runs only in the dedicated AtCoder connection tab, and auto-hides successful connection notices after four seconds. It still needs one live regression after both PCs replace `0.1.0-demo`.
- Automated tests cannot prove the current logged-in AtCoder DOM and status endpoint behavior. A manual rehearsal remains required with only `Litms` or an explicitly authorized friend's account.
- The generated userscript is intentionally untracked and must be rebuilt after the demo server's LAN origin is known.
- Two specification gaps found during final audit were closed: physical deletion after 90 days and the device-local list of the latest three result URLs.
- A source-level comparison corrected the earlier traffic claim. AtCoderResultNotifier reads Pending IDs from the current DOM and makes one status JSON request per contest every five seconds only while Pending; Custom Contest `0.1.1-demo` could fetch the submissions HTML and then status JSON in the same cycle. `0.1.2-demo` now uses the refreshed submissions HTML for both discovery and verdict transitions, limiting active-match AtCoder traffic to one non-overlapping request per five seconds, with exponential backoff up to 60 seconds and immediate 60-second backoff for authentication rejection or `429`.
- AtCoder's public terms prohibit conduct that harms the service or significantly disadvantages others but do not publish a numeric automation allowance for the internal submissions endpoints used here. The two-person demo is therefore documented as a low-load, own-data, cautionary scope—not as officially approved automation.
- AtCoder Problems explicitly asks API users to sleep for more than one second between calls. The offline problem-pool generator now fetches its two resources serially with a 1.1-second delay and remains outside room/match runtime.
- AtCoder's current terms also require one account per person and prohibit lending or sharing accounts. A two-player rehearsal must use each participant's own account rather than a spare account created by one person.
- GitHub CLI 2.98.0 is installed and supports Issue-linked branches, PR creation, checks, and reviews, but the configured `Keita-Kindai` token was invalid. Its local `gh pr create --help` does not yet expose the newer documented `--attach` flag, so screenshots should be uploaded through the browser until the installed CLI is updated and the flag is verified. Remote Issue, push, PR, and ruleset changes remain blocked until `gh auth login -h github.com` succeeds.

# Reusable lessons

- For interrupted-agent recovery, first inventory the dirty worktree and map implemented boundaries to accepted specifications; do not equate file presence with completion.
- Test the handoff seams, not only isolated modules: two clients, server authority, persistence, reload, and the next state transition belong in one vertical-slice check.
- Keep external-user integration checks separate from synthetic acceptance tests, and leave a precise manual-verification boundary when login state prevents automation.
- Diagnose bottom-up without destructive shortcuts: process ownership and manager state, listener/readiness, SQL connection, database existence, application configuration, migration, then HTTP health.
- Treat `pg_ctl` as an alternate direct control path, not another mandatory layer below launchd. Do not mix a direct `pg_ctl start` process with a Homebrew-managed process after diagnosis.
- Do not delete `postmaster.pid`, sockets, or the data directory, and do not run `initdb` over an existing cluster, until a stale artifact or invalid cluster is actually proven.
- After an external integration works end to end, audit request cadence and persistent UI feedback separately; functional success alone does not prove respectful traffic or a quiet user experience.
- For any external service, read first-party terms and API rules first, inventory exact data and request behavior from code, distinguish public research from personal-data use, and report rules, inferences, and ambiguity separately. A third-party client is evidence of technique, not permission.
- A green-main convention needs three layers: Agents branch before editing, CI checks every proposed integration, and remote branch protection prevents bypass. Any one layer alone is insufficient.
- Prefer one ordinary worktree. When parallel isolation is necessary, treat `git worktree add` through clean verification and `git worktree remove` as one atomic lifecycle; a branch can be checked out in only one worktree at a time.

# Open questions

- Do the current AtCoder submissions table selectors and same-origin status response still match the userscript when tested in a logged-in Tampermonkey session?
- What upstream macOS event placed the GUI launchd domain in on-demand-only mode? The measured incident is recoverable, but that deeper OS trigger was not proven.
- Before Custom Contest moves beyond a two-person invite-only demo, should AtCoder be contacted for explicit guidance on polling the undocumented authenticated submissions pages?
- After GitHub CLI authentication is restored, should the repository ruleset require PR plus CI only for the current solo phase, then add one mandatory approval when a second GitHub reviewer joins?
