function j
    cd $argv
end


function _j_complete
  fd '.git' -H -t d  "$HOME/work/" -x dirname
end

complete -c j -f 
complete -c j -n "not __fish_seen_subcommand_from (_j_complete)" -a "(_j_complete)"
