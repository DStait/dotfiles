function update --description "Update Brew, formulae, Casks and App store apps"
    echo ">> Updating brew"
    brew update
    echo ">> Updating brew formulae"
    brew upgrade
    echo ">> Updating brew casks"
    brew cu -y -q --cleanup
    echo ">> Update App store apps"
    mas upgrade
end