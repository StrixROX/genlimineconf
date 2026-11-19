#!/usr/bin/env bash

CMDDIR_PATH="@CMDDIR_PATH@"

cmd="$1"; shift

case $cmd in
  add-entry)
    source "$CMDDIR_PATH/generate_boot_entry.sh"
    generate_boot_entry "$@"
    ;;
  remove-entry)
    source "$CMDDIR_PATH/remove_boot_entry.sh"
    remove_boot_entry "$@"
    ;;
  generate)
    source "$CMDDIR_PATH/generate_limine_conf.sh"
    generate_limine_conf "$@"
    ;;
  refresh)
    source "$CMDDIR_PATH/refresh_entries.sh"
    refresh_entries "$@"
    ;;
  *)
    >&2 echo "Error: Invalid command: $cmd"
    exit 2
    ;;
esac
