# Repository Guidelines

## Project Structure & Module Organization

This repository stores reusable Agent Skills and the small shell toolchain that manages them. `skills/` is the canonical source of truth; local agent skill directories should contain symlinks back to this repository, not independent copies.

- `skills/<skill-name>/SKILL.md` is the source for each skill.
- `skills/_template/` is the starting point for new skills and is not synced.
- Optional skill support files live beside the owning skill in `assets/`, `references/`, or `scripts/`.
- `docs/` contains repository and authoring guidance.
- `tools/` contains repo-wide shell automation, with shared helpers in `tools/lib/`.

Keep skill-specific scripts inside `skills/<skill-name>/scripts/`; keep cross-repo automation in `tools/`.
Consult `docs/agent-discovery.md`, `docs/authoring-portable-skills.md`, and `docs/repository-structure.md` when designing or revising a skill.

## Build, Test, and Development Commands

- `cp -R skills/_template skills/my-skill` creates a new skill scaffold.
- `tools/check` runs `shellcheck` on shell scripts under `tools/` and `skills/`, excluding `assets/` and `references/`.
- `tools/sync-agent-skills --dry-run` previews symlinks into local agent skill directories.
- `tools/sync-agent-skills` links valid skills into `~/.claude/skills` and `~/.agents/skills`.
- `tools/sync-agent-skills --target PATH` adds an extra sync target; repeat the flag for multiple targets.
- `tools/unsync-agent-skills` removes only symlinks that point back to this repository.

`tools/check` requires `shellcheck` (`brew install shellcheck` on macOS).

## Coding Style & Naming Conventions

Skill directory names should match the `name` field in `SKILL.md` frontmatter, for example `skills/code-review` with `name: code-review`. Every skill must start with YAML frontmatter containing `name` and `description`. Directories prefixed with `_` or `.` are not synced; see `is_syncable_skill` in `tools/lib/skills.sh`.

Shell scripts should use bash where needed, prefer `set -euo pipefail`, quote variables, and pass `shellcheck`. Use clear, portable Markdown in skill files so instructions work across agents.

## Testing Guidelines

Run `tools/check` before committing changes to shell scripts or skill scripts. For new behavior in tools, add focused shell coverage when practical; for Markdown-only skill edits, validate structure manually and keep examples executable where possible.

## Agent-Specific Notes

Generated local agent directories should contain symlinks to this repository, not independent copies. Default sync targets are `~/.claude/skills` and `~/.agents/skills`, the shared path used by Codex, Pi, OpenCode, GitHub Copilot, Windsurf, and Gemini CLI. Do not edit synced copies directly; update `skills/` here and rerun the sync tool.
