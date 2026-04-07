# Getting Started

Quick start guide for maintainers.

## 1) Validate Pack

```bash
./scripts/validate-pack.sh
```

## 2) Backend Maintainer Flow

```bash
./scripts/sync-rules.sh --dry-run --profile backend --from-file ./repos-backend.txt
./scripts/sync-backend.sh
./scripts/audit-sync.sh --profile backend --from-file ./repos-backend.txt
```

## 3) Frontend Maintainer Flow

```bash
./scripts/sync-rules.sh --dry-run --profile frontend --from-file ./repos-frontend.txt
./scripts/sync-frontend.sh
./scripts/audit-sync.sh --profile frontend --from-file ./repos-frontend.txt
```

## 4) Fullstack Maintainer Flow

```bash
./scripts/sync-rules.sh --dry-run --profile full --from-file ./repos-fullstack.txt
./scripts/sync-fullstack.sh
./scripts/audit-sync.sh --profile full --from-file ./repos-fullstack.txt
```

## 5) Release Steps

1. Update content.
2. Run validation.
3. Bump `VERSION` and `pack-manifest.yaml`.
4. Update `CHANGELOG.md`.
