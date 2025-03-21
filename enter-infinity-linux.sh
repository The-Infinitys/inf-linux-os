#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

cd "$(dirname "$0")"

# Enter to built env
script/config-rootfs.sh debug rootfs
script/init-chroot.sh rootfs
chroot rootfs /debug-system.sh
script/exit-chroot.sh rootfs
script/config-rootfs.sh after rootfs
