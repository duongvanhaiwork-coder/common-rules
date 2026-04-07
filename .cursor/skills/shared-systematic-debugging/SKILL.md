---
name: shared-systematic-debugging
description: Debug issues using evidence-driven steps from reproduction to verified fix.
---

# Shared Systematic Debugging

## When To Use
- Any bug, test failure, flaky behavior, or unexpected output.
- Any issue where root cause is not yet confirmed.

## Checklist
1. Reproduce the issue with clear steps and environment details.
2. Isolate the failing layer/component and narrow scope.
3. Form one or more testable root-cause hypotheses.
4. Gather evidence to validate or reject each hypothesis.
5. Apply the smallest fix that addresses confirmed root cause.
6. Verify fix and run targeted regression checks.
7. Document root cause, fix rationale, and residual risk.

## Output Format
- Reproduction details
- Root cause
- Fix applied
- Verification evidence
- Regression status and next action
