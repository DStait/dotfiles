function update
    set -l OS_TYPE (uname)



    switch $OS_TYPE
        case "Darwin"
            _print_green ">> Updating brew"
            brew update
            _print_green ">> Updating brew formulae"
            brew upgrade
            _print_green ">> Updating brew casks"
            brew cu -y -q --cleanup
            _print_green ">> Update App store apps"
            mas upgrade

        case "Linux"
            _print_green ">> Prompt for sudo" 
            sudo echo >/dev/null
            _print_green ">> Updating repos"
            sudo apt update
            _print_green ">> Updating packages"
            sudo apt upgrade -y 
            if command -v snap-store >/dev/null
                _print_green ">> Killing snap store processes" 
                sudo killall snap-store
                _print_green ">> Refreshing snap store" 
                sudo snap refresh
            end
            if command -v flatpak >/dev/null
                _print_green ">> Updating flatpak apps"
                flatpak update
            end
            _print_green ">> Remove unneeded packages" 
            sudo apt autoremove -y 
    end
end


function _print_green
    set -l GREEN "\e[1;32m"
    set -l NORMAL "\e[0m"
    
    printf "\n$GREEN$argv$NORMAL\n"
end