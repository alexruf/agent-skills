---
name: workstream
description: "Whenever the user says something like: 'Begin workstream: <name>', 'resume workstream <name>', or 'continue workstream <name>' - always read this skill to understand how to proceed."
---

# Workstreams

Workstreams are stored in the project root under a folder: `.agents/workstreams/<workstream name>/`

If this folder doesn't exist, create it. Check whether `.agents/` is covered by the project's `.gitignore`; if not, ask the user whether workstream files should be tracked in version control before creating them.

`<workstream name>` refers to a workstream name specified by the user, in lowercase-hyphenated form (e.g. `update-pull-request-workflow`). For example, if the user says, `Begin workstream: update-pull-request-workflow`, `<workstream name>` would be `update-pull-request-workflow`.

If the folder for `<workstream name>` already exists, check whether `TODOs.md` exists before doing anything else. If it doesn't exist yet, the workstream is still in its planning phase — see "Starting a new workstream" below, don't jump to implementation. If it does exist and every item is already checked off, don't silently resume — ask the user whether this is new scope that should reuse the name (in which case archive or clear the old files first) or whether they meant to resume/continue a different, still-open workstream.

Inside of this `<workstream name>` folder are the following possible files:

- `CURRENT_DESIGN.md` - detailed description of all relevant parts of the codebase for the workstream we're working on. It contains all files and important functions and/or selectors for the workstream description given to us. If this file doesn't exist, then your first step is to create it. If this file already does exist, you do not need to read it unless it is relevant to the current TODO that you're working on.
- `PLAN.md` - detailed plan of the changes to be made. This file contains a detailed high-level plan of the changes that need to be made to the codebase in order to complete the workstream. It is based on the understanding of the codebase as established by the project `AGENTS.md` file (if it exists) and the `CURRENT_DESIGN.md` file. If this file doesn't exist, you are to create it based on the workstream description that the user gave you — see "Starting a new workstream" below for the interactive process to follow before `TODOs.md` gets created from it. You do not need to read this file if it already exists, but you can if you find it helpful to accomplishing your current TODO from `TODOs.md`.
- `TODOs.md` - created only once the user has explicitly approved `PLAN.md` (see "Starting a new workstream" below). It is a non-hierarchical numbered outline of sequential steps to be taken. Each of the todos in this file correspond to a `STEP-<N>.md` file, and those files are where any sub-steps go. Always read this file before starting work so that you know what specific step to work on next. Example:

    ```md
    1. [x] Analyze all existing code related to creating users
    2. [ ] Refactor the codebase so that all users join the `#general` channel when they're created
    ```

- `STEP-<N>.md` - these file correspond to the numbered step from `TODOs.md`. They contain the current step status, a series of numbered sub-steps, and a final section of notes related to where we are in completing this step. Status must be one of `NOT_STARTED`, `IN_PROGRESS`, `BLOCKED`, or `COMPLETED` — set it to `IN_PROGRESS` as soon as you start the step, and to `BLOCKED` (with the reason recorded in NOTES) if you can't continue. If a `STEP-<N>.md` already exists for the step you're about to start (e.g. a prior session was interrupted), read it first and resume from its NOTES rather than starting over. You can use this file as a memory bank for important information for picking up where you left off in case the session ends, the context clears, and you need to pick up from where you left off in a new context. Here's an example of what this file could look like:

    ```md .agents/workstreams/update-pull-request-workflow/STEP-1.md
    # Analyze all existing code related to creating users

    Status: COMPLETED

    ## Sub tasks

    1. [x] review all user-creation code in `backend/`
    2. [x] review all user-creation code in `frontend/`

    ## NOTES

    I've completed my investigation and found the following functions as relevant for creating users, starting with the backend:

    ### Backend user creation code

    - `createUser()` - `backend/userManagement.ts:78-190`
    - ...
    ```

- `KNOWLEDGE.md` - if this file exists, always read it before beginning on any TODOs. It contains project gotchas and dos & donts. Create/update this file as necessary with any useful feedback the user provides, and any discoveries you've made about the codebase as you're working (this is to save you from having to perform the same troubleshooting steps next time). Keep it concise and not too long. Reserve it for durable, cross-step gotchas that future steps or future workstreams would benefit from; context that only matters for the step you're currently on belongs in that step's `NOTES` section instead.

## Starting a new workstream

A workstream always begins with an interactive planning phase — never skip straight to creating `TODOs.md` or doing implementation work just because the folder, `CURRENT_DESIGN.md`, or `PLAN.md` exist.

1. Explore the codebase read-only (no edits anywhere except this workstream's own folder) to write or refresh `CURRENT_DESIGN.md`.
2. Draft or revise `PLAN.md` from `CURRENT_DESIGN.md`, `AGENTS.md` (if present), and the workstream description the user gave.
3. Present the plan to the user and iterate on it together: surface open questions, tradeoffs, and scope decisions rather than presenting a finished plan as a fait accompli. Update `CURRENT_DESIGN.md`/`PLAN.md` in place as the discussion refines them.
4. Do not create `TODOs.md`, and do not touch any file outside the workstream folder, until the user explicitly approves the plan (e.g. "looks good", "start implementing", "go ahead"). A vague or unrelated reply is not approval — keep iterating until you get an explicit go-ahead.
5. Once approved, create `TODOs.md` from the approved `PLAN.md`, then proceed one TODO at a time as described in NOTES below.

If `TODOs.md` doesn't exist yet when you're asked to resume a workstream, it's still in this planning phase — reload `CURRENT_DESIGN.md`/`PLAN.md` if present, summarize where planning left off, and continue the back-and-forth from there rather than assuming it's safe to start implementing.

## NOTES

Work in segments of one TODO at a time unless instructed otherwise. When you've completed a TODO, give the user a very brief report on what you've done. Leave any further details in the `NOTES` section of the corresponding `STEP-<N>.md` file.

To avoid using up unnecessary context, do not read previous step files (unless you need to in order to complete the current step you're working on).

Your progress should be tracked in the particular `STEP-<N>.md` file you're working on. However, if it's pertinent to completing the current step you're working on, you may update any of the other files in the workstream folder.

If as you're working on a subtask you discover that it makes sense to adjust and update the `PLAN.md` or `TODOs.md` files, then do so immediately before proceeding with any implementation work.

- Important: never mark a TODO in TODOs.md as completed unless you've first created a corresponding `STEP-<N>.md` file for it, done the step, updated its notes section, and marked its status as `COMPLETED`.
- Important: as you are working, always update the current `STEP-<N>.md` file to mark subtasks as completed immediately after you complete them. No exceptions! Do not start the next sub-step until you've done this! This is to ensure interrupted sessions can smoothly pick up from where you left off.
- Important: if your agent environment has a `todos` type tool (a UI checklist), NEVER USE IT when using this skill!
- Important: When creating files for a workstream, NEVER create multiple `STEP-<N>.md` files in a row! ALWAYS ONLY create the STEP file for the current TODO that you're working on, and only after you've reviewed any relevant files and are ready to begin work.
- Important: if inserting or reordering items in `TODOs.md` shifts which TODO a `STEP-<N>.md` file corresponds to, renumber the affected `STEP-<N>.md` files so the mapping stays 1:1. Don't leave stale numbering.
- Important: if completing a step reveals that `CURRENT_DESIGN.md` is now wrong or incomplete, update it before moving to the next step rather than letting it go stale.

After you've completed a step and marked its TODO in the `TODOs.md` as done, stop and let the user review your changes (unless otherwise instructed to continue without stopping).

## Review Only Instruction

If the user tells you either "review only", "verify only" or "verify plan" for the workstream (or something to that effect), this indicates that they don't want you to actually complete any TODOs. Instead, for this session just review the existing CURRENT_DESIGN.md, PLAN.md, TODOs.md, KNOWLEDGE.md (and any relevant STEP file), compare it to the codebase, and verify whether the current plan is sound or if any adjustments should be made. If adjustments should be made, update the documents accordingly and then stop after giving the user a brief summary of the changes.

## Completing a workstream

Once every item in `TODOs.md` is checked off, do a final pass: confirm `KNOWLEDGE.md` captures anything durable worth keeping for next time, then tell the user the workstream is done. Ask whether to leave the `.agents/workstreams/<workstream name>/` folder in place as a record or delete it — don't delete it unprompted.

## Managing limited context

There are two useful tools an agent environment might have:

- (A) The ability to know how much context is remaining
- (B) A tool that lets you start a fresh session context and continue where you left off by passing in context to the new session tool

If the agent software has (A) but not (B), then come to a stop when you have little context remaining and give a brief report to the user.

If the agent software has both (A) and (B) and it's time to start a fresh session because of limited remaining context, use (B) to start a fresh session in a way that let's you pick up from where you left off. Make sure to **always** tell yourself to load the 'workstream' skill in the new session context, and then per the instructions here, provide it the user-given `<workstream name>` you've been working on.

If it has neither (A) nor (B), don't worry about it, hopefully it will auto-compact properly.
