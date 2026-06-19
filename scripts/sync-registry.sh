#!/bin/bash
set -e

PACKAGES_DIR="packages"
OUTPUT_DIR="generated"

mkdir -p "${OUTPUT_DIR}"
rm -f "${OUTPUT_DIR}"/*.json

echo "Scanning ${PACKAGES_DIR}/*/build.sh ..."

for dir in "${PACKAGES_DIR}"/*/; do
    [ -d "$dir" ] || continue
    build_file="${dir}build.sh"
    [ -f "$build_file" ] || continue

    # Reset vars before sourcing
    BPKG_PKG_NAME=""
    BPKG_PKG_VERSION=""
    BPKG_PKG_SRCURL=""
    BPKG_PKG_SHA256=""
    BPKG_PKG_MAINTAINER=""
    BPKG_PKG_DESCRIPTION=""

    # shellcheck source=/dev/null
    source "$build_file"

    if [ -z "$BPKG_PKG_NAME" ]; then
        echo "warning: skipping $build_file (missing BPKG_PKG_NAME)"
        continue
    fi

    out_file="${OUTPUT_DIR}/${BPKG_PKG_NAME}.json"

    jq -n \
        --arg name "$BPKG_PKG_NAME" \
        --arg version "$BPKG_PKG_VERSION" \
        --arg srcurl "$BPKG_PKG_SRCURL" \
        --arg sha256 "$BPKG_PKG_SHA256" \
        --arg maintainer "$BPKG_PKG_MAINTAINER" \
        --arg description "$BPKG_PKG_DESCRIPTION" \
        '{
            name: $name,
            url: $srcurl,
            version: $version,
            description: $description,
            author: $maintainer,
            sha256: $sha256
        }' > "$out_file"

    echo "Generated: $out_file"
done

echo "✓ Sync complete."
