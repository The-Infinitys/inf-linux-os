#!/bin/bash

# mount filesystems
echo "Mounting filesystems..."

mount -o bind /run/ rootfs/run
cp /etc/hosts rootfs/etc
mount --bind /dev/ rootfs/dev

chroot rootfs /bin/bash -c "mount -t proc none /proc; mount -t sysfs none /sys; mount -t devpts none /dev/pts"

echo "Done."
