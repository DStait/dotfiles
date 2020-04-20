#!/bin/bash

########## Variables

dir=~/dotfiles                                      # dotfiles directory
olddir=~/dotfiles_old                               # old dotfiles backup directory
files="vimrc zshrc iterm tmux.conf"                 # list of files/folders to symlink in homedir
PLATFORM=$(uname)                                   # Linux or Darwin (MacOS)


########## Functions

install_zsh () {
# Test to see if zshell is installed.  If it is:
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d ~/.oh-my-zsh/ ]]; then
        git clone http://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh)
    fi
else
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $PLATFORM == 'Linux' ]]; then
        if [[ -f /etc/redhat-release ]]; then
            sudo yum install zsh -y
            install_zsh
        fi
        if [[ -f /etc/debian_version ]]; then
            sudo apt-get install zsh -y
            install_zsh
        fi
    # If the platform is MacOS, inform to install zsh and Exit. (Shouldn't ever get here)
    elif [[ $PLATFORM == 'Darwin' ]]; then
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}


# Make sure xcode is installed
if [[ ! $(xcode-select -p ) ]]; then
  xcode-select --install
fi


# Check if MacOS & install homebrew if it is (Needed for git install)
if [[ $PLATFORM == 'Darwin' ]]; then
  # Check if Homebrew installed 
  if [[ ! $(which brew) ]]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
fi

# Check if git is installed, install if not
if [ ! $(which git) ]; then
  if [[ -f /etc/debian_version ]]; then
    sudo apt install git -y
  fi
  if [[ -f /etc/redhat-release ]]; then
    sudo yum install git -y
  fi
  if [[ $PLATFORM == 'Darwin' ]]; then
    brew install git
  fi
fi


# Clone dotfiles repo
git clone https://github.com/MrNimmy/dotfiles.git ~/dotfiles

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# move any existing dotfiles in homedir to dotfiles_old directory, 
# then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    echo "Moving any existing dotfiles from ~ to $olddir"
    mv ~/.$file ~/dotfiles_old/
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

# Mac Setup
if [[ $PLATFORM == 'Darwin' ]]; then
  # Keep-alive: update existing `sudo` time stamp 
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
  brew update                 # Make sure we’re using the latest Homebrew.
  brew upgrade                # Upgrade any already-installed formulae.
  brew tap homebrew/bundle    # Install bundle to install our Apps later on
  brew bundle                 # Install Applications
  source macos                # Set my MacOS settings
  touch ~/.hushlogin
fi

# Ubuntu Setup
if [[ -f /etc/debian_version ]]; then
  source ubuntu_setup.sh
fi



# Global Setup
install_zsh
# Set git to use ssh not https
git remote set-url origin git@github.com:mrnimmy/dotfiles.git

