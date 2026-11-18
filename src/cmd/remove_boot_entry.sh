#!/usr/bin/env bash

remove_boot_entry() {
  if [ -z "$1" ]; then
    >&2 echo "Error: Missing arg: 1: pkgname"
    exit 1
  elif [ -z "$2" ]; then
    >&2 echo "Error: Missing arg: 2: version"
    exit 1
  fi

  local pkgname=$1
  local version=$2

  init_check

  local entriesdir_path="${ENTRIESDIR_PATH:-'/var/lib/genlimineconf'}"
  local entriesdir_name="${ENTRIESDIR_NAME:-'entries'}"
  local entriesdir="$entriesdir_path/$entriesdir_name"

  local entry="$entriesdir/${pkgname}_${version}.entry"

  if [ -f "$entry" ]; then
    rm "$entry"
    echo "Info: Removed boot entry: $entry"
  else
    >&2 echo "Error: Boot entry not found: $entry"
    exit 1
  fi
}
