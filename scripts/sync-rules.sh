#!/usr/bin/env bash
set -euo pipefail

# Sync shared Cursor pack into target repositories.
# Usage:
#   ./scripts/sync-rules.sh /abs/path/repo1 /abs/path/repo2
#   ./scripts/sync-rules.sh --from-file ./repos-backend.txt
#   ./scripts/sync-rules.sh --rules-only --from-file ./repos-backend.txt
#   ./scripts/sync-rules.sh --profile backend --from-file ./repos-backend.txt
#   ./scripts/sync-rules.sh --dry-run --profile full --from-file ./repos-fullstack.txt

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
MANIFEST="${ROOT_DIR}/pack-manifest.yaml"
PARSER="${SCRIPT_DIR}/lib/manifest_parser.py"
PACK_VERSION="$(tr -d '\n' < "${ROOT_DIR}/VERSION")"
SOURCE_OF_TRUTH="${SOURCE_OF_TRUTH:-common-rules}"
MANAGED_BY="sync-rules.sh"

print_usage() {
  echo "Usage: $0 /abs/path/repo1 [/abs/path/repo2 ...]"
  echo "   or: $0 --from-file /abs/path/repos-<profile>.txt"
  echo "Options:"
  echo "  --rules-only       Sync only .cursor/rules"
  echo "  --with-commands    Include .cursor/commands (default: included)"
  echo "  --with-skills      Include .cursor/skills (default: included)"
  echo "  --with-all         Deprecated alias (full pack is default)"
  echo "  --profile <name>   global|backend|frontend|full (default: global)"
  echo "  --dry-run          Print actions without writing files"
}

if [[ "$#" -eq 0 ]]; then
  print_usage
  exit 1
fi

repos=()
sync_commands=true
sync_skills=true
repo_file=""
profile="global"
dry_run=false

copy_file() {
  local src="$1"
  local dst="$2"
  if [[ "${dry_run}" == "true" ]]; then
    echo "[DRY-RUN] copy ${src} -> ${dst}"
  else
    if [[ "${src}" == *.md || "${src}" == *.mdc ]]; then
      inject_generated_header "${src}" "${dst}"
    else
      cp "${src}" "${dst}"
    fi
  fi
}

inject_generated_header() {
  local src="$1"
  local dst="$2"

  python3 - "$src" "$dst" "$PACK_VERSION" "$SOURCE_OF_TRUTH" "$MANAGED_BY" <<'PY'
import sys
from pathlib import Path

src = Path(sys.argv[1])
dst = Path(sys.argv[2])
version = sys.argv[3]
source_of_truth = sys.argv[4]
managed_by = sys.argv[5]
text = src.read_text(encoding="utf-8")
lines = text.splitlines()

if lines and lines[0].strip() == "---":
    end_idx = None
    for i in range(1, len(lines)):
        if lines[i].strip() == "---":
            end_idx = i
            break
    if end_idx is not None:
        frontmatter = lines[1:end_idx]
        def upsert(front, key, value):
            prefix = f"{key}:"
            for idx, line in enumerate(front):
                if line.strip().startswith(prefix):
                    front[idx] = f"{key}: {value}"
                    return
            front.append(f"{key}: {value}")

        key = "sourcePackVersion:"
        inserted = False
        for idx, line in enumerate(frontmatter):
            if line.strip().startswith(key):
                frontmatter[idx] = f"sourcePackVersion: {version}"
                inserted = True
                break
        if not inserted:
            frontmatter.append(f"sourcePackVersion: {version}")
        upsert(frontmatter, "sourceOfTruth", source_of_truth)
        upsert(frontmatter, "managedBy", managed_by)

        rebuilt = ["---"] + frontmatter + ["---"] + lines[end_idx + 1 :]
        dst.write_text("\n".join(rebuilt) + ("\n" if text.endswith("\n") else ""), encoding="utf-8")
    else:
        # Malformed frontmatter: keep file content unchanged.
        dst.write_text(text, encoding="utf-8")
else:
    # No frontmatter: keep content unchanged to avoid polluting prompt body.
    dst.write_text(text, encoding="utf-8")
PY
}

ensure_dir() {
  local path="$1"
  if [[ "${dry_run}" == "true" ]]; then
    echo "[DRY-RUN] mkdir -p ${path}"
  else
    mkdir -p "${path}"
  fi
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --with-commands)
      sync_commands=true
      shift
      ;;
    --with-skills)
      sync_skills=true
      shift
      ;;
    --with-all)
      sync_commands=true
      sync_skills=true
      echo "[WARN] --with-all is deprecated; full pack is already the default."
      shift
      ;;
    --rules-only)
      sync_commands=false
      sync_skills=false
      shift
      ;;
    --from-file)
      if [[ "$#" -lt 2 ]]; then
        print_usage
        exit 1
      fi
      repo_file="$2"
      shift 2
      ;;
    --profile)
      if [[ "$#" -lt 2 ]]; then
        print_usage
        exit 1
      fi
      profile="$2"
      shift 2
      ;;
    --dry-run)
      dry_run=true
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
  echo "Allowed values: global|backend|frontend|full"
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

if [[ -n "${repo_file}" ]]; then
  repo_file_name="$(basename "${repo_file}")"
  case "${repo_file_name}" in
    repos-backend.txt)
      if [[ "${profile}" != "backend" && "${profile}" != "full" ]]; then
        echo "[ERROR] ${repo_file_name} is for backend/full profile."
        exit 1
      fi
      ;;
    repos-frontend.txt)
      if [[ "${profile}" != "frontend" && "${profile}" != "full" ]]; then
        echo "[ERROR] ${repo_file_name} is for frontend/full profile."
        exit 1
      fi
      ;;
    repos-fullstack.txt)
      if [[ "${profile}" != "full" ]]; then
        echo "[ERROR] ${repo_file_name} is for full profile only."
        exit 1
      fi
      ;;
  esac
fi

if [[ "${#repos[@]}" -eq 0 ]]; then
  echo "[ERROR] No repositories provided."
  exit 1
fi

if [[ ! -f "${MANIFEST}" ]]; then
  echo "[ERROR] Manifest not found: ${MANIFEST}"
  exit 1
fi
if [[ ! -f "${PARSER}" ]]; then
  echo "[ERROR] Manifest parser not found: ${PARSER}"
  exit 1
fi

pair_args=(--manifest "${MANIFEST}" --mode sync_pairs --profile "${profile}")
if [[ "${sync_commands}" == "true" ]]; then
  pair_args+=(--include-commands)
fi
if [[ "${sync_skills}" == "true" ]]; then
  pair_args+=(--include-skills)
fi

pairs_output="$(python3 "${PARSER}" "${pair_args[@]}")"

for repo in "${repos[@]}"; do
  if [[ ! -d "${repo}" ]]; then
    echo "[SKIP] Not found: ${repo}"
    continue
  fi

  while IFS=$'\t' read -r src_rel dst_rel; do
    [[ -z "${src_rel}" ]] && continue
    src_abs="${ROOT_DIR}/${src_rel}"
    dst_abs="${repo}/${dst_rel}"
    dst_dir="$(dirname "${dst_abs}")"
    ensure_dir "${dst_dir}"

    if [[ "${dst_rel}" == ".cursor/rules/project-overrides.mdc" && -f "${dst_abs}" ]]; then
      echo "[OK] ${repo}: kept existing project-overrides.mdc"
      continue
    fi

    copy_file "${src_abs}" "${dst_abs}"
  done <<< "${pairs_output}"

  echo "[OK] ${repo}: synced pack (profile=${profile}, commands=${sync_commands}, skills=${sync_skills})"
done
