function update
    set -l OS_TYPE (uname)



    switch $OS_TYPE
        case "Darwin"
            _print_color "green" ">> Updating brew"
            brew update
            _print_color "green" ">> Updating brew formulae"
            brew upgrade
            _print_color "green" ">> Updating brew casks"
            brew cu -y -q --cleanup
            _print_color "green" ">> Update App store apps"
            mas upgrade

        case "Linux"
            _print_color "green" ">> Prompt for sudo" 
            sudo echo >/dev/null
            _print_color "green" ">> Updating repos"
            sudo apt update
            _print_color "green" ">> Updating packages"
            sudo apt upgrade -y 
            if command -v snap-store >/dev/null
                _print_color "green" ">> Killing snap store processes" 
                sudo killall snap-store
                _print_color "green" ">> Refreshing snap store" 
                sudo snap refresh
            end
            if command -v flatpak >/dev/null
                _print_color "green" ">> Updating flatpak apps"
                flatpak update -y
            end
            _print_color "green" ">> Remove unneeded packages" 
            sudo apt autoremove -y 
            if test -e "/var/run/reboot-required"
                _print_color "red" "!!! Reboot required !!!"
            end
    end
end


function _print_color
    set -l COLOR_REQ $argv[1]
    set -l STRING $argv[2..-1] 
    set -l NORMAL "\e[0m"

    switch $COLOR_REQ
        case "green"
            set -f COLOR "\e[1;32m"
        case "red"
            set -f COLOR "\e[1;31m"
    end
    
    printf "\n$COLOR$STRING$NORMAL\n"
end

