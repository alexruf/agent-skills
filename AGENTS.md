# Agent Instructions

## Development Philosophy

- Incremental progress over big bangs
- Learn from existing code before writing new code
- Pragmatic over dogmatic
- Clear intent over clever code

## Repository Rules

- Keep each skill in `skills/<skill-name>/`.
- Use one `SKILL.md` as the public entry point for each skill.
- Keep optional skill support files local to the skill:
  - `scripts/` for executable helpers
  - `assets/` for templates, images, and static inputs
  - `references/` for longer supporting documentation
- Put repo-wide automation or validation in `tools/`.

## Change Process

- Prefer small, working commits.
- Match existing structure before adding new conventions.
- Add checks when behavior or automation is introduced.
- Run `tools/check` before committing changes to shell scripts in `tools/`.
