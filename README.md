# agent-rules

James's portable, agent-agnostic corpus of coding preferences, anti-patterns,
and corrections. Read by AI coding assistants (Claude Code, Cursor, Aider,
Codex, etc.) via the [`AGENTS.md`](AGENTS.md) convention.

## What lives here

- [`AGENTS.md`](AGENTS.md) — entry point for AI tools. The map.
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — how new entries get added.
- `rules/` — curated, durable rules.
  - `always/` — universal; loaded every session.
  - `scoped/` — topic-specific; loaded when relevant.
- `learnings/` — append-only log of corrections. Promoted to `rules/` after recurrence.
- `archive/` — superseded entries, kept for history.

## What does NOT live here

- **Tool installations** (MCP servers, IDE configs, skill packages) — those
  belong in declarative system config (nix flake, dotfiles, etc.), not here.
  This repo only describes *how to use* tools, not how to install them.
- **Project-specific instructions** — those go in each project's own
  `AGENTS.md` or `CLAUDE.md`.
- **Anything a linter, type checker, formatter, or framework docs already
  catches.** See the anti-bloat checklist in [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Setup

```bash
git clone <repo-url> ~/code/agent-rules
cd ~/code/agent-rules
./scripts/install.sh
```

`install.sh` does two things:

1. Symlinks the repo into `~/.claude/skills/agent-rules/` so Claude Code
   discovers it as a skill (frontmatter loads at session start; body loads
   on demand).
2. Appends a short, marker-fenced pointer block to `~/.claude/CLAUDE.md`
   so the assistant knows where to look and when to open a PR.

The script is idempotent — re-running it does nothing if already installed.

### Required environment

- `CONTEXT7_API_KEY` — set in your shell rc (or via nix-managed sops/agenix).
  Used by the `ctx7` CLI for library documentation lookups. Get a key at
  <https://context7.com>.

### MCP servers and tool installs

This repo deliberately does **not** install MCP servers or IDE-specific
configuration. Those live in the nix flake at `~/.config/nix/flake.nix`
(or wherever your system is declared). If a rule here references a tool,
the corresponding install belongs in the flake.

## Adding entries

See [`CONTRIBUTING.md`](CONTRIBUTING.md). In short:

- When an assistant is redirected mid-task, it offers to log a learning.
- On yes, it opens a PR adding `learnings/YYYY-MM-DD-slug.md` on a branch.
- James reviews and merges. The PR history *is* the corrections log.
- Promotion to a permanent rule is a separate PR after the same correction recurs.

## Why this exists

A new conversation has no memory of how the last one ended. Auto-memory
captures some of it, but it's ephemeral and machine-local. This repo is the
deliberate, portable, version-controlled subset — the things James has
actually said "do it this way" about. It travels with the user, not the tool.
