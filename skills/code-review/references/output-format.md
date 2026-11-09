# Output Format

Every review produces the same report: fill in
[`assets/report-template.md`](../assets/report-template.md) and output nothing
else.

## Fixed structure

- Keep the template's headings, section order, table columns, row labels, and
  separators exactly. Never add, rename, reorder, or drop a section, row, or
  column. The one repeating part is the `### F1` block: write one per finding.
- Headings, labels, verdict values, priority tags, categories, and confidence
  values stay in English, word for word. Write the prose (titles, justification,
  finding bodies, fixes, coverage details) in the user's language and keep code
  identifiers as they are. When the request does not reveal the user's
  language, write the prose in English.
- Replace every `{{...}}` placeholder. Write `None` for an empty value.
- Write no text before the `# Code Review` heading and none after the
  `## Next Steps` section.
- Use plain Markdown only: no emoji, no extra bold or italics, no horizontal
  rules.

Special cases, each with fixed wording:

| Situation | Output |
| --- | --- |
| No findings | Under `## Findings`, write `No findings.` Under `## Next Steps`, write `Nothing to fix.` |
| Empty diff | Only the heading, then `Nothing to review: <reason>.` |
| No suggestion | Omit the `suggestion` block for that finding; keep `**Fix:**`. |
| No rule support | Omit the ` · Rule: ...` part of the metadata line. |

## Header

- **Target:** what was reviewed, for example `feature/sync vs origin/main`,
  `uncommitted changes on main`, `PR #128`, `commit 3f2a1c9`, or `a1b2..c3d4`.
- **Verdict:**
  - `Correct`: no P0 or P1 findings, and nothing breaks existing behavior.
  - `Incorrect`: any P0 or P1, or anything that breaks existing behavior.
  - Style and P3 items never decide the verdict; docs findings count only when
    rated P1.
- **Counts:** the number of findings per priority, including zeros.
- **Justification:** one to three sentences on what drives the verdict.

## Findings

Number findings `F1`, `F2`, ... in the order listed. Sort by priority, then
`confirmed` before `plausible`, then by path.

### Priority

| Level | Meaning | Example |
| --- | --- | --- |
| **P0** | Blocks release or operations. Only for universal problems that need no assumptions about input. | Data corruption, auth bypass, build broken |
| **P1** | Urgent; fix before or right after merging. | Race under normal load, breaking API change without migration path |
| **P2** | Real defect; fix in the normal course of work. | Edge case mishandled, stale docs, missing test for new branch |
| **P3** | Low impact but worth fixing. | Misleading name, comment cleanup |

Rate severity honestly: state the conditions the problem depends on, and do not
inflate it.

### Category

Use exactly one of these values. They follow the sections in `criteria.md`;
section 4 splits into `data-safety` (migrations, destructive operations) and
`compatibility` (public contracts):

`correctness` · `integration` · `security` · `data-safety` · `compatibility` ·
`tests` · `intent` · `generated-code` · `maintainability` · `performance` ·
`dependencies` · `comments`

### Fields

- **Title:** imperative, at most 80 characters.
- **Location:** `path:line` or `path:start-end`, at most about 10 lines, and it
  must overlap the diff. When the root cause sits outside the diff (for example
  an unhandled case in a consumer), anchor on the changed line and name the other
  location in the body. A grouped `comments` finding anchors on the first
  location and lists the others in the body.
- **Confidence:** `confirmed` (reproduced or traced end to end) or `plausible`
  (strong evidence, trigger not fully proven).
- **Rule:** cite the project rule file and line when a rule supports the
  finding. Never invent a citation.
- **Body:** one paragraph covering the trigger (inputs, environment, sequence),
  the impact, and why it is wrong. Neutral and matter-of-fact.
- **Fix:** one sentence describing the change.
- **Suggestion:** optional, only concrete replacement code, at most about 3
  lines, no commentary inside it, original indentation preserved exactly.

## Coverage

Fill every row with one line:

- **Scope:** the review mode and refs, for example
  `origin/main...HEAD + uncommitted + untracked`.
- **Files:** the number of reviewed files and the changed line counts.
- **Skipped:** each skipped path or pattern with its reason.
- **Context:** the project rule files and intent sources that were read.
- **Checks:** each command run and its result.
- **Residual risk:** risks you could not verify and material test gaps.

## Example

````md
# Code Review: feature/stats vs origin/main

| Verdict | P0 | P1 | P2 | P3 |
| --- | --- | --- | --- | --- |
| Incorrect | 0 | 1 | 0 | 1 |

The empty-batch case writes `NaN` into the dashboard cache. The rest of the
change is sound.

## Findings

### F1 [P1] Handle empty batch before computing the average

`src/stats.ts:42-44` · correctness · confirmed

When a tenant has no events in the window, `items` is empty and
`total / items.length` yields `NaN`. The value is written to the dashboard cache
and served until the next refresh.

**Fix:** Return 0 when `items` is empty.

```suggestion
if (items.length === 0) return 0;
return total / items.length;
```

### F2 [P3] Remove iteration notes from comments

`src/stats.ts:12` · comments · confirmed · Rule: AGENTS.md:31

`src/stats.ts:12` and `src/cache.ts:58` describe earlier iterations ("switched
to batching", "now uses the new cache") rather than the current code.

**Fix:** Delete both comments; the reason for batching is already in the commit message.

## Coverage

| Item | Details |
| --- | --- |
| Scope | origin/main...HEAD + uncommitted + untracked |
| Files | 4 reviewed (+120/-35) |
| Skipped | package-lock.json (lock file) |
| Context | AGENTS.md, PR description |
| Checks | `npm test -- stats`: passed |
| Residual risk | Cache eviction in src/cache.ts has no test |

## Next Steps

Reply with finding IDs (for example `F1 F3`) to have them fixed.
````

Do not apply any fix until the user asks.
