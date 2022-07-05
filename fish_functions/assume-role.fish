function _assume_role_help
    echo "Please pass the following arguments:"
    echo "  -p Profile"
    echo "  -a Account ID"
    echo "  -r RoleName"
end

function assume-role
    if set -q $argv; 
        _assume_role_help
        return 1
    end
    argparse 'p/profile=' 'a/account=' 'r/role=' -- $argv 
    

    set -l profile_name $_flag_p
    set -l account_id $_flag_a
    set -l role_name $_flag_r

    set -l credentials (aws-vault exec $profile_name -- aws sts assume-role --role-arn arn:aws:iam::$account_id:role/$role_name --role-session-name local)
    set -gx AWS_ACCESS_KEY_ID (echo $credentials | jq -r '.Credentials.AccessKeyId')
    set -gx AWS_SECRET_ACCESS_KEY (echo $credentials | jq -r '.Credentials.SecretAccessKey')
    set -gx AWS_SESSION_TOKEN (echo $credentials | jq -r '.Credentials.SessionToken')
    echo "Assumed role. The credentials will expire at "(echo $credentials | jq -r '.Credentials.Expiration')
end



# Set the available commands to the function
set -l commands -p -r -a 

# Disable file completions for the entire command
# because it does not take files anywhere
complete -c assume-role -f

# For the AWS Profiles stored in AWS-Vault
complete -x -c assume-role -s p -d "Profile" -n "not __fish_seen_subcommand_from $commands" -a "(aws-vault ls | grep -Ev  '^(_|-|Profile|=)' | cut -d ' ' -f 1)"
# For the commonly used Roles
complete -x -c assume-role -s r -d "Role Name" -n "not __fish_seen_subcommand_from $commands" -a "CloudOSBatch AdministratorAccess ReadOnlyUser"
complete -x -c assume-role -s a -d "Account ID" -n "not __fish_seen_subcommand_from $commands"