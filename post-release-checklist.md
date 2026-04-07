# Post Release Checklist

Use this checklist right after publishing a pack release.

## Scope

- Release tag: `pack-v<version>`
- Target profiles: backend, frontend, full (as applicable)

## Verification Steps

- [ ] Confirm release tag exists in repository.
- [ ] Confirm release notes match `CHANGELOG.md` version section.
- [ ] Re-run local pack validation:
  - `./scripts/validate-pack.sh`
- [ ] Re-run profile audits on target lists:
  - `./scripts/audit-sync.sh --profile backend --from-file ./repos-backend.txt`
  - `./scripts/audit-sync.sh --profile frontend --from-file ./repos-frontend.txt`
  - `./scripts/audit-sync.sh --profile full --from-file ./repos-fullstack.txt` (if used)
- [ ] Confirm no unexpected missing files in audited repositories.
- [ ] Confirm `VERSION`, `pack-manifest.yaml`, and release tag are consistent.

## Follow-up

- [ ] Record any rollout issues and mitigation actions.
- [ ] Open follow-up task for gaps found during post-release verification.
