---
name: shared-code-quality
description: Review changes with a quality-first checklist covering logic, maintainability, security, and tests.
---

# Shared Code Quality

## When To Use
- Before marking implementation complete.
- Before commit, merge, or handoff.
- When asked to review code quality explicitly.

## Checklist
1. Validate logic correctness and edge-case handling.
2. Check maintainability (readability, complexity, coupling).
3. Check security and sensitive-data handling.
4. Check performance impact on critical paths.
5. Confirm test coverage for changed behavior.
6. Identify regressions and missing verification.

## Output Format
- Findings by severity (Critical, High, Medium, Low)
- Impact and suggested fix per finding
- Missing tests or verification gaps
- Residual risks
