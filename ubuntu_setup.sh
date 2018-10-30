#!/bin/bash

packages=(
    firefox
    vagrant
    git
    remmina
    remmina-plugin-rdp
    zsh
    vim
    openssh-server
    htop
    virtualbox-qt
    virtualbox-guest-additions-iso
    docker.io
    tree
    jq
)

# Update the system
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

# Make sure this is installed otherwise we cannot use the command add-apt-repository
sudo apt install software-properties-common -y


# VSCodium
echo 'Downloading and installing VSCodium'
location='/tmp/VSCodium.deb'
url=$(wget -O- -q --no-check-certificate https://github.com/VSCodium/vscodium/releases/latest | grep -oE '/VSCodium/vscodium/releases/download/[0-9]+.[0-9]+.[0-9]+/.*amd64\.deb')
curl --progress-bar -L -o $location "https://github.com$url"
sudo dpkg -i $location
sudo apt install -f -y
# Fixes for VSCodium
ln -s ~/.config/VSCodium '~/.config/Code - OSS'


## Nextcloud
sudo apt-add-repository ppa:nextcloud-devs/client -y
packages+=('nextcloud-client')

## Ulauncher
sudo apt-add-repository ppa:agornostal/ulauncher -y
packages+=('ulauncher')

## Spotify
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 931FF8E79F0876134EDDBDCCA87FF9DF48BF1C90
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
packages+=('spotify-client')

# Paper icons
sudo apt-add-repository ppa:snwh/ppa -y
packages+=('paper-icon-theme')


# Install packages
sudo apt update && sudo apt install -y ${packages[@]} && sudo apt autoremove -y

