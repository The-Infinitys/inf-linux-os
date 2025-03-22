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
# Download original ISO image

apt-get install --assume-yes binwalk casper genisoimage live-boot live-boot-initramfs-tools squashfs-tools wget

wget $ORIGINAL_URL

# Extract original ISO image
mkdir ./custom_live_cd
mv $ORIGINAL_ISO ./custom_live_cd
cd ./custom_live_cd
mkdir isomount
mount -o loop $ORIGINAL_ISO isomount

mkdir extracted
rsync --exclude=/casper/filesystem.squashfs -a ./isomount/ extracted
unsquashfs isomount/casper/filesystem.squashfs
mv squashfs-root edit

# Copy package files to the extracted root filesystem
cp -r ../rootfs/* edit