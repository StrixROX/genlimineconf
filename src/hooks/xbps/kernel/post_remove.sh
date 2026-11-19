#!/bin/sh
#
# Kernel post-remove hook for genlimineconf.
#
# Arguments passed to this script: $1 pkgname, $2 version.
#
PKGNAME="$1"
VERSION="$2"

EXECDIR_PATH="@EXECDIR_PATH@"

genlimineconf="$EXECDIR_PATH/genlimineconf"

if [ ! -x "$genlimineconf" ]; then
	exit 0
fi

${genlimineconf} generate
