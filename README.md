# agent-rules

James's portable corpus of coding preferences, anti-patterns, and
corrections. Discovered by Claude Code as a skill via
[`SKILL.md`](SKILL.md).

## What lives here

- [`SKILL.md`](SKILL.md) — entry point for AI tools (the skill manifest and map).
- [`AGENTS.md`](AGENTS.md) — architectural decisions; read before restructuring.
- [`CONTRIBUTING.md`](CONTRIBUTING.md) — how new entries get added.
- `rules/` — curated, durable rules.
  - `always/` — universal; loaded every session.
  - `scoped/` — topic-specific; loaded when relevant.
- `skills/` — task-triggered method guidance, each loaded on demand.
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

   **nix-darwin + home-manager** (declarative, preferred):
   ```nix
   home.activation.agentRulesSkills = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
     mkdir -p ~/.claude/skills
     link_skill() {
       local name="$1" target="$2"
       if [[ -e ~/.claude/skills/$name && ! -L ~/.claude/skills/$name ]]; then
         echo "WARNING: ~/.claude/skills/$name exists and is not a symlink — leaving alone"
       else
         ln -sfn "$target" ~/.claude/skills/$name
       fi
     }
     link_skill agent-rules ~/code/agent-rules
     link_skill dense-agent-docs ~/code/agent-rules/skills/dense-agent-docs
   '';
   ```

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
- Promotion to a permanent rule is a separate PR after the same correction recurs.

## Why this exists

A new conversation has no memory of how the last one ended. Auto-memory
captures some of it, but it's ephemeral and machine-local. This repo is the
deliberate, portable, version-controlled subset — the things James has
actually said "do it this way" about. It travels with the user, not the tool.
