---
name: frontend-state-ux-resilience
description: Validate frontend state behavior and UX resilience for async and failure-prone flows.
---

# Frontend State And UX Resilience

## When To Use
- Changes affecting state transitions, async flows, or user interaction logic.
- Features with loading/error/empty states.

## Checklist
1. Verify state transitions are explicit and predictable.
2. Verify loading, empty, success, and error states are handled.
3. Verify duplicate actions are prevented for long-running requests.
4. Verify fallback UI behavior during partial failures.
5. Add/update tests for critical state and UX paths.
6. Document user-facing behavior changes and risks.

## Output Format
- State/UX impact
- Resilience checks
- Verification status
- Remaining risk
