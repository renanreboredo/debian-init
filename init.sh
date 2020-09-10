printf '\n\nUpdating system\n\n'
sleep 2
sudo apt update && sudo apt upgrade

printf '\n\nInstalling Liquorix kernel\n\n'
sleep 2
curl 'https://liquorix.net/add-liquorix-repo.sh' | sudo bash
sudo apt install linux-image-liquorix-amd64 linux-headers-liquorix-amd64 -y

printf '\n\nInstalling nix package manager\n\n'
sleep 2
sudo mkdir /nix && sudo chown rebores /nix
curl -L https://nixos.org/nix/install | sh
. /home/rebores/.nix-profile/etc/profile.d/nix.sh


printf '\n\nAdding nixpkgs-unstable channel\n\n'
sleep 2
nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
nix-channel --update nixos-unstable

printf '\n\nAdding home-manager\n\n'
sleep 2
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update
export NIX_PATH=$HOME/.nix-defexpr/channels${NIX_PATH:+:}$NIX_PATH
nix-shell '<home-manager>' -A install
