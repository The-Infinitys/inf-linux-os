#!/bin/bash

cp script/build-system.sh rootfs/build-system.sh
chroot rootfs /build-system.sh
