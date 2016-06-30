mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts

export HOME=/etc/skel

DESKTOP_FILE_ROOT=/usr/share/applications
SKEL_DESKTOP_FILE_ROOT=$HOME/.local/share/applications
CHROME_EXTN_ROOT=$HOME/.config/chromium/Default/Extensions
PENCILBOX_DIR="pencilbox-2-master"

mkdir -p $SKEL_DESKTOP_FILE_ROOT
mkdir -p $CHROME_EXTN_ROOT

# Install Packages
apt-get update
apt-get install -y apache2 nodejs nodejs-legacy npm openjdk-7-jre pepperflashplugin-nonfree
update-pepperflashplugin-nonfree --install
apt-get install -y celestia geogebra kgeography kalzium kbruch stellarium step tuxmath openshot audacity chromium-browser openteacher khangman artha shutter tuxtype tuxpaint turtleart marble kazam calibre freemind gimp inkscape vlc kwordquiz kturtle gcompris klettres ibus-m17n
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections
apt-get install -y ubuntu-restricted-extras

rm -f /var/cache/apt/archives/*.deb
#look at scratch2

# Configuration changes
sed -i -e 's/var\/www\/html/var\/www/g' /etc/apache2/sites-available/000-default.conf

# Pencilbox Setup
wget https://github.com/balaswecha/pencilbox-2/archive/master.zip
unzip master.zip
#rm -rf /var/www
mv $PENCILBOX_DIR/app/* /var/www/
mv /var/app /var/www
chown -R www-data:www-data /var/www
mv $PENCILBOX_DIR /opt/electron
sed -i "/mainWindow.loadURL/c\mainWindow.loadURL('http:\/\/localhost');" /opt/electron/main.js
sed -i "/\/js\/BalaSwechaInitialData.txt/c\var dumpFile = '\/var\/www\/js\/BalaSwechaInitialData.txt';" /var/www/js/pre-populator.js
cd /opt/electron
npm install

# Move files
cp -R /build/opt/* /opt/
cp -R /build/mindmup/eealagocaipaflcjmeapmobpmilffopi $CHROME_EXTN_ROOT/
cp /build/mindmup/chrome-eealagocaipaflcjmeapmobpmilffopi-Default.png /usr/share/icons/
cp /build/mindmup/chrome-eealagocaipaflcjmeapmobpmilffopi-Default.desktop $DESKTOP_FILE_ROOT
chmod 644 $DESKTOP_FILE_ROOT/chrome-eealagocaipaflcjmeapmobpmilffopi-Default.desktop
chmod 644 /usr/share/icons/chrome-eealagocaipaflcjmeapmobpmilffopi-Default.png
cp /build/Preferences $CHROME_EXTN_ROOT/../
mv /build/videos /var/www/

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

###### Branding Changes ########

# Regenerate default Schemas
glib-compile-schemas /usr/share/glib-2.0/schemas

# Set the login background

# Creating test user for adding lightdm to acl of xhost (root is not allowed to add)
echo -e "test\ntest\n" | adduser test
su test -s /bin/bash -c "xhost +SI:localuser:lightdm"
deluser test

dbus-uuidgen >/var/lib/dbus/machine-id # needs to exist for running below commands
su lightdm -s /bin/bash -c "gsettings set com.canonical.unity-greeter draw-grid false"
su lightdm -s /bin/bash -c "gsettings set com.canonical.unity-greeter draw-user-backgrounds true"
su lightdm -s /bin/bash -c "gsettings set com.canonical.unity-greeter background /usr/share/backgrounds/balaswecha-dark.png"

umount /proc || sudo umount -lf /proc
umount -lf /sys
umount -lf /dev/pts
