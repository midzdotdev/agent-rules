---
name: early-returns
description: Reduce nesting by returning early from guard conditions instead of wrapping the happy path in if/else
applies: code-style
severity: preference
learned: 2026-06-20
occurrences: 1
status: learning
---

# Prefer early returns over nested conditionals

## The pattern

Use early returns (also called "guard clauses" or the "bouncer pattern") to
handle preconditions first, then let the happy path live at the top scope
of the function.

Avoid:

```ts
function process(x) {
  if (x) {
    if (isValid(x)) {
      if (canRun()) {
        // ...real work, three levels deep
      } else {
        return error("cannot run");
      }
    } else {
      return error("invalid");
    }
  } else {
    return error("missing");
  }
}
```

Prefer:

```ts
function process(x) {
  if (!x) return error("missing");
  if (!isValid(x)) return error("invalid");
  if (!canRun()) return error("cannot run");

  // ...real work, at top scope
}
```

## Why

- The happy path is no longer indented under three layers of conditions.
- Each guard reads as one rule, on one line.
- Adding or removing a guard doesn't ripple indentation through the rest
  of the function.
- A reviewer sees the preconditions enumerated up top before any logic.

## When this came up

James asked for this explicitly while specifying his coding preferences
for the `agent-rules` repo on 2026-06-20. Worded as: *"if I tell claude to
use early returns or whatever it's called, where rather than having many
nested if blocks and else if blocks, the complexity of the scope is
reduced by returning inside an if before that complexity is introduced,
then that should also be logged here."*

## When NOT to apply

- Inside expression-based / single-return functional code (map/filter/reduce
  chains, ternary expressions). The form doesn't accommodate early return.
- When the conditions genuinely require interleaved logic — both branches
  do real work that needs to merge afterwards. Rare; almost always a smell.
- In languages or contexts where multiple returns are idiomatically
  discouraged (some C++ shops, some MISRA-style codebases). Match the
  surrounding style.
