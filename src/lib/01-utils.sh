#!/usr/bin/env bash

LIBEXECDIR_PATH="@LIBEXECDIR_PATH@"

source "$LIBEXECDIR_PATH/lib/00-core.sh"

init_check() {
  check() {
    # check if limine.conf exists
    local limine_conf_path=$(get_limine_conf_path 2>/dev/null)

    if [ -z "$limine_conf_path" ]; then
      >&2 echo "Error: Missing: limine.conf"
      return 1
    fi

    # check if $confdir exists
    local CONFDIR_PATH="@CONFDIR_PATH@"
    local CONFDIR_NAME="@CONFDIR_NAME@"

    local confdir="$CONFDIR_PATH/$CONFDIR_NAME"

    if [ ! -d "$confdir" ]; then
      >&2 echo "Error: Missing config directory: $confdir/"
    fi

    # check if $entriesdir exists
    local ENTRIESDIR_PATH="@ENTRIESDIR_PATH@"
    local ENTRIESDIR_NAME="@ENTRIESDIR_NAME@"

    local entriesdir="$ENTRIESDIR_PATH/$ENTRIESDIR_NAME"

    if [ ! -d "$entriesdir" ]; then
      >&2 echo "Error: Missing boot entries directory: $entriesdir/"
    fi
 }

  if ! check; then
    >&2 echo "Error: Init failure: genlimineconf and/or related directories did not init properly"
    exit 1
  fi
}

