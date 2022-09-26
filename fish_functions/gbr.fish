function gbr --description "git rebase, pick first commit, ff others from main/master"
    if [ (uname) = "Darwin" ]
        set -f sed_command (which gsed)
    else
        set -f sed_command (which sed)
    end
    set -l MAINMASTER  (git branch -l master main | grep -oE "(master|main)")
    GIT_SEQUENCE_EDITOR="$sed_command -i -e 's/^pick/f/g' -e '0,/^f/s//pick/1'" git rebase -i "origin/$MAINMASTER"
end