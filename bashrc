# shellcheck shell=bash source=/dev/null

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc

# Load blesh
if $_isarch; then
	[[ $- == *i* ]] && source /usr/share/blesh/ble.sh --noattach
else
	[[ -d $HOME/.local/share/blesh ]] && source "$HOME/.local/share/blesh/ble.sh"
fi

# User specific aliases, environment, and functions
homebrew="$(command -v {/opt/homebrew,/usr/local}/bin/brew 2>/dev/null)"
if [[ -n $homebrew ]]; then
	if [[ -z ${HOMEBREW_REPOSITORY+x} ]]; then
		# shellcheck disable=SC2046
		eval $(env -i HOME="$HOME" "$homebrew" shellenv)
	else
		# shellcheck disable=SC2046
		eval $(env -i HOME="$HOME" "$homebrew" shellenv | grep -w PATH=)
	fi
fi
unset homebrew

# enable bash completion in interactive shells
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# if [[ $OSTYPE = darwin* ]] && [[ $TERM = tmux-256color ]]; then
# 	export TERMINFO="$HOME/.local/share/terminfo"
# 	if ! [[ $TERMINFO/74/tmux-256color -nt $HOME/.config/dotfiles/tmux-256color.terminfo ]]; then
# 		mkdir -p "$TERMINFO"
# 		/usr/bin/tic -x "$HOME/.config/dotfiles/tmux-256color.terminfo"
# 	fi
# fi

# Aliases
[[ -f ~/.config/shell/aliases ]] && . ~/.config/shell/aliases

# Functions
[[ -f ~/.config/shell/funcs ]] && . ~/.config/shell/funcs

# completion for dotfiles command
alias dotfiles='git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME'
[[ $(type -t __git_complete) = function ]] && __git_complete dotfiles git

# History
FIGNORE=DS_Store
HISTCONTROL=ignoreboth:ignoredups:erasedups
HISTSIZE=500000
HISTFILESIZE=50000000
HISTTIMEFORMAT="%F %T  "
HISTIGNORE='&:[ ]*:exit:[bf]g:rm*:mpv*:z*:cp*:mv*:ls:ll:la:clear:date:pwd:mpc*'
shopt -s checkwinsize histappend

# Directory Navigation
shopt -s autocd

# Don't overwrite existing files by redirection
set -o noclobber

# Load private things
[[ -f "$HOME/.bash_private" ]] && . "$HOME/.bash_private"

# Load zoxide
eval "$(zoxide init bash)"

# Startup blesh
[[ ${BLE_VERSION-} ]] && ble-attach

# Start Sway
#[ "$(tty)" = "/dev/tty1" ] && exec sway

# if [[ ! "$PATH" == */home/dnewman/.fzf/bin* ]]; then
# 	PATH="${PATH:+${PATH}:}/home/dnewman/.fzf/bin"
# fi

if [[ -d "$HOME/.fzf/bin/" ]]; then
	eval "$(fzf --bash)"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Load starship
eval "$(starship init bash)"

# all my terminals support color so let's colorize this alllllll
# PS1="\[\e[33m\][\t] \`if [[ \$? = '0' ]]; then echo \"\[\e[0;32m\]\"; else echo \"\[\e[0;31m\]\"; fi\`\u@\h\[\e[0m\]> "
# modify the title bar, too
# PS1="\[\e]0;\u@\h: \w\a\]$PS1"

[[ -d "$HOME/.cargo/" ]] && . "$HOME/.cargo/env"
[[ -d "$HOME/.deno/" ]] && . "$HOME/.deno/env"
# Added by LM Studio CLI (lms)
[[ -d "$HOME/.lmstudio/" ]] && export PATH="$PATH:$HOME/.lmstudio/bin"

if [ -e "/usr/bin/asdf" ]; then
	export ASDF_DATA_DIR="${HOME}/.asdf"
	export PATH="$ASDF_DATA_DIR/shims:$PATH"
fi

[[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
bleopt highlight_syntax=true
eval "$(atuin init bash)"
