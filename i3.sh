printf '\n\nInstall i3\n\n'
sleep 2
sudo apt install i3 xorg tint2 i3blocks rofi kitty -y

printf '\n\nInstall i3-gaps\n\n'
sleep 2

cd ~/tmp
git clone https://github.com/renanreboredo/i3-gaps-deb.git
cd i3-gaps-deb
./i3-gaps-deb

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