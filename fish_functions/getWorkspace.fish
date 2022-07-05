function getWorkspace
    set -l profile "$argv[1]"
    set -l USER "$argv[2]"
    set -l WS_DETAILS (aws workspaces describe-workspaces --profile $profile | jq --arg USER "$USER" '.Workspaces[] | select(.UserName == $USER)')
    set -l BUNDLE_ID (echo $WS_DETAILS | jq -r '.BundleId' )
    set -l BUNDLE_NAME (aws workspaces describe-workspace-bundles --bundle-id "$BUNDLE_ID" --profile $profile | jq -r '.Bundles[].Name')

    echo $WS_DETAILS | jq --arg BUNDLE_NAME "$BUNDLE_NAME" '. + {BundleName: $BUNDLE_NAME}'
end


complete -x -c getWorkspace -d "Profile" -a "(aws-vault ls | grep workspaces | grep -Ev  '^(_|-|Profile|=)' | cut -d ' ' -f 1)"