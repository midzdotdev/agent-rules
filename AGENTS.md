# Architecture

Non-obvious decisions about how this repo is structured. Read before
restructuring it (not before adding entries — that's `CONTRIBUTING.md`).

## Rules vs. skills vs. learnings

- **Rule** (`rules/`) — a standing preference that colours work continuously;
  short, resident (always/) or topically loaded (scoped/).
- **Skill** (`skills/`) — a procedure for a specific task, loaded on demand
  when its trigger fires. Choose this over a rule when the guidance is a
  multi-step method, not a one-line disposition. Each skill needs its own
  symlink into `~/.claude/skills/` (see the nix flake).
- **Learning** (`learnings/`) — a raw correction, append-only. Recurrence makes
  it a promotion *candidate*, not an automatic rule (see `CONTRIBUTING.md`).

## `rules/always/` has a soft cap of ~5 files

Always-on rules get pulled into context (via the SKILL.md body) for
essentially every non-trivial task, so each one competes for budget on
most loads. Promotion requires the rule to be both universal *and* worth
that cost. The cap isn't enforced mechanically — hold it in PR review.

## The SKILL.md list is the index — no separate index file

`SKILL.md` lists every un-promoted learning with its topic; the agent matches
that against the task, the same way it does for `rules/scoped/`. At this scale
the list *is* the index — a separate `INDEX.md`, a generator, or a CI check to
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
