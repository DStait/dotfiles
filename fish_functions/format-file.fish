function format-file
    set -l FILE "$argv"
    set -l FILE_EXT (path extension "$FILE")

    switch "$FILE_EXT"
        case ".py"
            _format_py_file "$FILE"
        
        case ".tf" ".tfvars"
            _format_tf_file "$FILE"
        
        case ".json"
            _format_json_file "$FILE"

        case "*"
            echo "No formatter configured for filetype: $FILE_EXT"
    end

    
end


function _format_py_file
    set -l FILE "$argv"
    black --line-length 79 --quiet "$FILE"
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
