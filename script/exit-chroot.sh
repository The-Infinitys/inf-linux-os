#!/bin/bash

# umount filesystems
echo "Unmounting filesystems..."
umount rootfs/run
umount rootfs/dev

echo "Done."