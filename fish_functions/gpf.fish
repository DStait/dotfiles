function gpf --description "git push -fu \$branchname"
  set -l branch_name (git branch | grep '*' | cut -d " " -f 2)
  git push -fu origin $branch_name
end
