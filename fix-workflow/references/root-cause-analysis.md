# Root Cause Analysis

## 5 Whys Technique

Ask "Why?" repeatedly until you reach the fundamental cause.

### Example: Application Crash

1. **Why did the app crash?** → Null pointer exception
2. **Why was there a null pointer?** → Variable was uninitialized
3. **Why was it uninitialized?** → Missing validation on API response
4. **Why was validation missing?** → API contract was unclear
5. **Why was contract unclear?** → No documentation for edge cases

**Root cause**: Missing API documentation for edge cases
**Fix**: Add validation + document the API contract

### Example: Form Submission Failing

1. **Why can't users submit forms?** → Database connection refused
2. **Why was connection refused?** → Database memory full
3. **Why was memory full?** → Sudden increase in data writes
4. **Why the increase?** → New service started writing to same DB
5. **Why wasn't this caught?** → No communication about system changes

**Root cause**: New service impact not communicated
**Fix**: Increase DB capacity + add monitoring + improve change communication

## Root Cause Categories

| Category | Examples |
|----------|----------|
| **Technical** | Code defects, architectural flaws, infrastructure failures |
| **Process** | Testing gaps, unclear requirements, poor development methods |
| **Human** | Miscommunication, knowledge gaps, time pressure |

## Best Practices

- Involve people with direct knowledge of the system
- Document each step of analysis
- Remain open to unexpected causes
- Focus on systemic issues, not individual blame
- One bug may have multiple contributing causes
