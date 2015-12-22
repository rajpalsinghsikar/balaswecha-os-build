#!/usr/bin/env bash

WORKDIR=livecdtmp
FILENAME=ubuntu-10.04-amd64.iso

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
umount /proc || umount -lf /proc
umount /sys
umount /dev/pts
exit
sudo umount edit/dev
