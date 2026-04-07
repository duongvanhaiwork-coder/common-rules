---
name: shared-verification-gate
description: Enforce evidence before completion claims with explicit verification status.
---

# Shared Verification Gate

## When To Use
- Before claiming a task is complete.
- Before commit, PR, or release-readiness decision.

## Checklist
1. Identify required checks for this task (lint/test/build/etc.).
2. Run available checks in relevant scope.
3. Capture pass/fail status and notable output.
4. If checks are skipped, state why and provide run instructions.
5. Block "done" claims when required evidence is missing.
6. Report remaining risk tied to missing verification.

## Output Format
- Required checks
- Executed checks and results
- Skipped checks with rationale
- Final gate decision (Pass/Blocked)
