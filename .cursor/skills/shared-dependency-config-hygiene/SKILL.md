---
name: shared-dependency-config-hygiene
description: Enforce dependency and configuration hygiene with clear impact tracking.
---

# Shared Dependency And Config Hygiene

## When To Use
- Any task adding/updating dependencies.
- Any task changing configuration or environment behavior.

## Checklist
1. Justify dependency additions and evaluate existing alternatives.
2. Scope dependency upgrades and note compatibility impact.
3. Ensure secrets and environment-specific values are not hardcoded.
4. Verify safe defaults and required config for production paths.
5. Validate startup/config checks for critical settings where possible.
6. Document impact and rollback plan for dependency/config changes.

## Output Format
- Dependency changes and rationale
- Config changes and environment impact
- Compatibility/security notes
- Rollback and follow-up actions
