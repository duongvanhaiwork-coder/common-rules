# Changelog

## 2.9.0

- Added new shared skill `shared-auto-commit-assistant` with `prepare-only`, `auto-commit`, and `auto-push` modes.
- Updated skill index and README prompt templates for authorized auto add/commit/push workflow.

## 2.8.5

- Fixed `project-overrides-template.mdc` to `alwaysApply: true` so project override guidance is active by default after bootstrap/sync.
- Updated `README.md` pack version display to match `VERSION` and `pack-manifest.yaml`.

## 2.8.4

- Clarified `sync-rules.sh` help text that commands/skills are included by default.
- Kept `--with-all` for backward compatibility but marked it deprecated with runtime warning.

## 2.8.3

- Aligned docs/checklists with current sync defaults by removing redundant `--with-all` examples.
- Updated `GETTING-STARTED.md`, `PLAYBOOK.md`, `compatibility-matrix.md`, and baseline checklist command examples.

## 2.8.2

- Made `sourceOfTruth` metadata portable by default (`common-rules`) instead of local absolute path.
- Added support for `SOURCE_OF_TRUTH` environment variable override in sync script.

## 2.8.1

- Cleaned CLI UX by removing redundant `--with-all` from wrappers, Makefile shortcuts, and bootstrap flow.
- Updated sync usage examples to profile-specific repo lists.
- Kept behavior unchanged (full-pack sync remains the default).

## 2.8.0

- Added source version stamping during sync for frontmatter-based files.
- Synced files now carry `sourcePackVersion` to reduce drift from manual edits in consumer repos.

## 2.7.0

- Changed `sync-rules.sh` default behavior to sync full pack (rules + commands + skills).
- Added `--rules-only` mode in `sync-rules.sh` and `audit-sync.sh`.
- Added profile/file guardrails in `sync-rules.sh` for `repos-*.txt` usage.
- Refactored `audit-sync.sh` to derive expected files from `pack-manifest.yaml` via shared parser.
- Updated README to reflect new sync/audit defaults and rules-only mode.

## 2.6.0

- Refactored `scripts/audit-sync.sh` to derive expected files directly from `pack-manifest.yaml` (removed hardcoded file lists).
- Added shared manifest parser utility: `scripts/lib/manifest_parser.py`.
- Refactored `scripts/validate-pack.sh` to validate source files from manifest parser output.
- Reduced duplicate flow logic to improve consistency between manifest, validation, and audit.

## 2.5.0

- Added `baseline-certification-checklist.md` for one-time end-to-end production readiness certification.
- Updated README with baseline certification guidance.

## 2.4.0

- Added `.github/workflows/security-scan.yml` (gitleaks) for secret scanning.
- Added `fire-drill-checklist.md` for monthly end-to-end operational verification.
- Updated README with security scan and fire-drill sections.

## 2.3.0

- Added `post-release-checklist.md` for post-release verification discipline.
- Added `.github/workflows/post-release-verify.yml` manual workflow.
- Updated README with post-release verification section.

## 2.2.0

- Improved release workflow to extract release notes from `CHANGELOG.md` section `## <VERSION>`.
- Release now fails if matching changelog section is missing or empty.
- Updated README release automation notes.

## 2.1.0

- Added `.github/workflows/release-pack.yml` for manual pack release automation.
- Release workflow validates pack, creates `pack-v<version>` tag, and publishes a GitHub Release.
- Updated README with release automation usage notes.

## 2.0.0

- Added team governance artifacts:
  - `.github/CODEOWNERS`
  - `.github/PULL_REQUEST_TEMPLATE.md`
- Updated README with governance section.
- This release introduces mandatory ownership/review workflow (process-level breaking change).

## 1.9.0

- Added `GETTING-STARTED.md` with role-based quick-start flows.
- Added `Makefile` with common validation/sync/audit aliases.
- Added `Known Pitfalls` and quick-start references to `README.md`.

## 1.8.0

- Added `scripts/check-manifest-consistency.sh` to enforce:
  - `VERSION` equals `pack-manifest.yaml` version.
  - Manifest-listed files exist.
  - Manifest-listed files are covered by audit script references.
- Integrated manifest consistency check into `scripts/validate-pack.sh`.

## 1.7.0

- Added `scripts/bootstrap-repo.sh` for one-command repo onboarding (sync + audit).
- Added `PLAYBOOK.md` with daily operating workflow for team usage.
- Updated root README with bootstrap and playbook sections.

## 1.6.0

- Added CI workflow `.github/workflows/pack-validation.yml` to run pack validation on push/PR.
- Added profile wrapper scripts:
  - `scripts/sync-backend.sh`
  - `scripts/sync-frontend.sh`
  - `scripts/sync-fullstack.sh`
- Clarified release governance and versioning policy in root README.
- Synced version markers across `VERSION` and `pack-manifest.yaml`.

## 1.5.0

- Added backend domain skills:
  - `backend-contract-migration-safety`
  - `backend-reliability-observability`
- Added frontend domain skills:
  - `frontend-state-ux-resilience`
  - `frontend-accessibility-performance`
- Extended `pack-manifest.yaml` with backend/frontend `skills` sections.
- Extended `scripts/audit-sync.sh` to validate domain skills.

## 1.4.0

- Added `pack-manifest.yaml` as pack source-of-truth listing required files per profile.
- Added `--dry-run` option to `scripts/sync-rules.sh`.
- Added `scripts/audit-sync.sh` to verify synced repositories by profile.
- Added governance/release guidance updates in root README.

## 1.3.0

- Added sync profile support in `scripts/sync-rules.sh`:
  - `--profile global|backend|frontend|full`
- Added compatibility matrix document for pack selection per repo type.
- Added `scripts/validate-pack.sh` for local integrity checks.
- Added `VERSION` file as single source of truth for pack version.

## 1.2.0

- Added base governance and operations shared rules.
- Added ops readiness command.
- Added dependency/config hygiene and operational readiness skills.
- Expanded sync to support optional commands and skills.
