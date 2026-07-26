---
description: Comments only surface gotchas, unusual patterns/algorithms, or non-obvious decisions — never narrate the code, never leave scaffolding-era status notes
applies: code-style
---

# Comments are for gotchas, not narration

## The pattern

A comment earns its place only by carrying what the code cannot:

1. a gotcha for the next editor (invariant, ordering constraint, trap);
2. clarification of an unusual pattern or algorithm;
3. the *why* behind a non-obvious decision.

Everything else goes: comments restating what the code obviously does, and
scaffolding-era status notes ("STUB", "until X lands in Wave 3", PR numbers as
future tense) — git history owns provenance, and stale narration actively
misleads (a reader can't tell what's real).

## Why

- Comment *density* is not a virtue and reads as noise to James — heavily
  commented code was part of what made a codebase feel "impossible for
  maintainers to work with" even when reviewers rated the same comments
  favourably.
- Status-note comments rot silently: nothing forces an update when the
  referenced future arrives, so they end up describing shipped production
  code as a stub.

## When this came up

Issue Atlas codebase review (2026-07-26): four review agents *praised* the
repo's comment density ("every non-obvious decision documented"). James
corrected: "The comments often state the obvious and instead should only be
to surface gotchas for future readers, or clarify unusual patterns/algorithms."
The review had also found production files still headed "STUB." weeks after
shipping.

## When NOT to apply

- Decision-record comments with a real *why* (trade-off, named test oracle,
  rationale a reader can't infer) are category 3 — keep them.
- Public-API doc comments in a library meant for external consumers follow
  the library's documentation standard, not this rule.
- Docs files aren't comments — density rules for those live in
  `dense-agent-docs`.
