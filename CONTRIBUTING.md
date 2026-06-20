# Contributing

Two ways the repo grows: corrections logged to `learnings/`, the recurring
ones promoted to `rules/`.

## Scope

Only **portable, cross-project** preferences belong here — things that travel
across every codebase. A rule that only makes sense in one project goes in
that project's own `AGENTS.md` / `CLAUDE.md`; mixing it in here pollutes
context for every other project.

| Belongs here | Goes in the project |
|---|---|
| "Prefer early returns over nested conditionals" | "Run `pnpm db:migrate` after schema changes in jobhunt" |
| "`NODE_ENV` is not a deployment stage" | "Staging API for project X is at `<url>`" |
| "For library docs, use ctx7" | "Uncheck Follow in LinkedIn Easy Apply" |

## Logging a learning

Once the immediate fix is applied, offer: *"Log this to `agent-rules`?"* On yes:

1. `cd ~/code/agent-rules`
2. `git checkout -b learning/<slug>`
3. Copy `learnings/TEMPLATE.md` → `learnings/$(date +%Y-%m-%d)-<slug>.md`
4. Fill in: what was asked, what was wrong, the correction, and **why** the
   preferred way is better.
5. Add a row to [`learnings/INDEX.md`](learnings/INDEX.md).
6. Commit (`learning: prefer X over Y`), push, `gh pr create --fill`.
7. Drop the PR link in chat.

Skip the PR for one-off naming choices, transient context, or anything that
won't help a future session on a different task. The friction of asking is
part of the bloat control.

## Promotion: learning → rule

When a correction recurs (bump `occurrences`), open a follow-up PR:

1. Distil the entry into `rules/scoped/<topic>.md` — or `rules/always/` for a
   genuinely universal rule (be strict; see the always/ cap in `AGENTS.md`).
2. Set the learning's `status: promoted`; leave the file as history.
3. Add the "Promoted to" link in `learnings/INDEX.md`.

## Anti-bloat checklist

A rule earns its place only if all hold:

- [ ] **Not lint-catchable** — no linter, type checker, formatter, or
      framework doc already enforces it.
- [ ] **Not derivable** in 30 seconds from the surrounding code.
- [ ] **Has a real *why*** — an incident, hidden constraint, or non-obvious
      tradeoff. If it's pure taste, say so.
- [ ] **Portable** across projects (else → the project's own file).
- [ ] **One file, one rule.**

Write the entry itself to the `dense-agent-docs` skill's standard.

## Frontmatter

```yaml
---
name: early-returns          # filename-safe slug
description: ...              # one line; load-bearing for relevance ranking
applies: code-style          # rough topic
severity: preference         # preference | rule | hard-rule
learned: 2026-06-20          # ISO date first added
occurrences: 1               # bumped each recurrence
status: learning             # learning | promoted | deprecated
---
```

Body sections (the template enforces them): **The pattern** · **Why** ·
**When this came up** · **When NOT to apply**.

## Archive audit

`.github/workflows/archive-audit.yml` runs quarterly and PRs stale learnings
(criteria in `scripts/audit-archive.sh`) into `archive/`. Merge to accept;
close to keep one alive — bump its `learned:` date so the next audit skips it.
