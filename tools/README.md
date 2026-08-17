# Tools

Repo-wide automation and validation scripts live here.

Keep skill-specific helpers inside the owning skill directory under `skills/<skill-name>/scripts/`.

## Available Tools

- `sync-agent-skills`: Symlink selected valid skill directories from this
  repository into local agent-specific personal skill directories. Run it with
  no selection in a terminal for an interactive prompt, pass names such as
  `code-review diagnose` for a subset, or use `--all` for unattended bulk sync.
- `unsync-agent-skills`: Remove only selected target symlinks that point back to
  valid skill directories in this repository. It accepts the same interactive,
  positional, and `--all` selection modes. `--prune-dangling` also removes
  selected broken links that retain a `.../skills/<skill-name>` target after the
  repository has moved.
- `test-agent-skill-sync`: Run dependency-free behavioral coverage for selective
  sync and unsync:

  ```sh
  tools/test-agent-skill-sync
  ```
- `check`: Run `shellcheck` against all shell scripts under `tools/` and
  `skills/` (excluding `assets/` and `references/`). Run before committing
  changes to any shell script in the repo.

By default, the sync tool links skills into `~/.claude/skills` and
`~/.agents/skills`. Codex uses `~/.agents/skills`, and Pi also scans that path.
Without named skills or `--all`, a non-terminal invocation fails rather than
silently processing every skill.
