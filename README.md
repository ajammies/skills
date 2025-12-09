# Claude Code Skills

A composable collection of skills and commands for Claude Code.

## Installation

Clone into your Claude settings directory:

```bash
git clone https://github.com/ajammies/skills.git ~/.claude/skills
```

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

Single-action prompts invoked with `/command-name`.

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
- [Claude Skills Deep Dive](https://leehanchung.github.io/blogs/2025/10/26/claude-skills-deep-dive/) - Detailed guide
- [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) - Community resources
