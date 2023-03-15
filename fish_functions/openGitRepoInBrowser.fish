function openGitRepoInBrowser
  set -l URL "https://"(git remote -v | head -n1 | awk '{print $2}' | cut -d '@' -f 2 | sed 's|:|/|')
  if [ (uname) = "Darwin" ]
    open $URL
  else
    xdg-open 
  end
end