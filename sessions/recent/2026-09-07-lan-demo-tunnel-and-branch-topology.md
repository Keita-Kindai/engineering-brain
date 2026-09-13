---
title: LAN demo blocked by AP isolation, and the stacked branch topology
date: 2026-09-07
status: active
project: custom-contest
---

# Goal

Serve the Custom Contest dev app to a second participant for a live duel demo, then work out which branches are actually ready to push and open as pull requests.

# What happened

The dev server was started with `next dev -H 0.0.0.0 -p 3000` and the LAN URL answered `200` from the host machine, but the friend's browser hung with a pending request. The cause was the router, not the app. After the demo question, a branch survey showed that four of the six feature branches are stacked on one another rather than cut from `main`.

# What worked

- Cloudflare quick tunnel (`cloudflared tunnel --url http://localhost:3000`) reached the second participant when the LAN could not.
- `allowedDevOrigins: ['*.trycloudflare.com']` in `apps/web/next.config.ts` let Next.js dev accept the tunnel host. Next detected the config edit and restarted itself.
- `git merge-base` plus `git rev-list --left-right --count` exposed the branch topology in two commands.

# What failed

- Reaching the friend over the LAN. `ping` to the router succeeded while `ping` to two peer devices on the same subnet failed. That is AP client isolation; no server-side change can work around it.
- The previously built userscript pointed at a stale origin (`http://192.168.0.35:3000`) from an earlier network, so it could not have worked even without the isolation.

# Important discoveries

- `strict-origin-when-cross-origin` in DevTools is the default Referrer-Policy label, not an error. The real symptom was that no request ever reached the server.
- The userscript bakes the server origin in at build time, into both `@connect` and the bundle body. Editing the installed script by hand means changing two places; rebuilding with `CUSTOM_CONTEST_SERVER_ORIGIN=<origin> pnpm userscript:build` is the supported path.
- A quick tunnel gets a new random hostname on every restart, so every restart forces a userscript rebuild and a reinstall for both participants.
- `cloudflared` errors limited to `/_next/hmr` with `type=ws` are dev hot-reload sockets. They do not explain an application-level failure.

# Misunderstandings corrected

- `apps/userscript/dist/` is ignored by `.gitignore:4`. It was described as uncommitted work; it is untracked build output.
- `git rebase main` was suggested for the stacked branches, but every branch already forks from the current `main` tip, so it is a no-op today. The branches need `git rebase --onto main feat/problem-set-frontend <branch>` after the base branch merges.

# Project state changes

- `feat/lan-demo-mvp` merged through PR #4. The working tree still sat on that branch, two commits behind `main`, which is what the demo was run from.
- `feat/problem-set-frontend` and `feat/fake-opponent` are the only branches that can be reviewed against `main` on their own.
- `feat/auth`, `feat/bo3`, and `feat/fake-opponent` exist only locally.

# Reusable lessons

- [[rebase-stacked-branches]] — detect a stacked topology and land it with `--onto` rather than moving files between branches.
- When a LAN demo hangs with no server log entry, test peer reachability before touching the application. Router client isolation looks exactly like an application hang.

# Open questions

- Whether the practice-side branches should be squashed before landing, given three of them replay the same two problem-set commits.
