.PHONY: validate dry-backend dry-frontend dry-full sync-backend sync-frontend sync-full audit-backend audit-frontend audit-full bootstrap-backend

validate:
	./scripts/validate-pack.sh

dry-backend:
	./scripts/sync-rules.sh --dry-run --profile backend --from-file ./repos-backend.txt

dry-frontend:
	./scripts/sync-rules.sh --dry-run --profile frontend --from-file ./repos-frontend.txt

dry-full:
	./scripts/sync-rules.sh --dry-run --profile full --from-file ./repos-fullstack.txt

sync-backend:
	./scripts/sync-backend.sh

sync-frontend:
	./scripts/sync-frontend.sh

sync-full:
	./scripts/sync-fullstack.sh

audit-backend:
	./scripts/audit-sync.sh --profile backend --from-file ./repos-backend.txt

audit-frontend:
	./scripts/audit-sync.sh --profile frontend --from-file ./repos-frontend.txt

audit-full:
	./scripts/audit-sync.sh --profile full --from-file ./repos-fullstack.txt

bootstrap-backend:
	./scripts/bootstrap-repo.sh /backend --profile backend --dry-run
