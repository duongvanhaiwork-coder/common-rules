---
name: backend-reliability-observability
description: Validate backend reliability behavior and observability coverage before release.
---

# Backend Reliability And Observability

## When To Use
- External I/O changes, retry/timeout logic updates, or production-impacting behavior.
- Release readiness checks for backend services/workers.

## Checklist
1. Verify timeout and retry policies are explicit and bounded.
2. Verify idempotency where retries or async jobs are involved.
3. Verify critical paths emit useful logs and metrics.
4. Verify error handling exposes actionable operational context.
5. Verify health/readiness behavior for deployable services.
6. Document watchpoints and rollback strategy for release.

## Output Format
- Reliability checks
- Observability checks
- Release risk
- Go/No-Go suggestion
