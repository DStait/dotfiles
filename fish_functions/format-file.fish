function format-file
    set -l FILES $argv

    for FILE in $FILES

        # Don't bother with directories
        if test -d "$FILE"
            continue
        end

        # Check our ignored file types
        if ! _check_ignored_format_file "$FILE"
            return
        end

        set -l FILE_EXT (path extension "$FILE")
        switch "$FILE_EXT"
            case ".py"
                _format_py_file "$FILE"
            
            case ".tf" ".tfvars"
                _format_tf_file "$FILE"
            
            case ".json"
                _format_json_file "$FILE"

            case "*"
                printf "%s%s%s not formatted. No formatter configured\n" (set_color red) "$FILE" (set_color normal)
                continue
        end

        printf "%s%s%s formatted.\n" (set_color green) "$FILE" (set_color normal)

    end
end

function _check_ignored_format_file
    set -l FILE "$argv"
    set -l IGNORED_FILES \
        "$HOME/Library/Application Support/Code/User/settings.json" 

    if contains $FILE $IGNORED_FILES
        printf "%s%s%s not formatted as it is in ignored file list.\n" (set_color blue) "$FILE" (set_color normal)
        return 1
    end
    
    return
end

function _format_py_file
    set -l FILE "$argv"
    black --line-length 88 --quiet "$FILE"
end

function _format_tf_file
    set -l FILE "$argv"
    terraform fmt "$FILE"
end

function _format_json_file
    set -l FILE "$argv"
    set -l FILE_TEMP "$FILE.tmp"

    jq --indent 4 . "$FILE" > "$FILE_TEMP"
    mv -f "$FILE_TEMP" "$FILE"
end
