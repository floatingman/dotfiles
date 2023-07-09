stty -ixon                # disable ctrl-s and ctrl-q

###########
# plugins #
###########

autoload -Uz compinit
compinit

source ~/.zsh_plugins.sh

# your project folder that we can `c [tab]` to
export PROJECTS="$HOME/workspace/github.com/floatingman"

# path to the local dotfiles repository
if [ -d "$HOME/.dotfiles" ]; then
  export DOTFILES="$HOME/.dotfiles"
else
  echo "could not find ~/.dotfiles directory"
  return
fi

# enable colour support
export TERM="xterm-256color"

# enable timestamps in history
export HIST_STAMPS="yyyy-mm-dd"

# set platform name so that we can run scripts based on the OS
unamestr=$(uname)
if [[ "$unamestr" == 'Linux' ]]; then
  platform='linux'
  if [[ -d "/run/WSL" ]]; then
    platform_wsl='true'
  elif grep -q microsoft /proc/version; then
    platform_wsl='true'
  else
    platform_wsl='false'
  fi
elif [[ "$unamestr" == 'Darwin' ]]; then
  #.config/shellcheck disable=SC2034
  platform='macos'
  #.config/shellcheck disable=SC2034
  platform_wsl='false'
  if [[ `uname -m` == 'arm64' ]]; then
    platform_apple_silicon='true'
  fi
fi
unset unamestr
##############
# Navigation #
##############
setopt AUTO_CD              # Go to folder path without using cd.

setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt CORRECT              # Spelling correction
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt EXTENDED_GLOB        # Use extended globbing syntax.
setopt NOCASEGLOB           # Do not use case-insensitive globbing.
setopt RCEXPANDPARAM        # Array expansion with parameters.
setopt NUMERICGLOBSORT      # Sort filenames numerically when it makes sense.
setopt NOBEEP               # Don't beep when an error occurs.


# Load ZSH Options
# all of our zsh files
typeset -U config_files
config_files=($DOTFILES/zsh/*/*.zsh)

# load the path files
for file in ${(M)config_files:#*/path.zsh}; do
  source "$file"
done

# load everything but the path and completion files
for file in ${${config_files:#*/path.zsh}:#*/completion.zsh}; do
  source "$file"
done

autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit
else
  compinit -C
fi

autoload -U +X bashcompinit && bashcompinit

# load every completion after autocomplete loads
for file in ${(M)config_files:#*/completion.zsh}; do
  source "$file"
done

unset config_files


bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'                # find file and cd to selected directory

# source zsh
[ -f $HOME/.config/shell/zshenv ] && source $HOME/.config/shell/zshenv
[ -f $HOME/.profile ] && source $HOME/.profile
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
[ -f $HOME/.fzf/shell/key-bindings.zsh ] && source $HOME/.fzf/shell/key-bindings.zsh
# [ -f $HOME/.shell/fzf-tab/fzf-tab.plugin.zsh ] && source $HOME/.shell/fzf-tab/fzf-tab.plugin.zsh
# enable-fzf-tab
# [ -d $HOME/.shell/fast-syntax-Highlighting ] && source $HOME/.shell/fast-syntax-Highlighting/fast-syntax-highlighting.plugin.zsh
# [ -f $HOME/.shell/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source  $HOME/.shell/zsh-autosuggestions/zsh-autosuggestions.zsh
# [ -f $HOME/.shell/zsh-history-substring-search/zsh-history-substring-search.zsh ] && source $HOME/.shell/zsh-history-substring-search/zsh-history-substring-search.zsh
# [ -d $HOME/.shell/zsh-completions/ ] &&  fpath=($HOME/.shell/zsh-completions/src $fpath)

# source apps
export _ZO_FZF_OPTS="$_FZF_DEFAULT_OPTS --select-1 --exit-0 --height=25% --reverse --no-sort --cycle"
export _ZO_DATA_DIR=$HOME/.zoxide
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v direnv > /dev/null 2>&1 && eval "$(direnv hook zsh)"
[ -d $HOME/.config/broot/launcher/bash/br ] && source $HOME/.config/broot/launcher/bash/br


# ===================
#    MISC SETTINGS
# ===================

# Fly.io settings
export FLYCTL_INSTALL="/home/floatingman/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# load private things if there
[ -f "$HOME/.zsh_private" ] && source "$HOME/.zsh_private"

# load mac things if there
[ -f "$HOME/.zsh_mac" ] && source "$HOME/.zsh_mac"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# add Pulumi to the PATH
export PATH=$PATH:$HOME/.pulumi/bin
export PATH=$PATH:/usr/local/go/bin
