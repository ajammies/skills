#!/bin/bash
# Initialize Claude Code skills and commands symlinks
# Run this script to set up global access to shared commands

set -e

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
COMMANDS_SOURCE="$SKILLS_DIR/commands"
COMMANDS_TARGET="$CLAUDE_DIR/commands"

echo "Setting up Claude Code skills from: $SKILLS_DIR"

# Ensure ~/.claude exists
mkdir -p "$CLAUDE_DIR"

# Handle commands symlink
if [ -L "$COMMANDS_TARGET" ]; then
    current_link=$(readlink "$COMMANDS_TARGET")
    if [ "$current_link" = "$COMMANDS_SOURCE" ]; then
        echo "✓ Commands symlink already configured"
    else
        echo "! Commands symlink exists but points to: $current_link"
        read -p "Replace with link to $COMMANDS_SOURCE? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm "$COMMANDS_TARGET"
            ln -s "$COMMANDS_SOURCE" "$COMMANDS_TARGET"
            echo "✓ Commands symlink updated"
        else
            echo "Skipped"
        fi
    fi
elif [ -d "$COMMANDS_TARGET" ]; then
    echo "! Directory exists at $COMMANDS_TARGET"
    echo "  Please backup/remove it manually, then re-run this script"
    exit 1
elif [ -e "$COMMANDS_TARGET" ]; then
    echo "! File exists at $COMMANDS_TARGET"
    echo "  Please remove it manually, then re-run this script"
    exit 1
else
    ln -s "$COMMANDS_SOURCE" "$COMMANDS_TARGET"
    echo "✓ Commands symlink created: $COMMANDS_TARGET -> $COMMANDS_SOURCE"
fi

echo ""
echo "Setup complete! Your commands are now available globally."
echo "Add .md files to $COMMANDS_SOURCE to create new slash commands."
