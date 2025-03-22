#!/bin/bash

# Package Infinity Linux to ISO Disk Image!

ORIGINAL_ISO="kubuntu-24.10-desktop-amd64.iso"
ORIGINAL_URL="https://cdimage.ubuntu.com/kubuntu/releases/24.10/release/${ORIGINAL_ISO}"

# Check if the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

cd "$(dirname "$0")"

# Create package directory
if [ -d "package" ]; then
  rm -rf package
fi
mkdir package

cd package

# Create a 8GB empty image file
dd if=/dev/zero of=infinity-linux.img bs=1M count=8192

# Initialize the image with GPT partition table
parted infinity-linux.img --script mklabel gpt

# Create bios-part partition (2MB, unformatted)
parted infinity-linux.img --script mkpart bios-part 1MiB 3MiB

# Create uefi-part partition (512MB, FAT32)
parted infinity-linux.img --script mkpart uefi-part fat32 3MiB 515MiB
parted infinity-linux.img --script set 2 esp on

# Create linux-boot partition (2048MB, ext4)
parted infinity-linux.img --script mkpart linux-boot ext4 515MiB 2563MiB

# Create inf-linux partition (remaining space, ext4)
parted infinity-linux.img --script mkpart inf-linux ext4 2563MiB 100%

# Format the partitions
LOOP_DEVICE=$(losetup --find --show infinity-linux.img)
mkfs.vfat -F 32 ${LOOP_DEVICE}p2 -n uefi-part
mkfs.ext4 ${LOOP_DEVICE}p3 -L linux-boot
mkfs.ext4 ${LOOP_DEVICE}p4 -L inf-linux
losetup -d ${LOOP_DEVICE}

# Mount the partitions
mkdir -p /mnt/linux-boot /mnt/inf-linux
mount ${LOOP_DEVICE}p3 /mnt/linux-boot
mount ${LOOP_DEVICE}p4 /mnt/inf-linux

# Copy rootfs/boot to linux-boot
cp -r rootfs/boot/* /mnt/linux-boot/

# Copy the rest of rootfs to inf-linux
cp -r rootfs/* /mnt/inf-linux/
rm -rf /mnt/inf-linux/boot

# Unmount the partitions
umount /mnt/linux-boot
umount /mnt/inf-linux
rmdir /mnt/linux-boot /mnt/inf-linux

# Mount all partitions again for grub-install
mount ${LOOP_DEVICE}p3 /mnt/linux-boot
mount ${LOOP_DEVICE}p4 /mnt/inf-linux
mount ${LOOP_DEVICE}p2 /mnt/linux-boot/efi

# Install GRUB
grub-install --target=x86_64-efi --efi-directory=/mnt/linux-boot/efi --boot-directory=/mnt/linux-boot --removable --recheck ${LOOP_DEVICE}
grub-install --target=i386-pc --boot-directory=/mnt/linux-boot --recheck ${LOOP_DEVICE}

# Unmount the partitions
umount /mnt/linux-boot/efi
umount /mnt/linux-boot
umount /mnt/inf-linux
rmdir /mnt/linux-boot /mnt/inf-linux