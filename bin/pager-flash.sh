#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARTIFACT_ROOT="${ROOT_DIR}/release-work/firmware"
BOARD=""
PORT=""
MODE="factory"

usage() {
    cat <<'EOF'
Usage:
  ./bin/pager-flash.sh --board heltec-v3 --port /dev/tty.usbmodemXXXX
  ./bin/pager-flash.sh --board heltec-v4 --port /dev/tty.usbmodemXXXX

Options:
  --board <name>   Supported: heltec-v3, heltec-v4
  --port <path>    Serial port for esptool
  --mode <name>    factory or update (default: factory)
EOF
}

banner() {
    cat <<'EOF'
========================================
  Meshtastic Pager Mode Flash Helper
  Friendly wrapper for Heltec V3 / V4
========================================
EOF
}

latest_in_dir() {
    local dir="$1"
    local pattern="$2"
    local exclude_pattern="${3:-}"

    while IFS= read -r candidate; do
        if [[ -n "${exclude_pattern}" && "$(basename "${candidate}")" == ${exclude_pattern} ]]; then
            continue
        fi
        echo "${candidate}"
        return 0
    done < <(find "${dir}" -maxdepth 1 -type f -name "${pattern}" -print0 | xargs -0 ls -t 2>/dev/null)
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --board)
            BOARD="$2"
            shift 2
            ;;
        --port)
            PORT="$2"
            shift 2
            ;;
        --mode)
            MODE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            usage
            exit 1
            ;;
    esac
done

if [[ -z "${BOARD}" || -z "${PORT}" ]]; then
    usage
    exit 1
fi

case "${BOARD}" in
    heltec-v3|heltec-v4)
        ;;
    *)
        echo "Unsupported board: ${BOARD}" >&2
        exit 1
        ;;
esac

board_dir="${ARTIFACT_ROOT}/${BOARD}"
if [[ ! -d "${board_dir}" ]]; then
    echo "Artifact folder not found: ${board_dir}" >&2
    echo "First run: ./bin/pager-package.sh ${BOARD}" >&2
    exit 1
fi

banner
echo "Board: ${BOARD}"
echo "Port:  ${PORT}"
echo "Mode:  ${MODE}"
echo

if [[ "${MODE}" == "factory" ]]; then
    factory_image="$(latest_in_dir "${board_dir}" 'firmware-*.factory.bin')"
    if [[ -z "${factory_image:-}" ]]; then
        echo "No factory image found in ${board_dir}" >&2
        exit 1
    fi
    (
        cd "${board_dir}"
        exec "${ROOT_DIR}/bin/device-install.sh" -p "${PORT}" -f "$(basename "${factory_image}")"
    )
elif [[ "${MODE}" == "update" ]]; then
    update_image="$(latest_in_dir "${board_dir}" 'firmware-*.bin' '*.factory.bin')"
    if [[ -z "${update_image:-}" ]]; then
        echo "No update image found in ${board_dir}" >&2
        exit 1
    fi
    (
        cd "${board_dir}"
        exec "${ROOT_DIR}/bin/device-update.sh" -p "${PORT}" -f "$(basename "${update_image}")"
    )
else
    echo "Unsupported mode: ${MODE}" >&2
    exit 1
fi
