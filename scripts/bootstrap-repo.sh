#!/usr/bin/env bash
set -euo pipefail

# Bootstrap a single repository with selected profile pack.
# Usage:
#   ./scripts/bootstrap-repo.sh /abs/path/repo --profile backend

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

repo=""
profile="global"

print_usage() {
  echo "Usage: $0 /abs/path/repo --profile global|backend|frontend|full [--dry-run] [--rules-only]"
}

if [[ "$#" -lt 1 ]]; then
  print_usage
  exit 1
fi

repo="$1"
shift

extra_args=()
rules_only=false
while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --profile)
      if [[ "$#" -lt 2 ]]; then
        print_usage
        exit 1
      fi
      profile="$2"
      shift 2
      ;;
    --dry-run)
      extra_args+=("--dry-run")
      shift
      ;;
    --rules-only)
      extra_args+=("--rules-only")
      rules_only=true
      shift
      ;;
    *)
      echo "[ERROR] Unknown argument: $1"
      print_usage
      exit 1
      ;;
  esac
done

if [[ ! -d "${repo}" ]]; then
  echo "[ERROR] Repository not found: ${repo}"
  exit 1
fi

if [[ "${profile}" != "global" && "${profile}" != "backend" && "${profile}" != "frontend" && "${profile}" != "full" ]]; then
  echo "[ERROR] Invalid profile: ${profile}"
  print_usage
  exit 1
fi

echo "[STEP] Sync pack into ${repo} (profile=${profile})"
"${SCRIPT_DIR}/sync-rules.sh" --profile "${profile}" "${extra_args[@]}" "${repo}"

if [[ " ${extra_args[*]} " == *" --dry-run "* ]]; then
  echo "[INFO] Dry run mode enabled, skipping audit."
  exit 0
fi

echo "[STEP] Audit synced files"
if [[ "${rules_only}" == "true" ]]; then
  "${SCRIPT_DIR}/audit-sync.sh" --rules-only --profile "${profile}" "${repo}"
else
  "${SCRIPT_DIR}/audit-sync.sh" --profile "${profile}" "${repo}"
fi

echo "[OK] Bootstrap completed for ${repo}"
