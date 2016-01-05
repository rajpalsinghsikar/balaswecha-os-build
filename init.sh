#!/usr/bin/env bash

WORKDIR=livecdtmp
FILENAME=ubuntu-14.04.3-desktop-amd64.iso
IMAGE_NAME=balaswecha-14.04-amd64.iso

mkdir -p $WORKDIR
cd $WORKDIR
cp ../$FILENAME .
mkdir mnt
sudo mount -o loop $FILENAME mnt
echo "Mounting Loop Done"
mkdir extract-cd
sudo rsync --exclude=/casper/filesystem.squashfs -a mnt/ extract-cd
sudo unsquashfs mnt/casper/filesystem.squashfs
echo "Unsquashing Done"
sudo mv squashfs-root edit
sudo cp ../script.sh edit/
sudo cp ../sources.list edit/etc/apt/
sudo cp /etc/resolv.conf edit/etc/
sudo mount --bind /dev/ edit/dev
echo "Entering chroot"

sudo chroot edit /bin/bash /script.sh
echo "Exitting chroot"
sudo umount -lf edit/dev
sudo chmod +w extract-cd/casper/filesystem.manifest
sudo chroot edit sh -c 'dpkg-query -W --showformat='${Package} ${Version}\n' > extract-cd/casper/filesystem.manifest'
echo "Done writing into manifest file"
sudo cp extract-cd/casper/filesystem.manifest extract-cd/casper/filesystem.manifest-desktop
sudo sed -i '/ubiquity/d' extract-cd/casper/filesystem.manifest-desktop
sudo sed -i '/casper/d' extract-cd/casper/filesystem.manifest-desktop
sudo mksquashfs edit extract-cd/casper/filesystem.squashfs -comp xz -e edit/boot
echo "mksquashfs Done"
sudo sh -c 'printf $(du -sx --block-size=1 edit | cut -f1) > extract-cd/casper/filesystem.size'
cd extract-cd
sudo rm md5sum.txt
find -type f -print0 | sudo xargs -0 md5sum | grep -v isolinux/boot.cat | sudo tee md5sum.txt
echo "Starting ISO creation"
sudo mkisofs -D -r -V "$IMAGE_NAME" -cache-inodes -J -l -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o "../$IMAGE_NAME" .
echo "Done"
