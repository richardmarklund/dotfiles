alias cd="z"
alias ls="eza --icons -G --group-directories-first"

source ~/trident/trident-dot-files/functions/functions



export GPG_TTY=$(tty)
export DOCKER_HOST=unix:///Users/ab000717/.colima/docker.sock
export TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE=/var/run/docker.sock
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"



# Created by `pipx` on 2023-04-06 08:37:04
export PATH="$PATH:/Users/ab000717/.local/bin:$PATH"

export PATH="$PATH:/Users/ab000717/git/polo/polo-dot-files/polo-cli:$PATH"

export GOPATH=$(go env GOPATH)
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
export GOPRIVATE=github.com/org-*
export GIT_SSH_COMMAND="ssh -F ~/.ssh/config"


# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


if [[ $- == *i* ]]; then
  eval "$(starship init zsh)"
fi
eval "$(zoxide init zsh)"
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
export JAVA_HOME="/opt/homebrew/opt/openjdk@17"
export PATH="/opt/homebrew/opt/openjdk@17/bin:$PATH"
export XDG_CONFIG_HOME="/Users/ab000717/.config"

export NVM_DIR="$HOME/.config/nvm"
nvm_lazy() {
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
alias nvm="nvm_lazy; nvm"
alias node="nvm_lazy; node"
alias npm="nvm_lazy; npm"
alias yarn="nvm_lazy; yarn"  # This loads nvm


# Created by `pipx` on 2024-12-10 14:29:43
export PATH="$PATH:/Users/ab000717/.local/bin"

# bun completions
[ -s "/Users/ab000717/.bun/_bun" ] && source "/Users/ab000717/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"



export GOPRIVATE=github.com/cariad-odp
alias k="kubectl"
# source <(kubectl completion bash)
# complete -o default -F __start_kubectl k


. "$HOME/.atuin/bin/env"

eval "$(atuin init zsh)"
export FLYCTL_INSTALL="/Users/ab000717/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# SSH key switching aliases
alias gprivate="ssh-add -D && ssh-add --apple-use-keychain ~/.ssh/id_richardmarklund"
alias gcariad="ssh-add -D && ssh-add --apple-use-keychain ~/.ssh/id_marklund_io"
