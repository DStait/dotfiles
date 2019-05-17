
# Set name of the theme to load. Themes at: https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="false"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Command auto-correction.
ENABLE_CORRECTION="false"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="yyyy-mm-dd"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
  vagrant
)



# Set default user - Hides name when this matches
DEFAULT_USER=$(whoami)

PLATFORM=$(uname)


#############################
##          MacOS          ##
#############################

if [[ $PLATFORM == 'Darwin' ]]; then
  #export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/opt/python/libexec/bin:/usr/local/bin:$PATH"
  export PATH="/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:$PATH"
  export ZSH=/Users/$DEFAULT_USER/.oh-my-zsh

  # source ZSH Autosuggestions & highlighting
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  # Get macOS Software Updates, updates Homebrew and its installed packages, uses mas to update apps installed from the App Store
  alias update='sudo softwareupdate -i -a;brew update; brew upgrade; brew cu -y -a --cleanup;mas upgrade'

  # IP address - 13 charaters from the start to line up ip address'
  alias ip='echo "Public:      $(dig +short myip.opendns.com @resolver1.opendns.com)"; echo "Wireless:    $(ipconfig getifaddr en0)"; echo "Thunderbolt: $(ipconfig getifaddr en3)"'
fi


#############################
##          Linux          ##
#############################

if [[ $PLATFORM == 'Linux' ]]; then
  export ZSH=/home/$DEFAULT_USER/.oh-my-zsh

  ## Set EDITOR to /usr/bin/vim if Vim is installed
  if [ -f /usr/bin/vim ]; then
    export EDITOR=/usr/bin/vim
  fi

fi



#############################
##         Global          ##
#############################

# Source oh-my-zsh 
source $ZSH/oh-my-zsh.sh

if [ -f ~/.zsh_profile ]; then
  source ~/.zsh_profile
fi

if [ -n "$SSH_CLIENT" ]; then
  PROMPT="$(whoami)@$(hostname) "$PROMPT
fi

## Aliases

# Easier navigation: .., ..., ...., .....
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"

# Color ls
alias ls="ls --color=auto"

# Easy ls with details
alias ll='ls -lah --color=auto' 

# Git commands
alias gs="git status"
alias gp="git push"
alias ga="git add"
alias gc="git commit -m"
alias gd='git diff'

# Vagrant Commands
alias vag='vagrant'
alias vagup='vagrant up'
alias vagdestroy='vagrant destroy -f'
alias vagssh='vagrant ssh'
alias vaghalt='vagrant halt'

alias findip="grep -E -o '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)'"

# bat (cat alternative)
alias bat='bat -n'


