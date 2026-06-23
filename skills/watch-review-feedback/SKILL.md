---
name: watch-review-feedback
description: "Use after creating issues or PRs (yourself or via a subagent) that the human will review asynchronously, so you catch and respond to their comments without being re-prompted. Tail the tracker, and the moment a comment/review lands, reply on the surface it came from and act on it. Triggers: 'watch for comments', 'tail the PR/issue', 'respond to review feedback proactively', or any time you hand the human something to review and then go idle."
---

# Watch review feedback

When you create reviewable artifacts (issues, PRs) and the human reviews them
asynchronously, don't go idle waiting for a re-prompt. Tail the tracker so their
comments reach you within seconds, and respond as if they'd typed the comment
into the session directly.

## When to use

- You just published issues/PRs (yours or a subagent's) the human will review.
- The human says they'll review, or asks you to watch/tail for comments.
- Any time you hand off something for review and would otherwise sit idle.

Stop watching when: the human gives the go to start the work, says stop, or the
session ends. Re-arm whenever you create new reviewables.

## Tail, don't poll

Poll-on-a-timer (a scheduled wakeup every N minutes) lags — a comment sits
unanswered until the next tick. Instead **tail**: run a background command that
blocks on a short poll loop and **exits the instant activity appears**, which
re-invokes you immediately. Drive it off your harness's background-task
mechanism (a backgrounded shell command that re-invokes you on exit).

Reference loop (GitHub/`gh`; the shape transfers to `glab`, Linear, etc. — swap
the count queries):

```bash
# Watch issue comments + open-PR comments/reviews. `sample` returns non-zero if
# ANY read fails or is empty, so a transient API blip can't be mistaken for a change.
sample() { local s="" v c r
  for n in 97 98 99 100; do
    v=$(gh issue view "$n" --json comments -q '.comments|length' 2>/dev/null) || return 1
    [ -n "$v" ] || return 1; s+="i$n=$v;"; done
  for p in $(gh pr list --state open --json number -q '.[].number' 2>/dev/null); do
    c=$(gh pr view "$p" --json comments -q '.comments|length' 2>/dev/null) || return 1
    r=$(gh pr view "$p" --json reviews -q '.reviews|length' 2>/dev/null) || return 1
    [ -n "$c" ] && [ -n "$r" ] || return 1; s+="p$p=c$c/r$r;"; done
  printf '%s' "$s"; }
until base=$(sample); do sleep 5; done            # clean baseline
while sleep 20; do
  cur=$(sample) || continue                        # API blip -> skip tick
  [ "$cur" = "$base" ] && continue
  sleep 3; conf=$(sample) || continue              # re-confirm before firing
  [ "$conf" != "$base" ] && { echo "ACTIVITY"; break; }
done
```

Watch issue-level comments **and** PR reviews/review-comments — review threads
don't show up in the issue-comment count. **Make the watcher transient-proof:**
skip any tick where a read fails or returns empty, and **re-confirm a detected
delta with a second sample** before firing — a momentary `gh`/network error
otherwise reads as phantom activity (observed: one empty read fired a phantom
wakeup).

## Attribution & identity

The CLI is usually authed as the human, so comments you post are authored under
*their* name. **Mark every comment as agent-authored** — append a one-line
footer (e.g. `— 🤖 agent-authored, replying for @user`) so the thread is honest
about who wrote it. Don't impersonate the human silently.

If you have a **distinct identity** (a GitHub App or a bot account with its own
token — `app[bot]` / a machine user), the footer is optional, and that identity
makes self-firing trivial to avoid (filter by author, below).

## Avoid self-firing

Authed as the human → your comments are indistinguishable from theirs by author,
so **re-baseline the watcher after every comment you post** (restart it so the
new count is the baseline). Re-baselining is simpler and robust; don't try to
parse authorship.

With a distinct bot/App identity → skip re-baselining and **filter out comments
authored by that identity** instead, e.g. count only
`select(.author.login != "<bot>")`. Gotcha: `gh ... --json` (GraphQL) reports a
bot's `author.login` as the bare slug `my-app`, while the REST API returns
`my-app[bot]` — filter on the form your query actually returns (bare slug for
`gh view`).

## On activity, respond

1. Read the new comment/review.
2. **Reply on the surface it came from.** Issue comment → reply on that issue.
   PR review/comment → reply on the PR (inline if it was an inline comment).
   Match the channel the human used; don't migrate the conversation elsewhere.
3. **Act with full session autonomy.** Treat the comment as if typed into the
   session: investigate, answer, push back, and **make code amendments
   proactively** — no extra permission gate beyond what you'd apply mid-session.
4. Surface what you did in the chat too, so the human sees it without opening the
   tracker.
5. Re-baseline and resume tailing.
