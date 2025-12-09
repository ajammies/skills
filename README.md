# Claude Code Skills

A composable collection of skills and commands for Claude Code.

## Installation

Clone into your Claude settings directory and run the init script:

```bash
git clone https://github.com/ajammies/skills.git ~/.claude/skills
cd ~/.claude/skills
./init.sh
```

The init script creates a symlink from `~/.claude/commands` to the commands in this repo, making all slash commands available globally.

## Skills

Multi-step workflows invoked automatically based on user intent.

| Skill | Description |
|-------|-------------|
| **create-feature** | Structured workflow for implementing new features with branching, TDD, atomic commits, and PR creation |
| **fix** | Bug fixing with reproduction, root cause analysis, minimal fixes, and regression testing |
| **refactor** | Safe code restructuring that preserves behavior with tests before/after |
| **review** | Checklist-driven code review for staged changes, branch diffs, or specific files |
| **research** | Explore codebase and online sources to gather information on a topic |
| **reflect** | End-of-session analysis to recommend workflow improvements |
| **create-skill** | Guide for creating new Claude Code skills |
| **create-agent** | Agent design using Vercel AI SDK generateObject with Zod schemas |

## Commands

Single-action prompts invoked with `/command-name`. Commands infer intent from context when no arguments provided.

### Skill Commands

| Command | Description |
|---------|-------------|
| `/create-feature` | Implement a new feature (routes to create-feature skill) |
| `/fix` | Fix a bug (routes to fix skill) |
| `/refactor` | Refactor code safely (routes to refactor skill) |
| `/review` | Review code changes (routes to review skill) |
| `/research` | Research a topic (routes to research skill) |
| `/reflect` | Analyze session for improvements (routes to reflect skill) |
| `/create-skill` | Create or update a skill (routes to create-skill skill) |
| `/create-agent` | Create or modify an agent (routes to create-agent skill) |

### Utility Commands

| Command | Description |
|---------|-------------|
| `/commit` | Create a git commit with conventional message |
| `/pr` | Create a pull request |
| `/fix-pr` | Fix PR review comments |
| `/issues` | List GitHub issues |
| `/do-issue` | Work on a GitHub issue |
| `/create-issue` | Create a new GitHub issue |
| `/check` | Run build/test checks |
| `/cleanup` | Clean up branches and artifacts |
| `/changelog` | Generate changelog from commits |
| `/explain` | Explain code or concepts |

## Structure

```
skills/
├── CLAUDE.md           # Project instructions for Claude
├── CONTRIBUTING.md     # How to contribute
├── commands/           # Single-action slash commands
│   └── *.md
└── <skill-name>/       # Multi-step workflows
    ├── SKILL.md        # Core instructions
    ├── references/     # Detailed docs (loaded on demand)
    └── scripts/        # Automation scripts
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines on creating and improving skills.

## References

- [anthropics/skills](https://github.com/anthropics/skills) - Official examples
- [diet103/claude-code-infrastructure-showcase](https://github.com/diet103/claude-code-infrastructure-showcase) - Infrastructure patterns and examples
- [Claude Skills Deep Dive](https://leehanchung.github.io/blogs/2025/10/26/claude-skills-deep-dive/) - Detailed guide
- [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) - Community resources
