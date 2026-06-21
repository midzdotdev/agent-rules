---
description: NODE_ENV is a build/runtime switch (React dev warnings, library optimisations), not a deployment-stage label. Set it to "production" everywhere; use other env vars or feature flags to differentiate stages.
applies: javascript
---

# `NODE_ENV` is not a deployment stage

## The rule

Set `NODE_ENV=production` in **every** server environment — local dev
server processes, preview, staging, prod. Do not use `NODE_ENV` to
differentiate deployment stages. For per-environment behaviour, use
purpose-named variables (`LOG_LEVEL`, `API_URL`, `ENABLE_DEV_FEATURES`)
or a feature-flag system.

## Why

`NODE_ENV` is a build/runtime switch, not a deployment label. Major
libraries — React, Express, Next.js, and many more — branch on
`process.env.NODE_ENV === 'production'` to:

- Strip development-only warnings, stack traces, and prop-type checks.
- Enable caching, connection pooling, and other prod optimisations.
- Apply minified, tree-shaken bundles.

If staging runs `NODE_ENV=development`, **staging is running different
code than production**: different bundles, different optimisations,
different branches inside library internals. The thing you tested isn't
the thing you ship — which is the failure mode staging exists to prevent.
Matteo Collina has a long-running argument that `NODE_ENV` used this way
is "a lie"; 12-Factor methodology agrees.

## How to apply

**In codebases:**

- Don't write `if (process.env.NODE_ENV === 'staging')` — there's no
  such value; staging should be `production`.
- If you find `process.env.NODE_ENV !== 'production'` used to gate
  feature flags, telemetry, or environment-specific behaviour, flag it
  as a smell. Replace with a purpose-named variable.
- Gate dev-only conveniences (verbose logs, mock data) on specific
  flags: `ENABLE_DEV_FEATURES`, `LOG_LEVEL=debug`, etc. Leave `NODE_ENV`
  alone.

**In deployments:**

- Confirm staging and prod both set `NODE_ENV=production`. If staging is
  `development` or unset, that's a bug — staging is not running the prod
  bundle, so it isn't actually testing the prod app.
- Use `APP_ENV` or `DEPLOY_STAGE` if you need a name to branch on
  outside library code.
- Reach for a feature-flag system (LaunchDarkly, GrowthBook, even
  env-var-fed flags) for behaviour toggles, instead of inferring from
  environment.

## When NOT to apply

- Local development with framework dev servers (Next.js, Vite,
  webpack-dev-server) that explicitly want `NODE_ENV=development` to
  enable HMR and unminified output. The rule applies to *server
  processes*, not the bundler's dev server on a developer's laptop.
- Build steps producing client bundles, where setting
  `NODE_ENV=production` for prod builds is the intended, documented use
  of the variable.
