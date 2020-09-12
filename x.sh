printf '\n\nInstall i3\n\n'
sleep 2
sudo apt install i3 xorg tint2 i3blocks rofi kitty -y

printf '\n\nInstall i3-gaps\n\n'
sleep 2

sudo apt install -y build-essential autoconf xutils-dev libtool automake dh-autoreconf libxcb-keysyms1-dev libpango1.0-dev \
libxcb-util0-dev xcb libxcb1-dev libxcb-icccm4-dev libyajl-dev libev-dev libxcb-xkb-dev libxcb-cursor-dev libxkbcommon-dev \ 
libxcb-xinerama0-dev libxkbcommon-x11-dev libstartup-notification0-dev libxcb-randr0-dev libxcb-xrm0 libxcb-xrm-dev \
libxcb-shape0 libxcb-shape0-dev

cd ~/tmp
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
rm ~/.config/i3/config ~/.config/rofi/config 
cp i3/config ~/.config/i3/config
cp i3/i3blocks.conf ~/.config/i3/i3blocks.conf
cp i3/scripts ~/.config/i3/scripts
cp rofi/config ~/.config/rofi/config
cp kitty/kitty.conf ~/.config/kitty/kitty.conf
cp /etc/X11/xinit/xinitrc ~/.xinitrc
echo 'exec i3' >> ~/.xinitrc
mkdir ~/Pictures
cd ~/tmp/debian-init
cp wallpaper.jpg ~/Pictures
startx