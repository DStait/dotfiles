## Functions
# Anything that can't be put into the fish_functions dir because
# it's needed before they can be copied over.
function _source_file_if_exists
    set -l file "$argv"
    if test -e "$file"
        source "$file"
    end
end

# Simple prompt for when using vscode
if [ "$TERM_PROGRAM" = "vscode" ]
    function fish_prompt
        echo ""
        set -l dir (basename (pwd))
        echo "[$status] $dir > "
    end
end

# PATH 
fish_add_path ~/bin
fish_add_path ~/.local/bin

set -xg EDITOR 'nvim'
set -xg FZF_DISABLE_KEYBINDINGS 1

# Secrets to be kept out of git
_source_file_if_exists "$HOME/.config/fish/fish_secrets"
# Other files to source
_source_file_if_exists "/opt/homebrew/opt/asdf/libexec/asdf.fish"
_source_file_if_exists "$HOME/.docker/init-fish.sh"

zoxide init fish | source

# MacOS Settings
if [ (uname) = "Darwin" ]
  set -l HOMEBREW_PREFIX "/opt/homebrew"

  fish_add_path "$HOMEBREW_PREFIX/bin"
  alias brew='arch -arm64 /opt/homebrew/bin/brew'
  alias brewx='arch -x86_64 /usr/local/bin/brew'

  fish_add_path "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin"
  fish_add_path "$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin"
  fish_add_path "$HOMEBREW_PREFIX/opt/ssh-copy-id/bin"

  # Use GNU ls
  alias ls "gls"

  # brew
  alias bi "brew install"
  alias bci "brew install --cask"

  alias allowfileexec "xattr -dr com.apple.quarantine"
  alias icloud "cd $HOME/Library/Mobile\ Documents/com~apple~CloudDocs"
  alias charm "open -na PyCharm.app"
end


bind \cw backward-kill-word

alias ls "ls --color=auto"

alias dl "cd ~/Downloads"
alias dt "cd ~/Desktop"
# Git commands
alias gs "git status"
alias gp "git pull"
alias ga "git add"
alias gc "git commit -m"
alias gd 'git diff'
alias gcom 'git checkout main 2> /dev/null || git checkout master'
alias git-delete-merged-branches 'git fetch --prune && git branch --merged | egrep -v "(^\*|master|main)" | xargs git branch -d'
# Git check-ignore alternative
alias gitcheckignore 'git clean -dXn'

# jq pipe to less with color
alias jql='jq -C | less'
alias whoamiaws "aws sts get-caller-identity"

alias datenow 'date "+%F-%H-%M-%S"'
alias dr "docker run --rm -it -v (pwd):/cur_dir" 
