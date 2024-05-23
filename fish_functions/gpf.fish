function gpf --description "git push force with lease to remote branch"
  set -l branch_name (git branch | grep '*' | cut -d " " -f 2)
  git push --force-with-lease -u origin $branch_name
end
