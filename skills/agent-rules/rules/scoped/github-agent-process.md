---
description: The harness ↔ GitHub-agent process — what work happens in a local Claude Code session vs. via a repo's dispatch agent. Routing principle, two-axis label vocabulary (status:* state vs agent:* execution, state ≠ trigger), and the ticket lifecycle. Applies to any repo wired with the agent dispatch workflow.
applies: github-agents
---

# Harness ↔ GitHub-agent process

How work is routed between a **local harness session** (interactive Claude Code)
and a repo's **dispatch agent** (claude-code-action on a runner, label-triggered).
First wired in `midzdotdev/issue-atlas`; the workflow will extract to
`midzdotdev/agent-workflows` when a second repo adopts it. Per-repo bindings
(tracker, exact label strings, runner) live in that repo's
`docs/agents/issue-tracker.md` + `docs/agents/triage-labels.md`.

## Routing principle

- **Harness**: everything interactive or meta — capturing/triaging/grilling
  tickets, `/to-spec`, `/to-tickets`, workflow edits (`.github/workflows/*` is
  agent-forbidden anyway), reviewing James's own work pre-push (`/code-review`).
- **Dispatch agent**: executing a fully-specified ticket, and pushing fixes in
  response to `@claude` PR comments.
- **James never posts GitHub comments from local sessions** — they'd publish as
  James. The dispatch agent (`claude[bot]`) is the only GitHub reply surface.
  Creating issues and editing issue bodies locally is fine: tickets are James's
  words. Chat is the local reply surface.

## Two label axes — state ≠ trigger

- **`status:*` (triage axis)** — where the ticket is in its lifecycle. Pure
  state: applying one never dispatches. Skills batch-apply them safely. Exactly
  one per triaged ticket; an untriaged ticket is unlabeled (the inbox).
- **`agent:*` (execution axis)** — what the dispatch machine is doing.
  `agent:go` is the **only** trigger; the workflow strips it at run start
  (retry = re-add) and never touches `status:*`.

Canonical vocabulary and colours (identical in every adopting repo):

| Label | Hex | Meaning |
|---|---|---|
| `status:needs-triage` | `D93F0B` | Triage started but stalled; resume `/triage` |
| `status:needs-info` | `FEF2C0` | Waiting on human answers; questions recorded in issue body |
| `status:ready-for-agent` | `0E8A16` | Fully specified: scoped, verifiable, blockers declared. State only |
| `status:ready-for-human` | `5319E7` | Fully specified; needs human judgment/access/manual testing |
| `status:wontfix` | `CFD3D7` | Rejected or already implemented; closed with reasoning |
| `agent:go` | `000000` | Dispatch trigger; stripped at run start; re-add to retry |
| `agent:working` | `FBCA04` | Run in progress |
| `agent:done` | `1D76DB` | Branch pushed + Create-PR link posted; stays as history |
| `agent:failed` | `B60205` | Run failed/timed out; run-link comment posted |

Pocock canonical roles map 1:1 to `status:*`; category roles (bug/enhancement)
are unused. GitHub default labels are deleted.

## Lifecycle

1. **Capture** — ideas become unlabeled issues, zero ceremony, from anywhere.
2. **Triage (harness)** — `/triage` sweeps unlabeled; grilling is interactive.
   The issue **body is the working document**, ending in a `## Decisions`
   section: one bullet per resolved question, as *decision + reason*. Verbatim
   Q&A is discarded. Outcome = one `status:*` label.
3. **Decompose (harness)** — grill → optional `/to-spec` (plain issue, never
   `agent:go`) → `/to-tickets` publishes tracer-bullet tickets blockers-first,
   each born `status:ready-for-agent`.
4. **Dispatch** — James arms **one frontier ticket at a time** with `agent:go`
   (single runner slot; batch-arming evicts queued runs). Frontier advancement
   is manual: after a merge, arm the next unblocked ticket.
5. **Review & merge** — the agent never opens or merges PRs: it pushes
   `claude/*` and posts a pre-filled Create-PR link (`Closes #N`). James clicks
   it (PR authored as James — the deliberate checkpoint), runs `@claude` rounds
   for fixes to agent work, merges; the ticket auto-closes.

## Deferred extensions (recorded, not built)

Issue-comment-responsive agent (async grilling on GitHub); frontier
auto-advance on issue close; extraction to `agent-workflows`. Design record:
`midzdotdev/vps-config#11`.
