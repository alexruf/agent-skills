---
name: technical-explainer
description: >
  Explain technical mechanisms with clear mental models, diagrams, concrete
  examples, equations, pseudocode, or small code samples. Use for conceptual
  how/why questions and technical comparisons. Do not use for factual lookups,
  debugging or failure diagnosis, editing, or implementation-first coding tasks.
---

# Technical Explainer

## Goal

Make technical subjects understandable without sacrificing correctness. The
user should leave with a usable mental model, not a collection of facts.
Prefer the shortest explanation that preserves an accurate, usable mental
model.

## Core workflow

1. Fix the answer's scope, depth, format, and length before selecting content.
2. Lead with the most important insight; give the core mental model before
   implementation details.
3. Choose one explanatory spine: prose, ordered steps, a visual, an example,
   an equation, or code. Add a second form only when it carries information
   the first cannot; never restate the spine in another form.
4. Stop when the requested depth is satisfied, even if more context is
   relevant.

If the user demonstrates domain knowledge, skip elementary background and use
established terminology. Define unfamiliar terms at first meaningful use.

## Write for humans

The explanation must read as if a knowledgeable colleague wrote it, not as
generated documentation. Prose carries the explanation; formatting only
supports it.

Avoid the tells of machine-written text:

- Bullet lists of bolded noun phrases where connected prose would explain
  more ("**Speed:** Indexes are fast.").
- Headers and sections on an answer short enough to be a few paragraphs.
- Filler and throat-clearing: "Let's dive in", "It's worth noting that",
  "plays a crucial role", "In the world of ...".
- A closing summary that restates what was just said.
- Uniform sentence and paragraph shapes, and triads of adjectives
  ("fast, scalable, and reliable").
- Hedging every claim. State what is true; qualify only what genuinely
  varies.
- Walls of text: several consecutive paragraphs describing structure or
  flow that a diagram would show at a glance.

Contrast — the same content, machine-flavored and human:

> **Understanding Database Indexes**
>
> Indexes play a crucial role in query performance. Let's break down the key
> aspects:
>
> - **Faster reads:** Indexes significantly speed up lookups.
> - **B-tree structure:** Most databases use B-trees under the hood.
> - **Write overhead:** It's important to note that indexes slow down writes.
>
> In summary, indexes are a powerful tool for performance optimization.

versus:

> An index is a sorted copy of one column with pointers back to the rows.
> Sorted data can be binary-searched, so the database finds one row among a
> million in about 20 comparisons instead of scanning all million. The cost
> lands on writes: every insert now maintains the table plus each index, so
> each index you add makes writes slightly slower.

The second version is shorter and explains the mechanism; the first only
labels it.

## Control scope and density

Build the answer from required content, not from the available techniques.
Obey explicit limits such as sentence counts, word counts, or requested
formats. Otherwise treat "concise" as a demand for density, not a size cap:
a concise "how" answer contains the central mental model, the minimum causal
chain from input to output, and only the qualifications needed to keep that
model accurate.

Do not append examples, benefits, design rationale, variants, or recaps by
default. Apply a necessity test to every paragraph, list, diagram, and
example: if removing it leaves an accurate, usable answer to the exact
question, remove it. Relevance or interest alone is insufficient.

## Choose representations deliberately

- Ordered prose for a short causal sequence.
- A diagram whenever the answer describes how parts connect, how data
  changes shape, or how control branches (see below).
- A table for genuine trade-offs, not feature inventories.
- Code or pseudocode when execution exposes the mechanism. Keep it small,
  internally consistent, and runnable when practical; comment only
  non-obvious lines; default to Python for ML or data-science topics when no
  language is specified.
- An equation for a mathematical relationship.
- A concrete example when abstraction is the main barrier.

## Diagrams

Prose describing structure or flow is read linearly; a diagram is grasped at
once. Reach for one whenever the answer describes how parts connect, how data
changes shape, or how control branches — not only when prose fails. Two or
more paragraphs walking through a structure are usually a sign that a diagram
should carry it instead.

Use Mermaid only when the output environment is known to render it; otherwise
clean ASCII.

Example — merge vs. rebase, where the shape of the history *is* the content:

```text
before
A---B---C            main
     \
      D---E          feature

after `git merge feature` (on main)
A---B---C---M        main
     \     /
      D---E          feature

after `git rebase main` (on feature)
A---B---C            main
         \
          D'---E'    feature
```

Describing these three shapes in words would take paragraphs and still leave
the reader drawing the picture in their head. The prose then adds only what
the picture cannot show: `M` is a merge commit with two parents, and `D'`,
`E'` are new commits with new hashes — which is why rebasing an
already-pushed branch disrupts collaborators. When diagram and prose would
carry the same content, keep the diagram and cut the prose, not the other way
around.

## Concrete examples

A good example is small enough to simulate mentally — a few packets, rows,
bits, or values — and traces actual data through the mechanism. Let it
replace abstraction rather than follow an already complete explanation.

Abstract claim:

> A Bloom filter can return false positives but never false negatives.

The same claim as a traceable example:

> Take a 10-bit filter with two hash functions. Inserting "cat" sets bits 2
> and 7. Looking up "dog" hashes to bits 2 and 5 — bit 5 is still 0, so "dog"
> was definitely never inserted. Looking up "cow" happens to hash to bits 2
> and 7, both already set by "cat", so the filter answers "maybe" for an item
> that was never added. That is the false positive. A false negative is
> impossible because inserting an item only ever sets bits, never clears
> them.

The example earns its place because the reader can verify every step, and
the state is small enough to hold in the head. After the example, move from
the concrete observation to the general principle.

Do not add an example merely because a topic is abstract. If the mechanism
can be stated directly, state it directly.

## Explain mechanisms, not definitions

"How does X work" requires the causal chain with real stages, not
placeholders:

> A write arrives → it is appended to the write-ahead log on disk → the
> client gets its acknowledgment → the in-memory table is updated → later
> the memtable is flushed to a sorted file. A crash after the acknowledgment
> loses nothing, because recovery replays the log.

Each arrow must answer "and that causes what?". If a step can be deleted
without breaking the chain, it does not belong in the chain.

For "why" questions, identify which kind of reason is being asked for —
conceptual, implementation, computational, practical, economic, or
historical — and answer that one. Distinguish "easy to describe or
implement" from "easy to make reliable, efficient, scalable, or
production-ready".

## Analogies

An analogy is scaffolding: state what maps to what, say where it breaks when
that limitation matters, then return to the real mechanism.

> A CPU cache is a workbench next to a tool shelf: workbench = cache, shelf
> = main memory, the walk to the shelf = latency. The analogy breaks at
> eviction — a workbench does not silently clear itself when full, but a
> cache does, and which item gets removed (the eviction policy) is where
> most of the interesting behavior lives.

Never let an analogy imply a false conclusion.

## Comparisons

Establish the main architectural difference first; the visible features
follow from it.

> Postgres is built around durable transactional storage on disk; Redis is
> built around single-threaded access to data held in memory. Everything
> users experience as a "difference" — latency, data-size limits, query
> power, persistence guarantees — falls out of that one design split.

Add a small table only when it exposes trade-offs the prose has not; avoid
large feature matrices.

## Equations

Give intuition first unless the user asks for a formal treatment. For each
non-obvious equation: define the important variables, substitute a small
numerical example when practical, and say how the result moves when the
important variables change. Mark schematic equations as simplifications.

> Little's law, `L = λ · W`: items in a system = arrival rate × time each
> item spends in it. A service receiving 200 requests/s with 50 ms average
> latency holds 200 × 0.05 = 10 requests in flight at any moment. Halve the
> latency and the in-flight count halves too — the equation says a latency
> fix is also a connection-pool and memory fix.

## Accuracy

Simplify only when it improves understanding, and label any simplification
that could be mistaken for a factual claim. Introduce complexity when it
changes the user's mental model. State when a detail is uncertain,
version-specific, implementation-specific, or environment-dependent. When
current documentation matters and tools are available, verify material
claims rather than guessing.

## Final quality check

Before answering, silently verify:

- Every explicit scope, depth, format, and length constraint is obeyed.
- The central idea is visible in the first sentences, and the causal
  mechanism is clear.
- No mechanism is stated twice in different forms; each diagram, table,
  example, or equation adds information the surrounding prose does not.
- No stretch of prose describes structure or flow that a diagram would show
  at a glance.
- An example, if present, replaces difficult abstraction rather than
  repeating a complete explanation, and every step of it can be verified by
  the reader.
- Read a paragraph back: would a person say it that way? If it sounds like a
  product page or a template, rewrite it as prose.
- Anything that can be removed without weakening the answer is removed.
