# agent-rules

James's portable corpus of coding preferences, anti-patterns, and
corrections. Each subdirectory of [`skills/`](skills/) is a self-contained
skill, discovered by Claude Code — and installable with the
[`skills`](https://www.npmjs.com/package/skills) CLI — via its `SKILL.md`.

## What lives here

- [`skills/`](skills/) — one directory per skill, each loaded on demand via its `SKILL.md`.
  - [`agent-rules/`](skills/agent-rules/) — the rules corpus. Its `SKILL.md` is the map; alongside it:
    - `rules/always/` — universal; applied to every task.
    - `rules/scoped/` — topic-specific; applied when the topic matches.
    - `learnings/` — corrections not yet promoted to `rules/`; listed in the `SKILL.md` by topic.
  - [`dense-agent-docs/`](skills/dense-agent-docs/) — writing standard for documents an LLM loads as instructions.
  - [`watch-review-feedback/`](skills/watch-review-feedback/) — after handing the human issues/PRs to review, tail the tracker and respond to their comments proactively, on the surface they came from.
- [`AGENTS.md`](AGENTS.md) — architectural decisions; read before restructuring.
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — how new entries get added.

## What does NOT live here

- **Tool installations** (MCP servers, IDE configs, skill packages) — those
  belong in declarative system config (nix flake, dotfiles, etc.), not here.
  This repo only describes *how to use* tools, not how to install them.
- **Project-specific instructions** — those go in each project's own
  `AGENTS.md` or `CLAUDE.md`.
- **Anything a linter, type checker, formatter, or framework docs already
  catches.** See the anti-bloat checklist in [`CONTRIBUTING.md`](CONTRIBUTING.md).

## Setup

### With the `skills` CLI (easiest)

[`skills`](https://www.npmjs.com/package/skills) discovers every skill under
`skills/` and links it into your agent's skills directory:

```bash
# both skills, globally, for Claude Code
npx skills add midzdotdev/agent-rules -g -a claude-code

# or list / pick
npx skills add midzdotdev/agent-rules --list
npx skills add midzdotdev/agent-rules --skill dense-agent-docs -g -a claude-code
```

### By hand

1. Clone:
   ```bash
   git clone git@github.com:midzdotdev/agent-rules.git ~/code/agent-rules
   ```

2. Symlink each skill into `~/.claude/skills/`. Claude Code does not recurse,
   so add one line per skill directory:

   ```bash
   mkdir -p ~/.claude/skills
   ln -sfn ~/code/agent-rules/skills/agent-rules ~/.claude/skills/agent-rules
   ln -sfn ~/code/agent-rules/skills/dense-agent-docs ~/.claude/skills/dense-agent-docs
   ```

   **Declarative** (e.g. nix-darwin + home-manager): make the same symlinks from
   an activation script — one per skill. Keep that logic in your system config,
   not copied here, so the two can't drift.

That's it. Each `SKILL.md` frontmatter loads at session start; the body
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
- On yes, it commits `learnings/YYYY-MM-DD-slug.md` straight to `main` and
  pushes — no branch, no PR. Your confirmation in chat is the gate; the commit
  history *is* the corrections log.
- Promotion to a permanent rule is a later commit, once the same correction
  recurs *and* still clears the anti-bloat bar — recurrence flags a candidate,
  it doesn't auto-promote.

## Why this exists

A new conversation has no memory of how the last one ended. Auto-memory
captures some of it, but it's ephemeral and machine-local. This repo is the
deliberate, portable, version-controlled subset — the things James has
actually said "do it this way" about. It travels with the user, not the tool.
