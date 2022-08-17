#!/bin/bash

packages=(
    firefox
    git
    vim
    openssh-server
    htop
    docker.io
    tree
    jq
    python3
    python3-pip
    python3-venv
)

# Update the system
sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y

# Make sure this is installed otherwise we cannot use the command add-apt-repository
sudo apt install software-properties-common -y

# Install packages
sudo apt update && sudo apt install -y ${packages[@]} && sudo apt autoremove -y

