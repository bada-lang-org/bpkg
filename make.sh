#!/bin/bash
set -e

BPKG_NAME="bpkg"
BPKG_VERSION="0.1.0"
BPKG_DEPENDS="bash curl git jq"

echo "Building ${BPKG_NAME} v${BPKG_VERSION}"

echo "[make] checking dependencies..."
# shellcheck disable=SC2086
pkg install ${BPKG_DEPENDS} -y

echo "[make] installing ${BPKG_NAME}..."
install -Dm755 "bin/${BPKG_NAME}" "${PREFIX}/bin/${BPKG_NAME}"

echo "[make] installing stdlib..."
mkdir -p "${PREFIX}/share/bada/lib"
for f in stdlib/*.bada; do
    name=$(basename "$f" .bada)
    mkdir -p "${PREFIX}/share/bada/lib/${name}"
    cp "$f" "${PREFIX}/share/bada/lib/${name}/${name}.bada"
    echo "[make] stdlib: ${name}"
done

echo "[make] verifying..."
${BPKG_NAME} --version
echo "[make] ✓ ${BPKG_NAME} installed successfully"
