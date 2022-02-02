function start-ssm
    aws ssm start-session --target "$argv[1]" --profile "$argv[2]"
end