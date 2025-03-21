#!/bin/bash

if [ "$1" == "before" ]; then
  cp -f src/ubuntu-oracular-full.list rootfs/etc/apt/sources.list
  cp script/config-chroot.sh rootfs/config-chroot.sh
  cp script/build-system.sh rootfs/build-system.sh
elif [ "$1" == "after" ]; then
  rm -f rootfs/*.sh
elif [ "$1" == "debug" ]; then
  cp script/config-chroot.sh rootfs/config-chroot.sh
  cp script/debug-system.sh rootfs/debug-system.sh
else
  echo "Usage: $0 {--before|--after}"
  exit 1
fi
