#!/usr/bin/env bash
# Install agent-rules into the local Claude Code config.
#
# - Symlinks the repo to ~/.claude/skills/agent-rules/ so it's discovered
#   as a skill (frontmatter loads at session start; body loads on demand).
# - Appends a marker-fenced pointer block to ~/.claude/CLAUDE.md so the
#   assistant knows where to look and when to open a PR.
#
# Idempotent: re-running is a no-op.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CLAUDE_DIR="$HOME/.claude"
SKILLS_DIR="$CLAUDE_DIR/skills"
SKILL_LINK="$SKILLS_DIR/agent-rules"
CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"
MARKER="<!-- agent-rules:pointer -->"

mkdir -p "$SKILLS_DIR"

# 1. Symlink the repo into ~/.claude/skills/agent-rules
if [[ -L "$SKILL_LINK" ]]; then
  current="$(readlink "$SKILL_LINK")"
  if [[ "$current" == "$REPO_DIR" ]]; then
    echo "✓ skill symlink already points here: $SKILL_LINK"
  else
    echo "✗ $SKILL_LINK points at $current, not $REPO_DIR. Remove or fix it manually." >&2
    exit 1
  fi
elif [[ -e "$SKILL_LINK" ]]; then
  echo "✗ $SKILL_LINK exists and is not a symlink. Move it aside and re-run." >&2
  exit 1
else
  ln -s "$REPO_DIR" "$SKILL_LINK"
  echo "✓ symlinked $REPO_DIR → $SKILL_LINK"
fi

# 2. Append the pointer block to ~/.claude/CLAUDE.md if not already there.
if [[ -f "$CLAUDE_MD" ]] && grep -qF "$MARKER" "$CLAUDE_MD"; then
  echo "✓ pointer block already present in $CLAUDE_MD"
else
  cat >> "$CLAUDE_MD" <<EOF

$MARKER
## agent-rules

My durable coding rules and corrections log live in \`~/code/agent-rules/\`
(also symlinked at \`~/.claude/skills/agent-rules/\`). Read \`AGENTS.md\`
there for the map. When working on a non-trivial task, skim the relevant
scoped rules and recent learnings.

When I redirect you on a preference that should generalise, follow that
repo's \`CONTRIBUTING.md\`: draft a \`learnings/YYYY-MM-DD-slug.md\` entry
on a branch and open a PR with \`gh pr create\`.
EOF
  echo "✓ appended pointer block to $CLAUDE_MD"
fi

echo
echo "install complete. agents will discover this repo on the next session."
