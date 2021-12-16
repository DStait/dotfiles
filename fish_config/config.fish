# PATH 
fish_add_path ~/bin
fish_add_path /opt/homebrew/bin
# Secrets to be kept out of git
if test -e ~/.config/fish/fish_secrets
  source ~/.config/fish/fish_secrets
end

alias vim "nvim"
alias vag "vagrant"

alias dl "cd ~/Downloads"
alias dt "cd ~/Desktop"
# Git commands
alias gs "git status -s"
alias gp "git pull"
alias ga "git add"
alias gc "git commit -m"
alias gd 'git diff'

# Git check-ignore alternative
alias gitcheckignore 'git clean -dXn'

# jq pipe to less with color
alias jql='jq -C | less'

# add svn unversioned files
alias svn-add-unversioned "svn st | grep '^\?' | sed 's/^\? *//' | xargs -I% svn add %"
alias digs 'dig +short'
