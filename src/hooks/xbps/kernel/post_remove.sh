#!/bin/sh
#
# Kernel post-remove hook for genlimineconf.
#
# Arguments passed to this script: $1 pkgname, $2 version.
#
PKGNAME="$1"
VERSION="$2"

executable="$EXEC_DIR/genlimineconf"

if [ ! -x "$executable" ]; then
	exit 0
fi

${executable} remove-entry ${KERNEL_NAME} ${VERSION}
${executable} generate
