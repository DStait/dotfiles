#!/usr/bin/env bash

# https://stackoverflow.com/questions/59895/how-can-i-get-the-source-directory-of-a-bash-script-from-within-the-script-itsel
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# For symlink_files function
source "${SCRIPT_DIR}/initial_install_functions.sh"

default_fish_function_dir="${HOME}/.config/fish/functions"
personal_fish_function_dir="${HOME}/dotfiles/fish_functions"

# default_fish_completion_dir="${HOME}/.config/fish/completions"
# personal_fish_completion_dir="${HOME}/dotfiles/fish_completions"


symlink_files $personal_fish_function_dir $default_fish_function_dir
# symlink_files $personal_fish_completion_dir $default_fish_completion_dir
