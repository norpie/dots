#!/usr/bin/env bash

set -euo pipefail

CLAUDE_DIR=".claude/claude.md"

# --- Helper Functions ---

get_git_root() {
    local root
    root=$(git root)
    if [ -z "$root" ]; then
        echo "Error: Not in a git repository" >&2
        exit 1
    fi
    echo "$root"
}

# Check if any of the given files are tracked by git
any_tracked() {
    local files=("$@")
    for file in "${files[@]}"; do
        if git ls-files --error-unmatch "$file" &>/dev/null; then
            return 0
        fi
    done
    return 1
}

# --- Migration ---

migrate_claude_files() {
    local root_files
    root_files=(claude.*.md)

    # Check if glob matched anything
    if [ ! -e "${root_files[0]}" ]; then
        return 0
    fi

    # Only migrate if .claude directory exists
    if [ ! -d ".claude" ]; then
        return 0
    fi

    # Don't migrate if any files are git-tracked
    if any_tracked "${root_files[@]}"; then
        echo "Skipping migration: some claude.*.md files are git-tracked"
        return 0
    fi

    # Create target directory and migrate
    mkdir -p "$CLAUDE_DIR"
    for file in "${root_files[@]}"; do
        mv "$file" "$CLAUDE_DIR/"
        echo "Migrated $file -> $CLAUDE_DIR/$file"
    done
}

# --- File Discovery ---

find_claude_files() {
    local files=()

    # Check repo root
    for f in claude.*.md; do
        [ -e "$f" ] && files+=("$f")
    done

    # Check .claude/claude.md/
    if [ -d "$CLAUDE_DIR" ]; then
        for f in "$CLAUDE_DIR"/claude.*.md; do
            [ -e "$f" ] && files+=("$f")
        done
    fi

    printf '%s\n' "${files[@]}"
}

# --- Main ---

main() {
    local git_root
    git_root=$(get_git_root)
    cd "$git_root" || exit 1

    # Run migration
    migrate_claude_files

    # Find all claude files
    local claude_files
    claude_files=$(find_claude_files)

    if [ -z "$claude_files" ]; then
        echo "No claude.*.md files found"
        exit 1
    fi

    # Use fzf to select a file
    local selected
    selected=$(echo "$claude_files" | fzf --prompt="Select claude context file: ")

    if [ -z "$selected" ]; then
        echo "No file selected"
        exit 0
    fi

    # Remove existing CLAUDE.md if it's a symlink or file
    if [ -e "CLAUDE.md" ] || [ -L "CLAUDE.md" ]; then
        rm "CLAUDE.md"
    fi

    # Create symlink
    ln -s "$selected" "CLAUDE.md"
    echo "Linked CLAUDE.md -> $selected"
}

main "$@"
