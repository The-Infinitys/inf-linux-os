#!/bin/bash
#!/bin/bash

if [ "$1" == "before" ]; then
  cp -f src/ubuntu-oracular-full.list rootfs/etc/apt/sources.list
  cp script/config-chroot.sh rootfs/config-chroot.sh
  cp script/build-system.sh rootfs/build-system.sh
elif [ "$1" == "after" ]; then
  rm -f rootfs/config-chroot.sh
  rm -f rootfs/build-system.sh
fi
