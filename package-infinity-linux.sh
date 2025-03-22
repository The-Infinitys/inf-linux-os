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

rm -f inf-linux.img
# Create a 8GB empty image file
echo "Creating a 8GB empty image file..."
truncate -s 8G infinity-linux.img

# Initialize the image with GPT partition table
echo "Initializing the image with GPT partition table..."
parted infinity-linux.img --script mklabel gpt

# Create bios-part partition (2MB, unformatted)
echo "Creating bios-part partition (2MB, unformatted)..."
parted infinity-linux.img --script mkpart BIOS_PART 1MiB 3MiB

# Create uefi-part partition (512MB, FAT32)
echo "Creating uefi-part partition (512MB, FAT32)..."
parted infinity-linux.img --script mkpart UEFI_PART fat32 3MiB 515MiB
parted infinity-linux.img --script set 2 esp on

# Create linux-boot partition (2048MB, ext4)
echo "Creating linux-boot partition (2048MB, ext4)..."
parted infinity-linux.img --script mkpart LINUX_BOOT ext4 515MiB 2563MiB

# Create inf-linux partition (remaining space, ext4)
echo "Creating inf-linux partition (remaining space, ext4)..."
parted infinity-linux.img --script mkpart INF_LINUX ext4 2563MiB 100%

# Format the partitions
echo "Formatting the partitions..."

# Remount the loop device
LOOP_DEVICE=$(losetup --find --show infinity-linux.img)
partprobe ${LOOP_DEVICE}


mkfs.vfat -F 32 ${LOOP_DEVICE}p2 -n UEFI_BOOT
mkfs.ext4 ${LOOP_DEVICE}p3 -L LINUX_BOOT
mkfs.ext4 ${LOOP_DEVICE}p4 -L INF_LINUX

# Mount the partitions
echo "Mounting the partitions..."

mkdir -p /mnt/linux-boot /mnt/inf-linux
mount ${LOOP_DEVICE}p3 /mnt/linux-boot
mount ${LOOP_DEVICE}p4 /mnt/inf-linux

# Copy rootfs/boot to linux-boot
echo "Copying rootfs/boot to linux-boot..."
cp -r rootfs/boot/* /mnt/linux-boot/

# Copy the rest of rootfs to inf-linux
echo "Copying the rest of rootfs to inf-linux..."
cp -r rootfs/* /mnt/inf-linux/
rm -rf /mnt/inf-linux/boot

# Unmount the partitions
echo "Unmounting the partitions..."
umount /mnt/linux-boot
umount /mnt/inf-linux
rmdir /mnt/linux-boot /mnt/inf-linux

# Mount all partitions again for grub-install
echo "Mounting all partitions again for grub-install..."
mount ${LOOP_DEVICE}p3 /mnt/inf-linux/boot
mount ${LOOP_DEVICE}p4 /mnt/inf-linux/
mount ${LOOP_DEVICE}p2 /mnt/inf-linux/efi

echo "Initializing chroot environment..."
script/init-chroot.sh /mnt/inf-linux

# Install GRUB
echo "Installing GRUB..."
chroot /mnt/inf-linux "grub-install --target=x86_64-efi --boot-directory=/boot ${LOOP_DEVICE} \
grub-install --target=i386-pc --boot-directory=/boot ${LOOP_DEVICE}"

echo "Exiting chroot environment..."
script/exit-chroot.sh /mnt/inf-linux

# Unmount the partitions
echo "Unmounting the partitions..."
umount /mnt/inf-linux/efi
umount /mnt/inf-linux/boot
umount /mnt/inf-linux
rmdir /mnt/linux-boot /mnt/inf-linux

losetup -d ${LOOP_DEVICE}

echo "Script completed successfully."
