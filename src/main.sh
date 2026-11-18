#!/usr/bin/env bash

LIBEXECDIR_PATH="@LIBEXECDIR_PATH@"

cmd="$1"; shift

case $cmd in
  add-entry)
    source "$LIBEXECDIR_PATH/generate_boot_entry.sh"
    generate_boot_entry "$@"
    ;;
  remove-entry)
    source "$LIBEXECDIR_PATH/remove_boot_entry.sh"
    remove_boot_entry "$@"
    ;;
  generate)
    source "$LIBEXECDIR_PATH/generate_limine_conf.sh"
    generate_limine_conf "$@"
    ;;
  *)
    >&2 echo "Error: Invalid command: $cmd"
    exit 2
    ;;
esac
