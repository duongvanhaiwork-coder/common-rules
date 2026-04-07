# Compatibility Matrix

Use this matrix to choose which pack profile to sync for each repository type.

| Repo Type                | Sync Profile | Include Commands | Include Skills                    |
| ------------------------ | ------------ | ---------------- | --------------------------------- |
| Backend-only             | `backend`    | Yes              | Yes (global + backend domain)     |
| Frontend-only            | `frontend`   | Yes              | Yes (global + frontend domain)    |
| Fullstack monorepo       | `full`       | Yes              | Yes (global + both domains)       |
| Generic/shared utilities | `global`     | Optional         | Optional                          |

## Recommended Commands

- Backend repo:
  - `./scripts/sync-rules.sh --profile backend --from-file ./repos-backend.txt`
- Frontend repo:
  - `./scripts/sync-rules.sh --profile frontend --from-file ./repos-frontend.txt`
- Fullstack repo:
  - `./scripts/sync-rules.sh --profile full --from-file ./repos-fullstack.txt`

## Repo List Policy

- Keep one repo-list file per profile to avoid accidental cross-profile sync.
- Do not mix backend and frontend repos in the same list file.
