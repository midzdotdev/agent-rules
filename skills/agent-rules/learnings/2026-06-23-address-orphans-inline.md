---
description: Reap orphans (zombie procs, stale files, broken units) inline during cleanup passes; only spawn_task when the fix needs the user's hands
applies: cleanup-discipline
---

# Address orphans inline during cleanup passes

## The pattern

When a cleanup / audit / post-deploy verification pass surfaces orphans that
predate the current task — zombie processes, stale tmp files, broken systemd
units, dead npm globals, leftover cron entries — sanity-check and fix them
inline. Don't flag them as a separate `spawn_task` chip just because they're
not strictly part of the current change.

Run the sanity check first: right user, no live consumer, not load-bearing
for anything running. Then `kill -TERM`, `rm`, `systemctl disable`, `crontab`
edit — whatever closes it out as part of the same pass.

Reserve `spawn_task` for fixes that genuinely can't be done now:

1. **Needs the user's hands** — OAuth flows in a browser, BotFather token
   rotation in Telegram, anything requiring a credential the agent doesn't
   have.
2. **Blast radius warrants explicit approval** — deleting a customer-data
   directory, removing an Ansible role the playbook still references,
   modifying a shared production resource.

Everything else gets reaped inline.

## Why

- A cleanup pass that flags orphans without fixing them just shifts the bloat
  from the host to the user's chip queue. Same drift, different surface.
- Sanity-checking *and then asking* costs more attention than sanity-checking
  *and then doing* — once the check has passed, the action is the cheap part.
- Orphans drift silently between sessions. A pile of "I noticed this but
  didn't fix it" entries trains the agent to keep noticing without acting.
- `spawn_task` chips have a UI cost for James every time he sees one. Using
  them as the default for any pre-existing oddity makes the signal-to-noise
  ratio tank.

## When this came up

2026-06-23, vps-config — meridian/Claude-subscription rollout. The
post-deploy cleanup audit found three orphan `browser-use --mcp` processes
on the VPS still running from a May-14 prototype (40 days old, no live CDP
consumer, no parent in any systemd cgroup). I flagged them as a `spawn_task`
chip alongside an unrelated Telegram token issue (which legitimately needed
the user). James pushed back: *"Always proactively address issues like the
browser-use zombies"*. The reap was a one-line `kill -TERM 525176 525178
529545`, which then succeeded cleanly. The chip was withdrawn.

## When NOT to apply

- The user already chose to defer it (explicit "leave it for now" / "I'll
  handle that later"). Their decision wins.
- The orphan turns out to *be* load-bearing on inspection (something
  legitimately depends on it that the sanity check didn't surface). Stop,
  investigate, surface what you found before touching it.
- The orphan is genuinely outside the current session's scope *and* the
  inline fix would balloon — e.g., "this stale file is one of forty across
  three hosts" deserves a tracked task, not forty `rm`s mid-pass.
- The fix is destructive in a way that benefits from explicit
  user-in-the-loop approval, per the "blast radius" carve-out above.
