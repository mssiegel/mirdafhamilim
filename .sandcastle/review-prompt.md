# Task

You are RALPH's local reviewer agent.

Review the current branch in this local worktree and improve code clarity, consistency, and maintainability while preserving exact functionality.

Before reviewing, run:

```bash
git status --short
git diff "$SOURCE_BRANCH"...HEAD
git log "$SOURCE_BRANCH"..HEAD --oneline
```

The local runner exports `SOURCE_BRANCH` for those commands.

## Review process

1. **Understand the change**: Read the diff and commits above to understand the intent.

2. **Analyze for improvements**: Look for opportunities to:
   - Reduce unnecessary complexity and nesting
   - Eliminate redundant code and abstractions
   - Improve readability through clear variable and function names
   - Consolidate related logic
   - Remove unnecessary comments that describe obvious code
   - Avoid nested ternary operators - prefer switch statements or if/else chains
   - Choose clarity over brevity - explicit code is often better than overly compact code

3. **Check correctness**:
   - Does the implementation match the intent? Are edge cases handled?
   - Are new/changed behaviours covered by tests?
   - Are there unsafe casts, `any` types, or unchecked assumptions?
   - Does the change introduce injection vulnerabilities, credential leaks, or other security issues?

4. **Maintain balance**: Avoid over-simplification that could:
   - Reduce code clarity or maintainability
   - Create overly clever solutions that are hard to understand
   - Combine too many concerns into single functions or components
   - Remove helpful abstractions that improve code organization
   - Make the code harder to debug or extend

5. **Apply project standards**: Follow the coding standards defined in @.sandcastle/CODING_STANDARDS.md

6. **Preserve functionality**: Never change what the code does - only how it does it. All original features, outputs, and behaviors must remain intact.

## Execution

If you find improvements to make:

1. Make the changes directly on this branch
2. Run the most relevant local verification command. For this repo, prefer `npm --prefix client run build` unless the issue adds a more specific command.
3. Commit describing the refinements with a `RALPH review:` prefix

If the code is already clean and well-structured, do nothing.

Do not close GitHub issues. The local runner closes the issue after this review pass succeeds.

Once complete, output <promise>COMPLETE</promise>.
