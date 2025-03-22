#!/bin/bash

# mount filesystems
echo "Mounting filesystems..."

mount -o bind /run/ $1/run
cp /etc/hosts $1/etc/
mount --bind /dev/ $1/dev

echo "Done."
