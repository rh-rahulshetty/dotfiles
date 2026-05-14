#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link_claude_commands() {
    local src_dir="$DOTFILES_DIR/.claude/commands"
    local dest_dir="$HOME/.claude/commands"

    mkdir -p "$dest_dir"

    for src in "$src_dir/"*; do
        [[ -e "$src" ]] || continue
        local name dest
        name="$(basename "$src")"
        dest="$dest_dir/$name"

        if [[ -L "$dest" ]]; then
            rm "$dest"
        elif [[ -e "$dest" ]]; then
            echo "Skipping $name: $dest exists and is not a symlink"
            continue
        fi

        ln -s "$src" "$dest"
        echo "Linked $name"
    done
}

link_claude_commands
