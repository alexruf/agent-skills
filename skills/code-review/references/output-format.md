# Output Format

Present the findings first, then the verdict, then what was covered. Do not add
a summary of the changes, a per-file listing, a "strengths" section, or praise.

## Priority

| Level | Meaning | Example |
| --- | --- | --- |
| **P0** | Blocks release or operations. Only for universal problems that need no assumptions about input. | Data corruption, auth bypass, build broken |
| **P1** | Urgent; fix before or right after merging. | Race under normal load, breaking API change without migration path |
| **P2** | Real defect; fix in the normal course of work. | Edge case mishandled, stale docs, missing test for new branch |
| **P3** | Low impact but worth fixing. | Misleading name, comment cleanup |

Rate severity honestly: state the conditions the problem depends on, and do not
inflate it.

## Findings

Sort by priority, then by confidence. Use this shape for each one:

~~~md
**[P1] Handle empty batch before computing the average** — `src/stats.ts:42-44`

When a tenant has no events in the window, `items` is empty and
`total / items.length` yields `NaN`. The value is written to the dashboard
cache and served until the next refresh. Confidence: confirmed.

```suggestion
if (items.length === 0) return 0;
return total / items.length;
```
~~~

- **Title:** imperative, at most 80 characters, priority tag first.
- **Location:** `path:line` or `path:start-end`, at most about 10 lines, and it
  must overlap the diff. When the root cause sits outside the diff (for example
  an unhandled case in a consumer), anchor on the changed line and name the other
  location in the body.
- **Body:** one paragraph covering the trigger (inputs, environment, sequence),
  the impact, and why it is wrong. Neutral and matter-of-fact. No location
  details beyond what the reader needs.
- **Confidence:** `confirmed` (reproduced or traced end to end) or `plausible`
  (strong evidence, trigger not fully proven).
- **Rule:** when a project rule supports the finding, cite the file and line,
  for example `Rule: AGENTS.md:18`. Never invent a citation.
- **Suggestion block:** optional, only concrete replacement code, at most about
  3 lines, no commentary inside it, original indentation preserved exactly.

If nothing passes the reporting bar, write `No findings.`

## Verdict

```md
### Verdict
Incorrect — the empty-batch case corrupts cached dashboard values (P1); the
rest of the change is sound.
```

- **Correct:** no P0 or P1 findings, and nothing breaks existing behavior.
- **Incorrect:** any P0 or P1, or anything that breaks existing behavior.
- Style and P3 items never decide this judgment; docs findings count only when
  rated P1. Add one to three sentences of justification.

## Coverage

```md
### Coverage
- Scope: origin/main...HEAD plus uncommitted changes, 12 files (+340/-85)
- Skipped: package-lock.json (lock file), src/gen/ (generated)
- Checks run: `npm test -- stats` passed; none otherwise
- Residual risk: retry path in src/sync.ts not exercised by any test
```

List what you reviewed, what you skipped and why, which commands you ran and
their results, and the risks you could not verify. Keep each item to one line.

## Follow-up

End by offering to fix selected findings. Do not apply any fix until the user
asks.
