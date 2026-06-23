---
description: Every HTML artifact ships both light and dark themes and defaults to the system's prefers-color-scheme
applies: html
---

# Always ship light + dark HTML artifacts, match system theme by default

## The pattern

Every HTML file written for James — architecture diagrams, dashboards, mockups,
share-ready pages, throwaway previews — implements both a light and a dark
theme and selects between them with `prefers-color-scheme`. Never hardcode one
palette.

Mechanics:

- Define palette tokens as CSS custom properties on `:root` (light) and
  override them inside `@media (prefers-color-scheme: dark)`.
- Style everything from those tokens — body, text, borders, code blocks,
  pills, and especially **SVG fills/strokes** (use `var(--token)` or
  `currentColor`, never inline hex). A single `:root` override should flip
  the entire document, diagram included.
- Don't add a manual toggle unless asked — `prefers-color-scheme` is enough.

```html
<style>
  :root            { --bg:#fff; --fg:#1f2328; --accent:#0969da; }
  @media (prefers-color-scheme: dark) {
    :root          { --bg:#0e1116; --fg:#e6edf3; --accent:#58a6ff; }
  }
  html, body       { background: var(--bg); color: var(--fg); }
  svg .accentLine  { stroke: var(--accent); }
</style>
```

## Why

- Forcing one palette breaks readability for users on the opposite system
  theme — and at a glance the artifact reads as half-finished.
- It's a 6-line CSS change at write time but ~impossible to retrofit cleanly
  once SVG fills and hex literals are sprinkled through the markup.
- HTML "previews" turn into committed docs more often than you'd think.
  Doing it right by default avoids a second pass later.

## When this came up

Shipped a dark-only architecture HTML for the webhook-relay PR. James
redirected: *"Always provide both a light and dark theme in HTML artifacts
and match the system theme by default."* The fix was structural — palette
tokens on `:root` + a `prefers-color-scheme` override + driving every SVG
class off the tokens.

## When NOT to apply

- A literal print stylesheet (e.g. `@page` blocks for PDF generation) where
  forcing a known background is correct — call it out explicitly.
- A screenshot the artifact is generated *into* a fixed-theme context (e.g.
  a known-dark slide deck). Still ship both, but the default chosen can be
  pinned with reason.
- HTML email templates rendered in clients without `prefers-color-scheme`
  support — there you follow the email-client conventions instead.
