#!/bin/bash

if [ "$1" == "before" ]; then
  echo "Executing before chroot setup..."
  bash -c "mount -t proc none /proc; mount -t sysfs none /sys; mount -t devpts none /dev/pts"
elif [ "$1" == "after" ]; then
  echo "Executing after chroot setup..."
  bash -c "umount /proc; umount /sys; umount /dev/pts"
else
  echo "Invalid argument. Please use 'before' or 'after'."
  exit 1
fi
