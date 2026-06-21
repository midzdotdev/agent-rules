# Git hooks

Versioned hooks for this repo. Enable them once per clone:

```bash
git config core.hooksPath .githooks
```

- **`pre-commit`** — runs `lychee --offline` over `**/*.md` to catch dangling
  relative links (e.g. a moved file) before they're committed. Needs
  [`lychee`](https://github.com/lycheeverse/lychee) on `PATH`
  (`brew install lychee`); skips with a notice if it's missing. The same check,
  plus external links, runs in CI via [`links.yml`](../.github/workflows/links.yml).
