#!/bin/bash
# Initialize Claude Code skills and commands symlinks
# Run this script to set up global access to shared commands

set -e

SKILLS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
COMMANDS_SOURCE="$SKILLS_DIR/commands"
COMMANDS_TARGET="$CLAUDE_DIR/commands"
HOOKS_SOURCE="$SKILLS_DIR/hooks"
HOOKS_TARGET="$CLAUDE_DIR/hooks"

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

# Handle hooks symlink
if [ -L "$HOOKS_TARGET" ]; then
    current_link=$(readlink "$HOOKS_TARGET")
    if [ "$current_link" = "$HOOKS_SOURCE" ]; then
        echo "✓ Hooks symlink already configured"
    else
        echo "! Hooks symlink exists but points to: $current_link"
        read -p "Replace with link to $HOOKS_SOURCE? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm "$HOOKS_TARGET"
            ln -s "$HOOKS_SOURCE" "$HOOKS_TARGET"
            echo "✓ Hooks symlink updated"
        else
            echo "Skipped"
        fi
    fi
elif [ -d "$HOOKS_TARGET" ]; then
    echo "! Directory exists at $HOOKS_TARGET"
    echo "  Please backup/remove it manually, then re-run this script"
    exit 1
elif [ -e "$HOOKS_TARGET" ]; then
    echo "! File exists at $HOOKS_TARGET"
    echo "  Please remove it manually, then re-run this script"
    exit 1
else
    ln -s "$HOOKS_SOURCE" "$HOOKS_TARGET"
    echo "✓ Hooks symlink created: $HOOKS_TARGET -> $HOOKS_SOURCE"
fi

# Configure UserPromptSubmit hook in settings.json
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
HOOK_COMMAND="$HOOKS_SOURCE/skill-activation.sh"

configure_hook() {
    if [ ! -f "$SETTINGS_FILE" ]; then
        # Create new settings file with hook
        cat > "$SETTINGS_FILE" << EOF
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "$HOOK_COMMAND"
          }
        ]
      }
    ]
  }
}
EOF
        echo "✓ Created settings.json with skill activation hook"
    elif grep -q "skill-activation.sh" "$SETTINGS_FILE"; then
        echo "✓ Skill activation hook already configured in settings.json"
    else
        # Settings exists but no hook - need to merge
        # Use a temp file approach with jq if available, otherwise warn
        if command -v jq &> /dev/null; then
            HOOK_CONFIG='{"UserPromptSubmit":[{"hooks":[{"type":"command","command":"'"$HOOK_COMMAND"'"}]}]}'
            jq --argjson hook "$HOOK_CONFIG" '.hooks = (.hooks // {}) + $hook' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
            echo "✓ Added skill activation hook to settings.json"
        else
            echo "! settings.json exists but jq is not installed"
            echo "  Please manually add the following to $SETTINGS_FILE:"
            echo ""
            echo '  "hooks": {'
            echo '    "UserPromptSubmit": ['
            echo '      {'
            echo '        "hooks": ['
            echo '          {'
            echo '            "type": "command",'
            echo "            \"command\": \"$HOOK_COMMAND\""
            echo '          }'
            echo '        ]'
            echo '      }'
            echo '    ]'
            echo '  }'
        fi
    fi
}

configure_hook

echo ""
echo "Setup complete! Your commands and hooks are now available globally."
echo "Add .md files to $COMMANDS_SOURCE to create new slash commands."
