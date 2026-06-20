# Agent Rules

This repo holds James's coding rules and the running log of corrections he's
given AI assistants. Treat the contents as standing instructions.

## Layout

- **`rules/always/`** — universal rules; load every task. *(Empty until the
  first promotion. Look at `learnings/` for live preferences.)*
- **`rules/scoped/`** — topic-specific rules; load when the topic matches.
  *(Empty until the first promotion.)*
- **`learnings/`** — append-only corrections log. **This is the hot area.**
  Skim recent entries before starting a non-trivial task.
- **`archive/`** — superseded entries; ignore unless reviewing history.

## Recent learnings

- [2026-06-20 — prefer early returns over nested conditionals](learnings/2026-06-20-early-returns.md)

## When James redirects you

Follow [`CONTRIBUTING.md`](CONTRIBUTING.md). Short version: draft an entry
in `learnings/YYYY-MM-DD-slug.md`, commit on a branch, open a PR with
`gh pr create`, and link the PR in chat so he can review.

Don't open a PR for trivial corrections (a typo, a one-off naming choice).
Open one when the redirect names a *pattern* you should apply next time too.

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

The full checklist lives in [`CONTRIBUTING.md`](CONTRIBUTING.md).
