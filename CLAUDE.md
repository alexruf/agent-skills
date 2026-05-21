# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repository Does

Canonical store for reusable Agent Skills. `skills/` is the single source of truth; the scripts in `tools/` symlink each skill into agent-specific personal directories (default: `~/.claude/skills` and `~/.agents/skills`, the shared path used by Codex, Pi, OpenCode, GitHub Copilot, Windsurf, and Gemini CLI) so edits propagate automatically.

## Common Commands

```sh
tools/check                           # shellcheck on tools/ and skills/ (excludes assets/, references/)
tools/sync-agent-skills --dry-run     # preview symlinks
tools/sync-agent-skills               # link into default targets
tools/sync-agent-skills --target PATH # add an extra target (repeatable)
tools/unsync-agent-skills             # remove only links pointing back to this repo
cp -R skills/_template skills/my-skill  # scaffold a new skill
```

`tools/check` requires `shellcheck` (`brew install shellcheck`).

## Architecture

### Skill package format

A skill is a directory under `skills/` containing a `SKILL.md` entry point. `SKILL.md` opens with YAML frontmatter (`name`, `description`) followed by Markdown instructions. Optional subdirectories: `scripts/` (helpers), `assets/` (static files), `references/` (background material). The directory name must match the `name` frontmatter field.

Directories prefixed with `_` (e.g. `_template`) or `.` are skipped by sync — see `is_syncable_skill` in `tools/lib/skills.sh`.

Authoring guidance for skills lives in `docs/` (`agent-discovery.md`, `authoring-portable-skills.md`, `repository-structure.md`) — consult it when designing or revising a skill.

### Sync mechanism

`tools/sync-agent-skills` iterates `skills/*`, filters via `is_syncable_skill`, and runs `ln -sfn <skill> <target>/<name>` for each target. It refuses to overwrite an existing non-symlink at the destination. `tools/unsync-agent-skills` only removes symlinks whose resolved target is a valid skill in this repo, so skills from other sources are left alone.

`tools/lib/skills.sh` is sourced (not executed) by both sync scripts and exposes `default_skill_targets` and `is_syncable_skill`.

## Conventions

- Run `tools/check` before committing shell-script changes.
- Skill directory names use lowercase hyphen-separated words and must stay stable once synced (links would break).
- Skill-specific helpers go in `skills/<skill-name>/scripts/`; repo-wide automation goes in `tools/`.
- Do not edit synced copies in `~/.claude/skills` or `~/.agents/skills` — edit `skills/` here; the symlinks pick it up.
- Shell scripts use `#!/usr/bin/env bash` with `set -euo pipefail` and must pass `shellcheck`.
- Skill Markdown must stay portable — avoid agent-specific syntax in `_template`, and prefer wording that works across the agents listed above.
