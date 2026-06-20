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
- **Learning** (`learnings/`) — a raw correction, append-only; promoted to a
  rule once it recurs.

## `rules/always/` has a soft cap of ~5 files

Each file here loads into every prompt's context budget. Promotion
requires the rule to be both universal *and* worth that cost. The cap
isn't enforced mechanically — hold it in PR review.

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
