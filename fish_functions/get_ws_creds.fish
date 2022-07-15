function get_ws_creds
    set -l env "$argv[1]"
    set -l WORKSPACE_SSM_PATH_PREFIX "/workspaces"

    if [ $env = "prod" ]
        set -f WORKSPACE_SSM_PATH $WORKSPACE_SSM_PATH_PREFIX
    else
        set -f WORKSPACE_SSM_PATH $WORKSPACE_SSM_PATH_PREFIX/$env
    end

    for KEY in $WORKSPACE_SSM_KEYS
        set -l param_name $WORKSPACE_SSM_PATH/$KEY
        set -l value (aws-vault exec core_auth -- aws ssm get-parameter \
            --name $param_name  \
            --with-decryption | 
            jq -r '.Parameter.Value')
        
        printf '%s: %s\n' $param_name $value
    end
    

end
