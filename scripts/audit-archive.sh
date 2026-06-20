#!/usr/bin/env bash
# Quarterly archive audit.
#
# Moves learnings to archive/learnings/ when ALL of:
#   - status: learning
#   - occurrences: 1
#   - learned date is more than THRESHOLD_DAYS ago
#
# Writes a human-readable report to $AUDIT_REPORT (default /tmp/audit-report.md)
# so the GitHub Action can use it as the PR body. The file moves are real:
# the PR contains actual `git mv`s. Merging accepts the archive; closing
# preserves the learning.
#
# Local use: just run it. Cross-platform (GNU + BSD date).

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPORT="${AUDIT_REPORT:-/tmp/audit-report.md}"
THRESHOLD_DAYS="${THRESHOLD_DAYS:-180}"

cd "$REPO_DIR"

# Cross-platform date parser (GNU date on Linux, BSD date on macOS).
if date -d "2020-01-01" +%s >/dev/null 2>&1; then
  parse_date() { date -d "$1" +%s; }
else
  parse_date() { date -j -f "%Y-%m-%d" "$1" +%s; }
fi

now_epoch=$(date +%s)
candidates=()

while IFS= read -r -d '' file; do
  learned=$(awk '/^learned:/{print $2; exit}' "$file")
  occurrences=$(awk '/^occurrences:/{print $2; exit}' "$file")
  status=$(awk '/^status:/{print $2; exit}' "$file")

  [[ "$status" != "learning" ]] && continue
  [[ "$occurrences" != "1" ]] && continue
  [[ -z "$learned" ]] && continue

  learned_epoch=$(parse_date "$learned" 2>/dev/null || echo "")
  [[ -z "$learned_epoch" ]] && continue

  age_days=$(( (now_epoch - learned_epoch) / 86400 ))
  if (( age_days > THRESHOLD_DAYS )); then
    candidates+=("${file}|${age_days}")
  fi
done < <(find learnings -type f -name "*.md" ! -name "INDEX.md" ! -name "TEMPLATE.md" -print0)

if (( ${#candidates[@]} == 0 )); then
  echo "no candidates" > "$REPORT"
  echo "no candidates this quarter; repo is healthy."
  exit 0
fi

mkdir -p archive/learnings
index_file="learnings/INDEX.md"

# 1. Move the stale learnings.
moved=()  # entries: "src|target|age"
for c in "${candidates[@]}"; do
  file="${c%|*}"
  age="${c##*|}"
  target="archive/learnings/$(basename "$file")"
  git mv "$file" "$target"
  moved+=("${file}|${target}|${age}")
done

# 2. Repoint INDEX.md rows for moved learnings and mark them archived. The link
#    target there is relative to learnings/, so it becomes ../archive/learnings/.
for m in "${moved[@]}"; do
  base="$(basename "${m%%|*}")"
  esc="$(printf '%s' "$base" | sed 's#[][\.*^$]#\\&#g')"  # escape regex metachars for awk
  awk -v lit="$base" -v rx="$esc" '
    index($0, "](" lit ")") {
      gsub("\\]\\(" rx "\\)", "](../archive/learnings/" lit ")")
      sub(/\| learning \|/, "| archived |")
    }
    { print }
  ' "$index_file" > "$index_file.tmp" && mv "$index_file.tmp" "$index_file"
done
git add "$index_file"

# 3. Find any OTHER file still referencing a moved learning (e.g. SKILL.md's
#    "Recent learnings" list). Those are curatorial — flag them, don't auto-edit.
refs=""
for m in "${moved[@]}"; do
  base="$(basename "${m%%|*}")"
  while IFS= read -r hit; do
    hit="${hit#./}"
    [[ "$hit" == archive/learnings/* ]] && continue  # the moved file itself
    [[ "$hit" == "$index_file" ]] && continue         # auto-repointed above
    refs+="- \`$hit\` references \`$base\`"$'\n'
  done < <(grep -rlF --exclude-dir=.git "$base" . 2>/dev/null | sort -u)
done

{
  echo "# Quarterly archive audit"
  echo
  echo "Proposing to archive ${#moved[@]} learning(s)."
  echo
  echo "Criteria: \`status: learning\`, \`occurrences: 1\`, \`learned\` older than ${THRESHOLD_DAYS} days."
  echo
  echo "## Moved"
  echo
  for m in "${moved[@]}"; do
    file="${m%%|*}"; rest="${m#*|}"; target="${rest%%|*}"; age="${rest##*|}"
    echo "- \`$file\` → \`$target\` (age: ${age}d)"
  done
  echo
  echo "\`learnings/INDEX.md\` rows were repointed to the archive and marked \`archived\` automatically."
  echo
  if [[ -n "$refs" ]]; then
    echo "## References to review"
    echo
    echo "These files still mention a moved learning — repoint or remove before merging:"
    echo
    printf '%s' "$refs"
    echo
  fi
  echo "## How to handle this PR"
  echo
  echo "- **Merge** if these learnings are truly stale."
  echo "- **Close without merging** if any is still relevant. The file stays in \`learnings/\`."
  echo "  Optionally bump its \`learned:\` field to today so this audit won't flag it next quarter."
} > "$REPORT"

echo "report at $REPORT; ${#moved[@]} file(s) moved."
