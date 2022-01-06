function openGitRepoInBrowser
  $BROWSER_COMMAND (git remote -v | head -n1 | awk '{print $2}' | cut -d '@' -f 2 | sed 's|:|/|')
end