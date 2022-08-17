function venv --description "Creates a python venv"
    set -l COMMAND "$argv[1]" 
    set -l NAME "$argv[2]"

    set -l VENV_DIR "$HOME/.python-venvs"
    set -l CONF_FILE "$VENV_DIR/config"
    set -l CUR_DIR (pwd)

    mkdir -p $VENV_DIR

    if not test -f $CONF_FILE
        echo "NAME,DIRECTORY" > $CONF_FILE
    end

    switch $COMMAND 
        case "list"
            if test (wc -l $CONF_FILE) = "1 $CONF_FILE"
                echo "No virtual environments created."
            else 
                column -t -s "," $CONF_FILE
            end

        case "create"
            # check if venv already exists
            if not _venv_check $CONF_FILE $NAME
                python3 -m venv "$VENV_DIR/$NAME"
                echo "$NAME,$CUR_DIR" >> $CONF_FILE
            else
                echo "venv $NAME already exists"
            end
            
        case "delete"
            if _venv_check $CONF_FILE $NAME
                # check if the venv is currently active
                if type -q deactivate
                    deactivate
                end
                sed -i "/^$NAME,/d" $CONF_FILE
                rm -rf $VENV_DIR/$NAME
            else
                echo "venv $NAME doesn't exist."
            end

        case "activate"
            if _venv_check $CONF_FILE $NAME
                source $VENV_DIR/$NAME/bin/activate.fish
            else
                echo "venv $NAME doesn't exist. Please create it first"
            end
    end
end


function _venv_check --description "return true if venv exists"
    set -l CONF_FILE $argv[1]
    set -l NAME $argv[2]

    if [ (cut -d "," -f 1 $CONF_FILE |  grep -E  "^$NAME\$") ]
        return 0
    else
        return 1
    end
end


# Disable file completions
complete -c venv -f

# Command that can autocomplete the venvs
set -l commands activate delete
# All available commands
set -l commands_all list activate create delete

complete -x -c venv \
    -n "__fish_seen_subcommand_from $commands" \
    -a "(tail -n+2 $HOME/.python-venvs/config | sed -e 's/,/\\t/g')"

complete -x -c venv -n "not __fish_seen_subcommand_from $commands_all" -a "$commands_all"
