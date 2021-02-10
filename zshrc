# Set name of the theme to load. Themes at: https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="oxide"

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
  svn
  docker
  docker-compose
  git
  kitchen
)


# use cdpath var for auto cd
setopt auto_cd
# Don't add to history when prefixed with space
setopt HIST_IGNORE_SPACE
# Set default user - Hides name when this matches
DEFAULT_USER=$(whoami)
# Darwin or Linux
PLATFORM=$(uname)


#############################
##          MacOS          ##
#############################

if [[ $PLATFORM == 'Darwin' ]]; then
  export PATH="/Users/$DEFAULT_USER/bin:/usr/local/opt/mysql-client/bin:/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.6.0/bin:/usr/local/opt/gnu-sed/libexec/gnubin:/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:$PATH"
  export ZSH=/Users/$DEFAULT_USER/.oh-my-zsh
  # source ZSH Autosuggestions & highlighting
  source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  # z install
  source /usr/local/etc/profile.d/z.sh
  # update Homebrew and its installed packages, uses mas to update apps installed from the App Store
  alias update='brew update; brew upgrade; brew cu -y -q --cleanup;mas upgrade'
  alias flush_dns="sudo killall -HUP mDNSResponder" 
  alias clearKeyboardSettings='sudo rm /Library/Preferences/com.apple.keyboardtype.plist'
  alias dsf='diff-so-fancy | less -RFX'
fi


#############################
##          Linux          ##
#############################

if [[ $PLATFORM == 'Linux' ]]; then
  export ZSH=/home/$DEFAULT_USER/.oh-my-zsh
fi


#############################
##         Global          ##
#############################

export EDITOR=$(which vim)
setopt shwordsplit

# Source oh-my-zsh, functions, local settings and custom autocomplete
source $ZSH/oh-my-zsh.sh
if [ -f ~/.zsh_functions ]; then source ~/.zsh_functions; fi
if [ -f ~/.zsh_local ]; then source ~/.zsh_local; fi
if [ -f ~/.zsh_custom_autocomplete ]; then source ~/.zsh_custom_autocomplete; fi

# Add username and hostname if user is over ssh
if [ -n "$SSH_CLIENT" ]; then
  PROMPT="$(whoami)@$(hostname) "$PROMPT
fi

## Aliases
alias dl="cd ~/Downloads"
alias dt="cd ~/Desktop"
# Color ls
alias ls="ls --color=auto"
# Easy ls with details
alias ll='ls -lah --color=auto' 
alias l='ls -1' 
# Git commands
alias gs="git status -s"
alias gp="git pull"
alias ga="git add"
alias gc="git commit -m"
alias gd='git diff'
# Git check-ignore alternative
alias gitcheckignore='git clean -dXn'
# jq pipe to less with color
alias jql='jq -C | less'
# add svn unversioned files
alias svn-add-unversioned="svn st | grep '^\?' | sed 's/^\? *//' | xargs -I% svn add %"
alias digs='dig +short'
alias h='history'

# Functions
function to() {
    q=" $*"
    q=${q// -/ !}
    cd $(fzf -1 +m -q "$q" < ~/.config/to)
    return
}
function bm() {
    mkdir -p ~/.cache
    touch ~/.config/to
    if egrep $PWD'$' ~/.config/to
    then
        echo ...already exists
    else
        echo "$PWD" >> ~/.config/to
    fi
}