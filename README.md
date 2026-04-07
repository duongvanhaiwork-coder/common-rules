# Common Rules

Shared Cursor rules for all projects live in:

- `.cursor/rules/base-core.mdc`
- `.cursor/rules/polyglot-conventions.mdc`
- `.cursor/rules/project-overrides-template.mdc`
- `.cursor/rules/base-operations.mdc`
- `.cursor/rules/base-change-governance.mdc`

Current shared pack version (see `VERSION`):

- `2.8.5`

## Update Flow

1. Edit shared rules in this repository.
2. Sync rules to target repositories.
3. Keep project-specific customization in each repo's `project-overrides.mdc`.

## Sync Script

Run from this repository:

```bash
chmod +x ./scripts/sync-rules.sh
./scripts/sync-rules.sh /abs/path/repoA /abs/path/repoB
```

Sync from file:

```bash
./scripts/sync-rules.sh --from-file ./repos-backend.txt
```

Default sync (rules + commands + skills):

```bash
./scripts/sync-rules.sh --from-file ./repos-backend.txt
```

Rules-only sync:

```bash
./scripts/sync-rules.sh --rules-only --from-file ./repos-backend.txt
```

Sync by profile:

```bash
./scripts/sync-rules.sh --profile backend --from-file ./repos-backend.txt
./scripts/sync-rules.sh --profile frontend --from-file ./repos-frontend.txt
./scripts/sync-rules.sh --profile full --from-file ./repos-fullstack.txt
```

Profile wrappers (recommended):

```bash
./scripts/sync-backend.sh
./scripts/sync-frontend.sh
./scripts/sync-fullstack.sh
```

Example:

```bash
./scripts/sync-rules.sh \
  /frontend
```

Example `repos-backend.txt`:

```text
# one absolute path per line
/backend
```

## Notes

- Shared rules, commands, and skills are overwritten when corresponding sync options are used.
- Existing `project-overrides.mdc` files are preserved.
- If a repo does not exist, it is skipped.
- See `compatibility-matrix.md` for recommended profile per repo type.
- Use profile-specific repo lists: `repos-backend.txt`, `repos-frontend.txt`, `repos-fullstack.txt`.
- Synced files with frontmatter include `sourcePackVersion` to track source version.
- `sourceOfTruth` defaults to `common-rules` (portable); override with `SOURCE_OF_TRUTH` env var when needed.

## Validation

```bash
chmod +x ./scripts/validate-pack.sh
./scripts/validate-pack.sh
```

Validation now includes manifest consistency checks:

- `VERSION` must match `pack-manifest.yaml`.
- All manifest entries must exist on disk.
- Audit expectations are derived from `pack-manifest.yaml`.

## CI Validation

- Workflow: `.github/workflows/pack-validation.yml`
- Runs `./scripts/validate-pack.sh` on push/PR to keep pack integrity stable.
- Workflow: `.github/workflows/security-scan.yml`
  - Runs gitleaks on push/PR/manual trigger to detect potential secret exposure.

## Release Automation

- Workflow: `.github/workflows/release-pack.yml`
- Trigger manually via GitHub Actions (`workflow_dispatch`).
- Behavior:
  - Runs pack validation.
  - Reads `VERSION` and creates tag `pack-v<version>`.
  - Extracts release notes from `CHANGELOG.md` section `## <VERSION>`.
  - Publishes a GitHub Release with that tag and extracted notes.

## Post Release Verification

- Checklist: `post-release-checklist.md`
- Workflow: `.github/workflows/post-release-verify.yml`
- Trigger manually and provide:
  - `profile`: backend/frontend/full
  - `repo_list_file`: one of `repos-backend.txt`, `repos-frontend.txt`, `repos-fullstack.txt`

## Monthly Fire Drill

- Checklist: `fire-drill-checklist.md`
- Recommended cadence: monthly
- Goal: verify the full lifecycle (validate -> sync -> audit -> release -> post-release verify).

## Baseline Certification

- Checklist: `baseline-certification-checklist.md`
- Use once to certify end-to-end readiness on real backend/frontend repos.
- Add `Baseline certified` note in `CHANGELOG.md` when completed.

## Team Governance

- `/.github/CODEOWNERS` enforces ownership boundaries by pack area.
- `/.github/PULL_REQUEST_TEMPLATE.md` standardizes verification and release metadata in PRs.

## Bootstrap New Repo

```bash
chmod +x ./scripts/bootstrap-repo.sh
./scripts/bootstrap-repo.sh /abs/path/repo --profile backend
```

Use `--dry-run` to preview actions before writing files.
Use `--rules-only` if you want rules-only sync/audit bootstrap mode.

## Governance And Release Process

- Ownership:
  - Global pack owner maintains `.cursor/*` under root.
  - Domain owners maintain `backend/.cursor/*` and `frontend/.cursor/*`.
- Source of truth:
  - `pack-manifest.yaml` defines expected files by profile.
  - `VERSION` is the canonical pack version.
- Versioning policy:
  - Patch (`x.y.Z`): docs/script fix, no pack-structure change.
  - Minor (`x.Y.z`): new compatible rules/commands/skills or new optional scripts.
  - Major (`X.y.z`): breaking pack layout/profile behavior or migration-required changes.
- Release flow:
  1. Update rule/command/skill content.
  2. Run `./scripts/validate-pack.sh`.
  3. Bump `VERSION` and add entry to `CHANGELOG.md`.
  4. Run dry run sync:
     - `./scripts/sync-rules.sh --dry-run --profile <profile> --from-file ./repos-<profile>.txt`
  5. Run real sync and then audit:
     - `./scripts/sync-rules.sh --profile <profile> --from-file ./repos-<profile>.txt`
     - `./scripts/audit-sync.sh --profile <profile> --from-file ./repos-<profile>.txt`

## Team Playbook

- See `PLAYBOOK.md` for the day-to-day workflow (change -> validate -> dry-run -> rollout -> audit -> release).
- See `GETTING-STARTED.md` for role-based quick-start commands.

## Quick Mapping: Task -> Command -> Skill

| Task Type | Recommended Command | Recommended Skill Flow |
| --- | --- | --- |
| Multi-file feature/refactor | `plan-task.md` -> `implement-task.md` | `shared-planning-execution` -> `shared-code-quality` -> `shared-verification-gate` |
| Bug/failure investigation | `implement-task.md` | `shared-systematic-debugging` -> `shared-code-quality` -> `shared-verification-gate` |
| Pre-merge review | `review-changes.md` | `shared-code-quality` -> `shared-security-baseline` |
| Release readiness | `ship-checklist.md` | `shared-verification-gate` -> `shared-communication-handoff` |
| Operational safety check | `ops-readiness-check.md` | `shared-operational-readiness` |
| Dependency/config update | `implement-task.md` | `shared-dependency-config-hygiene` -> `shared-security-baseline` -> `shared-verification-gate` |
| Backend contract/migration change | `backend-implement-api.md` | `backend-contract-migration-safety` -> `backend-reliability-observability` |
| Frontend state/UX change | `frontend-implement-ui.md` | `frontend-state-ux-resilience` -> `frontend-accessibility-performance` |

## How To Use Commands And Skills In Practice

Use this order in a normal working session:

1. Pick one command based on task type.
2. Run 1-3 matching skills from the mapping table.
3. Execute work and follow each skill checklist/output format.
4. Close with verification (`shared-verification-gate`) before saying "done".

Quick examples:

- New API feature:
  - Command: `backend-implement-api.md`
  - Skills: `shared-planning-execution` -> `backend-contract-migration-safety` -> `shared-verification-gate`
- UI bug in loading/error state:
  - Command: `frontend-implement-ui.md`
  - Skills: `shared-systematic-debugging` -> `frontend-state-ux-resilience` -> `shared-verification-gate`
- Pre-merge quality check:
  - Command: `review-changes.md`
  - Skills: `shared-code-quality` -> `shared-security-baseline`

Rules for combining them:

- Rules define guardrails (what must/must-not happen).
- Commands define entry workflow (what to do for this task type).
- Skills define execution depth (how to do it with checklist evidence).
- If guidance conflicts, follow project override rules first, then shared rules.

## Prompt Templates For Command And Skill

Use these prompts so the agent can detect intended command/skill clearly.

Command only:

```text
Use command <command-name> for this task.
```

Skill only:

```text
Use skill <skill-name> for this task.
```

Command + skill:

```text
Use command <command-name> and skill <skill-name> for this task.
If guidance conflicts, prioritize project-overrides.
```

Examples:

```text
Use command implement-task and skill shared-verification-gate for this task.
```

```text
Use command backend-implement-api and skill backend-contract-migration-safety for this task.
Do not commit or push unless I explicitly ask.
```

Auto commit assistant (new):

```text
Use skill shared-auto-commit-assistant in prepare-only mode.
Stage only relevant files and draft commit message; do not commit or push.
```

```text
Use skill shared-auto-commit-assistant in auto-commit mode.
If verification passes, automatically add relevant files and commit. Do not push.
```

```text
Use skill shared-auto-commit-assistant in auto-push mode.
If verification passes, automatically add, commit, and push on current branch.
```

## Known Pitfalls

- Using the wrong profile list file (for example backend profile with frontend list).
- Running audit before running real sync (dry-run does not write files).
- Running `--rules-only` sync, then full audit (includes commands/skills by default).
- Forgetting to bump both `VERSION` and `pack-manifest.yaml` version together.
- Mixing backend and frontend repos in one shared list file.
- Updating manifest without updating audit expectations.
