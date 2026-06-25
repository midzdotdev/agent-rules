# Architecture

Non-obvious decisions about how this repo is structured. Read before
restructuring it (not before adding entries — that's `CONTRIBUTING.md`).

## Every skill lives under `skills/` — no root `SKILL.md`

The repo root has no `SKILL.md`. Each skill is its own directory under
`skills/` (`agent-rules`, `dense-agent-docs`) and is self-contained — the
`agent-rules` skill carries its own `rules/` and `learnings/`.

Why no root manifest: the `skills` CLI (`npx skills add`) returns the *first*
`SKILL.md` it finds and stops unless `--list`/`fullDepth` is set. A root one
would make the CLI treat the entire repo as a single skill and never surface the
others. Keeping every skill one level down lets the CLI — and Claude Code, which
also doesn't recurse — discover and link each one independently.

## Entries commit straight to `main` — no branches, no PRs

The local clone is the source of truth: Claude loads these skills by symlink
from `~/code/agent-rules`, so the working copy must always be current. The
remote is a backup. Branch-and-PR would leave the local `main` stale between
merges and scatter the corrections log across PR threads.

So agents commit approved learnings/rules directly to `main` and push. The human
gate moves from async PR review to the in-chat confirmation *before* the commit;
the commit history is the log. The pre-commit hook (`lychee --offline`) validates
links locally — it's the gate now. The CI workflow still runs on push to `main`
but only as an after-the-fact external-link backstop on the backup; it no longer
gates anything (see `.github/workflows/links.yml`).

## Rules vs. skills vs. learnings

- **Rule** (`skills/agent-rules/rules/`) — a standing preference that colours
  work continuously; short. Applied to every task (always/) or when the topic
  matches (scoped/).
- **Skill** (`skills/`) — a procedure for a specific task, loaded on demand
  when its trigger fires. Choose this over a rule when the guidance is a
  multi-step method, not a one-line disposition. Each skill needs its own
  symlink into `~/.claude/skills/` (see the nix flake).
- **Learning** (`skills/agent-rules/learnings/`) — a provisional correction;
  deleted once promoted or retired (git is the history). Recurrence makes it a
  promotion *candidate*, not an automatic rule (see `CONTRIBUTING.md`).

## `rules/always/` has a soft cap of ~5 files

Always-on rules get pulled into context (via the `agent-rules` SKILL.md body)
for essentially every non-trivial task, so each one competes for budget on
most loads. Promotion requires the rule to be both universal *and* worth
that cost. The cap isn't enforced mechanically — hold it at capture time, when
you confirm the entry.

## The SKILL.md list is the index — no separate index file

The `agent-rules` SKILL.md lists every un-promoted learning with its topic; the
agent matches that against the task, the same way it does for `rules/scoped/`.
At this scale the list *is* the index — a separate `INDEX.md`, a generator, or a CI check to
keep them in sync is machinery the content doesn't yet justify. If the list ever
outgrows the entry doc, generate it from frontmatter then, not before.

## No cross-tool sync today

James currently uses only Claude Code. Adding ruler / per-tool fan-out
costs maintenance for tools that aren't active. Revisit when a second
tool (Cursor, Aider, Codex) lands — the frontmatter and structure here
are already ruler-compatible.

## Tool installs live in nix, not here

MCP server registrations, IDE extensions, CLI binaries — declared in
`~/.config/nix/flake.nix`, not duplicated here. This repo describes
*how* to use a tool; nix decides *whether* it exists. Keeps the repo
portable across machines and the nix flake the single source of truth
for machine state.
