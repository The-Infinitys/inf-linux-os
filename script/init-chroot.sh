#!/bin/bash

# mount filesystems
echo "Mounting filesystems..."

mount -o bind /run/ rootfs/run
cp /etc/hosts rootfs/etc/
mount --bind /dev/ rootfs/dev

echo "Done."
