#!/usr/bin/env bash
set -euo pipefail

# Audit expected pack files after sync.
# Usage:
#   ./scripts/audit-sync.sh --profile global --from-file ./repos-global.txt

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
MANIFEST="${ROOT_DIR}/pack-manifest.yaml"

profile="global"
repo_file=""
repos=()
scope="all"

print_usage() {
  echo "Usage: $0 --profile global|backend|frontend|full --from-file /abs/path/repos-<profile>.txt"
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --profile)
      profile="${2:-}"
      shift 2
      ;;
    --from-file)
      repo_file="${2:-}"
      shift 2
      ;;
    --rules-only)
      scope="rules"
      shift
      ;;
    *)
      repos+=("$1")
      shift
      ;;
  esac
done

if [[ "${profile}" != "global" && "${profile}" != "backend" && "${profile}" != "frontend" && "${profile}" != "full" ]]; then
  echo "[ERROR] Invalid profile: ${profile}"
  print_usage
  exit 1
fi

if [[ -z "${repo_file}" && "${#repos[@]}" -eq 0 ]]; then
  print_usage
  exit 1
fi

if [[ -n "${repo_file}" ]]; then
  if [[ ! -f "${repo_file}" ]]; then
    echo "[ERROR] Repo file not found: ${repo_file}"
    exit 1
  fi
  while IFS= read -r line || [[ -n "${line}" ]]; do
    trimmed="${line#"${line%%[![:space:]]*}"}"
    trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"
    if [[ -z "${trimmed}" || "${trimmed}" == \#* ]]; then
      continue
    fi
    repos+=("${trimmed}")
  done < "${repo_file}"
fi

if [[ "${#repos[@]}" -eq 0 ]]; then
  echo "[ERROR] No repositories provided."
  exit 1
fi

check_file() {
  local repo="$1"
  local rel="$2"
  if [[ ! -f "${repo}/${rel}" ]]; then
    echo "  [MISSING] ${rel}"
    return 1
  fi
  return 0
}

check_frontmatter_metadata() {
  local file="$1"
  python3 - "$file" <<'PY'
import sys
from pathlib import Path

p = Path(sys.argv[1])
text = p.read_text(encoding="utf-8")
lines = text.splitlines()

if not lines or lines[0].strip() != "---":
    # not frontmatter-based, skip metadata check
    raise SystemExit(0)

end_idx = None
for i in range(1, len(lines)):
    if lines[i].strip() == "---":
        end_idx = i
        break

if end_idx is None:
    print("[MISSING FRONTMATTER END]")
    raise SystemExit(1)

front = "\n".join(lines[1:end_idx])
required = ["sourcePackVersion:", "sourceOfTruth:", "managedBy:"]
missing = [k for k in required if k not in front]
if missing:
    for k in missing:
        print(f"[MISSING METADATA] {k}")
    raise SystemExit(1)
PY
}

if [[ ! -f "${MANIFEST}" ]]; then
  echo "[ERROR] Manifest not found: ${MANIFEST}"
  exit 1
fi

PARSER="${ROOT_DIR}/scripts/lib/manifest_parser.py"
if [[ ! -f "${PARSER}" ]]; then
  echo "[ERROR] Manifest parser not found: ${PARSER}"
  exit 1
fi

pair_args=(--manifest "${MANIFEST}" --mode sync_pairs --profile "${profile}")
if [[ "${scope}" != "rules" ]]; then
  pair_args+=(--include-commands --include-skills)
fi
expected_files_output="$(python3 "${PARSER}" "${pair_args[@]}" | awk -F'\t' '{print $2}' | sort -u)"
expected_files=()
while IFS= read -r line; do
  [[ -n "${line}" ]] && expected_files+=("${line}")
done <<< "${expected_files_output}"

failed=0
echo "Audit profile: ${profile}"
echo "Pack version: $(tr -d '\n' < "${ROOT_DIR}/VERSION")"
for repo in "${repos[@]}"; do
  if [[ ! -d "${repo}" ]]; then
    echo "[SKIP] ${repo} (not found)"
    continue
  fi
  echo "[CHECK] ${repo}"
  repo_failed=0
  for rel in "${expected_files[@]}"; do
    check_file "${repo}" "${rel}" || repo_failed=1
    full_path="${repo}/${rel}"
    if [[ -f "${full_path}" ]] && [[ "${full_path}" == *.md || "${full_path}" == *.mdc ]]; then
      if [[ "${rel}" == ".cursor/rules/project-overrides.mdc" ]]; then
        continue
      fi
      check_frontmatter_metadata "${full_path}" >/tmp/common-rules-audit-meta.txt 2>&1 || {
        while IFS= read -r mline; do
          [[ -n "${mline}" ]] && echo "  ${mline} in ${rel}"
        done < /tmp/common-rules-audit-meta.txt
        repo_failed=1
      }
    fi
  done

  if [[ "${repo_failed}" -eq 0 ]]; then
    echo "  [OK] pack files present"
  else
    failed=1
  fi
done

if [[ "${failed}" -ne 0 ]]; then
  echo "[FAIL] Audit found missing files."
  exit 1
fi

echo "[OK] Audit passed."
