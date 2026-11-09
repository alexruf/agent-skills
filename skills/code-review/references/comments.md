# Comments and Documentation

Review comments and docs on two levels: whether they are **accurate**, and
whether they are **worth keeping** in their current form.

## Scope

- Comments, docstrings, and doc files added or modified by the change.
- Existing comments next to changed code that the change may have made stale.
- Docs (README, CHANGELOG, `docs/`, help text, examples) that describe behavior,
  flags, or config the change touches.

Leave older comments next to unchanged code alone.

## Accuracy

These are defects, because a wrong comment misleads the next reader. Report each
as its own finding, normally P2. Use P1 when the wrong docs could lead users into
data loss or a security mistake.

- The comment describes behavior the code no longer has, or never had.
- Docstring parameters, return values, raised errors, or units do not match the
  signature or implementation.
- Docs, help text, or examples refer to renamed or removed flags, commands,
  config keys, or endpoints.
- Example code that would not run against the changed API.

## Form and language

Comments written while iterating with an agent tend to address the reviewer or
the conversation instead of the future reader. Flag comments that:

- **Refer to the conversation or to earlier iterations:** "now uses", "changed
  to", "as requested", "the new approach", "instead of the old X". This history
  belongs in the commit message.
- **Name a bug or fix without explaining it:** "fix for the crash", "workaround
  for #812". Explain why the code must be this way, then link the issue.
- **Explain standard, idiomatic code:** especially when it reads like a
  correction of an earlier attempt.
- **Describe file or folder layout:** the tree and imports already show it, and
  the comment goes stale with the next rename.
- **Stack negations:** "never retries, does not cache, and no fallback" for
  alternatives no reader would assume. One "deliberately" covers a real design
  choice.
- **Embed details that the next routine change will make wrong:** counts,
  lists of covered test cases, current versions.
- **Reassure instead of inform:** "robust", "safe", "production-ready",
  "carefully handles". These speak to a reviewer, not a reader.
- **Use terms invented in this change** that a reader cannot look up.
- **Restate what the code does** instead of why.
- **Keep commented-out code.** Version control remembers it.
- **Leave untracked work markers:** a new `TODO`/`FIXME` without an owner or
  issue reference.
- **Mix languages:** the comment's language differs from the rest of the
  codebase.

Two tests apply to every comment: *Would it make sense to someone reading the
file a year from now, without the PR or the conversation?* *Would it survive the
next routine update?*

### Recommend one of

1. **Delete** it when the code already says it.
2. **Shorten** it to one sentence, ideally one line, that states the reason.
3. **Explain why and link the issue** when the code only makes sense with that
   background.
4. **Move it** to the commit message or PR description when it is history.

### Reporting

Group form-and-language issues into **one** P3 finding that lists each location
and the recommended action. Do not open a separate finding per comment.

## Examples

Refers to an earlier iteration:

```py
# Switched to batching here since the per-row approach was too slow
for chunk in batched(rows, 500):
```

Better: no comment, or the reason that still holds:

```py
# The upstream API rejects requests with more than 500 rows.
for chunk in batched(rows, 500):
```

Names a fix but not the reason:

```go
// Fix for #812
conn.SetDeadline(time.Time{})
```

Better:

```go
// Clear the handshake deadline; otherwise long-lived streams are cut off
// after 30s. See #812.
conn.SetDeadline(time.Time{})
```

Reassures, stacks negations, and embeds a count that will drift:

```ts
// Robust, production-ready parser. Never throws, never mutates input,
// and handles all 14 supported formats.
```

Better:

```ts
// Returns null for unsupported formats instead of throwing.
```

Stale after the change. The code now retries 5 times:

```java
/** Retries the request up to 3 times. */
```

This is an accuracy defect: report it as its own finding.
