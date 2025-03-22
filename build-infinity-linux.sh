#!/bin/bash


if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

cd "$(dirname "$0")"

script/install-tools.sh
script/build-rootfs.sh
script/config-rootfs.sh before rootfs
script/init-chroot.sh rootfs
script/exec-chroot.sh
script/exit-chroot.sh rootfs
script/config-rootfs.sh after rootfs

echo "Done."
