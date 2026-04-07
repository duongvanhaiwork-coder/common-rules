# Fire Drill Checklist

Run this once per month to verify the full pack lifecycle still works in practice.

## Scope

- Test profile: backend and frontend (or fullstack if used)
- Test branch: temporary maintenance branch

## Steps

1. Apply a tiny non-breaking change in docs or command wording.
2. Run local validation:
   - `./scripts/validate-pack.sh`
3. Run dry-run rollout for affected profiles.
4. Run real sync for affected profiles.
5. Run profile audits and verify all pass.
6. Bump `VERSION` and `pack-manifest.yaml`.
7. Update `CHANGELOG.md` with fire-drill release note.
8. Trigger release workflow manually.
9. Trigger post-release verify workflow manually.
10. Record outcome and action items.

## Success Criteria

- Validation passes.
- Sync and audit pass.
- Release workflow succeeds and creates tag/release.
- Post-release verify succeeds for tested profiles.

## Follow-up

- Capture any flaky step and root cause.
- Create follow-up tasks for pipeline hardening.
