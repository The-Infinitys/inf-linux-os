#!/bin/bash


if [ "$EUID" -ne 0 ]; then
  echo "This script must be run as root" >&2
  exit 1
fi

cd "$(dirname "$0")"

script/install-tools.sh
script/build-rootfs.sh
script/config-rootfs.sh
script/init-chroot.sh
script/exit-chroot.sh

echo "Done."
