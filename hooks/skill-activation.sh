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

# Flatten JSON to single lines per rule for easier parsing
FLAT_JSON=$(tr -d '\n' < "$RULES_FILE" | sed 's/},/}\n/g')

while IFS= read -r rule; do
  # Skip empty lines
  [ -z "$rule" ] && continue

  # Extract skill name
  skill=$(echo "$rule" | sed 's/.*"skill"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')
  [ "$skill" = "$rule" ] && continue

  # Extract priority
  priority=$(echo "$rule" | sed 's/.*"priority"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/')

  # Extract keywords array
  keywords=$(echo "$rule" | grep -o '"keywords"[[:space:]]*:[[:space:]]*\[[^]]*\]' | sed 's/"keywords"[[:space:]]*:[[:space:]]*\[//' | sed 's/\]//' | tr -d '"')

  # Check each keyword
  IFS=',' read -ra KEYWORD_ARRAY <<< "$keywords"
  for keyword in "${KEYWORD_ARRAY[@]}"; do
    keyword=$(echo "$keyword" | xargs)  # trim whitespace
    if [ -n "$keyword" ] && echo "$PROMPT" | grep -qi "$keyword"; then
      MATCHED_SKILLS="$MATCHED_SKILLS
- [$priority] $skill"
      break
    fi
  done
done <<< "$FLAT_JSON"

if [ -n "$MATCHED_SKILLS" ]; then
  echo ""
  echo "=== SKILL ACTIVATION CHECK ==="
  echo "$MATCHED_SKILLS"
  echo ""
  echo "Use Skill tool BEFORE responding."
  echo "================================"
fi
