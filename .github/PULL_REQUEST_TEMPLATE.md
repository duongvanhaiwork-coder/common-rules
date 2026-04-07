# Pull Request Checklist

## Summary

- What changed?
- Why is this change needed?

## Impact Scope

- [ ] Global pack (`.cursor/*`)
- [ ] Backend domain pack (`backend/.cursor/*`)
- [ ] Frontend domain pack (`frontend/.cursor/*`)
- [ ] Operational scripts/docs only

## Verification Checklist

- [ ] `./scripts/validate-pack.sh` passed
- [ ] Dry-run completed for affected profile(s)
- [ ] Real sync completed for affected profile(s)
- [ ] Audit completed for affected profile(s)

## Release Metadata

- [ ] `VERSION` updated
- [ ] `pack-manifest.yaml` version updated
- [ ] `CHANGELOG.md` updated

## Risks And Rollback

- Main risks:
- Rollback approach:

## Notes

- Related issue/ticket:
- Additional context:
