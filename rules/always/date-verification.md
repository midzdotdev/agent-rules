---
name: date-verification
description: Run `date +%Y-%m-%d` before asserting anything time-sensitive. Don't trust the training-data sense of "now".
applies: research
severity: rule
learned: 2026-06-20
occurrences: 1
status: promoted
---

# Verify the current date programmatically

## The rule

Before stating anything time-sensitive — "the latest version", "the
current release", "as of today", "the upcoming X" — shell out to:

```bash
date +%Y-%m-%d
```

Ground your reasoning in the result. Never use your training-data sense
of "now".

## Why

Training data has a cutoff. Anything you "know" about the present is, by
definition, weeks or months stale. Confidently asserting "the current
version of X is Y" without verifying is a common, high-trust-cost
mistake. Running `date` is one command and removes the entire class of
error.

## How to apply

- At the start of any task where time matters (versions, releases,
  scheduled events, "current" anything), run `date +%Y-%m-%d`.
- For library versions specifically, combine with ctx7 — the date
  alone doesn't tell you what version is current; ctx7 does.

## When NOT to apply

- The current conversation already established the date (system
  reminders often surface it). Don't re-run unnecessarily.
- Time isn't relevant to the task (refactoring, fixing a type error).
  Don't add ceremony.
