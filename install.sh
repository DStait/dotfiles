#!/bin/bash

dir=~/dotfiles       # dotfiles directory
PLATFORM=$(uname)    # Linux or Darwin (MacOS)


# Check if MacOS & install requirements if needed
if [[ $PLATFORM == 'Darwin' ]]; then
  
  # Xcode
  if [[ ! $(xcode-select -p) ]]; then
    xcode-select --install
  fi

  # Homebrew
  if [[ ! $(which brew) ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  fi
fi

# Make sure git is installed. 
if [ ! $(which git) ]; then
  if [[ -f /etc/debian_version ]]; then sudo apt install git -y ; fi
  if [[ -f /etc/redhat-release ]]; then sudo yum install git -y ; fi
  if [[ $PLATFORM == 'Darwin'  ]]; then brew install git ; fi
fi


# Get dotfiles repo
if [ ! -d $dir ]; then 
  git clone https://github.com/DStait/dotfiles.git $dir && cd $dir
else 
  cd $dir && git pull
fi

source ./scripts/initial_install_functions.sh

# Symlink files into home dir
symlink_files "${dir}/homedir_config_files" ${HOME}

# Mac Setup
if [[ $PLATFORM == 'Darwin' ]]; then
  # Keep-alive: update existing `sudo` time stamp 
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
  # So brew command can be found for ARM Macs
  export PATH="/opt/homebrew/bin:$PATH"
  brew update                   # Make sure we’re using the latest Homebrew.
  brew upgrade                  # Upgrade any already-installed formulae.
  brew tap homebrew/bundle      # Install bundle to install our Apps later on
  brew bundle                   # Install Applications
  ./scripts/macos_setup.sh      # Set my MacOS settings
  touch ~/.hushlogin            # Hide login message
  ln -fs "${dir}/hammerspoon" ~/.hammerspoon 
  mkdir -p ~/Library/LaunchAgents 
  # Copy launchagent to change right option to F18 for Hyper key
  ln -fs "${dir}/com.local.KeyRemapping.plist" ~/Library/LaunchAgents/com.local.KeyRemapping.plist
  symlink_files "${dir}/fish_config" ~/.config/fish/
  install_fish
fi

# Ubuntu Setup
if [[ -f /etc/debian_version ]]; then
  symlink_files "${dir}/fish_config" ~/.config/fish/
  install_fish
  ./ubuntu_setup.sh
fi


# We use Alacritty's default Linux config directory as our storage location here.
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
