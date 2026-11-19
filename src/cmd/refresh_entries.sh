#!/usr/bin/env bash

LIBEXECDIR_PATH="@LIBEXECDIR_PATH@"

source "$LIBEXECDIR_PATH/lib/00-core.sh"
source "$LIBEXECDIR_PATH/lib/01-utils.sh"
source "$LIBEXECDIR_PATH/generate_boot_entry.sh"

refresh_entries() {
  init_check

  local ENTRIESDIR_PATH="@ENTRIESDIR_PATH@"
  local ENTRIESDIR_NAME="@ENTRIESDIR_NAME@"
  local entriesdir="$ENTRIESDIR_PATH/$ENTRIESDIR_NAME"

  # clean up stale entries before rebuilding from what's on disk
  rm -f "$entriesdir"/*.entry

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
