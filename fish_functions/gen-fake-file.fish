function gen-fake-file
    set -l SIZE "$argv[1]"
    set -l NAME "$argv[2]"

    if [ (uname) = "Darwin" ]
        mkfile "$SIZE" "$NAME"
    else
        head -c "$SIZE" </dev/urandom > "$NAME"
    end
end
