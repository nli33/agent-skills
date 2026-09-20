#!/usr/bin/env bash
# Symlinks every skill in this repo into ~/.claude/skills, so `git pull` here
# keeps global skills in sync without manual re-linking.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.claude/skills"
mkdir -p "$TARGET_DIR"

for skill_dir in "$REPO_DIR"/*/; do
  name="$(basename "$skill_dir")"
  [ -f "$skill_dir/SKILL.md" ] || continue

  link="$TARGET_DIR/$name"
  if [ -L "$link" ]; then
    if [ "$(readlink "$link")" = "$skill_dir" ] || [ "$(cd "$(dirname "$link")" && cd "$(readlink "$link")" && pwd)" = "${skill_dir%/}" ]; then
      echo "ok: $name already linked"
      continue
    fi
    echo "skip: $name symlink points elsewhere ($(readlink "$link"))"
    continue
  elif [ -e "$link" ]; then
    echo "skip: $name exists at $link and is not a symlink (leaving it alone)"
    continue
  fi

  ln -s "${skill_dir%/}" "$link"
  echo "linked: $name -> $skill_dir"
done
