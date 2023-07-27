function gqc
    set -l GIT_STATUS_UNTRACKED "??"
    set -l GIT_STATUS_DELETED "D"
    set -l GIT_FILES (git status --short)

    for FILE in $GIT_FILES
        set -l FILE_STATUS (echo "$FILE" | cut -d " " -f 1)

        # file should not be deleted or untracked
        if [ $FILE_STATUS = $GIT_STATUS_DELETED ]; or [ $FILE_STATUS = $GIT_STATUS_UNTRACKED ]
            continue
        end

        # check file extension and call formatter function
        set -l FILE_NAME (echo "$FILE" | awk {'print $2'})
        format-file "$FILE_NAME"
    end

    # Add all tracked files
    git add -u

    # dummy commit
    git commit -m "gqc"

    # rebase
    gbr
end
