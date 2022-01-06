

# Pass source dir, dest dir
function symlink_files() {
    local source_dir="$1"
    local dest_dir="$2"
    local timeNow=$(date "+%F-%H%M%S")
    local backupDirName="symlinkBackup-${timeNow}"

    # Make sure dest directory exists
    mkdir -p $dest_dir

    for file in $(ls -A $source_dir); do
        # If file exists and is not a symlink we back it up
        if [[ -f "${dest_dir}/${file}" && ! -L "${dest_dir}/${file}" ]]; then
            mkdir "${dest_dir}/${backupDirName}" 2> /dev/null
            mv "${dest_dir}/${file}" "${dest_dir}/${backupDirName}"
            echo "Moved original file ${dest_dir}/${file} to ${dest_dir}/${backupDirName}"
        fi

        echo "Linking ${source_dir}/${file} into ${dest_dir}"
        ln -fs ${source_dir}/${file} ${dest_dir}/${file}
    done
}

function install_zsh () {
    # Test to see if zshell is installed.  If it is:
    if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
        # Clone my oh-my-zsh repository from GitHub only if it isn't already present
        if [[ ! -d ~/.oh-my-zsh/ ]]; then
            git clone http://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
        fi
        # Install zsh theme
        if [[ ! -f ~/.oh-my-zsh/themes/oxide.zsh-theme ]]; then
            curl -LJ https://raw.githubusercontent.com/dikiaap/dotfiles/master/.oh-my-zsh/themes/oxide.zsh-theme -o ~/.oh-my-zsh/themes/oxide.zsh-theme 
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

function install_fish() {

    # MacOS - Test to see if fish is installed.
    if [ -f /opt/homebrew/bin/fish ] && [ $PLATFORM == 'Darwin' ]; then

        # Add to /etc/shells
        if ! grep fish /etc/shells ; then
            echo "Adding fish to /etc/shells"
            command -v fish | sudo tee -a /etc/shells
        fi

        # Set fish as shell
        if [ $(command -v fish) != $SHELL ]; then
            echo "Set fish as shell"
            chsh -s $(command -v fish)
        fi
    # We only have to install fisher on Linux
    elif [ -f /usr/bin/fish ] && [ $PLATFORM == 'Linux' ]; then 
        install_fisher
    else
        # Install fish shell
        if [[ $PLATFORM == 'Linux' ]]; then
            if [[ -f /etc/debian_version ]]; then
                echo "Fish is not installed, installing now.."
                sudo apt-add-repository ppa:fish-shell/release-3 -y
                sudo apt-get update
                sudo apt-get install fish -y
                install_fish
                install_fisher
            fi
        elif [[ $PLATFORM == 'Darwin' ]]; then
            echo "Fish is not installed, installing now.."
            brew install fish
            install_fish
        fi
    fi
}

function install_fisher() {
    echo "Install fisher and plugins"
    fish -c "curl -sL https://git.io/fisher | source && fisher update"
}
