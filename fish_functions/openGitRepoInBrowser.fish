function openGitRepoInBrowser
  xdg-open "https://"(git remote -v | head -n1 | awk '{print $2}' | cut -d '@' -f 2 | sed 's|:|/|')
end