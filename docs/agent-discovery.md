# Agent Discovery

There is no single official skill directory shared by all coding agents. The
portable part is the skill package format: one directory containing a `SKILL.md`
entry point plus optional support files.

## Personal Skill Directories

| Agent | Personal skill directory |
| --- | --- |
| Claude Code | `~/.claude/skills/<skill-name>/SKILL.md` |
| Codex | `~/.agents/skills/<skill-name>/SKILL.md` |
| Pi | `~/.pi/agent/skills/<skill-name>/SKILL.md` and `~/.agents/skills/<skill-name>/SKILL.md` |
| OpenCode | `~/.config/opencode/skills/<skill-name>/SKILL.md`, `~/.agents/skills/<skill-name>/SKILL.md`, and `~/.claude/skills/<skill-name>/SKILL.md` |
| GitHub Copilot / VS Code | `~/.copilot/skills/<skill-name>/SKILL.md`, `~/.agents/skills/<skill-name>/SKILL.md`, and `~/.claude/skills/<skill-name>/SKILL.md` |
| Windsurf / Cascade | `~/.codeium/windsurf/skills/<skill-name>/SKILL.md` and `~/.agents/skills/<skill-name>/SKILL.md` |
| Gemini CLI | `~/.gemini/skills/<skill-name>/SKILL.md` and `~/.agents/skills/<skill-name>/SKILL.md` |

`~/.agents/skills` is the useful shared personal directory for Codex, Pi,
OpenCode, GitHub Copilot, Windsurf, and Gemini CLI. Claude Code uses its own
personal directory, so this repository syncs to both `~/.claude/skills` and
`~/.agents/skills` by default.

## Project Skill Directories

| Agent | Project skill directory behavior |
| --- | --- |
| Claude Code | `.claude/skills/<skill-name>/SKILL.md` in the project. Claude Code also discovers parent and nested `.claude/skills` directories. |
| Codex | `.agents/skills/<skill-name>/SKILL.md` in the current directory and ancestor directories up to the repository root. |
| Pi | `.pi/skills/`, plus `.agents/skills/` in the current directory and ancestors. Pi also supports settings and CLI-provided skill paths. |
| OpenCode | `.opencode/skills/<skill-name>/SKILL.md`, `.agents/skills/<skill-name>/SKILL.md`, and `.claude/skills/<skill-name>/SKILL.md`. |
| GitHub Copilot / VS Code | `.github/skills/<skill-name>/SKILL.md`, `.agents/skills/<skill-name>/SKILL.md`, and `.claude/skills/<skill-name>/SKILL.md`. |
| Windsurf / Cascade | `.windsurf/skills/<skill-name>/SKILL.md` and `.agents/skills/<skill-name>/SKILL.md`. |
| Gemini CLI | `.gemini/skills/<skill-name>/SKILL.md` and `.agents/skills/<skill-name>/SKILL.md`. |

This repository starts with personal skill sync because it keeps the first
workflow simple and avoids checking generated agent-specific links into git.

## Repository Strategy

Keep canonical skills in `skills/<skill-name>/` and choose skills interactively
when running in a terminal:

```sh
tools/sync-agent-skills
```

For a named subset, pass skill directory names positionally:

```sh
tools/sync-agent-skills code-review diagnose
```

Use `--all` for unattended bulk sync:

```sh
tools/sync-agent-skills --all
```

Without skill names or `--all`, a non-terminal invocation fails instead of
silently processing every skill.

The script links each skill directory individually. This keeps the agent-specific
parent directories as real directories, which is more conservative than replacing
the entire parent directory with a symlink.

Remove repository-owned links with:

```sh
tools/unsync-agent-skills
```

The unsync tool removes only symlinks whose resolved target is a valid skill
directory in this repository. Skills installed from other repositories or created
directly in an agent directory are left untouched.

If this repository was moved or deleted before unsyncing, use
`--prune-dangling` to remove selected broken links whose stored target ends in
`/skills/<skill-name>`. For example, a broken
`~/.agents/skills/code-review -> /old/agent-skills/skills/code-review` link is
removed by:

```sh
tools/unsync-agent-skills --all --prune-dangling
```

The option does not remove arbitrary broken links.

## Custom Targets

Use `--target` for additional or older discovery paths:

```sh
tools/sync-agent-skills --target "$HOME/.claude/skills" --target "$HOME/.agents/skills"
```

For unattended custom-target sync, add `--all`:

```sh
tools/sync-agent-skills --target "$HOME/.claude/skills" --target "$HOME/.agents/skills" --all
```

Avoid syncing the same skill set to both `~/.agents/skills` and
`~/.pi/agent/skills` unless you intentionally want duplicate Pi discovery paths.
Pi warns on name collisions and keeps the first skill it finds.

The same principle applies to agents that already scan `~/.agents/skills`.
Prefer one shared target until a specific agent requires its native personal
directory.

Use `--dry-run` with an explicit selection when changing targets:

```sh
tools/sync-agent-skills --dry-run --all
```

## Agent Notes

- Claude Code follows the Agent Skills standard and adds Claude-specific
  frontmatter such as invocation controls, arguments, dynamic shell context,
  scoped hooks, model selection, and subagent execution.
- Codex follows the Agent Skills standard, supports user, repository, admin, and
  system skill scopes, and follows symlinked skill folders while scanning.
- Pi implements the Agent Skills standard leniently. It loads directories with
  `SKILL.md` recursively, supports `/skill:name` commands, ignores unknown
  frontmatter fields, and refuses to load skills without `description`.
- OpenCode supports the Agent Skills format, checks both shared compatibility
  paths and native `.opencode` paths, and requires `name` and `description`.
- GitHub Copilot / VS Code supports Agent Skills for VS Code, Copilot CLI, and
  Copilot coding agent. It scans `.github/skills` and shared compatibility paths.
- Windsurf / Cascade supports native Windsurf skill paths and shared
  `.agents/skills` compatibility paths.
- Gemini CLI supports native Gemini skill paths and shared `.agents/skills`
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
