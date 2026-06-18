#!/bin/bash
# bpkg build script — format inspired by Termux build.sh

BPKG_NAME="bpkg"
BPKG_VERSION="0.1.0"
BPKG_DESCRIPTION="Package manager for the Bada programming language"
BPKG_LICENSE="Apache-2.0"
BPKG_DEPENDS="bash curl git jq"

bpkg_step_check_deps() {
	pkg install ${BPKG_DEPENDS} -y
}

bpkg_step_install() {
	install -Dm755 "bin/${BPKG_NAME}" "${PREFIX}/bin/${BPKG_NAME}"
}

bpkg_step_verify() {
	${BPKG_NAME} --version
}

echo "Building ${BPKG_NAME} v${BPKG_VERSION}"
bpkg_step_check_deps
bpkg_step_install
bpkg_step_verify
echo "✓ done"
