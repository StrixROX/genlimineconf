#!/usr/bin/env bash

get_limine_conf_path() {
  #
  # Finds "limine.conf" and returns the path
  # of parent dir
  #

  local filename='limine.conf'

  local search_paths=(
    '/boot/limine'
    '/boot'
    '/limine'
    '/'
  )

  local path
  for path in "${search_paths[@]}"; do
    if [ -f "$path/$filename" ]; then
      echo "$path"
      return 0
    fi
  done

  >&2 echo "Error: Missing: limine.conf"
  return 1
}

get_root_part_uuid() {
  #
  # Get UUID of root partition, "/"
  #

  local root_part_uuid="$(findmnt -n -o UUID /)"

  echo "$root_part_uuid"
}

