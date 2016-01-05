mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts
apt-get update
apt-get install -y nodejs
umount /proc || sudo umount -lf /proc
umount -lf /sys
umount -lf /dev/pts
