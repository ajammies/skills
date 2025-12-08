# Zod Schema Patterns for generateObject

## Table of Contents
- [Core Rules](#core-rules)
- [Using .describe()](#using-describe)
- [Optional vs Nullable](#optional-vs-nullable)
- [Enums](#enums)
- [Arrays](#arrays)
- [Nested Objects](#nested-objects)
- [Common Pitfalls](#common-pitfalls)

## Core Rules

1. **Top-level must be object** - Not array or primitive
2. **Schema = contract** - Define schema before prompt
3. **Every ambiguous field needs `.describe()`**

## Using .describe()

`.describe()` is a mini-prompt guiding the model on what to generate.

```typescript
// Bad - ambiguous field names
z.object({
  layout: z.enum(['grid', 'list']),
  composition: z.enum(['centered', 'thirds']),
});

// Good - clear guidance
z.object({
  layout: z.enum(['grid', 'list'])
    .describe('Page structure: how content blocks are arranged'),
  composition: z.enum(['centered', 'thirds'])
    .describe('Visual composition: where subjects are placed in frame'),
});
```

**When to use `.describe()`:**
- Ambigous field names
- Similar field names (layout vs composition, size vs scale)
- Non-obvious enum values
- Fields with specific format requirements
- Domain-specific terminology

## Optional vs Nullable

**Prefer `.nullable()` over `.optional()`** for LLM reliability.

```typescript
// Bad - model may omit field entirely
z.object({
  moral: z.string().optional(),
});

// Good - model explicitly decides null or value
z.object({
  moral: z.string().nullable()
    .describe('Story moral if applicable, null if none'),
});
```

**Why:** `.nullable()` forces the model to consciously decide. `.optional()` may be ignored. Some providers (OpenAI structured output) don't support `.optional()` or `.nullish()`.

## Enums

Enums need descriptive values or `.describe()`.

```typescript
// Bad - model may confuse purposes
z.enum(['setup', 'conflict', 'resolution'])

// Good - clear purpose labels
const PlotBeatPurposeSchema = z.enum([
  'setup',
  'conflict',
  'rising_action',
  'climax',
  'resolution',
]).describe('Narrative function: setup introduces, conflict establishes problem, rising_action builds tension, climax is turning point, resolution concludes');

// Alternative - descriptive enum values
z.enum([
  'extreme_wide_establishing_shot',
  'wide_full_body',
  'medium_waist_up',
  'close_up_face',
  'extreme_close_up_detail',
]);
```

## Arrays

```typescript
// Define item schema separately for reuse
const CharacterSchema = z.object({
  name: z.string().min(1),
  description: z.string().min(1),
});

// Array with constraints
z.array(CharacterSchema)
  .min(1).describe('At least one character required')
  .max(6).describe('Maximum 6 characters for clarity');

// Array with specific count guidance
z.array(PlotBeatSchema)
  .min(4).max(6)
  .describe('4-6 structural beats covering setup through resolution');
```

## Nested Objects

Keep nesting shallow. Flatten when possible.

```typescript
// Acceptable - logical grouping
z.object({
  ageRange: z.object({
    min: z.number().int().min(2).max(12),
    max: z.number().int().min(2).max(12),
  }),
});

// Bad - deep nesting
z.object({
  story: z.object({
    metadata: z.object({
      details: z.object({
        title: z.string(),
      }),
    }),
  }),
});

// Better - flattened
z.object({
  storyTitle: z.string(),
});
```

## Common Pitfalls

### 1. Stringified Arrays
Model returns `"[\"a\", \"b\"]"` instead of `["a", "b"]`.

**Fix:** Add `.describe('Array of strings, not JSON string')` or ensure schema is clear.

### 2. Wrong Enum Value
Model puts value from field A into field B.

**Fix:** Add `.describe()` to both fields clarifying their distinct purposes.

### 3. Empty Strings
Model returns `""` instead of meaningful content.

**Fix:** Use `.min(1)` and add `.describe()` with examples.

### 4. Type Coercion
Model returns `"5"` instead of `5`.

**Fix:** Use explicit types, consider `z.coerce.number()` if needed.

### 5. Missing Required Fields
Model omits fields entirely.

**Fix:** Check if field is truly required. If optional, use `.nullable()` not `.optional()`.

## Validation Pattern

Add refinements for complex validation:

```typescript
const AgeRangeSchema = z.object({
  min: z.number().int().min(2).max(12),
  max: z.number().int().min(2).max(12),
}).refine(
  (data) => data.min <= data.max,
  { message: 'ageRange.min must be <= ageRange.max' }
);
```
