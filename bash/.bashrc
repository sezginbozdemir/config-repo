# Alias
alias bashrc="nvim ~/.bashrc"
alias source_bashrc="source ~/.bashrc"

# Yazi

y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd <"$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Editors
export EDITOR="nvim"
export VISUAL="nvim"

# Git prompt (bash-git-prompt)

if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
	GIT_PROMPT_ONLY_IN_REPO=1
	source "$HOME/.bash-git-prompt/gitprompt.sh"
fi
GIT_PROMPT_THEME=Evermeet_Ubuntu

# Git branch in PS1
parse_git_branch() {
	git rev-parse --abbrev-ref HEAD 2>/dev/null | sed 's/.*/ - (\0)/'
}

# Prompt: everything light green
export PS1="\[\e[1;32m\]\u@\h:\w\$(parse_git_branch) \$ \[\e[0m\]"

# System-wide bashrc (if present)

if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# PATH additions

if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
	PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# =========================
# Optional per-user rc directory
# =========================
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi
unset rc

# Tool init
eval "$(zoxide init bash)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# bash-completion (only once, only for interactive shells)
[[ $PS1 &&
	! ${BASH_COMPLETION_VERSINFO:-} &&
	-f /usr/share/bash-completion/bash_completion ]] &&
	. /usr/share/bash-completion/bash_completion

# Private secrets (not committed)
[ -f "$HOME/.bashrc_private" ] && . "$HOME/.bashrc_private"
