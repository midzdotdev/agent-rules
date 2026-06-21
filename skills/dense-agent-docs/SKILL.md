---
name: dense-agent-docs
description: "Use when writing or editing any document an LLM loads as instructions or memory — CLAUDE.md, AGENTS.md, SKILL.md, rule and learning files, agent memory, .cursor/rules, copilot-instructions. Maximises signal per token: cut what the model can infer, lead with the instruction, structure over prose. Not for human-facing docs like README or changelogs."
---

# Dense agent docs

Writing standard for documents an LLM loads as instructions or memory. Goal:
the smallest set of high-signal tokens that produces correct behaviour. The
reader is an expert that infers from little and pays for every token on each
load — strip the scaffolding a human would need. Not for human-facing docs
(README, changelogs), which need that scaffolding.

## Directives

1. **Cut what the model can infer.** If it lives in the types, config, schema,
   or general knowledge, delete it. Completeness is not the goal; a
   load-bearing doc is.
2. **Lead with the instruction.** Directive first. Keep a *why* only when it
   lets the reader generalise to cases you didn't spell out — otherwise drop it.
3. **Structure over prose.** Tables, lists, numbered steps; one concept per
   line. Prose only when structure can't carry the meaning.
4. **Imperative, no hedging.** "Do X," not "you might consider X."
5. **Match freedom to fragility.** Many valid paths → state intent, leave the
   method open. Fragile or consistency-critical → exact steps; name what not
   to touch.
6. **One term per concept.** Pick a word and reuse it. No synonyms for the
   same thing.
7. **No time-sensitive phrasing.** Not "as of June 2026" or "the new way" —
   cut superseded guidance or collapse it into one "old patterns" note.
8. **Examples only to disambiguate.** An input/output pair only when the rule
   is unclear without it. One default plus an escape hatch beats a menu of
   options.
9. **Point, don't restate.** Long or rarely-needed detail goes behind an
   on-demand pointer (a reference file, another skill) with a sharp trigger line.

## Emphasis

Default to explained rules. Reserve hard MUST / NEVER for true invariants or a
rule you've seen violated — escalated emphasis is a fix, not the baseline
register. All-caps absolutism everywhere is a smell.

## Budget

A size ceiling (CLAUDE.md ~200 lines, SKILL.md body ~500) is a signal to split
or cut, not to compress prose further.

---

*Distilled from Anthropic's skill best-practices, context-engineering guidance,
and the claude-md-optimizer and skill-creator skills.*
