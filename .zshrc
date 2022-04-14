# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# EDITOR LISTED -- For TMUX Integrations
export EDITOR="nvim"

ZSH_THEME="jnrowe"
DISABLE_AUTO_UPDATE="true"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

ZSH_DISABLE_COMPFIX=true
source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="$HOME/tools/lua-language-server/bin/macOS:$PATH"
export PATH="$HOME/tools/java-language-server/dist:$PATH"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Custom Scripts/Aliases
alias my_gbpurge='git branch --merged | grep -Ev "(\*|master|develop)" | sed 's/+//' | xargs -n 1 git branch -d'
alias my_config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias alert="echo '\a'"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!

#alias luamake=/Users/aherrera/tools/lua-language-server/3rd/luamake/luamake
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
