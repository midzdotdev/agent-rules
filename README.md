# agent-rules

James's portable corpus of coding preferences, anti-patterns, and
corrections. Discovered by Claude Code as a skill via
[`SKILL.md`](SKILL.md).

## What lives here

- [`SKILL.md`](SKILL.md) — entry point for AI tools (the skill manifest and map).
- [`AGENTS.md`](AGENTS.md) — architectural decisions; read before restructuring.
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — how new entries get added.
- `rules/` — curated, durable rules.
  - `always/` — universal; applied to every task.
  - `scoped/` — topic-specific; applied when the topic matches.
- `skills/` — task-triggered method guidance, each loaded on demand.
- `learnings/` — corrections not yet promoted to `rules/`; listed in `SKILL.md` by topic.

## What does NOT live here

- **Tool installations** (MCP servers, IDE configs, skill packages) — those
  belong in declarative system config (nix flake, dotfiles, etc.), not here.
  This repo only describes *how to use* tools, not how to install them.
- **Project-specific instructions** — those go in each project's own
  `AGENTS.md` or `CLAUDE.md`.
- **Anything a linter, type checker, formatter, or framework docs already
  catches.** See the anti-bloat checklist in [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Setup

1. Clone:
   ```bash
   git clone <repo-url> ~/code/agent-rules
   ```

2. Make Claude Code discover `SKILL.md` by symlinking into `~/.claude/skills/`.
   The repo root is one skill; **each directory under `skills/` is its own
   skill and needs its own link** (Claude Code does not recurse). Add a line
   per skill.

   **Manual** (any system):
   ```bash
   mkdir -p ~/.claude/skills
   ln -sfn ~/code/agent-rules ~/.claude/skills/agent-rules
   ln -sfn ~/code/agent-rules/skills/dense-agent-docs ~/.claude/skills/dense-agent-docs
   ```

   **Declarative** (e.g. nix-darwin + home-manager): make the same symlinks from
   an activation script — one per skill. Keep that logic in your system config,
   not copied here, so the two can't drift.

That's it. `SKILL.md` frontmatter loads at session start; the body
loads on demand.

### Required environment

- `CONTEXT7_API_KEY` — set in your shell rc (or via nix-managed
  sops/agenix). Used by the `ctx7` CLI for library documentation
  lookups. Get a key at <https://context7.com>.

### Tool installs and MCP servers

This repo deliberately does **not** install MCP servers or IDE-specific
configuration. Those live in your system config (nix flake, dotfiles,
etc.). If a rule here references a tool, the corresponding install
belongs there.

## Adding entries

See [`CONTRIBUTING.md`](CONTRIBUTING.md). In short:

- When an assistant is redirected mid-task, it offers to log a learning.
- On yes, it opens a PR adding `learnings/YYYY-MM-DD-slug.md` on a branch.
- James reviews and merges. The PR history *is* the corrections log.
- Promotion to a permanent rule is a separate PR, once the same correction
  recurs *and* still clears the anti-bloat bar — recurrence flags a candidate,
  it doesn't auto-promote.

## Why this exists

A new conversation has no memory of how the last one ended. Auto-memory
captures some of it, but it's ephemeral and machine-local. This repo is the
deliberate, portable, version-controlled subset — the things James has
actually said "do it this way" about. It travels with the user, not the tool.
