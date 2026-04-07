#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PARSER="${ROOT_DIR}/scripts/lib/manifest_parser.py"
MANIFEST="${ROOT_DIR}/pack-manifest.yaml"

required_files=(
  "${ROOT_DIR}/VERSION"
  "${ROOT_DIR}/CHANGELOG.md"
  "${MANIFEST}"
  "${ROOT_DIR}/compatibility-matrix.md"
  "${ROOT_DIR}/.cursor/skills/README.md"
  "${PARSER}"
)

missing=0
for file in "${required_files[@]}"; do
  if [[ ! -f "${file}" ]]; then
    echo "[MISSING] ${file}"
    missing=1
  fi
done

while IFS= read -r rel; do
  [[ -z "${rel}" ]] && continue
  if [[ ! -f "${ROOT_DIR}/${rel}" ]]; then
    echo "[MISSING] ${ROOT_DIR}/${rel}"
    missing=1
  fi
done < <(python3 "${PARSER}" --manifest "${MANIFEST}" --mode all_source_files)

if [[ ! -d "${ROOT_DIR}/backend/.cursor/rules" ]]; then
  echo "[MISSING] backend/.cursor/rules"
  missing=1
fi
if [[ ! -d "${ROOT_DIR}/frontend/.cursor/rules" ]]; then
  echo "[MISSING] frontend/.cursor/rules"
  missing=1
fi

if [[ "${missing}" -ne 0 ]]; then
  echo "[FAIL] Pack validation failed."
  exit 1
fi

if [[ ! -x "${ROOT_DIR}/scripts/check-manifest-consistency.sh" ]]; then
  chmod +x "${ROOT_DIR}/scripts/check-manifest-consistency.sh"
fi
"${ROOT_DIR}/scripts/check-manifest-consistency.sh"

echo "[OK] Pack validation passed."
