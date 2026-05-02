#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${ROOT_DIR}/release-work/firmware"
OTA_URL_ESP32S3="https://github.com/meshtastic/esp32-unified-ota/releases/latest/download/mt-esp32s3-ota.bin"
# Large firmware blobs fetched from raw.githubusercontent.com often fail in the browser (“Failed to fetch”).
# jsDelivr mirrors those blobs reliably. CDN caveat: `@main` + unchanged path => long-lived cache (hits
# `mt-esp32s3-ota.bin`). We append `?v=<firmware version>` on every part URL to bust caches when the manifest
# version changes.
# Override base: PAGER_FLASHER_FIRMWARE_ROOT, or jsDelivr ref only: PAGER_JSDELIVR_REF=<branch|sha> (default: main).
DEFAULT_GH_USER_REPO="chemobook/meshtastic-pager-mode"

usage() {
    cat <<'EOF'
Usage: ./bin/pager-package.sh <env> [<env>...]

Environment:
  PAGER_FLASHER_FIRMWARE_ROOT  Full base URL prefix for firmware paths (overrides jsDelivr ref below).
  PAGER_JSDELIVR_REF           Git branch or commit for jsDelivr (default: main). Use full SHA after a push if CDN is stubborn.

Example:
  ./bin/pager-package.sh heltec-v3 heltec-v4
EOF
}

require_tool() {
    local tool_name="$1"
    if ! command -v "${tool_name}" >/dev/null 2>&1; then
        echo "Required tool not found: ${tool_name}" >&2
        exit 1
    fi
}

if [[ $# -lt 1 ]]; then
    usage
    exit 1
fi

latest_matching_file() {
    local search_dir="$1"
    local glob="$2"
    local exclude_glob="${3:-}"

    while IFS= read -r candidate; do
        if [[ -n "${exclude_glob}" && "$(basename "${candidate}")" == ${exclude_glob} ]]; then
            continue
        fi
        echo "${candidate}"
        return 0
    done < <(find "${search_dir}" -maxdepth 1 -type f -name "${glob}" -print0 | xargs -0 ls -t 2>/dev/null)
}

download_if_missing() {
    local target_file="$1"
    local url="$2"
    if [[ -f "${target_file}" ]]; then
        return 0
    fi
    echo "Downloading $(basename "${target_file}")"
    curl -L --fail --silent --show-error "${url}" -o "${target_file}"
}

write_web_installer_manifest() {
    local env_name="$1"
    local target_dir="$2"
    local meta_json_path="$3"
    local factory_name="$4"
    local littlefs_name="$5"
    local ota_helper_name="$6"
    local firmware_root="$7"
    local version
    local ota_offset
    local littlefs_offset
    local chip_family

    require_tool jq

    version="$(jq -r '.version' "${meta_json_path}")"
    ota_offset="$(jq -r '.part[] | select(.subtype == "ota_1") | .offset' "${meta_json_path}")"
    littlefs_offset="$(jq -r '.part[] | select(.subtype == "spiffs") | .offset' "${meta_json_path}")"
    ota_offset="$((ota_offset))"
    littlefs_offset="$((littlefs_offset))"

    case "$(jq -r '.mcu' "${meta_json_path}")" in
        esp32s3)
            chip_family="ESP32-S3"
            ;;
        esp32c3)
            chip_family="ESP32-C3"
            ;;
        esp32c6)
            chip_family="ESP32-C6"
            ;;
        esp32)
            chip_family="ESP32"
            ;;
        *)
            echo "Unsupported MCU for web flasher manifest: $(jq -r '.mcu' "${meta_json_path}")" >&2
            exit 1
            ;;
    esac

    cat > "${target_dir}/web-installer.json" <<EOF
{
  "name": "Meshtastic Pager Mode Fork (${env_name})",
  "version": "${version}",
  "new_install_prompt_erase": false,
  "builds": [
    {
      "chipFamily": "${chip_family}",
      "improv": false,
      "parts": [
        {
          "path": "${firmware_root}/release-work/firmware/${env_name}/${factory_name}?v=${version}",
          "offset": 0
        },
        {
          "path": "${firmware_root}/release-work/firmware/${env_name}/${ota_helper_name}?v=${version}",
          "offset": ${ota_offset}
        },
        {
          "path": "${firmware_root}/release-work/firmware/${env_name}/${littlefs_name}?v=${version}",
          "offset": ${littlefs_offset}
        }
      ]
    }
  ]
}
EOF
}

mkdir -p "${OUT_DIR}"

# jsDelivr: https://cdn.jsdelivr.net/gh/<user>/<repo>@<ref>/...
resolve_jsdelivr_firmware_root() {
	if [[ -n "${PAGER_FLASHER_FIRMWARE_ROOT:-}" ]]; then
		echo "${PAGER_FLASHER_FIRMWARE_ROOT}"
		return
	fi
	echo "https://cdn.jsdelivr.net/gh/${DEFAULT_GH_USER_REPO}@${PAGER_JSDELIVR_REF:-main}"
}

PACKAGED_FIRMWARE_ROOT="$(resolve_jsdelivr_firmware_root)"

for env_name in "$@"; do
    build_dir="${ROOT_DIR}/.pio/build/${env_name}"
    if [[ ! -d "${build_dir}" ]]; then
        echo "Build directory not found: ${build_dir}" >&2
        echo "Run: pio run -e ${env_name}" >&2
        exit 1
    fi

    factory_bin="$(latest_matching_file "${build_dir}" 'firmware-*.factory.bin')"
    ota_bin="$(latest_matching_file "${build_dir}" 'firmware-*.bin' '*.factory.bin')"
    meta_json="$(latest_matching_file "${build_dir}" 'firmware-*.mt.json')"
    littlefs_bin="$(latest_matching_file "${build_dir}" 'littlefs-*.bin')"

    if [[ -z "${factory_bin:-}" || -z "${ota_bin:-}" || -z "${meta_json:-}" || -z "${littlefs_bin:-}" ]]; then
        echo "Missing required build artifacts for ${env_name}" >&2
        exit 1
    fi

    target_dir="${OUT_DIR}/${env_name}"
    rm -rf "${target_dir}"
    mkdir -p "${target_dir}"

    cp "${factory_bin}" "${target_dir}/"
    cp "${ota_bin}" "${target_dir}/"
    cp "${meta_json}" "${target_dir}/"
    cp "${littlefs_bin}" "${target_dir}/"

    for optional in bootloader.bin partitions.bin; do
        if [[ -f "${build_dir}/${optional}" ]]; then
            cp "${build_dir}/${optional}" "${target_dir}/"
        fi
    done

    if grep -q '"mcu": "esp32s3"' "${meta_json}"; then
        download_if_missing "${target_dir}/mt-esp32s3-ota.bin" "${OTA_URL_ESP32S3}"
    fi

    cat > "${target_dir}/BUILD-INFO.txt" <<EOF
Fork: Meshtastic Pager Mode
PlatformIO env: ${env_name}
jsDelivr base: ${PACKAGED_FIRMWARE_ROOT}
Packaged at: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
Factory image: $(basename "${factory_bin}")
Update image: $(basename "${ota_bin}")
LittleFS image: $(basename "${littlefs_bin}")
Metadata: $(basename "${meta_json}")
EOF

    cp "${meta_json}" "${target_dir}/latest.mt.json"
    write_web_installer_manifest \
        "${env_name}" \
        "${target_dir}" \
        "${meta_json}" \
        "$(basename "${factory_bin}")" \
        "$(basename "${littlefs_bin}")" \
        "mt-esp32s3-ota.bin" \
        "${PACKAGED_FIRMWARE_ROOT}"

    echo "Packaged ${env_name} -> ${target_dir}"
done
