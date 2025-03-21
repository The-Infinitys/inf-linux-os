#!/bin/bash

# build rootfs

echo "Building rootfs..."

if [ -d "rootfs" ]; then
  rm -rf rootfs
fi

mkdir rootfs

mmdebstrap --components="main restricted universe multiverse" \
  oracular rootfs http://jp.archive.ubuntu.com/ubuntu/ --mode=auto\
  --arch=amd64 --include=systemd-sysv,dbus,iproute2,iputils-ping,net-tools,openssh-server,apt-utils,apt-transport-https,ca-certificates,software-properties-common,gnupg,gnupg-agent,gnupg2,gnupg1,gnupg-curl,gnupg-l10n,gnupg-pgpgpg,gnupg-doc,wget,nano,sudo,less,locales,apt-utils

echo "Done."
