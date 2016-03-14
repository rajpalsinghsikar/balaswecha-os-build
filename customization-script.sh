mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts
DESKTOP_FILE_ROOT=/usr/share/applications
SKEL_DESKTOP_FILE_ROOT=/etc/skel/.local/share/applications

# Install Packages
apt-get update
apt-get install -y nodejs nodejs-legacy apache2 libapache2-mod-php5 libapache2-mod-python openjdk-7-jre pepperflashplugin-nonfree
update-pepperflashplugin-nonfree --install
apt-get install -y celestia geogebra kgeography kalzium kbruch stellarium step tuxmath openshot audacity chromium-browser openteacher khangman

# Move files
cp -R /build/opt/* /opt/
cp -R /build/var/www /var/

# Create Symlinks
rm -rf /usr/bin/firefox
ln -s /usr/bin/chromium-browser /usr/bin/firefox
ln -s /usr/bin/libreoffice /usr/bin/doc-reader
ln -s /usr/bin/evince /usr/bin/pdf-reader

# Create launcher shortcuts
mkdir -p $SKEL_DESKTOP_FILE_ROOT
cp $DESKTOP_FILE_ROOT/openshot.desktop $SKEL_DESKTOP_FILE_ROOT/
cp $DESKTOP_FILE_ROOT/audacity.desktop $SKEL_DESKTOP_FILE_ROOT/
cp $DESKTOP_FILE_ROOT/pencilbox.desktop $SKEL_DESKTOP_FILE_ROOT/
umount /proc || sudo umount -lf /proc
umount -lf /sys
umount -lf /dev/pts
