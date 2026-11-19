#!/usr/bin/env bash

LIBDIR_PATH="@LIBDIR_PATH@"
CMDDIR_PATH="@CMDDIR_PATH@"

source "$LIBDIR_PATH/00-core.sh"
source "$LIBDIR_PATH/01-utils.sh"
source "$CMDDIR_PATH/generate_boot_entry.sh"

refresh_entries() {
  init_check

  local ENTRIESDIR="$ENTRIESDIR" # environment supplied var

  # clean up stale entries before rebuilding from what's on disk
  rm -f "$ENTRIESDIR"/*.entry

  local KERNEL_NAME="@KERNEL_NAME@"
  local KERNEL_PATH="@KERNEL_PATH@"
  local bootdir="/boot/$KERNEL_PATH"

  local kernel version
  shopt -s nullglob
  for kernel in "$bootdir"/vmlinuz-*; do
    version="${kernel##*/vmlinuz-}"
    generate_boot_entry "$KERNEL_NAME" "$version"
  done
  shopt -u nullglob

  echo "Info: Refreshed boot entries from: $bootdir"
}
