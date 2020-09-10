apt update && apt install sudo
usermod -aG sudo rebores
echo '%rebores ALL=(ALL) ALL' >> /etc/sudoers

