# Authoring Portable Skills

This repository targets coding agents that understand the Agent Skills format,
including Claude Code, Codex, Pi, OpenCode, GitHub Copilot, Windsurf, and
Gemini CLI. Use the common Agent Skills standard as the baseline, then add
agent-specific metadata only when the skill needs it.

## Baseline Format

A portable skill is a directory containing `SKILL.md`:

```text
skills/<skill-name>/
|-- SKILL.md
|-- scripts/
|-- references/
`-- assets/
```

`SKILL.md` starts with YAML frontmatter and then Markdown instructions:

```md
---
name: skill-name
description: Do one clear job. Use when the user asks for that job or uses likely trigger words.
---

# Skill Name

Follow concise, task-focused instructions.
```

## Frontmatter Policy

Use these fields by default:

| Field | Policy |
| --- | --- |
| `name` | Required. Use 1-64 lowercase letters, numbers, and hyphens. Do not start or end with a hyphen, and do not use consecutive hyphens. Match the parent directory name. |
| `description` | Required. Keep it specific, front-load the primary use case, and stay below 1024 characters. Include when to use the skill. |
| `license` | Optional. Use only when the skill has explicit licensing terms. |
| `compatibility` | Optional. Use only for meaningful environment requirements. |
| `metadata` | Optional. Use for repository-owned metadata that agents can ignore safely. |
| `allowed-tools` | Optional and experimental. Avoid in portable templates unless the skill truly needs pre-approved tools. |

Avoid agent-specific fields in the shared template. They can be useful in real
skills, but they reduce portability and may be ignored by other agents.

## Writing Descriptions

The description is the main matching surface for all three agents. Write it as a
short capability statement plus trigger guidance:

```yaml
description: Review git diffs for correctness, missing tests, risky behavior changes, and maintainability issues. Use when the user asks for a code review, PR review, or change review.
```

Keep descriptions concise because agents may shorten or cap the initial skill
listing when many skills are installed.

## Body Guidelines

- Keep `SKILL.md` focused; move long details to `references/`.
- Write imperative instructions with explicit inputs and outputs.
- Reference support files with relative paths from the skill root.
- Prefer `scripts/` only for deterministic behavior or external tooling.
- Keep each skill focused on one job.

## Agent-Specific Extensions

- Claude Code supports extra frontmatter for invocation control, arguments,
  shell context injection, tool pre-approval, hooks, model selection, and forked
  subagent context.
- Codex supports optional `agents/openai.yaml` for Codex app metadata,
  invocation policy, and dependencies.
- Pi ignores unknown frontmatter fields, supports `/skill:name` commands, and
  allows the `name` to differ from the directory, though this repository keeps
  them matching for standard compatibility.
- OpenCode, GitHub Copilot, Windsurf, and Gemini CLI can consume the baseline
  `SKILL.md` format through either native paths or shared `.agents/skills`
  compatibility paths.

## Sources

- Claude Code Skills: <https://code.claude.com/docs/en/skills>
- Codex Skills: <https://developers.openai.com/codex/skills>
- Pi Skills: <https://pi.dev/docs/latest/skills>
- OpenCode Skills: <https://opencode.ai/docs/skills>
- GitHub Copilot / VS Code Agent Skills: <https://code.visualstudio.com/docs/copilot/customization/agent-skills>
- Windsurf Skills: <https://docs.windsurf.com/windsurf/cascade/skills>
- Gemini CLI Agent Skills: <https://geminicli.com/docs/cli/using-agent-skills/>
- Agent Skills specification: <https://agentskills.io/specification>
