#!/bin/bash

# package rootfs

echo "Packaging rootfs..."

cd custom_live_cd
rm extracted/casper/vmlinuz
cp ../rootfs/boot/vmlinuz extracted/casper/vmlinuz
chmod 644 extracted/casper/vmlinuz
cp -L ../rootfs/boot/vmlinuz extracted/casper/vmlinuz
mkdir initrdmount
unmkinitramfs -v extracted/casper/initrd initrdmount
cp -R initrdmount/main/conf conf
mv conf initrdconf
cp -R initrdmount/main/scripts initrdconf/scripts
mkinitramfs -d initrdconf -o ninitrd
rm extracted/casper/initrd
mv ninitrd extracted/casper/initrd

echo "Done."

echo "Cleaning up..."

rm ../rootfs/boot/initrd.img-*
rm ../rootfs/boot/vmlinuz-*

echo "Done."

echo "Rebuilding manifest..."

chmod +w extracted/casper/filesystem.manifest
chroot edit dpkg-query -W --showformat='${Package} ${Version}\n' > extracted/casper/filesystem.manifest
cp extracted/casper/filesystem.manifest extracted/casper/filesystem.manifest-desktop
sed -i '/ubiquity/d' extracted/casper/filesystem.manifest-desktop
sed -i '/casper/d' extracted/casper/filesystem.manifest-desktop

rm extracted/casper/filesystem.squashfs
rm extracted/casper/filesystem.squashfs.gpg

mksquashfs ../rootfs extracted/casper/filesystem.squashfs -comp xz
printf $(du -sx --block-size=1 edit | cut -f1) > extracted/casper/filesystem.size

gpg --local-user 2551D59A01F3022FAFB75644F440B26DF14188A2 --output extracted/casper/filesystem.squashfs.gpg --detach-sign extracted/casper/filesystem.squashfs

printf $(du -sx --block-size=1 edit | cut -f1) > extracted/casper/filesystem.size

