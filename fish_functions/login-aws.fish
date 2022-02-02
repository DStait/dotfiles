function login-aws
    aws-vault login "$argv" --stdout | xargs /mnt/c/Program\ Files\ \(x86\)/Microsoft/Edge/Application/msedge.exe --args --profile-directory="$argv" --new-window
end