#!/usr/bin/env bash

get_limine_conf_path() {
  #
  # Finds "limine.conf" and returns the path
  # of parent dir
  #

  local filename='limine.conf'

  local universal_paths=(
    '/boot/limine'
    '/boot'
    '/limine'
    '/'
  )

  local efi_paths=(
    '/boot/efi/EFI/BOOT'
    '/boot/efi/EFI/Limine'
    '/boot/EFI/BOOT'
    '/boot/EFI/Limine'
    '/efi/EFI/BOOT'
    '/efi/EFI/Limine'
    '/EFI/BOOT'
    '/EFI/Limine'
  )

  local search_paths

  # Check if system is UEFI or BIOS
  if [ -d /sys/firmware/efi ]; then
    search_paths=("${efi_paths[@]}" "${universal_paths[@]}")
  else
    search_paths=("${universal_paths[@]}")
  fi

  local path
  for path in "${search_paths[@]}"; do
    if [ -f "$path/$filename" ]; then
      echo "$path"
      return 0
    fi
  done

  >&2 echo "Error: Not found: limine.conf"
  return 1
}

get_root_part_uuid() {
  #
  # Get UUID of root partition, "/"
  #

  local root_part_uuid="$(findmnt -n -o UUID /)"

  echo "$root_part_uuid"
}

