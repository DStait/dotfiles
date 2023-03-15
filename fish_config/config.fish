# PATH 
fish_add_path ~/bin
fish_add_path ~/.local/bin

set -xg EDITOR 'vim'

# Secrets to be kept out of git
if test -e ~/.config/fish/fish_secrets
  source ~/.config/fish/fish_secrets
end

if [ (uname) = "Darwin" ]
  set -l HOMEBREW_PREFIX "/opt/homebrew"

  fish_add_path "$HOMEBREW_PREFIX/bin"
  alias brew='arch -arm64 /opt/homebrew/bin/brew'
  alias brewx='arch -x86_64 /usr/local/bin/brew'

  fish_add_path "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin"
  fish_add_path "$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin"
end

alias dl "cd ~/Downloads"
alias dt "cd ~/Desktop"
# Git commands
alias gs "git status"
alias gp "git pull"
alias ga "git add"
alias gc "git commit -m"
alias gd 'git diff'
alias grb 'git rebase -i origin/master' 
alias gcom 'git checkout main 2> /dev/null || git checkout master'
alias gqc 'git add -A; and gc "a"; and gbr'
alias git-delete-merged-branches 'git fetch --prune && git branch --merged | egrep -v "(^\*|master|main)" | xargs git branch -d'

# Git check-ignore alternative
alias gitcheckignore 'git clean -dXn'

# jq pipe to less with color
alias jql='jq -C | less'

# add svn unversioned files
alias svn-add-unversioned "svn st | grep '^\?' | sed 's/^\? *//' | xargs -I% svn add %"
alias digs 'dig +short'

alias whoamiaws "aws sts get-caller-identity"

# brew
alias bi "brew install"
alias bci "brew install --cask"

source /Users/dominicstait/.docker/init-fish.sh || true # Added by Docker Desktop
