function gbr --description "git rebase, pick first commit, ff others from main/master"
    set -l MAINMASTER  (git branch -l master main | grep -oE "(master|main)")
    GIT_SEQUENCE_EDITOR="sed -i -e 's/^pick/f/g' -e '0,/^f/s//pick/1'" git rebase -i "origin/$MAINMASTER"
end