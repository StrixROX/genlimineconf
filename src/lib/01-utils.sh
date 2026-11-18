#!/usr/bin/env bash

init_check() {
  local check() {
    # check if limine.conf exists
    local limine_conf_path=$(get_limine_conf_path 2>/dev/null)

    if [ -z "$limine_conf_path" ]; then
      >&2 echo "Error: Missing: limine.conf"
      return 1
    fi

    # check if $confdir exists
    local confdir_path="${CONFDIR_PATH:-'/etc/genlimineconf'}"
    local confdir_name="${CONFDIR_NAME:-'limine.conf.d'}"
    local confdir="$confdir_path/$confdir_name"

    if [ ! -d "$confdir" ]; then
      >&2 echo "Error: Missing config directory: $confdir/"
    fi

    # check if $entriesdir exists
    local entriesdir_path="${ENTRIESDIR_PATH:-'/var/lib/genlimineconf'}"
    local entriesdir_name="${ENTRIESDIR_NAME:-'entries'}"
    local entriesdir="$entriesdir_path/$entriesdir_name"

    if [ ! -d "$entriesdir" ]; then
      >&2 echo "Error: Missing boot entries directory: $entriesdir/"
    fi
 }

  if ! check; then
    >&2 echo "Error: Init failure: genlimineconf and/or related directories did not init properly"
    exit 1
  fi
}

