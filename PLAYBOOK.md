# Common Rules Playbook

Daily operating guide for maintaining and rolling out this pack.

## 1) Before You Change Anything

- Pull latest `main/master`.
- Check current pack version in `VERSION`.
- Confirm target scope: global, backend, frontend, or full.

## 2) Make Changes

- Update files in one or more of:
  - `.cursor/rules`
  - `.cursor/commands`
  - `.cursor/skills`
  - `backend/.cursor/*`
  - `frontend/.cursor/*`

## 3) Validate Locally

```bash
./scripts/validate-pack.sh
```

## 4) Dry-Run Rollout

```bash
./scripts/sync-rules.sh --dry-run --profile backend --from-file ./repos-backend.txt
./scripts/sync-rules.sh --dry-run --profile frontend --from-file ./repos-frontend.txt
```

## 5) Real Rollout

```bash
./scripts/sync-backend.sh
./scripts/sync-frontend.sh
```

## 6) Audit After Rollout

```bash
./scripts/audit-sync.sh --profile backend --from-file ./repos-backend.txt
./scripts/audit-sync.sh --profile frontend --from-file ./repos-frontend.txt
```

## 7) Release The Pack

- Update `CHANGELOG.md` with what changed and why.
- Bump `VERSION` and `pack-manifest.yaml` version together.
- Ensure CI (`pack-validation`) is green.

## 8) Bootstrap New Repository

```bash
./scripts/bootstrap-repo.sh /abs/path/new-repo --profile backend
```
