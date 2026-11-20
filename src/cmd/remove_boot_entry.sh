#!/usr/bin/env bash

LIBDIR_PATH="@LIBDIR_PATH@"

source "$LIBDIR_PATH/01-utils.sh"

remove_boot_entry() {
  if [ -z "$1" ]; then
    >&2 echo "Error: Missing arg: 1: pkgname"
    exit 1
  elif [ -z "$2" ]; then
    >&2 echo "Error: Missing arg: 2: version"
    exit 1
  fi

  local pkgname="$1"
  local version="$2"

  init_check

  local ENTRIESDIR="${ENTRIESDIR:-@ENTRIESDIR@}" # environment supplied var

  local entry="$ENTRIESDIR/${pkgname}_${version}.entry"

  if [ -f "$entry" ]; then
    rm "$entry"
    echo "Info: Removed boot entry: $entry"
  else
    >&2 echo "Error: Boot entry not found: $entry"
    exit 1
  fi
}
