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

printf $(du -sx --block-size=1 edit | cut -f1) > extracted/casper/filesystem.size

cd extracted
rm md5sum.txt
find -type f -print0 | xargs -0 md5sum | grep -v isolinux/boot.cat | tee md5sum.txt
cd ..

# Export ISO
ISO_FILE="kubuntu-24.10-desktop-amd64.iso"

dd bs=1 count=512 if=$ISO_FILE of=mbr.img
dd if=$ISO_FILE of=EFI.img bs=1M skip=$(fdisk -l $ISO_FILE | grep EFI | awk '{print $2}') count=$(fdisk -l $ISO_FILE | grep EFI | awk '{print $4}')
xorriso -indev "$ISO_FILE" -report_el_torito cmd

xorriso -outdev InfinityLinux-24.iso -map extracted / -- -volid "Infinity Linux OS Oracular" -boot_image grub grub2_mbr=mbr.img -boot_image any partition_table=on -boot_image any partition_cyl_align=off -boot_image any partition_offset=16 -boot_image any mbr_force_bootable=on -append_partition 2 28732ac11ff8d211ba4b00a0c93ec93b EFI.img -boot_image any appended_part_as=gpt -boot_image any iso_mbr_part_type=a2a0d0ebe5b9334487c068b6b72699c7 -boot_image any cat_path='/boot.catalog' -boot_image grub bin_path='/boot/grub/i386-pc/eltorito.img' -boot_image any platform_id=0x00 -boot_image any emul_type=no_emulation -boot_image any load_size=2048 -boot_image any boot_info_table=on -boot_image grub grub2_boot_info=on -boot_image any next -boot_image any efi_path=--interval:appended_partition_2:all:: -boot_image any platform_id=0xef -boot_image any emul_type=no_emulation -boot_image any load_size=4349952


sha512sum InfinityLinux-24.iso > InfinityLinux-24.iso.sha512