#!/usr/bin/env bash

cmd="$1"; shift

cmd_dir="$LIBDIR_PATH/cmd"
case $cmd in
  add-entry)
    source "$cmd_dir/generate_boot_entry.sh"
    generate_boot_entry "$@"
    ;;
  remove-entry)
    source "$cmd_dir/remove_boot_entry.sh"
    remove_boot_entry "$@"
    ;;
  generate)
    source "$cmd_dir/generate_limine_conf.sh"
    generate_limine_conf "$@"
    ;;
  *)
    >&2 echo "Error: Invalid command: $cmd"
    exit 2
    ;;
esac
