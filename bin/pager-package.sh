#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_DIR="${ROOT_DIR}/release-work/firmware"
OTA_URL_ESP32S3="https://github.com/meshtastic/esp32-unified-ota/releases/latest/download/mt-esp32s3-ota.bin"

usage() {
    cat <<'EOF'
Usage: ./bin/pager-package.sh <env> [<env>...]

Example:
  ./bin/pager-package.sh heltec-v3 heltec-v4
EOF
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

mkdir -p "${OUT_DIR}"

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
Packaged at: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
Factory image: $(basename "${factory_bin}")
Update image: $(basename "${ota_bin}")
LittleFS image: $(basename "${littlefs_bin}")
Metadata: $(basename "${meta_json}")
EOF

    echo "Packaged ${env_name} -> ${target_dir}"
done
