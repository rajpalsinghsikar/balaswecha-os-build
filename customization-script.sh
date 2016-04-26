mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts

export HOME=/etc/skel

DESKTOP_FILE_ROOT=/usr/share/applications
SKEL_DESKTOP_FILE_ROOT=$HOME/.local/share/applications
CHROME_EXTN_ROOT=$HOME/.config/chromium/Default/Extensions

mkdir -p $SKEL_DESKTOP_FILE_ROOT
mkdir -p $CHROME_EXTN_ROOT

# Install Packages
apt-get update
apt-get install -y nodejs nodejs-legacy npm apache2 libapache2-mod-php5 libapache2-mod-python openjdk-7-jre pepperflashplugin-nonfree
update-pepperflashplugin-nonfree --install
apt-get install -y celestia geogebra kgeography kalzium kbruch stellarium step tuxmath openshot audacity chromium-browser openteacher khangman artha shutter tuxtype tuxpaint turtleart marble kazam calibre freemind gimp inkscape ubuntu-restricted-extras vlc kwordquiz kturtle gcompris klettres ibus-m17n
#look at scratch2

# Move files
cp -R /build/opt/* /opt/
cp -R /build/var/www/* /var/www/html/
cp -R /build/mindmup/eealagocaipaflcjmeapmobpmilffopi $CHROME_EXTN_ROOT/
cp /build/mindmup/chrome-eealagocaipaflcjmeapmobpmilffopi-Default.png /usr/share/icons/
cp /build/mindmup/chrome-eealagocaipaflcjmeapmobpmilffopi-Default.desktop $DESKTOP_FILE_ROOT
chmod 644 $DESKTOP_FILE_ROOT/chrome-eealagocaipaflcjmeapmobpmilffopi-Default.desktop
chmod 644 /usr/share/icons/chrome-eealagocaipaflcjmeapmobpmilffopi-Default.png
cp /build/Preferences $CHROME_EXTN_ROOT/../

# Create Symlinks
rm -rf /usr/bin/firefox
ln -s /usr/bin/chromium-browser /usr/bin/firefox
ln -s /usr/bin/libreoffice /usr/bin/doc-reader
ln -s /usr/bin/evince /usr/bin/pdf-reader

# Create launcher shortcuts
cp $DESKTOP_FILE_ROOT/openshot.desktop $SKEL_DESKTOP_FILE_ROOT/
cp $DESKTOP_FILE_ROOT/audacity.desktop $SKEL_DESKTOP_FILE_ROOT/
cp $DESKTOP_FILE_ROOT/pencilbox.desktop $SKEL_DESKTOP_FILE_ROOT/
cp $DESKTOP_FILE_ROOT/chrome-eealagocaipaflcjmeapmobpmilffopi-Default.desktop $SKEL_DESKTOP_FILE_ROOT/

# Regenerate default Schemas
glib-compile-schemas /usr/share/glib-2.0/schemas

umount /proc || sudo umount -lf /proc
umount -lf /sys
umount -lf /dev/pts
