# Tools

Repo-wide automation and validation scripts live here.

Keep skill-specific helpers inside the owning skill directory under `skills/<skill-name>/scripts/`.

## Available Tools

- `sync-agent-skills`: Symlink valid skill directories from this repository into
  local agent-specific personal skill directories.
- `unsync-agent-skills`: Remove only target symlinks that point back to valid
  skill directories in this repository.
- `check`: Run `shellcheck` against the bash tools in this directory. Run before
  committing changes to any script under `tools/`.

By default, the sync tool links skills into `~/.claude/skills` and
`~/.agents/skills`. Codex uses `~/.agents/skills`, and Pi also scans that path.
