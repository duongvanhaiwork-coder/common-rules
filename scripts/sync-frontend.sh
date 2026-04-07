#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"${SCRIPT_DIR}/sync-rules.sh" --profile frontend --from-file "${SCRIPT_DIR}/../repos-frontend.txt" "$@"
