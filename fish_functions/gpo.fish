function gpo
    
    set -l branch_name (git branch --list | grep "*" | awk '{print $2}')

    if [ $branch_name = "main" ]
        or [ $branch_name = "master" ]
        echo "Not pushing to main/master"
        return 1
    end

    git push -u origin $branch_name 

end
