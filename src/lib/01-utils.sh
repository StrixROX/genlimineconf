#!/usr/bin/env bash

LIBDIR_PATH="@LIBDIR_PATH@"

source "$LIBDIR_PATH/00-core.sh"

init_check() {
  #
  # Checks if all the required files and directories are present
  # in their intended places before any other commands/functions
  # get executed.
  #
  # Note: ENTRIESDIR_PATH used to be a constant supplied at build
  # time (pointing to `/var/lib/genlimineconf`), but the entries
  # were later re-targetted to `/tmp` using `mktemp -d`. So,
  # ENTRIESDIR_PATH is not a runtime environment variable that
  # needs to be supplied by the user/calling functions.
  #
  # TLDR: Always set $ENTRIESDIR_PATH env variable.
  #

  check() {
    # check if limine.conf exists
    local limine_conf_path=$(get_limine_conf_path 2>/dev/null)

    if [ -z "$limine_conf_path" ]; then
      >&2 echo "Error: Missing: limine.conf"
      return 1
    fi

    # check if $confdir exists
    local CONFDIR="@CONFDIR@"

    if [ ! -d "$CONFDIR" ]; then
      >&2 echo "Error: Missing config directory: $CONFDIR/"
      return 1
    fi

    # check if $entriesdir exists
    local ENTRIESDIR_PATH="$ENTRIESDIR_PATH" # environment supplied var
    local ENTRIESDIR_NAME="@ENTRIESDIR_NAME@"

    local entriesdir="$ENTRIESDIR_PATH/$ENTRIESDIR_NAME"

    if [ -z "$ENTRIESDIR_PATH" ]; then
      >&2 echo "Error: Unset environment variable: ENTRIESDIR_PATH"
      return 1
    elif [ ! -d "$entriesdir" ]; then
      >&2 echo "Error: Missing boot entries directory: $entriesdir/"
      return 1
    fi
 }

  if ! check; then
    >&2 echo "Error: Init failure: genlimineconf and/or related directories did not init properly"
    exit 1
  fi
}

