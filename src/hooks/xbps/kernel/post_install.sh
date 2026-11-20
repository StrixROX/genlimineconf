#!/bin/sh
#
# Kernel post-install hook for genlimineconf.
#
# Arguments passed to this script: $1 pkgname, $2 version.
#
PKGNAME="$1"
VERSION="$2"

genlimineconf="@BINDIR@/genlimineconf"

if [ ! -x "$genlimineconf" ]; then
	exit 0
fi

ENTRIESDIR="@ENTRIESDIR@" ${genlimineconf} add-entry "@KERNEL_NAME@" "$VERSION"
ENTRIESDIR="@ENTRIESDIR@" ${genlimineconf} generate
