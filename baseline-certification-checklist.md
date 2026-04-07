# Baseline Certification Checklist

Use this once to certify the pack is production-ready end-to-end.

## Target Repositories

- Backend sample repo: ______________________
- Frontend sample repo: _____________________

## End-to-End Certification Steps

- [ ] Step 1: Apply a tiny non-breaking change in this pack repository.
- [ ] Step 2: Run local validation.
  - [ ] `./scripts/validate-pack.sh`
- [ ] Step 3: Run backend rollout and audit.
  - [ ] `./scripts/sync-rules.sh --profile backend --from-file ./repos-backend.txt`
  - [ ] `./scripts/audit-sync.sh --profile backend --from-file ./repos-backend.txt`
- [ ] Step 4: Run frontend rollout and audit.
  - [ ] `./scripts/sync-rules.sh --profile frontend --from-file ./repos-frontend.txt`
  - [ ] `./scripts/audit-sync.sh --profile frontend --from-file ./repos-frontend.txt`
- [ ] Step 5: Trigger pack release workflow (`Release Pack`).
- [ ] Step 6: Trigger post-release verify workflow (`Post Release Verify`).
- [ ] Step 7: Confirm release tag, release notes, and verification artifact exist.
- [ ] Step 8: Record result in `CHANGELOG.md` with note `Baseline certified`.

## Exit Criteria

- [ ] All steps above are green without manual workaround.
- [ ] No unexpected missing files in audit output.
- [ ] Version, manifest, release tag, and changelog are consistent.

## Certification Record

- Certified by: ______________________
- Date: ______________________
- Release version: ______________________
