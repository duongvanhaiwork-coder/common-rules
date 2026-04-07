Run a backend final readiness check before merge/release.

Checklist:
- API/schema changes are backward compatible or explicitly documented as breaking.
- Authn/authz and input validation exist at boundary points.
- No secrets/sensitive data are exposed in code or logs.
- Error handling and observability are sufficient for critical paths.
- Tests/lint/build passed, or exceptions are documented with follow-up actions.

Return:
- Ready / Not Ready
- Blocking issues
- Recommended next steps
