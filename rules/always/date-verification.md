---
name: date-verification
description: Run `date +%Y-%m-%d` before asserting anything time-sensitive. Don't trust the training-data sense of "now".
applies: research
severity: rule
learned: 2026-06-20
occurrences: 1
status: seeded
---

# Verify the current date programmatically

## The rule

Before stating anything time-sensitive — "latest version", "current release",
"as of today", "upcoming X" — run:

```bash
date +%Y-%m-%d
```

Ground the claim in the result, not the training-data sense of "now".

## Why

Your training has a cutoff, so any unverified "current X" is likely stale — a
high-trust-cost error that one command removes.

## How to apply

- For version/library currency, pair with ctx7: `date` says when "now" is,
  ctx7 says what's current.

## When NOT to apply

- The conversation already surfaced the date (system reminders often do).
- Time is irrelevant to the task (refactoring, fixing a type error).
