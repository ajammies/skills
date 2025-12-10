#!/bin/bash
# Skill activation hook - matches user prompts against skill rules
# Runs on UserPromptSubmit to suggest relevant skills

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES_FILE="$SCRIPT_DIR/skill-rules.json"

# Read prompt from stdin (JSON with prompt field)
INPUT=$(cat)
PROMPT=$(echo "$INPUT" | grep -o '"prompt"[[:space:]]*:[[:space:]]*"[^"]*"' | sed 's/"prompt"[[:space:]]*:[[:space:]]*"//' | sed 's/"$//' | tr '[:upper:]' '[:lower:]')

if [ -z "$PROMPT" ]; then
  exit 0
fi

if [ ! -f "$RULES_FILE" ]; then
  exit 0
fi

# Parse rules and match keywords
MATCHED_SKILLS=""

while IFS= read -r rule; do
  skill=$(echo "$rule" | sed 's/.*"skill"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
  priority=$(echo "$rule" | sed 's/.*"priority"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
  keywords=$(echo "$rule" | grep -o '"keywords"[[:space:]]*:[[:space:]]*\[[^]]*\]' | sed 's/"keywords"[[:space:]]*:[[:space:]]*\[//' | sed 's/\]//' | tr -d '"' | tr ',' '\n')

  for keyword in $keywords; do
    keyword=$(echo "$keyword" | tr -d ' ')
    if echo "$PROMPT" | grep -qi "$keyword"; then
      MATCHED_SKILLS="$MATCHED_SKILLS\n- [$priority] $skill"
      break
    fi
  done
done < <(grep -o '{[^}]*"skill"[^}]*}' "$RULES_FILE")

if [ -n "$MATCHED_SKILLS" ]; then
  echo ""
  echo "=== SKILL ACTIVATION CHECK ==="
  echo -e "$MATCHED_SKILLS"
  echo ""
  echo "Use Skill tool BEFORE responding."
  echo "================================"
fi
