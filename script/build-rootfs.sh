#!/bin/bash

# build rootfs

echo "Building rootfs..."

if [ -d "rootfs" ]; then
  rm -rf rootfs
fi

mkdir rootfs

TARGET_PACKAGE=" \
    open-infrastructure-system-boot \
    open-infrastructure-system-build \
    open-infrastructure-system-config \
    open-infrastructure-system-images \
    isolinux syslinux \
    linux-headers-generic \
    linux-image-generic \
    kubuntu-desktop ubuntu-server \
    build-essential curl vim \
    open-vm-tools-desktop \
    clamav \
    bind9 \
    openssh-server \
    samba smbclient cifs-utils \
    isc-dhcp-server \
    minidlna \
    language-pack-ja \
    language-pack-kde-ja \
    fonts-noto \
    fcitx5-mozc mozc-utils-gui \
    libreoffice-l10n-ja libreoffice-help-ja \
    thunderbird-locale-ja \
    systemd-sysv \
    dbus \
    iproute2 \
    iputils-ping \
    net-tools \
    openssh-server \
    apt-utils \
    apt-transport-https \
    wget \
    nano \
    sudo \
    less \
    locales \
    mount \
" mmdebstrap --components="main restricted universe multiverse" \
  oracular rootfs http://jp.archive.ubuntu.com/ubuntu/ --mode=auto\
  --arch=amd64

echo "Done."
