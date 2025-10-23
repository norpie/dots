#!/usr/bin/env bash

# Get git root directory
git_root=$(git root)
if [ -z "$git_root" ]; then
    echo "Error: Not in a git repository"
    exit 1
fi

# Find all claude.*.md files in git root
cd "$git_root" || exit 1
claude_files=$(ls claude.*.md 2>/dev/null)

if [ -z "$claude_files" ]; then
    echo "No claude.*.md files found in $git_root"
    exit 1
fi

# Use fzf to select a file
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
