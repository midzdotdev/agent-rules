#!/usr/bin/env bash
# Consistency check for the rules corpus. Guards the repo's core promise:
# every file loads cleanly into an agent. Verifies:
#   1. Relative markdown links resolve.
#   2. Every learning file has an INDEX.md row (and INDEX links resolve, via #1).
#   3. Rule and learning files carry frontmatter (--- + name: + description:).
#
# Run locally or in CI. Cross-platform (GNU + BSD). Exits non-zero on any failure.

set -uo pipefail
cd "$(cd "$(dirname "$0")/.." && pwd)"

fail=0
err() { echo "FAIL: $*"; fail=1; }

# 1. Relative markdown links resolve.
while IFS= read -r md; do
  dir="$(dirname "$md")"
  while IFS= read -r link; do
    case "$link" in http*|\#*|mailto*) continue ;; esac
    target="${link%%#*}"   # strip #anchor
    target="${target%%:*}" # strip :line suffix
    [[ -z "$target" ]] && continue
    [[ -e "$dir/$target" ]] || err "$md → broken link: $link"
  done < <(grep -oE '\]\([^)]+\)' "$md" | sed -E 's/^\]\(//; s/\)$//')
done < <(find . -name '*.md' -not -path './.git/*')

# 2. Every learning file is listed in INDEX.md.
index="learnings/INDEX.md"
for f in learnings/*.md; do
  base="$(basename "$f")"
  [[ "$base" == INDEX.md || "$base" == TEMPLATE.md ]] && continue
  grep -qF "($base)" "$index" || err "$f not listed in $index"
done

# 3. Rule and learning entries carry frontmatter.
while IFS= read -r f; do
  base="$(basename "$f")"
  [[ "$base" == README.md || "$base" == INDEX.md || "$base" == TEMPLATE.md ]] && continue
  [[ "$(head -n 1 "$f")" == "---" ]] || err "$f missing frontmatter open (---)"
  grep -qE '^name:' "$f"        || err "$f missing name:"
  grep -qE '^description:' "$f" || err "$f missing description:"
done < <(find rules learnings -name '*.md')

if (( fail )); then
  echo "consistency check FAILED"
  exit 1
fi
echo "consistency check passed"
