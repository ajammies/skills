# Check Project

Run lint, typecheck, and tests to validate the project.

## Steps

1. Detect project tooling by checking for config files
2. Run available checks in order: lint, typecheck, tests
3. Report results and fix any failures

## Detection

| File | Tooling | Commands |
|------|---------|----------|
| `package.json` | Node.js | `npm run lint`, `npm run typecheck`, `npm test` |
| `Cargo.toml` | Rust | `cargo clippy`, `cargo check`, `cargo test` |
| `pyproject.toml` | Python | `ruff check .`, `mypy .`, `pytest` |
| `go.mod` | Go | `golangci-lint run`, `go build`, `go test ./...` |

## Behavior

- Skip unavailable commands gracefully
- Stop on first failure and report the error
- Suggest fixes for common issues
- If no config files found, ask user what to run

## Usage

```
/check           # Run all available checks
/check lint      # Run only lint
/check test      # Run only tests
```

Arguments: $ARGUMENTS
