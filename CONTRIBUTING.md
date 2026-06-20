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
5. Add it to the **Learnings** list in `SKILL.md`, with its topic — that's how
   the agent finds it later.
6. Commit (`learning: prefer X over Y`), push, `gh pr create --fill`.
7. Drop the PR link in chat.

Skip the PR for one-off naming choices, transient context, or anything that
won't help a future session on a different task. The friction of asking is
part of the bloat control.

## Promotion: learning → rule

Recurrence is the trigger to *consider* promotion, not an automatic graduation:
when a correction recurs and clears the anti-bloat checklist below (universal,
portable, worth the always/ cost), promote it in a follow-up PR:

1. Distil it into `rules/scoped/<topic>.md` — or `rules/always/` for a genuinely
   universal rule (be strict; see the always/ cap in `AGENTS.md`).
2. Delete the learning from `learnings/` — git keeps the history; don't leave a
   duplicate behind.
3. In `SKILL.md`, move it from **Learnings** to **Always** / **Scoped**.

## Seeding a rule directly

A rule needn't come from a logged correction — write it straight into `rules/`
(the two starting rules were lifted from a global config this way). List it under
**Always** / **Scoped** in `SKILL.md`; the anti-bloat checklist and the
dense-agent-docs standard still apply.

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
description: one-line summary of the rule or learning
applies: code-style          # rough topic — how the agent finds it
---
```

No `status` (the directory says whether it's a rule or a learning), no date
(it's in git, and in the learning's filename), no recurrence counter (git is the
history). Body sections (enforced by the template): **The pattern** · **Why** ·
**When this came up** · **When NOT to apply**.

## Retiring a learning

If a learning no longer holds, delete it and remove it from `SKILL.md`. Git keeps
the history; there's no scheduled audit — prune by hand when you notice one.
