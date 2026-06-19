#!/bin/bash
set -e

BPKG_NAME="bpkg"
BPKG_VERSION="0.1.0"
BPKG_DEPENDS="bash curl git jq"
BPKG_SHA256SUM="7b92f0b36ebf41c505f57782f17a7792c852251557d5d963bb5c310c403c6a24"
# shellcheck disable=SC2034
BPKG_TARBALL_SHA256="2ba750d56a6929a9651aa31872687f5eadc9e9ffdc587857e571f45a8bea8607"
# shellcheck disable=SC2034
BPKG_TARBALL_URL="https://github.com/bada-lang-org/bpkg/archive/refs/tags/v${BPKG_VERSION}.tar.gz"

echo "Building ${BPKG_NAME} v${BPKG_VERSION}"

echo "[make] checking dependencies..."
# shellcheck disable=SC2086
pkg install ${BPKG_DEPENDS} -y

echo "[make] verifying bin/bpkg integrity..."
echo "${BPKG_SHA256SUM}  bin/${BPKG_NAME}" | sha256sum -c -
echo "[make] ✓ binary integrity check passed"

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
