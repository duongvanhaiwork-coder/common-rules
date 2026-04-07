---
name: backend-contract-migration-safety
description: Ensure backend contract and migration changes are safe, explicit, and reversible.
---

# Backend Contract And Migration Safety

## When To Use
- API/schema/event contract updates.
- Database migration or persistence model changes.

## Checklist
1. Identify contract changes and default compatibility impact.
2. Mark breaking changes and provide migration notes.
3. Validate transition path for schema/data evolution.
4. Check rollback feasibility for migration steps.
5. Add/update tests for contract and migration behavior.
6. Document operational risk and rollout guardrails.

## Output Format
- Contract impact
- Migration/rollback plan
- Verification status
- Residual risk
