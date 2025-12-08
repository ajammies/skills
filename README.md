# Claude Code Skills

A collection of reusable skills for Claude Code that enforce consistent workflows, coding standards, and best practices across projects.

## What are Skills?

Skills are modular instruction sets that extend Claude's capabilities with specialized knowledge and workflows. They teach Claude *how* to complete specific tasks in a repeatable way—from following coding standards to managing git workflows.

## Installation

Clone this repository to your Claude config directory:

```bash
# Personal skills (available everywhere)
git clone https://github.com/ajammies/skills.git ~/.claude/skills
```

To update:

```bash
cd ~/.claude/skills && git pull
```

## Available Skills

| Skill | Description |
|-------|-------------|
| **code-rules** | Coding philosophy and standards. Pure functions, explicit types, no premature abstraction. |
| **commit** | Atomic commits with proper formatting. Branch validation and message guidelines. |
| **create-issue** | GitHub issue management. Create, view, resolve, and link issues to PRs. |
| **create-skill** | Guide for creating new skills. Anatomy, progressive disclosure, packaging. |
| **design-agent** | Agent architecture using Vercel AI SDK. Zod schemas, prompting, error handling. |
| **find-pattern** | Find existing patterns before implementing. Prevents reinventing the wheel. |
| **pr-workflow** | Full PR lifecycle. Branch → Plan → Implement → Test → PR → Merge → Reflect. |
| **reflect** | End-of-session reflection. Analyze what worked and recommend improvements. |

## Usage

Skills are automatically loaded by Claude Code when relevant. You can also invoke them explicitly:

```
/skill code-rules    # Load coding standards before complex edits
/skill pr-workflow   # Start a feature with proper branching
/skill reflect       # Analyze session and capture learnings
```


## Creating Your Own Skills

See the `create-skill` skill for comprehensive guidance, or start with this template:

```markdown
---
name: my-skill
description: When to use this skill. Be specific about triggers.
---

# My Skill

## WORKFLOW

1. **Step One** - What to do first
2. **Step Two** - What to do next
   ⏸️ Pause for user input if needed

## Principles

- Key principle 1
- Key principle 2
```

## Project Configuration

After installing skills, create a `CLAUDE.md` in your project root to provide project-specific context. See [CLAUDE.md](CLAUDE.md) for a template.

## Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch (`git checkout -b feat/new-skill`)
3. Follow the existing skill format
4. Test the skill in a real project
5. Submit a pull request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

## License

Apache 2.0 - See [LICENSE](LICENSE) for details.

## Acknowledgments

Inspired by [anthropics/skills](https://github.com/anthropics/skills) and the Claude Code community.
