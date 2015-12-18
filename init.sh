#!/usr/bin/env bash

WORKDIR=livecdtmp
mkdir -p $WORKDIR
cd $WORKDIR
wget http://localhost/iso/ubuntu-10.04-desktop-amd64.iso
mkdir mnt
sudo mount -o loop ubuntu-10.04-desktop-amd64.iso mnt
mkdir extract-cd
sudo rsync --exclude=/casper/filesystem.squashfs -a mnt/ extract-cd
sudo unsquashfs mnt/casper/filesystem.squashfs
sudo mv squashfs-root edit
sudo cp /etc/resolv.conf edit/etc/
sudo mount --bind /dev/ edit/dev
sudo chroot edit
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts
