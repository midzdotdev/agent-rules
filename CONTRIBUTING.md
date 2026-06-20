# Contributing

This repo grows two ways: corrections logged as `learnings/`, and the
recurring ones eventually promoted into `rules/`.

## When James redirects you mid-task

The assistant should offer (once the immediate fix is applied):

> *"Want me to log this to `agent-rules`?"*

On yes:

1. `cd ~/code/agent-rules`
2. Branch: `git checkout -b learning/<short-slug>`
3. Copy `learnings/TEMPLATE.md` to `learnings/$(date +%Y-%m-%d)-<slug>.md`
4. Fill in honestly: *what was asked*, *what was done wrong*, *what the
   correction was*, **why** James's way is better.
5. Update [`learnings/INDEX.md`](learnings/INDEX.md) with a new row.
6. Commit with a tight message (`learning: prefer X over Y`).
7. Push and open a PR: `gh pr create --fill`.
8. Drop the PR link in chat so James can review.

On no, drop it. The friction of asking is part of the bloat control.

### Don't open a PR for

- One-off naming choices in a single file ("call it `tasks` not `items`").
- Project-specific patterns — those go in that project's `AGENTS.md`.
- Anything Claude is likely to forget the moment the conversation ends but
  doesn't generalise: trivia, transient context.

### Do open a PR for

- A pattern that should apply across tasks ("always prefer X over Y").
- A repeated mistake worth a named rule ("you keep doing Z; here's why
  that's wrong").
- An opinionated framework/tool choice ("never suggest `npm`, use `pnpm`").

## Promotion: learning → rule

When the same correction recurs (bump `occurrences` in frontmatter), open a
follow-up PR:

1. Move or distill the entry into `rules/scoped/<topic>.md` (or
   `rules/always/<name>.md` for genuinely universal rules — be very strict
   about this).
2. Update the learning entry's frontmatter: `status: promoted`.
3. Update [`learnings/INDEX.md`](learnings/INDEX.md) with the
   "Promoted to" link.
4. Leave the original `learnings/` entry in place — it's the history.

`rules/always/` should stay under five files. Every entry there is on every
prompt's context budget.

## Anti-bloat checklist

Before writing a rule, all of these must hold:

- [ ] **Not lint-catchable.** Linters, type checkers, formatters, or
      framework docs do not already enforce this.
- [ ] **Not derivable in 30 seconds** by a careful reader of the surrounding
      code.
- [ ] **Has a real *why*.** A specific incident, a hidden constraint, a
      non-obvious tradeoff. If the only reason is "I just like it that way,"
      keep it but write that down — at least future-you knows it's taste.
- [ ] **Correctly scoped.** Universal rules go in `always/`. Everything else
      in `scoped/`. When in doubt, scoped.
- [ ] **One file, one rule.** No omnibus files. Diffs and pruning depend on
      atomicity.

## Frontmatter conventions

```yaml
---
name: early-returns                              # filename-safe slug
description: Reduce nesting by returning early   # one line; load-bearing for relevance ranking
applies: code-style                              # rough topic
severity: preference                             # preference | rule | hard-rule
learned: 2026-06-20                              # ISO date the rule was first added
occurrences: 1                                   # bumped each time the correction recurs
status: learning                                 # learning | promoted | deprecated
---
```

After the frontmatter, every file has these sections (the template enforces
this):

- **The pattern** — what the rule actually says, with a code example if it
  helps.
- **Why** — the non-obvious reason. No why, no rule.
- **When this came up** — the original incident. Specific enough that the
  *why* is grounded in something real.
- **When NOT to apply** — edge cases. Forces honesty about scope.

## Archive workflow

A GitHub Actions workflow runs quarterly (`.github/workflows/archive-audit.yml`)
and proposes a PR archiving learnings that:

- Have `status: learning` (never promoted).
- Have `occurrences: 1` (never recurred).
- Are older than 180 days.

Review the PR and either:

- **Merge** if the entries really are stale → they move to `archive/`.
- **Close** if any are still relevant → they stay in `learnings/`.
  Optionally bump `learned:` to today so the audit doesn't flag them again
  next quarter.

The script is `scripts/audit-archive.sh` and works locally too.
