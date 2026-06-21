---
description: Reduce nesting by returning early from guard conditions instead of wrapping the happy path in if/else
applies: code-style
---

# Prefer early returns over nested conditionals

## The pattern

Handle preconditions first with early returns (guard clauses), then let the
happy path live at the function's top scope.

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

- Happy path isn't buried under three layers of indentation.
- Each guard reads as one rule on one line.
- Adding or removing a guard doesn't re-indent the rest of the function.
- Preconditions are enumerated up front, before any logic.

## When this came up

James specified this while setting up `agent-rules` (2026-06-20): reduce scope
complexity by returning inside a guard `if` before nesting is introduced.

## When NOT to apply

- Expression-based / single-return functional code (map/filter/reduce,
  ternaries) — no place for an early return.
- When both branches do real work that must merge afterwards. Rare; usually a
  smell.
- Codebases that idiomatically discourage multiple returns (some C++/MISRA
  shops). Match surrounding style.
