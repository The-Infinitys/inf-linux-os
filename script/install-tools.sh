#!/bin/bash

echo "Installing tools..."
apt update
apt install -y binwalk casper genisoimage live-boot live-boot-initramfs-tools squashfs-tools apparmor apparmor-utils bridge-utils libvirt-clients libvirt-daemon-system libguestfs-tools qemu-kvm virt-manager
echo "Tools installed."