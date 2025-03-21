#!/bin/bash

# umount filesystems
echo "Unmounting filesystems..."
umount rootfs/run
umount rootfs/sys
umount rootfs/dev/pts
umount rootfs/dev

echo "Done."