function update
    set -l OS_TYPE (uname)

    switch $OS_TYPE
        case "Darwin"
            echo ">> Updating brew"
            brew update
            echo ">> Updating brew formulae"
            brew upgrade
            echo ">> Updating brew casks"
            brew cu -y -q --cleanup
            echo ">> Update App store apps"
            mas upgrade

        case "Linux"
            echo ">> Prompt for sudo" 
            sudo echo >/dev/null
            echo ">> Killing snap store processes" 
            sudo killall snap-store
            echo ">> Updating repos"
            sudo apt update
            echo ">> Updating packages"
            sudo apt upgrade -y 
            echo ">> Refreshing snap store" 
            sudo snap refresh

            echo ">> Remove unneeded packages" 
            sudo apt autoremove -y 
    end
end