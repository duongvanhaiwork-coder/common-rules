Run a final readiness checklist before merge/release.

Checklist:
- Scope is satisfied and acceptance criteria are met.
- Lint/tests/build checks passed, or exceptions documented.
- Breaking changes are identified and documented.
- Security basics checked (no secrets, sensitive logs, unsafe defaults).
- Deployment/rollback notes are prepared if behavior changed.

Return:
- Ready / Not Ready decision
- Blocking items (if any)
- Recommended next action
