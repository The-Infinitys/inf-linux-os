#!/bin/bash

# umount filesystems
echo "Unmounting filesystems..."
umount $1/run
umount $1/dev

echo "Done."