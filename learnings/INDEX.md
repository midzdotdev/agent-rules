# Learnings index

Tracks every learning entry and whether it has been promoted to a rule.

| Date       | Learning                                                  | Status   | Promoted to |
|------------|-----------------------------------------------------------|----------|-------------|
| 2026-06-20 | [early-returns](2026-06-20-early-returns.md)              | learning | —           |

## How promotion works

When a learning's correction recurs (track via the `occurrences` field in
its frontmatter), open a PR distilling it into a file under `rules/scoped/`
(or `rules/always/` for genuinely universal rules — be strict).

After promotion:

- The original `learnings/*.md` file stays put (history).
- Its frontmatter `status:` changes from `learning` to `promoted`.
- The row in this index gets a "Promoted to" link to the rule file.

See [`../CONTRIBUTING.md`](../CONTRIBUTING.md) for the full workflow.
