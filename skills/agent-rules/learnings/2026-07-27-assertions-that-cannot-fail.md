---
description: A test that inspects source or a collection must first prove its subject exists — a missing landmark degrades to a silent pass, not a failure
applies: testing
---

# Prove the subject exists before asserting on it

## The pattern

When an assertion's subject is *derived* — a slice at a landmark, a filtered
collection, a regex match — a missing subject usually degrades into something
that passes. Assert existence first.

```ts
// Vacuous: indexOf returns -1 when absent, and -1 < any real index.
expect(body.indexOf('runBootLifecycle(')).toBeLessThan(body.indexOf('createApp('));

// Vacuous: slice(-1) returns the LAST CHARACTER, so this inspects one byte.
const handler = source.slice(source.indexOf('export default'));
expect(handler).not.toMatch(/buildDeps\(/);

// Sound: presence, then the property.
const at = source.indexOf('export default');
expect(at).toBeGreaterThanOrEqual(0);
expect(source.slice(at)).not.toMatch(/buildDeps\(/);
```

Two corollaries:

- **An "empty collection" assertion must prove the collection was populated from
  the right place.** `expect(importers).toEqual([])` passed because the scan
  walked one directory and the only file that could fail was in another.
- **A pattern must be able to match the reachable failure.** A regex requiring
  `from '...'` could never match an import of a module that exports nothing —
  where `import '...'` is the only possible form, and the only dangerous one.

Related but distinct: mutating a function's *body* is not mutating its *call
sites*. Both need their own mutation.

## Why

- These fail *open*. A normal broken assertion goes red; these go green, so the
  suite reports the opposite of the truth and the failure is invisible until
  production.
- They cluster on exactly the assertions worth having. Cheap value assertions
  don't derive a subject; the ones pinning a structural invariant — "startup
  work runs once", "nothing imports this" — are precisely the ones that slice
  and filter, so the strongest-looking tests are the likeliest to be hollow.
- Mutation testing catches them, but only if the mutation targets the *thing the
  test names* rather than something nearby.

## When this came up

Issue Atlas, #67 (mounting an existing server inside a bundler). Four separate
adversarial-review rounds each surfaced one, every one guarding a stated
acceptance criterion, every one leaving the full suite green:

- Deleting the boot lifecycle from both entries — **744/744 passing**.
- Moving it to run on *every request* — **746/746 passing, typecheck clean**.
- Adding the import that starts a second listener — **746/746 passing**.
- The same scan never reading the one file where that could happen.

The implementer (me) had mutation-tested the lifecycle function's body and
written a commit message claiming the gap was closed, while nothing asserted
anyone called it.

## When NOT to apply

- Assertions on a value handed in directly (`expect(user.name).toBe('x')`) —
  there's no derivation step to go vacuous.
- Frameworks whose matchers already fail on a missing subject — Testing
  Library's `getBy*` throws when nothing matches, so a follow-up assertion
  can't run against a phantom. `queryBy*` returns null and does need the guard.
- Don't inflate every test with existence preambles. The trigger is a *derived*
  subject: an index, a slice, a filter, a match.
