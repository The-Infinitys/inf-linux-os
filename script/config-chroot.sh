#!/bin/bash

if [ "$1" == "before" ]; then
  echo "Executing before chroot setup..."
  mount -t proc none /proc; mount -t sysfs none /sys; mount -t devpts none /dev/pts
elif [ "$1" == "after" ]; then
  echo "Executing after chroot setup..."
  umount /proc; umount /sys; umount /dev/pts
else
  echo "Invalid argument. Please use 'before' or 'after'."
  exit 1
fi
