---
name: shared-operational-readiness
description: Validate operational readiness before merge or release for reliability and rollback safety.
---

# Shared Operational Readiness

## When To Use
- Before merge/release for behavior-impacting changes.
- For tasks touching runtime reliability, deployment, or observability.

## Checklist
1. Confirm timeout/retry behavior is explicit and bounded.
2. Confirm logs/metrics cover critical success and failure paths.
3. Confirm health/readiness signals are available or documented.
4. Confirm rollback path exists and is realistic.
5. Confirm feature flags/toggles default safely when used.
6. Record operational risks and post-release watchpoints.

## Output Format
- Reliability checks
- Observability checks
- Rollback readiness
- Operational risks
- Go/No-Go suggestion
