# Custom Scripts/Aliases
alias my_gbpurge='git branch --no-track | grep -Ev "(\*|master|develop)" | sed 's/+//' | xargs -n 1 git branch -d'
alias my_config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias gw='git worktree'
