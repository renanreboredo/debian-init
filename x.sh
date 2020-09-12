printf '\n\nInstall i3\n\n'
sleep 2
sudo apt install i3 xorg tint2

printf '\n\nInstall i3-gaps\n\n'
sleep 2

sudo apt install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev libxcb-icccm4-dev libyajl-dev /
libstartup-notification0-dev libxcb-randr0-dev libev-dev libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev  / 
libxkbcommon-dev libxkbcommon-x11-dev libxcb-xrm-dev autoconf xutils-dev libtool automake

cd tmp
git clone https://www.github.com/Airblader/i3 i3-gaps
cd i3-gaps
git checkout gaps && git pull
autoreconf --force --install
rm -rf build
mkdir build
cd build
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
sudo make install

printf '\n\nConfigure i3\n\n'
sleep 2
cd ~/tmp 
git clone https://github.com/renanreboredo/dotfiles.git
cd dotfiles
cp i3/config ~/.config/i3/config
cp /etc/X11/xinit/xinitrc ~/.xinitrc
echo 'exec i3' >> ~/.xinitrc
cd ~/tmp/debian-init
mkdir Pictures
cp wallpaper.jpg Pictures
startx