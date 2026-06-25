---
name: agent-rules
description: James's portable coding rules, preferences, and corrections log. Consult before any non-trivial coding task. Apply rules/always/ every session; for the task's topic check rules/scoped/ and the learnings listed below. When James redirects you on a generalisable preference, open a PR per CONTRIBUTING.md.
---

# agent-rules

## Layout

- **`rules/always/`** — universal; apply every task.
- **`rules/scoped/`** — topic-specific; apply when topic matches.
- **`learnings/`** — corrections not yet promoted to rules; listed below with
  their topic. Apply when the topic matches.

## Always

- [Verify the current date programmatically](rules/always/date-verification.md)

## Scoped

- [`NODE_ENV` is not a deployment stage](rules/scoped/node-env.md)

## Learnings

Not yet promoted to rules — apply when the topic matches.

- [Prefer early returns over nested conditionals](learnings/2026-06-20-early-returns.md) — *code-style*
- [Clean up after yourself](learnings/2026-06-25-cleanup-artifacts.md) — *workflow*

## See also

These live at the repo root (one level above this skill), so use the repo links:

- Adding a learning or rule: [`CONTRIBUTING.md`](https://github.com/midzdotdev/agent-rules/blob/main/CONTRIBUTING.md)
- Changing how the repo itself works: [`AGENTS.md`](https://github.com/midzdotdev/agent-rules/blob/main/AGENTS.md)
