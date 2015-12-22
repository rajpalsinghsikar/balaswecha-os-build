#!/usr/bin/env bash

WORKDIR=livecdtmp
FILENAME=ubuntu-10.04-amd64.iso
IMAGE_NAME=balaswecha-10.04-amd64.iso

mkdir -p $WORKDIR
cd $WORKDIR
wget http://iso.morphic/$FILENAME
mkdir mnt
sudo mount -o loop $FILENAME mnt
mkdir extract-cd
sudo rsync --exclude=/casper/filesystem.squashfs -a mnt/ extract-cd
sudo unsquashfs mnt/casper/filesystem.squashfs
sudo mv squashfs-root edit
sudo cp /etc/resolv.conf edit/etc/
sudo mount --bind /dev/ edit/dev
sudo chroot edit
sudo mount -t proc none /proc
sudo mount -t sysfs none /sys
sudo mount -t devpts none /dev/pts
sudo umount /proc || sudo umount -lf /proc
sudo umount /sys
sudo umount /dev/pts
exit
sudo umount edit/dev
chmod +w extract-cd/casper/filesystem.manifest
sudo su
chroot edit dpkg-query -W --showformat='${Package} ${Version}\n' > extract-cd/casper/filesystem.manifest
exit
sudo cp extract-cd/casper/filesystem.manifest extract-cd/casper/filesystem.manifest-desktop
sudo sed -i '/ubiquity/d' extract-cd/casper/filesystem.manifest-desktop
sudo sed -i '/casper/d' extract-cd/casper/filesystem.manifest-desktop
sudo mksquashfs edit extract-cd/casper/filesystem.squashfs -comp xz -e edit/boot
sudo su
printf $(du -sx --block-size=1 edit | cut -f1) > extract-cd/casper/filesystem.size
exit
cd extract-cd
sudo rm md5sum.txt
find -type f -print0 | sudo xargs -0 md5sum | grep -v isolinux/boot.cat | sudo tee md5sum.txt
sudo mkisofs -D -r -V "$IMAGE_NAME" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o "../$IMAGE_NAME" .
