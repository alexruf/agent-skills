# Repository Structure

This repository stores reusable Agent Skills in a predictable layout.

The repository is the source of truth. Local agent skill directories should point
back to this repository with symlinks created by `tools/sync-agent-skills`.
Those links can be removed with `tools/unsync-agent-skills`.

## Skill Layout

```text
skills/<skill-name>/
|-- SKILL.md
|-- assets/
|-- references/
`-- scripts/
```

Only `SKILL.md` is required. Add the optional folders when the skill needs them.
Agent-specific metadata can live in agent-owned subdirectories such as
`agents/openai.yaml`, but keep the main `SKILL.md` portable unless the skill is
intentionally built for one agent.

## Naming

- Use lowercase directory names.
- Prefer hyphen-separated names for multi-word skills.
- Match the directory name to the `name` frontmatter field.
- Keep names stable once a skill is referenced by installation or sync tooling.

## Scope

Skill-specific files stay inside the skill directory. Repository-level docs, checks,
and maintenance tools stay outside `skills/`.

Generated agent-specific links stay outside this repository:

- Claude Code personal skills: `~/.claude/skills/<skill-name>/`
- Shared personal skills for Codex, Pi, OpenCode, GitHub Copilot, Windsurf, and
  Gemini CLI: `~/.agents/skills/<skill-name>/`
- Optional native personal paths can be added with explicit `--target` values
  when an agent requires them.

If a local agent version uses a different discovery directory, pass explicit
targets to `tools/sync-agent-skills`.
