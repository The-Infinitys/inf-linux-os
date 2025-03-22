#!/bin/bash

if [ "$1" == "before" ]; then
  cp -f src/ubuntu-oracular-full.list $2/etc/apt/sources.list
  cp script/config-chroot.sh $2/config-chroot.sh
  cp src/build-system.sh $2/build-system.sh
elif [ "$1" == "after" ]; then
  rm -f $2/*.sh
elif [ "$1" == "debug" ]; then
  cp script/config-chroot.sh $2/config-chroot.sh
  cp src/debug-system.sh $2/debug-system.sh
else
  echo "Usage: $0 {--before|--after}"
  exit 1
fi
