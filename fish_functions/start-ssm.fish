function start-ssm
    aws ssm start-session --target "$argv[1]" \
        --document-name AWS-StartInteractiveCommand \
        --parameters command='["sudo su - ubuntu || sudo su - ec2-user"]' \
        --profile "$argv[2]"
end

