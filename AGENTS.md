# Architecture

Non-obvious decisions about how this repo is structured. Read before
restructuring it (not before adding entries — that's `CONTRIBUTING.md`).

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
