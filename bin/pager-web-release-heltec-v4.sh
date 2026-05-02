#!/usr/bin/env bash
# Build heltec-v4 (OLED pager), refresh release-work/firmware/heltec-v4/, bump ?v=
# cache-busters in docs/index.html so GitHub Pages + raw.githubusercontent.com
# pick up the manifest that matches the packaged bins.
#
# Usage:
#   ./bin/pager-web-release-heltec-v4.sh
#   SKIP_BUILD=1 ./bin/pager-web-release-heltec-v4.sh   # repackage + refresh docs only
#
# After: commit release-work/firmware/heltec-v4 + docs/index.html; push → web flasher works.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

ENV_NAME="heltec-v4"

require_tool() {
	local n="$1"
	if ! command -v "${n}" >/dev/null 2>&1; then
		echo "Required tool not found: ${n}" >&2
		exit 1
	fi
}

resolve_pio() {
	if command -v pio >/dev/null 2>&1; then
		echo "pio"
		return
	fi
	local v="${HOME}/.platformio/penv/bin/pio"
	if [[ -x "${v}" ]]; then
		echo "${v}"
		return
	fi
	echo "PlatformIO CLI not found. Install PIO or ensure ~/.platformio/penv exists." >&2
	exit 1
}

require_tool jq
require_tool python3

pio_bin="$(resolve_pio)"

if [[ "${SKIP_BUILD:-0}" != "1" ]]; then
	"${pio_bin}" run -e "${ENV_NAME}"
fi

"${ROOT}/bin/pager-package.sh" "${ENV_NAME}"

MANIFEST="${ROOT}/release-work/firmware/${ENV_NAME}/web-installer.json"
INDEX="${ROOT}/docs/index.html"
VERSION="$(jq -r '.version' "${MANIFEST}")"

python3 <<PY
import re
from pathlib import Path

version = """${VERSION}""".strip()
env = """${ENV_NAME}"""
idx = Path("""${INDEX}""")
text = idx.read_text(encoding="utf-8")
pattern = (
    r"(https://raw\.githubusercontent\.com/"
    rf"chemobook/meshtastic-pager-mode/main/release-work/firmware/{re.escape(env)}/"
    r"web-installer\.json\?v=)[^\s\"]+"
)
# Keep &cdn=jd (or bump it once) so raw.githubusercontent.com refetches manifest after CDN-related manifest edits.
manifest_qs = version + "&cdn=jd"
new_text, n = re.subn(pattern, r"\g<1>" + manifest_qs, text)
if n == 0:
    raise SystemExit("Could not patch manifest URLs in docs/index.html (pattern mismatch?).")
idx.write_text(new_text, encoding="utf-8")
print(f"Patched docs/index.html: web-installer.json?v={manifest_qs} ({n} replacement(s))")
PY

echo "Done. Manifest version: ${VERSION}"
echo "Next: trunk fmt (optional), git add release-work/firmware/${ENV_NAME} docs/index.html, commit, push."
