#!/bin/bash

# build rootfs

echo "Building rootfs..."

if [ -d "rootfs" ]; then
  rm -rf rootfs
fi

ISO_URL="https://cdimage.ubuntu.com/kubuntu/releases/24.10/release/kubuntu-24.10-desktop-amd64.iso"
ISO_FILE="kubuntu-24.10-desktop-amd64.iso"

mkdir rootfs

if [ -f custom_live_cd/$ISO_FILE ]; then
  echo "$ISO_FILE already exists. Skipping download."
else
  echo "Downloading $ISO_FILE..."
  wget $ISO_URL -O $ISO_FILE
  mkdir custom_live_cd
  mv $ISO_FILE custom_live_cd
fi
cd custom_live_cd
mkdir isomount
mount -o loop $ISO_FILE isomount

mkdir extracted
rsync --exclude=/casper/filesystem.squashfs -a isomount/ extracted
unsquashfs isomount/casper/filesystem.squashfs
mv squashfs-root ../rootfs

echo "Done."
