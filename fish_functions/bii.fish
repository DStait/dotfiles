function bii --description "Check brew info for package and prompt for install"
    argparse 'c/cask' -- $argv
    or return 

    set -l cask_flag $_flag_c
    set -l package_name $argv

    brew info $cask_flag $package_name

    echo ""
    read -l -P "Do you want to install this package? y/n " install_package


    if [ $install_package = "y" ]
        brew install $cask_flag $package_name
    end
end
