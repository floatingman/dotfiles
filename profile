# Used in other dotfiles

# Detect which platform we are on
_islinux=false
[[ "$(uname -s)" =~ Linux ]] && _islinux=true
_ismac=false
[[ "$(uname -s)" =~ Darwin ]] && _ismac=true
_isubuntu=false
[[ "$(uname -v)" =~ Ubuntu ]] && _isubuntu=true
_isarch=false
[[ -f /etc/arch-release ]] && _isarch=true
# Detect if gui is running
_isxrunning=false
[[ -n "$DISPLAY" ]] && _isxrunning=true
# Detect if root
_isroot=false
[[ $UID -eq 0 ]] && _isroot=true

#
# Terminal
#

export TERMINAL='wezterm'

#
# Editors
#

export EDITOR='nvim'
export VISUAL='nvim'
export PAGER='less'

#
# Language
#

export LANG='en_US.UTF-8'

[ -d "$HOME/.local/bin" ] && export PATH=$PATH:"$HOME/.local/bin"

[ -d "$HOME/bin" ] && export PATH=$PATH:"$HOME/bin"

# Disable QT5 DPI scaling
export QT_AUTO_SCREEN_SCALE_FACTOR=0

# Set GPG TTY
# export GPG_TTY
# GPG_TTY=$(tty)

# Use GPG for SSH Agent
# unset SSH_AGENT_PID
# if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
# 	export SSH_AUTH_SOCK
# 	SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
# fi

if [ $(ps ax | grep "[s]sh-agent" | wc -l) -eq 0 ]; then
	eval $(ssh-agent -s) >/dev/null
	if [ "$(ssh-add -l)" = "The agent has no identities." ]; then
		# Auto-add ssh keys to your ssh agent
		# Example:
		# ssh-add ~/.ssh/id_rsa > /dev/null 2>&1
		ssh-add ~/.ssh/id_ed25519_dlp >/dev/null 2>&1
	fi
fi

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
[[ -s "$HOME/.pyenv/bin/pyenv" ]] && eval "$(pyenv init --path)"

[ -d "$HOME/.local/opt/go" ] && export PATH=$PATH:"$HOME/.local/opt/go/bin"
[ -d "$HOME/go/bin" ] && export PATH=$PATH:"$HOME/go/bin"
#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

[[ -d "$HOME/.local/share/JetBrains" ]] && export PATH="$PATH:$HOME/.local/share/JetBrains/Toolbox/scripts"

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# [ -s "$HOME/.atuin/bin/env" ] && source "$HOME/.atuin/bin/env"
[[ -d "$HOME/.cargo" ]] && source "$HOME/.cargo/env"
[[ -d "$HOME/.deno" ]] && source "$HOME/.deno/env"

# Added by LM Studio CLI (lms)
[[ -d "$HOME/.lmstudio/bin" ]] && export PATH="$PATH:$HOME/.lmstudio/bin"
