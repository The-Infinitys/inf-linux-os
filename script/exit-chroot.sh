#!/bin/bash

# umount filesystems
echo "Unmounting filesystems..."
chroot rootfs /bin/bash -c "umount /proc; umount /sys; umount /dev/pts"
umount rootfs/run
umount rootfs/dev

echo "Done."