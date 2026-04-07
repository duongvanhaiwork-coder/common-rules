---
name: shared-auto-commit-assistant
description: Stage relevant files, draft commit message, and optionally commit/push when explicitly authorized.
---

# Shared Auto Commit Assistant

## When To Use

- When you want the agent to prepare staging and commit message for quick approval.
- When you want optional auto-commit or auto-push with explicit permission.

## Relationship To Other Skills

- This skill complements (does not replace) `shared-git-workflow`.
- Use `shared-git-workflow` for broad git hygiene/review readiness.
- Use this skill when you specifically want staged output plus commit automation modes.
- Recommended order when combining: `shared-git-workflow` -> `shared-auto-commit-assistant`.

## Modes

1. `prepare-only` (default): stage scoped files and propose commit message, no commit/push.
2. `auto-commit`: stage + commit automatically after verification passes.
3. `auto-push`: stage + commit + push automatically after verification passes.

## Required Input

1. Target mode: `prepare-only` | `auto-commit` | `auto-push`.
2. Scope: files or directories to include/exclude.
3. Branch policy: current branch or target branch.

## Checklist

1. Inspect `git status`, `git diff`, and recent commit style.
2. Confirm exact staging scope and exclude unrelated changes.
3. Stage only approved files.
4. Draft concise commit message focused on intent and impact.
5. Run or confirm required verification state before commit.
6. If mode is `auto-commit` or `auto-push`, require explicit user authorization in prompt.
7. If mode is `auto-push`, push only after commit succeeds and branch is confirmed.

## Commit Message Quality Gate

- Message must match staged changes exactly (do not mention work not in commit).
- Message must include what changed and why it changed (not only generic verbs).
- Message should reflect primary scope (feature/fix/refactor/docs/chore) and impact.
- If multiple unrelated changes exist, split commits instead of one vague message.
- Block commit when message is ambiguous (for example: `update`, `fix stuff`, `misc`).

## Safety Rules

- Never use destructive git commands unless explicitly requested.
- Never stage secret files (`.env`, credentials, tokens, private keys).
- If verification is missing, block auto-commit and return `prepare-only` output.
- If scope is ambiguous, ask to confirm include/exclude paths first.

## Output Format

- Selected mode and scope
- Staged files
- Proposed commit message
- Verification status
- Action taken (`prepared` | `committed` | `pushed`) and next step
