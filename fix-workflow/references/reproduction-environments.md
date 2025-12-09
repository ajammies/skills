# Reproduction Environments

Environment setup varies per project. Check project documentation for specific instructions.

## Common Patterns

### Local Development
```bash
# Typical setup
npm install        # or yarn, pnpm
npm run dev        # start local server
```

### Staging Environment
- Use staging URL/credentials from project config
- May require VPN or specific network access
- Data may differ from production - note any differences

## Per-Project Configuration

Check these locations for project-specific setup:
- `README.md` - Setup instructions
- `.env.example` - Required environment variables
- `docker-compose.yml` - Container configuration
- `CLAUDE.md` - Project-specific context

## Tips

- Match the reporter's environment as closely as possible
- Note browser, OS, and version if relevant
- Check if bug is environment-specific (works locally, fails in staging)
- Document any environment differences that may affect reproduction
