# Review Criteria

Check these areas in order. Earlier areas usually produce higher-priority
findings. Every finding must still pass the reporting bar in `SKILL.md`.

## 1. Correctness

- Logic errors, inverted conditions, off-by-one, wrong operator or variable.
- Edge cases: empty, null or missing, zero, negative, boundaries, very large
  input, Unicode, time zones and DST, locale.
- Error handling: swallowed errors, overly broad catches, wrong error type,
  errors that lose context, missing cleanup on the failure path.
- Resources: unclosed files, connections, handles, subscriptions; leaks in loops.
- Concurrency: races, check-then-act, lock ordering, missing awaits, unsafe
  shared state, non-idempotent retries.
- State: stale caches, missing invalidation, partial updates without a
  transaction.

## 2. Integration across boundaries

- New enum variants, event types, message kinds, or commands: is every consumer
  updated, or does a `switch`/router fall through silently?
- Changed signatures, return types, or nullability: search all call sites,
  including ones outside the diff.
- Renamed or removed exports, config keys, environment variables, feature
  flags, CLI options, routes: search for remaining references (code, config,
  scripts, docs, CI).
- Serialization: do producers and consumers agree on field names, types, and
  optionality?

## 3. Security

Trace from a source an attacker controls (request data, files, environment,
third-party responses, model output) to a dangerous sink or a missing control.
Report only paths with a credible execution route.

- Authorization on new endpoints, handlers, and queries; tenant isolation.
- Injection: SQL, shell, template, path traversal, header, log, prompt.
- SSRF, open redirects, unsafe deserialization, XXE.
- Secrets or personal data in code, logs, errors, or test fixtures.
- Cryptography: home-grown schemes, weak algorithms, non-constant-time
  comparisons of secrets, predictable randomness.

## 4. Data safety and breaking changes

- **Migrations:** Are they reversible? Do they take long locks on large tables?
  Does adding a non-null column, or a constraint, work with existing rows? Is a
  backfill needed? Can code and schema deploy in either order?
- **Public contracts:** APIs, CLI flags, config formats, events, file formats,
  persisted data. Are changes backward compatible, versioned, or documented as
  breaking?
- Destructive operations: deletes, overwrites, truncation. Are they guarded and
  scoped correctly?

## 5. Tests

- Is new or changed behavior covered?
- Would the new test fail without the fix? A test that passes either way proves
  nothing.
- Were assertions weakened, deleted, or replaced with snapshots that accept
  anything? Were tests skipped or disabled without a reason?
- Do tests verify behavior, or only that mocks were called?
- Determinism: dependence on time, randomness, ordering, network, or shared
  global state.

## 6. Intent and scope

- Does the change do what the PR description, commit messages, or linked issue
  say? Look for described behavior that is missing or only partly wired up.
- Flag unrelated changes mixed in only when they add risk or hide the real change.

## 7. Signals of generated code

Agent-written changes have recurring failure modes:

- Calls to APIs, options, or flags that do not exist in the installed dependency
  version. Verify them.
- Stub, placeholder, or "simplified" implementations presented as complete.
- New helpers that duplicate an existing utility in the codebase.
- Defensive `try`/`catch`, fallbacks, or null checks that hide real failures.
- Dead code: unused parameters, functions, branches, or imports added by the
  change.
- Tests changed to match buggy output instead of fixing the code.

## 8. Maintainability

Report only when it materially hurts future changes:

- Misleading names that will cause misuse.
- Duplicated logic that must change in lockstep.
- Departure from an established pattern without reason. Cite the existing
  pattern (`path:line`).
- Abstraction with a single user and no clear second one coming.

## 9. Performance

- Repeated queries in loops (N+1), unbounded queries, missing pagination.
- Work or memory that grows without bound with input someone else controls.
- Expensive work added to hot paths, request handlers, or render loops.

## 10. Dependencies

- New dependencies: needed, maintained, license-compatible, reasonable size?
- Manifest and lock file out of sync (one changed without the other).
- Version bumps across major versions without the matching code changes.

## 11. Comments and documentation

See `comments.md`.
