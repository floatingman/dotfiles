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
  # shellcheck disable=SC2034
  platform='macos'
  # shellcheck disable=SC2034
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
[ -f $HOME/.shell/zshenv ] && source $HOME/.shell/zshenv
[ -f $HOME/.profile ] && source $HOME/.profile
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
[ -f $HOME/.fzf/shell/key-bindings.zsh ] && source $HOME/.fzf/shell/key-bindings.zsh
[ -f $HOME/.shell/fzf-tab/fzf-tab.plugin.zsh ] && source $HOME/.shell/fzf-tab/fzf-tab.plugin.zsh
[ -d $HOME/.shell/fast-syntax-Highlighting ] && source $HOME/.shell/fast-syntax-Highlighting/fast-syntax-highlighting.plugin.zsh
[ -f $HOME/.shell/zsh-autosuggestions/zsh-autosuggestions.zsh ] && source  $HOME/.shell/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -f $HOME/.shell/zsh-history-substring-search/zsh-history-substring-search.zsh ] && source $HOME/.shell/zsh-history-substring-search/zsh-history-substring-search.zsh
[ -d $HOME/.shell/zsh-completions/ ] &&  fpath=($HOME/.shell/zsh-completions/src $fpath)

# source apps
export _ZO_FZF_OPTS="$_FZF_DEFAULT_OPTS --select-1 --exit-0 --height=25% --reverse --no-sort --cycle"
export _ZO_DATA_DIR=$HOME/.zoxide
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v direnv > /dev/null 2>&1 && eval "$(direnv hook zsh)"
[ -d $HOME/.shell/forgit ] && source $HOME/.shell/forgit/forgit.plugin.zsh
[ -d $HOME/.shell/kube-fzf ] && export PATH=$PATH:$HOME/.shell/kube-fzf/
[ -d $HOME/.local/sdkman/ ] && export SDKMAN_DIR="$HOME/.local/sdkman" && source $HOME/.local/sdkman/bin/sdkman-init.sh
[ -d $HOME/.config/broot/launcher/bash/br ] && source $HOME/.config/broot/launcher/bash/br


# ===================
#    MISC SETTINGS
# ===================

# load private things if there
[ -f "$HOME/.zsh_private" ] && source "$HOME/.zsh_private"

# load mac things if there
[ -f "$HOME/.zsh_mac" ] && source "$HOME/.zsh_mac"

enable-fzf-tab

# Load keychain
eval $(keychain --eval --quiet --agents ssh,gpg id_ed25519_dlp id_ed25519_suse id_ed25519_suse_nopw C2A50D1443DC83C25C1C0E46F30B951D85DBE1C0)

# Make tmux copy across machines
precmd() { export p=`cat /tmp/clipboard` }

#########
# Color #
#########

BASE16_SHELL="$HOME/library/src/base16-shell"
BASE16_I3="$HOME/library/src/base16-i3"
BASE16_XRESOURCES="$HOME/library/src/base16-xresources"
BASE16_QUTEBROWSER="$HOME/library/src/base16-qutebrowser"
BASE16_ZATHURA="$HOME/library/src/base16-zathura"
BASE16_ROFI="$HOME/library/src/base16-rofi.pschyska"

[ -n "$PS1" ] && [ -s "$BASE16_SHELL/profile_helper.sh" ] && eval "$("$BASE16_SHELL/profile_helper.sh")"

theme() {
    if [ -z "$1" ]; then
        theme="gruvbox-dark-medium"
    elif [[ "$1" == "day" ]]; then
        theme="gruvbox-light-soft"
    else
        theme="$1"
    fi
    echo "$theme"
    # set shell
    _base16 "$BASE16_SHELL"/scripts/base16-"$theme".sh "$theme"
    # set i3
    i3config="$HOME/.config/i3/config"
    sed -i '1,/## Colors/!d' "$i3config"
    cat "$BASE16_I3"/colors/base16-"$theme".config >> "$i3config"
    i3-msg -q reload
    # set qutebrowser
    cp "$BASE16_QUTEBROWSER/themes/minimal/base16-$theme.config.py" ~/.config/qutebrowser/theme.config.py
    # set rofi
    cp "$BASE16_ROFI/themes/base16-$theme.rasi" "$HOME/.config/rofi/theme.rasi"
    # set xresources
    xresources="$HOME/.Xresources"
    sed -i '1,/! colors/!d' "$xresources"
    cat "$BASE16_XRESOURCES"/xresources/base16-"$theme".Xresources >> "$xresources"
    xrdb -load ~/.Xresources
    # set zathura
    zathurarc="$HOME/.config/zathura/zathurarc"
    sed -i '1,/## Colors/!d' "$zathurarc"
    cat "$BASE16_ZATHURA"/build_schemes/colors/base16-"$theme".config >> "$zathurarc"
}
