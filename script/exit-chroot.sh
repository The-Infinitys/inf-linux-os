#!/bin/bash

# umount filesystems
echo "Unmounting filesystems..."
chroot rootfs "umount /proc; umount /sys; umount /dev/pts"
umount rootfs/run
umount rootfs/dev

echo "Done."