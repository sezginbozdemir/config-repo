# ---- Powerlevel10k instant prompt (must stay near the top) ----
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ---- Basic environment ----
# Prefer nvim locally, vim over SSH
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# ---- PATH ----
export PATH="$HOME/bin:/usr/local/bin:$PATH"

# MongoDB
export PATH="/opt/homebrew/Cellar/mongodb-community/6.0.6/bin:$PATH"

# dotnet
if [[ ":$PATH:" != *":/usr/local/share/dotnet:"* ]]; then
  export PATH="/usr/local/share/dotnet:$PATH"
fi
export PATH="$PATH:/Users/sez/.dotnet/tools"

# Deduplicate PATH entries without re-sorting 
typeset -U path
path=($path)
export PATH="${(j/:/)path}"

# ---- Secrets ----
[[ -f ~/.zsh_secrets ]] && source ~/.zsh_secrets

# ---- Oh My Zsh ----
export ZSH="/Users/sezgin/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# ---- Zsh plugins -----

source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fpath+=/opt/homebrew/share/zsh-completions
autoload -U compinit && compinit

plugins=(
	git
	brew
	sudo
	copyfile
	jsontools
)

# OMZ update behavior
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 13

# OMZ behavior tweaks
DISABLE_MAGIC_FUNCTIONS="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"



source "$ZSH/oh-my-zsh.sh"

# ---- Powerlevel10k config ----
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ---- Tools ----
# nvm
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# zoxide
eval "$(zoxide init zsh)"

# ---- Functions ----
# yazi wrapper: cd into last directory after exiting yazi
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [[ -n "$cwd" && "$cwd" != "$PWD" ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# ---- Aliases ----
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"
alias icat="kitten icat"
alias clock="tty-clock -S -s -c -C 3"


