# Agent Rules

This repo holds James's coding rules and the running log of corrections he's
given AI assistants. Treat the contents as standing instructions.

## Layout

- **`rules/always/`** — universal rules; load every task.
- **`rules/scoped/`** — topic-specific rules; load when the topic matches.
- **`learnings/`** — append-only corrections log. Skim recent entries
  before starting a non-trivial task.
- **`archive/`** — superseded entries; ignore unless reviewing history.

## Always

- [Verify the current date programmatically](rules/always/date-verification.md)

## Scoped

- [`NODE_ENV` is not a deployment stage](rules/scoped/node-env.md)

## Recent learnings

- [2026-06-20 — prefer early returns over nested conditionals](learnings/2026-06-20-early-returns.md)

## When James redirects you

Follow [`CONTRIBUTING.md`](CONTRIBUTING.md). Short version: draft an entry
in `learnings/YYYY-MM-DD-slug.md`, commit on a branch, open a PR with
`gh pr create`, and link the PR in chat so he can review.

Don't open a PR for trivial corrections (a typo, a one-off naming choice)
or for **project-specific patterns** — those belong in that project's own
`AGENTS.md` or `CLAUDE.md`, not here. This repo is for rules that travel
with the user across every codebase.

## Frontmatter

Every rule and learning file starts with:

```yaml
---
name: short-slug
description: One-line summary (this is what tools read at session start)
applies: code-style | tools | communication | <other>
severity: preference | rule | hard-rule
learned: YYYY-MM-DD
occurrences: 1
status: learning           # learning | promoted | deprecated
---
```

The `description` field is load-bearing: tools that rank rules by relevance
(Cursor's agent-requested rules; the Claude skill model) read only the
frontmatter at session start. Make every word earn its place.

## Anti-bloat (the line you should not cross)

Before writing any rule or learning, check:

1. Would a linter, type checker, formatter, or framework docs already
   surface this? → **Don't write it.**
2. Could a careful reader derive this from the surrounding code in
   30 seconds? → **Don't write it.**
3. Is there a non-obvious *why*? → If no, **don't write it.**
4. **Does the rule only apply to one specific codebase or project?**
   → Put it in that project's own `AGENTS.md` or `CLAUDE.md`, **not
   here.** This repo is portable; project-specific rules pollute every
   other project's context.

The full checklist lives in [`CONTRIBUTING.md`](CONTRIBUTING.md).
