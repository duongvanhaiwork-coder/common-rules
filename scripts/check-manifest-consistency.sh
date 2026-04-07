#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MANIFEST="${ROOT_DIR}/pack-manifest.yaml"
VERSION_FILE="${ROOT_DIR}/VERSION"

if [[ ! -f "${MANIFEST}" ]]; then
  echo "[MISSING] ${MANIFEST}"
  exit 1
fi
if [[ ! -f "${VERSION_FILE}" ]]; then
  echo "[MISSING] ${VERSION_FILE}"
  exit 1
fi
manifest_version="$(python3 - "${MANIFEST}" <<'PY'
import sys
path = sys.argv[1]
with open(path, "r", encoding="utf-8") as f:
    for line in f:
        if line.startswith("version:"):
            print(line.split(":", 1)[1].strip())
            break
PY
)"
file_version="$(tr -d '\n' < "${VERSION_FILE}")"
if [[ "${manifest_version}" != "${file_version}" ]]; then
  echo "[MISMATCH] VERSION (${file_version}) != manifest (${manifest_version})"
  exit 1
fi

python3 - "${MANIFEST}" "${ROOT_DIR}" <<'PY'
import sys
from pathlib import Path

manifest_path = Path(sys.argv[1])
root = Path(sys.argv[2])

profiles = {}
current_profile = None
current_group = None

for raw in manifest_path.read_text(encoding="utf-8").splitlines():
    if raw.strip().startswith("#") or not raw.strip():
        continue
    indent = len(raw) - len(raw.lstrip(" "))
    s = raw.strip()
    if s.startswith("version:"):
        continue
    if indent == 2 and s.endswith(":"):
        current_profile = s[:-1]
        profiles.setdefault(current_profile, {"rules": [], "commands": [], "skills": []})
        current_group = None
        continue
    if indent == 4 and s.endswith(":"):
        current_group = s[:-1]
        continue
    if indent == 6 and s.startswith("- "):
        if current_profile and current_group:
            profiles[current_profile][current_group].append(s[2:].strip())

missing_files = []

for profile, groups in profiles.items():
    for rel in groups.get("rules", []):
        rel_path = f"{'.cursor/rules/' if profile == 'global' else f'{profile}/.cursor/rules/'}{rel}"
        if not (root / rel_path).is_file():
            missing_files.append(rel_path)
    for rel in groups.get("commands", []):
        rel_path = f"{'.cursor/commands/' if profile == 'global' else f'{profile}/.cursor/commands/'}{rel}"
        if not (root / rel_path).is_file():
            missing_files.append(rel_path)
    for rel in groups.get("skills", []):
        rel_path = f"{'.cursor/skills/' if profile == 'global' else f'{profile}/.cursor/skills/'}{rel}"
        if not (root / rel_path).is_file():
            missing_files.append(rel_path)

if missing_files:
    for p in sorted(set(missing_files)):
        print(f"[MISSING FILE] {p}")
    sys.exit(1)

print("[OK] Manifest consistency check passed.")
PY
