---
name: shared-security-baseline
description: Run baseline security checks for secrets, sensitive data, and input boundaries.
---

# Shared Security Baseline

## When To Use
- Any feature touching auth, data handling, API boundaries, or logs.
- Any change involving configuration, credentials, or external integrations.

## Checklist
1. Verify no secrets/tokens/credentials are hardcoded.
2. Verify sensitive data is not leaked through logs or error messages.
3. Verify external input is validated/sanitized at boundaries.
4. Verify principle of least privilege for data/integration access where applicable.
5. Verify security impact of behavior changes and document risks.
6. Flag required follow-up when security verification is partial.

## Output Format
- Security checks performed
- Findings and impact
- Mitigations applied
- Remaining security risk
