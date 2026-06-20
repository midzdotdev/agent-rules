---
name: agent-rules
description: James's portable coding rules, preferences, and corrections log. Consult before any non-trivial coding task. Apply rules/always/ every session; for the task's topic check rules/scoped/ and learnings/INDEX.md; skim the recent learnings below. When James redirects you on a generalisable preference, open a PR per CONTRIBUTING.md.
---

# agent-rules

## Layout

- **`rules/always/`** — universal; apply every task.
- **`rules/scoped/`** — topic-specific; apply when topic matches.
- **`learnings/`** — append-only corrections log. For the task's topic, scan
  the **Applies** column in [`INDEX.md`](learnings/INDEX.md) for past
  corrections; the recent few are also inlined under *Recent learnings* below.
- **`archive/`** — superseded; ignore.

## Always

- [Verify the current date programmatically](rules/always/date-verification.md)

## Scoped

- [`NODE_ENV` is not a deployment stage](rules/scoped/node-env.md)

## Recent learnings

- [2026-06-20 — prefer early returns over nested conditionals](learnings/2026-06-20-early-returns.md)

## See also

- Adding a learning or rule: [`CONTRIBUTING.md`](CONTRIBUTING.md)
- Changing how the repo itself works: [`AGENTS.md`](AGENTS.md)
