#!/bin/bash

echo "Executing chroot..."

echo "copy script/build-system.sh to rootfs/build-system.sh"
cp script/build-system.sh rootfs/build-system.sh
echo "Run build-system.sh in chroot"
chroot rootfs /bin/bash -c "cd /; ./build-system.sh"
