function field --description "Extract a field from a string using awk"
    set --local field $argv[1]
    set --local delimiter $argv[2]

    # Fish doesn't have a way of setting default values for variables
    set -q argv[1] || set field "0"
    set -q argv[2] || set delimiter " "

    awk -F "$delimiter" "{ print \$$field }"
end