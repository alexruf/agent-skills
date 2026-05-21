# shellcheck shell=bash
# Shared helpers for tools/sync-agent-skills and tools/unsync-agent-skills.
# Source this file; do not execute it.

default_skill_targets() {
  printf '%s\n' \
    "$HOME/.claude/skills" \
    "$HOME/.agents/skills"
}

is_syncable_skill() {
  local skill_dir="$1"
  local name
  [ -d "$skill_dir" ] || return 1
  name="$(basename "$skill_dir")"
  case "$name" in
    _*|.*) return 1 ;;
  esac
  [ -f "$skill_dir/SKILL.md" ]
}
