# Ops Readiness Check

Run an operational readiness check before merge/release.

Checklist:
- Timeout/retry behavior is explicit for critical external calls.
- Health/readiness checks are implemented or documented.
- Logs/metrics are sufficient for critical failure diagnosis.
- Rollback and fallback steps are defined for behavior-impacting changes.
- Config and dependency changes include risk and compatibility notes.

Return:
- Ready / Not Ready
- Blocking operational gaps
- Recommended release guardrails
