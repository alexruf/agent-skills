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
    _*|.*|*$'\n'*) return 1 ;;
  esac
  [ -f "$skill_dir/SKILL.md" ]
}

resolve_skill_selection() {
  local source_dir="$1"
  local select_all="$2"
  local interactive="$3"
  local skill_dir
  local skill_name
  local candidate
  local selected_dir
  local token
  local input
  local index
  local duplicate
  local -a available=()
  local -a selected=()
  local -a tokens=()

  shift 3

  for skill_dir in "$source_dir"/*; do
    is_syncable_skill "$skill_dir" || continue
    available+=("$skill_dir")
  done

  if [ "$select_all" -eq 1 ]; then
    if [ "$#" -gt 0 ]; then
      echo "--all cannot be combined with skill names." >&2
      return 2
    fi
    for skill_dir in "${available[@]}"; do
      printf '%s\n' "$skill_dir"
    done
    return 0
  fi

  if [ "$#" -gt 0 ]; then
    for skill_name in "$@"; do
      candidate=""
      for skill_dir in "${available[@]}"; do
        if [ "$(basename "$skill_dir")" = "$skill_name" ]; then
          candidate="$skill_dir"
          break
        fi
      done
      if [ -z "$candidate" ]; then
        echo "Unknown or unsyncable skill: $skill_name" >&2
        return 2
      fi

      duplicate=0
      for selected_dir in "${selected[@]}"; do
        if [ "$selected_dir" = "$candidate" ]; then
          duplicate=1
          break
        fi
      done
      [ "$duplicate" -eq 1 ] || selected+=("$candidate")
    done

    for skill_dir in "${selected[@]}"; do
      printf '%s\n' "$skill_dir"
    done
    return 0
  fi

  if [ "${#available[@]}" -eq 0 ]; then
    return 0
  fi

  if [ "$interactive" -ne 1 ]; then
    echo "No skill selection supplied; pass --all or one or more skill names." >&2
    return 2
  fi

  echo "Available skills:" >&2
  index=1
  for skill_dir in "${available[@]}"; do
    printf '  %s) %s\n' "$index" "$(basename "$skill_dir")" >&2
    index=$((index + 1))
  done

  while :; do
    printf 'Select skills (all, numbers, or names separated by spaces): ' >&2
    if ! IFS= read -r input; then
      echo "Selection cancelled." >&2
      return 1
    fi

    tokens=()
    read -r -a tokens <<< "$input"
    if [ "${#tokens[@]}" -eq 0 ]; then
      echo "Select at least one skill." >&2
      continue
    fi

    if [ "${#tokens[@]}" -eq 1 ] && [ "${tokens[0]}" = "all" ]; then
      for skill_dir in "${available[@]}"; do
        printf '%s\n' "$skill_dir"
      done
      return 0
    fi

    for token in "${tokens[@]}"; do
      if [ "$token" = "all" ]; then
        echo "Enter all by itself." >&2
        continue 2
      fi
    done

    selected=()
    for token in "${tokens[@]}"; do
      candidate=""
      if [[ "$token" =~ ^[1-9][0-9]*$ ]]; then
        index=$((token - 1))
        if [ "$index" -lt "${#available[@]}" ]; then
          candidate="${available[$index]}"
        fi
      else
        for skill_dir in "${available[@]}"; do
          if [ "$(basename "$skill_dir")" = "$token" ]; then
            candidate="$skill_dir"
            break
          fi
        done
      fi

      if [ -z "$candidate" ]; then
        echo "Invalid selection: $token" >&2
        continue 2
      fi

      duplicate=0
      for selected_dir in "${selected[@]}"; do
        if [ "$selected_dir" = "$candidate" ]; then
          duplicate=1
          break
        fi
      done
      [ "$duplicate" -eq 1 ] || selected+=("$candidate")
    done

    for skill_dir in "${selected[@]}"; do
      printf '%s\n' "$skill_dir"
    done
    return 0
  done
}
