---
description: After capturing what you need, delete the throwaway artifacts/resources you created — scratch repos, test issues/PRs/branches, temp files, dev servers. Persist only the deliverable.
applies: workflow
---

# Clean up after yourself

## The rule

When you create something only to accomplish a task — a scratch repo, test
issues/PRs/branches, scaffolding, `/tmp` files, a running dev server — **remove it
once you've captured what you actually needed** (the committed code, fixtures,
screenshots, measurements). Persist the deliverable; bin the scaffolding.

## Why

Throwaway artifacts accumulate into clutter that's expensive to untangle later:
orphaned repos, stale test issues polluting a real project, dangling branches,
leftover temp files. The session that made the mess has the context to clean it
up cheaply; a future session — or a human — does not.

## How to apply

- After a capture / run-through, delete the ephemeral source: test
  issues/PRs/branches, scratch repos, `/tmp` cookies/baselines/logs, background
  dev servers.
- Keep only what's intentionally persisted (committed code/fixtures/docs) and
  reusable tooling.
- If a cleanup step needs a permission/scope you lack (e.g. `gh` without
  `delete_repo`), do everything else and surface that one step for the human.

## When this came up

James, building Issue Atlas (2026-06-25): after a webhook-capture run-through that
created test issues + a scratch repo to capture real fixtures, he said *"Always
clean up after yourself for artifacts/resources which don't need to be persisted."*

## When NOT to apply

- Reusable tooling/scripts you'll want again — commit them, don't delete.
- Anything the user asked to keep, or that IS the deliverable.
